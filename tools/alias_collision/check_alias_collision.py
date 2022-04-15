"""Check for alias collisions within the codebase"""

from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser, FileType
from pathlib import Path
from typing import List
from dataclasses import dataclass
import itertools
import re


ERROR_MESSAGE_TEMPLATE = """Found alias collision
Alias %s defined in %s already exists as %s in %s.
Consider renaming your alias.
"""


def dir_path(path_string: str) -> Path:
    if Path(path_string).is_dir():
        return Path(path_string)
    else:
        raise NotADirectoryError(path_string)


def parse_arguments():
    parser = ArgumentParser(
        description=__doc__,
        formatter_class=ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "folder",
        type=dir_path,
        help="Folder to check",
    )
    return parser.parse_args()


@dataclass(frozen=True)
class Alias:

    alias: str
    value: str
    module: Path


def find_aliases_in_file(file: Path) -> List[Alias]:
    matches = re.findall(r"^alias (.*)='(.*)'", file.read_text(), re.M)
    return [Alias(match[0], match[1], file) for match in matches]


def find_all_aliases(path: Path) -> List:
    files = list(path.rglob("*.zsh"))
    aliases = [find_aliases_in_file(file) for file in files]
    return list(itertools.chain(*aliases))


def check_for_duplicates(aliases: List[Alias]) -> None:
    elements = dict()
    for alias in aliases:
        if alias.alias in elements:
            existing = elements[alias.alias]
            raise ValueError(
                ERROR_MESSAGE_TEMPLATE
                % (
                    f"{alias.alias}={alias.value}",
                    alias.module.name,
                    f"{existing.alias}={existing.value}",
                    existing.module.name,
                )
            )
        else:
            elements[alias.alias] = alias


def main():
    """main"""
    args = parse_arguments()
    aliases = find_all_aliases(args.folder)
    check_for_duplicates(aliases)
    print("Found no collisions")


if __name__ == "__main__":
    main()
