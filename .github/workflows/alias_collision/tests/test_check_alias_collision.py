from pathlib import Path

from pyfakefs.fake_filesystem import FakeFilesystem
import pytest

from check_alias_collision import (
    dir_path,
    find_all_aliases,
    find_aliases_in_file,
    check_for_duplicates,
    Alias,
    Collision,
    load_known_collisions,
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

ONE_KNOWN_COLLISION = """
[
    {
        "existing_alias": {
            "alias": "gcd",
            "value": "git checkout $(git_develop_branch)",
            "module": "plugins/git/git.plugin.zsh"
        },
        "new_alias": {
            "alias": "gcd",
            "value": "git checkout $(git config gitflow.branch.develop)",
            "module": "plugins/git-flow/git-flow.plugin.zsh"
        }
    }
]
"""


def test_dir_path__is_dir__input_path(fs: FakeFilesystem) -> None:
    fs.create_dir("test")
    assert Path("test") == dir_path("test")


def test_dir_path__is_file__raise_not_a_directory_error(fs: FakeFilesystem) -> None:
    fs.create_file("test")
    with pytest.raises(NotADirectoryError):
        dir_path("test")


def test_dir_path__does_not_exist__raise_not_a_directory_error(
    fs: FakeFilesystem,
) -> None:
    with pytest.raises(NotADirectoryError):
        dir_path("test")


def test_find_all_aliases__empty_folder_should_return_empty_list(
    fs: FakeFilesystem,
) -> None:
    fs.create_dir("test")
    result = find_all_aliases(Path("test"))
    assert [] == result


def test_find_aliases_in_file__empty_text_should_return_empty_list(
    fs: FakeFilesystem,
) -> None:
    fs.create_file("empty.zsh")
    result = find_aliases_in_file(Path("empty.zsh"))
    assert [] == result


def test_find_aliases_in_file__one_alias_should_find_one(fs: FakeFilesystem) -> None:
    fs.create_file("one.zsh", contents="alias g='git'")
    result = find_aliases_in_file(Path("one.zsh"))
    assert [Alias("g", "git", Path("one.zsh"))] == result


def test_find_aliases_in_file__three_aliases_should_find_three(
    fs: FakeFilesystem,
) -> None:
    fs.create_file("three.zsh", contents=THREE_ALIASES)
    result = find_aliases_in_file(Path("three.zsh"))
    assert [
        Alias("g", "git", Path("three.zsh")),
        Alias("ga", "git add", Path("three.zsh")),
        Alias("gaa", "git add --all", Path("three.zsh")),
    ] == result


def test_find_aliases_in_file__one_conditional_alias_should_find_none(
    fs: FakeFilesystem,
) -> None:
    fs.create_file("conditional.zsh", contents=CONDITIONAL_ALIAS)
    result = find_aliases_in_file(Path("conditional.zsh"))
    assert [] == result


def test_check_for_duplicates__no_duplicates_should_return_empty_dict() -> None:
    result = check_for_duplicates(
        [
            Alias("g", "git", Path("git.zsh")),
            Alias("ga", "git add", Path("git.zsh")),
            Alias("gaa", "git add --all", Path("git.zsh")),
        ]
    )
    assert result == []


def test_check_for_duplicates__duplicates_should_have_one_collision() -> None:
    result = check_for_duplicates(
        [
            Alias("gc", "git commit", Path("git.zsh")),
            Alias("gc", "git clone", Path("git.zsh")),
        ]
    )
    assert result == [
        Collision(
            Alias("gc", "git commit", Path("git.zsh")),
            Alias("gc", "git clone", Path("git.zsh")),
        )
    ]


def test_is_new_collision__new_alias_not_in_known_collisions__should_return_true() -> (
    None
):
    known_collisions = ["gc", "gd"]
    new_alias = Alias("ga", "git add", Path("git.zsh"))
    collision = Collision(Alias("gd", "git diff", Path("git.zsh")), new_alias)
    assert collision.is_new_collision(known_collisions) is True


def test_is_new_collision__new_alias_in_known_collisions__should_return_false() -> None:
    known_collisions = ["gc", "gd", "ga"]
    new_alias = Alias("ga", "git add", Path("git.zsh"))
    collision = Collision(Alias("gd", "git diff", Path("git.zsh")), new_alias)
    assert collision.is_new_collision(known_collisions) is False


def test_load_known_collisions__empty_file__should_return_empty_list(
    fs: FakeFilesystem,
) -> None:
    empty_list = Path("empty.json")
    fs.create_file(empty_list, contents="[]")
    result = load_known_collisions(empty_list)
    assert [] == result


def test_load_known_collisions__one_collision__should_return_one_collision(
    fs: FakeFilesystem,
) -> None:
    known_collisions_file = Path("known_collisions.json")
    fs.create_file(known_collisions_file, contents=ONE_KNOWN_COLLISION)
    result = load_known_collisions(known_collisions_file)
    assert 1 == len(result)
    assert "gcd" == result[0].existing_alias.alias
