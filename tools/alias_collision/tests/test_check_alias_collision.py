from pathlib import Path

from pyfakefs.fake_filesystem_unittest import TestCase
from check_alias_collision import (
    dir_path,
    find_all_aliases,
    find_aliases_in_file,
    check_for_duplicates,
    Alias,
)


THREE_ALIASES = """
alias g='git'

alias ga='git add'
alias gaa='git add --all'
"""

CONDITIONAL_ALIAS = """
is-at-least 2.8 "$git_version" \
  && alias gfa='git fetch --all --prune --jobs=10' \
  || alias gfa='git fetch --all --prune'
"""


class CheckAliasCollisionTest(TestCase):
    def setUp(self) -> None:
        self.setUpPyfakefs()

    def test_dir_path__is_dir__input_path(self) -> None:
        self.fs.create_dir("test")
        self.assertEqual(Path("test"), dir_path("test"))

    def test_dir_path__is_file__raise_not_a_directory_error(self) -> None:
        self.fs.create_file("test")
        with self.assertRaises(NotADirectoryError):
            dir_path("test")

    def test_dir_path__does_not_exist__raise_not_a_directory_error(self) -> None:
        with self.assertRaises(NotADirectoryError):
            dir_path("test")

    def test_find_all_aliases__empty_folder_should_return_empty_list(self) -> None:
        self.fs.create_dir("test")
        result = find_all_aliases(Path("test"))
        self.assertListEqual([], result)

    def test_find_aliases_in_file__empty_text_should_return_empty_list(self) -> None:
        self.fs.create_file("empty.zsh")
        result = find_aliases_in_file(Path("empty.zsh"))
        self.assertListEqual([], result)

    def test_find_aliases_in_file__one_alias_should_find_one(self) -> None:
        self.fs.create_file("one.zsh", contents="alias g='git'")
        result = find_aliases_in_file(Path("one.zsh"))
        self.assertListEqual([Alias("g", "git", Path("one.zsh"))], result)

    def test_find_aliases_in_file__three_aliases_should_find_three(self) -> None:
        self.fs.create_file("three.zsh", contents=THREE_ALIASES)
        result = find_aliases_in_file(Path("three.zsh"))
        self.assertListEqual(
            [
                Alias("g", "git", Path("three.zsh")),
                Alias("ga", "git add", Path("three.zsh")),
                Alias("gaa", "git add --all", Path("three.zsh")),
            ],
            result,
        )

    def test_find_aliases_in_file__one_conditional_alias_should_find_none(self) -> None:
        self.fs.create_file("conditional.zsh", contents=CONDITIONAL_ALIAS)
        result = find_aliases_in_file(Path("conditional.zsh"))
        self.assertListEqual([], result)

    def test_check_for_duplicates__no_duplicates_should_not_raise(self) -> None:
        check_for_duplicates(
            [
                Alias("g", "git", Path("git.zsh")),
                Alias("ga", "git add", Path("git.zsh")),
                Alias("gaa", "git add --all", Path("git.zsh")),
            ]
        )
        self.assertTrue(True)

    def test_check_for_duplicates__duplicates_should_raise(self) -> None:
        with self.assertRaises(ValueError):
            check_for_duplicates(
                [
                    Alias("gc", "git commit", Path("git.zsh")),
                    Alias("gc", "git clone", Path("git.zsh")),
                ]
            )
