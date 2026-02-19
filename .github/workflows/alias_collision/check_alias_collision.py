"""Check for alias collisions within the codebase"""

from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser
from pathlib import Path
from dataclasses import dataclass
from typing import List, Dict
import itertools
import re
import json


ERROR_MESSAGE_TEMPLATE = (
    "Alias `%s` defined in `%s` already exists as alias `%s` in `%s`."
)

KNOWN_COLLISIONS_PATH = Path(__file__).resolve().parent / "known_collisions.json"


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
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--known-collisions",
        type=Path,
        default=None,
        help="Json-serialized list of known collision to compare to",
    )
    group.add_argument(
        "--known-collisions-output-path",
        type=Path,
        default=KNOWN_COLLISIONS_PATH,
        help="Output path for a json-serialized list of known collisions",
    )
    return parser.parse_args()


@dataclass(frozen=True)
class Alias:
    alias: str
    value: str
    module: Path

    def to_dict(self) -> Dict:
        return {
            "alias": self.alias,
            "value": self.value,
            "module": str(self.module),
        }


@dataclass(frozen=True)
class Collision:
    existing_alias: Alias
    new_alias: Alias

    def is_new_collision(self, known_collision_aliases: List[str]) -> bool:
        return self.new_alias.alias not in known_collision_aliases

    @classmethod
    def from_dict(cls, collision_dict: Dict) -> "Collision":
        return cls(
            Alias(**collision_dict["existing_alias"]),
            Alias(**collision_dict["new_alias"]),
        )

    def to_dict(self) -> Dict:
        return {
            "existing_alias": self.existing_alias.to_dict(),
            "new_alias": self.new_alias.to_dict(),
        }


def find_aliases_in_file(file: Path) -> List[Alias]:
    matches = re.findall(r"^alias (.*)='(.*)'", file.read_text(), re.M)
    return [Alias(match[0], match[1], file) for match in matches]


def load_known_collisions(collision_file: Path) -> List[Collision]:
    collision_list = json.loads(collision_file.read_text())
    return [Collision.from_dict(collision_dict) for collision_dict in collision_list]


def find_all_aliases(path: Path) -> list:
    aliases = [find_aliases_in_file(file) for file in path.rglob("*.zsh")]
    return list(itertools.chain(*aliases))


def check_for_duplicates(aliases: List[Alias]) -> List[Collision]:
    elements = {}
    collisions = []
    for alias in aliases:
        if alias.alias in elements:
            existing = elements[alias.alias]
            collisions.append(Collision(existing, alias))
        else:
            elements[alias.alias] = alias
    return collisions


def print_collisions(collisions: Dict[Alias, Alias]) -> None:
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


def check_for_new_collisions(
    known_collisions: Path, collisions: List[Collision]
) -> List[Collision]:
    known_collisions = load_known_collisions(known_collisions)
    known_collision_aliases = [
        collision.new_alias.alias for collision in known_collisions
    ]

    return [
        collision
        for collision in collisions
        if collision.is_new_collision(known_collision_aliases)
    ]


def main() -> int:
    """main"""
    args = parse_arguments()
    aliases = find_all_aliases(args.folder)
    collisions = check_for_duplicates(aliases)

    if args.known_collisions is not None:
        new_collisions = check_for_new_collisions(args.known_collisions, collisions)
        print_collisions(new_collisions)
        return -1 if new_collisions else 0

    args.known_collisions_output_path.write_text(
        json.dumps([collision.to_dict() for collision in collisions])
    )
    return 0


if __name__ == "__main__":
    exit(main())
