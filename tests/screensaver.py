"""Real PTY checks; Python is for development only, not a screensaver dependency."""
import fcntl
import os
from pathlib import Path
import pty
import re
import select
import signal
import struct
import subprocess
import termios
import time
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "tools/screensaver.zsh"


class Terminal:
    def __init__(self, args=(), rows=28, columns=97, env=None, command=None, scene="aquarium"):
        self.master, self.slave = pty.openpty()
        self.resize(rows, columns, notify=False)
        self.before = termios.tcgetattr(self.slave)
        child_env = dict(os.environ, TERM="xterm-256color")
        child_env.pop("NO_COLOR", None)
        child_env.update(env or {})

        self.process = subprocess.Popen(
            command or ["zsh", "-f", str(SCRIPT), scene, *args],
            stdin=self.slave, stdout=self.slave, stderr=self.slave,
            env=child_env, start_new_session=True,
        )
        self.output = bytearray()
        os.set_blocking(self.master, False)

    def resize(self, rows, columns, notify=True):
        fcntl.ioctl(self.slave, termios.TIOCSWINSZ,
                    struct.pack("HHHH", rows, columns, 0, 0))
        if notify:
            os.killpg(self.process.pid, signal.SIGWINCH)

    def collect(self, duration=0.3):
        deadline = time.monotonic() + duration
        while time.monotonic() < deadline:
            readable, _, _ = select.select([self.master], [], [], 0.02)
            if readable:
                try:
                    self.output.extend(os.read(self.master, 65536))
                except BlockingIOError:
                    pass
        return bytes(self.output)

    def finish(self):
        deadline = time.monotonic() + 3
        while self.process.poll() is None and time.monotonic() < deadline:
            self.collect(0.05)
        if self.process.poll() is None:
            raise AssertionError("aquarium did not exit promptly")
        self.collect(0.05)
        return self.process.returncode

    def close(self):
        if self.process.poll() is None:
            os.killpg(self.process.pid, signal.SIGKILL)
            self.process.wait()
        os.close(self.master)
        os.close(self.slave)


class AquariumTests(unittest.TestCase):
    scene = "aquarium"

    def terminal(self, *args, **kwargs):
        kwargs.setdefault("scene", self.scene)
        terminal = Terminal(*args, **kwargs)
        self.addCleanup(terminal.close)
        return terminal

    def assert_restored(self, terminal):
        after = termios.tcgetattr(terminal.slave)
        before = terminal.before.copy()
        # macOS sets this transient kernel flag on any raw -> canonical stty
        # roundtrip. It is cleared by the next read, not a lost terminal setting.
        before[3] &= ~getattr(termios, "PENDIN", 0)
        after[3] &= ~getattr(termios, "PENDIN", 0)
        self.assertEqual(before, after)
        self.assertIn(b"\x1b[?1049h", terminal.output)
        self.assertIn(b"\x1b[?1049l", terminal.output)
        self.assertIn(b"\x1b[?25h", terminal.output)
        self.assertNotIn(b"bad math", terminal.output)
        self.assertNotIn(b"unknown function", terminal.output)

    def test_plain_and_arrow_keys(self):
        for key in [b"q", b"\x1b[A", b"\r", "🐚".encode()]:
            with self.subTest(key=key):
                terminal = self.terminal()
                terminal.collect()
                os.write(terminal.master, key)
                self.assertEqual(terminal.finish(), 0)
                self.assert_restored(terminal)
                # No unread suffix of the dismissing key remains in the TTY.
                attrs = termios.tcgetattr(terminal.slave)
                attrs[3] &= ~termios.ICANON
                attrs[6][termios.VMIN] = 0
                attrs[6][termios.VTIME] = 0
                termios.tcsetattr(terminal.slave, termios.TCSANOW, attrs)
                self.assertEqual(os.read(terminal.slave, 128), b"")

    def test_interrupt_and_suspend_signals(self):
        # With no controlling session the PTY survives child exit on macOS,
        # allowing an exact termios comparison. Send keyboard-equivalent signals.
        for sig, code in [(signal.SIGINT, 130), (signal.SIGTSTP, 148)]:
            with self.subTest(signal=sig):
                terminal = self.terminal()
                terminal.collect()
                os.killpg(terminal.process.pid, sig)
                self.assertEqual(terminal.finish(), code)
                self.assert_restored(terminal)

    def test_external_signals(self):
        for sig in [signal.SIGTERM, signal.SIGHUP, signal.SIGQUIT]:
            with self.subTest(signal=sig):
                terminal = self.terminal()
                terminal.collect()
                os.killpg(terminal.process.pid, sig)
                self.assertEqual(terminal.finish(), 128 + sig)
                self.assert_restored(terminal)

    def test_resize_small_and_back(self):
        terminal = self.terminal()
        terminal.collect()
        terminal.resize(8, 25)
        self.assertTrue(b"A little more" in terminal.collect(0.7))
        boundary = len(terminal.output)
        terminal.resize(40, 140)
        terminal.collect(0.7)
        self.assertTrue(b"O H  M Y  Z S H" in terminal.output[boundary:])
        os.write(terminal.master, b"q")
        self.assertEqual(terminal.finish(), 0)
        self.assert_restored(terminal)

    def test_timed_exit_and_animation(self):
        terminal = self.terminal(["--seconds", "1"])
        self.assertEqual(terminal.finish(), 0)
        self.assert_restored(terminal)
        self.assertIn(b"\x1b[38;5;", terminal.output)
        frames = bytes(terminal.output).split(b"\x1b[H")
        self.assertGreater(len(frames), 5)
        self.assertGreater(len(set(frames[2:-1])), 2)

    def test_monochrome(self):
        for args, env in [(["--mono"], {}), ([], {"NO_COLOR": "1"})]:
            with self.subTest(args=args, env=env):
                terminal = self.terminal([*args, "--seconds", "1"], env=env)
                self.assertEqual(terminal.finish(), 0)
                self.assertNotIn(b"\x1b[38;5;", terminal.output)
                self.assertNotIn(b"\x1b[38;2;", terminal.output)
                self.assert_restored(terminal)

    def test_arguments_and_pipes(self):
        for args, code in [([], 1), (["--seconds"], 2), (["--seconds", "0"], 2),
                           (["--seconds", "1+1"], 2), (["--oops"], 2), (["--help"], 0)]:
            with self.subTest(args=args):
                result = subprocess.run(["zsh", "-f", str(SCRIPT), self.scene, *args], capture_output=True)
                self.assertEqual(result.returncode, code)
                self.assertNotIn(b"\x1b", result.stdout + result.stderr)

    def test_snapshot_clipping_over_time(self):
        for tick in [0, 85, 99, 180, 700, 9999]:
            result = subprocess.run(["zsh", "-f", str(SCRIPT), self.scene, "--snapshot", str(tick)],
                                    capture_output=True, check=True)
            lines = result.stdout.decode("ascii").splitlines()
            self.assertEqual(len(lines), 28)
            self.assertEqual({len(line) for line in lines}, {96})

    def test_existing_omz_dispatcher(self):
        script = r"""
ZSH=$1
source "$ZSH/lib/cli.zsh"
for cmd in screensaver shellsaver; do
  omz $cmd --snapshot > /dev/null || exit 20
  for scene in aquarium logo hermit party; do
    omz $cmd $scene --snapshot > /dev/null || exit 21
  done
  omz $cmd --help || exit 22
  omz $cmd unknown > /dev/null 2>&1
  [[ $? == 2 ]] || exit 23
 done
(( ! ${+functions[_zshell_scene]} )) || exit 24
omz help
"""
        result = subprocess.run(["zsh", "-fc", script, "test", str(ROOT)],
                                capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr.decode())
        self.assertIn(b"Usage: omz screensaver", result.stdout)
        self.assertIn(b"screensaver [scene]", result.stderr)
        self.assertIn(b"shellsaver [scene]", result.stderr)


