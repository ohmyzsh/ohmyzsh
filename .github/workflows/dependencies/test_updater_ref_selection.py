import importlib.util
import pathlib
import unittest
from unittest import mock


UPDATER_PATH = pathlib.Path(__file__).with_name("updater.py")


def load_updater_module():
    spec = importlib.util.spec_from_file_location("omz_dependencies_updater", UPDATER_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


class UpdateRefSelectionTest(unittest.TestCase):
    def setUp(self):
        self.updater = load_updater_module()

    def _run_update(self, values, status):
        dependency = self.updater.Dependency("plugins/example", values)

        with mock.patch.object(
            self.updater.GitHub, "check_newer_tag", return_value=status
        ) as check_newer_tag, mock.patch.object(
            self.updater.GitHub, "check_updates", return_value=status
        ) as check_updates, mock.patch.object(
            self.updater.Git, "checkout_or_create_branch", return_value="branch"
        ), mock.patch.object(
            self.updater.Git, "repo_is_clean", return_value=True
        ), mock.patch.object(
            self.updater.Git, "clean_repo"
        ), mock.patch.object(
            dependency, "_Dependency__apply_upstream_changes"
        ) as apply_changes:
            dependency.update_or_notify()

        return apply_changes, check_newer_tag, check_updates

    def test_should_use_resolved_tag_if_dependency_tracks_tag_versions(self):
        values = {
            "repo": "ohmyzsh/example",
            "branch": "master",
            "version": "tag:v1.0.0",
        }
        status = {
            "has_updates": True,
            "version": "v1.2.0",
            "compare_url": "https://example.com/compare",
            "head_ref": "abcdef1234567890",
            "head_url": "https://example.com/releases/v1.2.0",
        }

        apply_changes, check_newer_tag, check_updates = self._run_update(values, status)

        apply_changes.assert_called_once_with("v1.2.0")
        check_newer_tag.assert_called_once_with("ohmyzsh/example", "v1.0.0")
        check_updates.assert_not_called()

    def test_should_keep_using_configured_branch_if_dependency_tracks_branch_head(self):
        values = {
            "repo": "ohmyzsh/example",
            "branch": "master",
            "version": "abcdef12",
        }
        status = {
            "has_updates": True,
            "version": "fedcba9876543210",
            "compare_url": "https://example.com/compare",
            "head_ref": "fedcba9876543210",
            "head_url": "https://example.com/commit/fedcba98",
        }

        apply_changes, check_newer_tag, check_updates = self._run_update(values, status)

        apply_changes.assert_called_once_with("master")
        check_updates.assert_called_once_with("ohmyzsh/example", "master", "abcdef12")
        check_newer_tag.assert_not_called()


if __name__ == "__main__":
    unittest.main()
