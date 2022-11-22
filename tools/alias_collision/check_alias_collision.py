"""Check for alias collisions within the codebase"""

from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser
from pathlib import Path
from dataclasses import dataclass
import itertools
import re


ERROR_MESSAGE_TEMPLATE = (
    "Alias `%s` defined in `%s` already exists as alias `%s` in `%s`."
)


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


@dataclass(frozen=True)
class Collision:

    existing_alias: Alias
    new_alias: Alias


def find_aliases_in_file(file: Path) -> list[Alias]:
    matches = re.findall(r"^alias (.*)='(.*)'", file.read_text(), re.M)
    return [Alias(match[0], match[1], file) for match in matches]


def find_all_aliases(path: Path) -> list:
    files = list(path.rglob("*.zsh"))
    aliases = [find_aliases_in_file(file) for file in files]
    return list(itertools.chain(*aliases))


def check_for_duplicates(aliases: list[Alias]) -> list[Collision]:
    elements = {}
    collisions = []
    for alias in aliases:
        if alias.alias in elements:
            existing = elements[alias.alias]
            collisions.append(Collision(existing, alias))
        else:
            elements[alias.alias] = alias
    return collisions


def print_collisions(collisions: dict[Alias, Alias]) -> None:
    if collisions:
        print(f"Found {len(collisions)} alias collisions:\n")
        for collision in collisions:
            print(
                ERROR_MESSAGE_TEMPLATE
                % (
                    f"{collision.new_alias.alias}={collision.new_alias.value}",
                    collision.new_alias.module.name,
                    f"{collision.existing_alias.alias}={collision.existing_alias.value}",
                    collision.existing_alias.module.name,
                )
            )
        print("\nConsider renaming your aliases.")
    else:
        print("Found no collisions")


def main():
    """main"""
    args = parse_arguments()
    aliases = find_all_aliases(args.folder)
    collisions = check_for_duplicates(aliases)
    print_collisions(collisions)
    if collisions:
        exit(-1)


if __name__ == "__main__":
    main()