class LogoTests(AquariumTests):
    scene = "logo"

    def test_updater_rainbow(self):
        for colorterm, colors in [
            ("truecolor", ["255;0;0", "255;97;0", "247;255;0", "0;255;30", "77;0;255", "168;0;255", "245;0;172"]),
            ("", ["196", "202", "226", "082", "021", "093", "163"]),
        ]:
            with self.subTest(colorterm=colorterm):
                terminal = self.terminal(["--seconds", "1"], env={"COLORTERM": colorterm})
                self.assertEqual(terminal.finish(), 0)
                prefix = "\x1b[38;2;" if colorterm else "\x1b[38;5;"
                for color in colors:
                    self.assertIn((prefix + color + "m").encode(), terminal.output)
                # The updater colors letters left-to-right, not entire rows.
                signature = prefix + colors[0] + "m  ____  " + prefix + colors[1] + "m/ /_    "
                self.assertIn(signature.encode(), terminal.output)
                self.assert_restored(terminal)


class PartyTests(AquariumTests):
    scene = "party"


class HermitTests(AquariumTests):
    scene = "hermit"

    def test_timed_exit_and_animation(self):
        terminal = self.terminal(["--seconds", "1"])
        self.assertEqual(terminal.finish(), 0)
        self.assert_restored(terminal)
        self.assertIn(b"\x1b[38;5;", terminal.output)
        # Unlike the swimming scenes, the crab intentionally holds still for
        # seconds. Check its face through the cycle, independently of captions.
        faces = set()
        for tick in [0, 40, 71, 80, 120, 160, 200, 240, 280]:
            still = subprocess.check_output(
                ["zsh", "-f", str(SCRIPT), "hermit", "--snapshot", str(tick)]
            ).splitlines()
            faces.add(b"\n".join(still[9:16]))
        self.assertGreater(len(faces), 5)


class SceneSelectionTests(unittest.TestCase):
    def test_default_is_aquarium(self):
        def still(*args):
            return subprocess.check_output(["zsh", "-f", str(SCRIPT), *args, "--snapshot"])
        self.assertEqual(still(), still("aquarium"))
        self.assertNotEqual(still(), still("logo"))

    def test_unknown_scene_rejected(self):
        result = subprocess.run(["zsh", "-f", str(SCRIPT), "unknown"], capture_output=True)
        self.assertEqual(result.returncode, 2)
        self.assertIn(b"unknown scene", result.stderr)

    def test_compact_logo(self):
        self.check_compact_scene("logo", b"Oh My Zsh")

    def test_compact_hermit(self):
        self.check_compact_scene("hermit", b"(o )")

    def test_compact_party(self):
        self.check_compact_scene("party", b"SCREENSAVER / PARTY")

    def test_wide_party(self):
        terminal = Terminal(["--seconds", "1"], rows=40, columns=140, scene="party")
        try:
            self.assertEqual(terminal.finish(), 0)
            self.assertIn(b"##########", terminal.output)
            self.assertIn(b"SCREENSAVER / PARTY", terminal.output)
        finally:
            terminal.close()

    def check_compact_scene(self, scene, expected):
        terminal = Terminal(["--seconds", "1"], rows=18, columns=49, scene=scene)
        try:
            self.assertEqual(terminal.finish(), 0)
            visible = re.sub(rb"\x1b\[[0-9;?]*[A-Za-z]", b"", terminal.output)
            self.assertIn(expected, visible)
            self.assertNotIn(b"division by zero", terminal.output)
        finally:
            terminal.close()


if __name__ == "__main__":
    unittest.main(verbosity=2)
