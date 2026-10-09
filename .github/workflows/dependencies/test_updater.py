import os
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import updater


class DependencyApplyUpstreamChangesTest(unittest.TestCase):
    def test_apply_upstream_changes_removes_stale_files(self):
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            worktree = tmp_path / "worktree"
            source = tmp_path / "source"
            target = worktree / "plugins" / "example"

            source.mkdir()
            (source / "kept.zsh").write_text("new content")
            (source / ".git").mkdir()
            (source / ".github").mkdir()

            target.mkdir(parents=True)
            (target / "kept.zsh").write_text("old content")
            (target / "stale.zsh").write_text("stale content")

            def fake_clone(_remote_url, _ref, repo_dir, reclone=False):
                shutil.copytree(source, repo_dir, dirs_exist_ok=True)

            dependency = updater.Dependency(
                "plugins/example",
                {"repo": "owner/repo", "branch": "main", "version": "old"},
            )

            previous_cwd = os.getcwd()
            try:
                os.chdir(worktree)
                with (
                    patch.object(updater, "TMP_DIR", str(tmp_path / "tmp")),
                    patch.object(updater.Git, "clone", fake_clone),
                ):
                    dependency._Dependency__apply_upstream_changes("new")
            finally:
                os.chdir(previous_cwd)

            self.assertEqual((target / "kept.zsh").read_text(), "new content")
            self.assertFalse((target / "stale.zsh").exists())
            self.assertFalse((target / ".git").exists())
            self.assertFalse((target / ".github").exists())


if __name__ == "__main__":
    unittest.main()
