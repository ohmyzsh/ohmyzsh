import importlib.util
import os
import pathlib
import subprocess
import tempfile
import unittest


UPDATER_PATH = pathlib.Path(__file__).with_name("updater.py")


def load_updater_module():
    spec = importlib.util.spec_from_file_location("omz_dependencies_updater", UPDATER_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


class RepoIsCleanTest(unittest.TestCase):
    def setUp(self):
        self.updater = load_updater_module()

    def test_should_return_true_if_repository_has_no_changes(self):
        with temporary_git_repo() as repo_dir:
            with chdir(repo_dir):
                self.assertTrue(self.updater.Git.repo_is_clean())

    def test_should_return_false_if_repository_has_untracked_files(self):
        with temporary_git_repo() as repo_dir:
            pathlib.Path(repo_dir, "new-file.txt").write_text("new\n")

            with chdir(repo_dir):
                self.assertFalse(self.updater.Git.repo_is_clean())


class chdir:
    def __init__(self, path):
        self.path = path
        self.previous = None

    def __enter__(self):
        self.previous = os.getcwd()
        os.chdir(self.path)

    def __exit__(self, exc_type, exc_value, traceback):
        os.chdir(self.previous)


class temporary_git_repo:
    def __enter__(self):
        self.tempdir = tempfile.TemporaryDirectory()
        self.path = pathlib.Path(self.tempdir.name)

        subprocess.run(
            ["git", "init", "-b", "master"],
            cwd=self.path,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=self.path,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=self.path,
            check=True,
            capture_output=True,
        )
        self.path.joinpath("tracked.txt").write_text("tracked\n")
        subprocess.run(
            ["git", "add", "tracked.txt"],
            cwd=self.path,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "commit", "-m", "initial"],
            cwd=self.path,
            check=True,
            capture_output=True,
        )

        return self.path

    def __exit__(self, exc_type, exc_value, traceback):
        self.tempdir.cleanup()


if __name__ == "__main__":
    unittest.main()
