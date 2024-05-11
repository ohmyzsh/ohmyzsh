import os
import subprocess
import sys
import requests
import shutil
import yaml
from copy import deepcopy
from typing import Optional, TypedDict

# Get TMP_DIR variable from environment
TMP_DIR = os.path.join(os.environ.get("TMP_DIR", "/tmp"), "ohmyzsh")
# Relative path to dependencies.yml file
DEPS_YAML_FILE = ".github/dependencies.yml"
# Dry run flag
DRY_RUN = os.environ.get("DRY_RUN", "0") == "1"

import timeit
class CodeTimer:
  def __init__(self, name=None):
    self.name = " '"  + name + "'" if name else ''

  def __enter__(self):
    self.start = timeit.default_timer()

  def __exit__(self, exc_type, exc_value, traceback):
    self.took = (timeit.default_timer() - self.start) * 1000.0
    print('Code block' + self.name + ' took: ' + str(self.took) + ' ms')


### YAML representation
def str_presenter(dumper, data):
  """
  Configures yaml for dumping multiline strings
  Ref: https://stackoverflow.com/a/33300001
  """
  if len(data.splitlines()) > 1:  # check for multiline string
    return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
  return dumper.represent_scalar('tag:yaml.org,2002:str', data)

yaml.add_representer(str, str_presenter)
yaml.representer.SafeRepresenter.add_representer(str, str_presenter)


# Types
class DependencyDict(TypedDict):
  repo: str
  branch: str
  version: str
  precopy: Optional[str]
  postcopy: Optional[str]

class DependencyYAML(TypedDict):
  dependencies: dict[str, DependencyDict]

class UpdateStatus(TypedDict):
  has_updates: bool
  version: Optional[str]
  compare_url: Optional[str]
  head_ref: Optional[str]
  head_url: Optional[str]


class CommandRunner:
  class Exception(Exception):
    def __init__(self, message, returncode, stage, stdout, stderr):
      super().__init__(message)
      self.returncode = returncode
      self.stage = stage
      self.stdout = stdout
      self.stderr = stderr

  @staticmethod
  def run_or_fail(command: list[str], stage: str, *args, **kwargs):
    if DRY_RUN and command[0] == "gh":
      command.insert(0, "echo")

    result = subprocess.run(command, *args, capture_output=True, **kwargs)

    if result.returncode != 0:
      raise CommandRunner.Exception(
        f"{stage} command failed with exit code {result.returncode}", returncode=result.returncode,
        stage=stage,
        stdout=result.stdout.decode("utf-8"),
        stderr=result.stderr.decode("utf-8")
      )

    return result


class DependencyStore:
  store: DependencyYAML = {
    "dependencies": {}
  }

  @staticmethod
  def set(data: DependencyYAML):
    DependencyStore.store = data

  @staticmethod
  def update_dependency_version(path: str, version: str) -> DependencyYAML:
    with CodeTimer(f"store deepcopy: {path}"):
      store_copy = deepcopy(DependencyStore.store)

    dependency = store_copy["dependencies"].get(path, {})
    dependency["version"] = version
    store_copy["dependencies"][path] = dependency

    return store_copy

  @staticmethod
  def write_store(file: str, data: DependencyYAML):
    with open(file, "w") as yaml_file:
      yaml.safe_dump(data, yaml_file, sort_keys=False)


class Dependency:
  def __init__(self, path: str, values: DependencyDict):
    self.path = path
    self.values = values

    self.name: str = ""
    self.desc: str = ""
    self.kind: str = ""

    match path.split("/"):
      case ["plugins", name]:
        self.name = name
        self.kind = "plugin"
        self.desc = f"{name} plugin"
      case ["themes", name]:
        self.name = name.replace(".zsh-theme", "")
        self.kind = "theme"
        self.desc = f"{self.name} theme"
      case _:
        self.name = self.desc = path

  def __str__(self):
    output: str = ""
    for key in DependencyDict.__dict__['__annotations__'].keys():
      if key not in self.values:
        output += f"{key}: None\n"
        continue

      value = self.values[key]
      if "\n" not in value:
        output += f"{key}: {value}\n"
      else:
        output += f"{key}:\n  "
        output += value.replace("\n", "\n  ", value.count("\n") - 1)
    return output

  def update_or_notify(self):
    # Print dependency settings
    print(f"Processing {self.desc}...", file=sys.stderr)
    print(self, file=sys.stderr)

    # Check for updates
    repo = self.values["repo"]
    remote_branch = self.values["branch"]
    version = self.values["version"]
    is_tag = version.startswith("tag:")

    try:
      with CodeTimer(f"update check: {repo}"):
        if is_tag:
          status = GitHub.check_newer_tag(repo, version.replace("tag:", ""))
        else:
          status = GitHub.check_updates(repo, remote_branch, version)

      if status["has_updates"]:
        short_sha = status["head_ref"][:8]
        new_version = status["version"] if is_tag else short_sha

        try:
          # Create new branch
          branch = Git.create_branch(self.path, new_version)

          # Update dependencies.yml file
          self.__update_yaml(f"tag:{new_version}" if is_tag else status["version"])

          # Update dependency files
          self.__apply_upstream_changes()

          # Add all changes and commit
          Git.add_and_commit(self.name, short_sha)

          # Push changes to remote
          Git.push(branch)

          # Create GitHub PR
          GitHub.create_pr(
            branch,
            f"feat({self.name}): update to version {new_version}",
            f"""## Description

Update for **{self.desc}**: update to version [{new_version}]({status['head_url']}).
Check out the [list of changes]({status['compare_url']}).
"""
          )

          # Clean up repository
          Git.clean_repo()
        except (CommandRunner.Exception, shutil.Error) as e:
          # Handle exception on automatic update
          match type(e):
            case CommandRunner.Exception:
              # Print error message
              print(f"Error running {e.stage} command: {e.returncode}", file=sys.stderr)
              print(e.stderr, file=sys.stderr)
            case shutil.Error:
              print(f"Error copying files: {e}", file=sys.stderr)

          try:
            Git.clean_repo()
          except CommandRunner.Exception as e:
            print(f"Error reverting repository to clean state: {e}", file=sys.stderr)
            sys.exit(1)

          # Create a GitHub issue to notify maintainer
          title = f"{self.path}: update to {new_version}"
          body = (
            f"""## Description

There is a new version of `{self.name}` {self.kind} available.

New version: [{new_version}]({status['head_url']})
Check out the [list of changes]({status['compare_url']}).
"""
          )

          print(f"Creating GitHub issue", file=sys.stderr)
          print(f"{title}\n\n{body}", file=sys.stderr)
          GitHub.create_issue(title, body)
    except Exception as e:
      print(e, file=sys.stderr)

  def __update_yaml(self, new_version: str) -> None:
    dep_yaml = DependencyStore.update_dependency_version(self.path, new_version)
    DependencyStore.write_store(DEPS_YAML_FILE, dep_yaml)

  def __apply_upstream_changes(self) -> None:
    # Patterns to ignore in copying files from upstream repo
    GLOBAL_IGNORE = [
      ".git",
      ".github",
      ".gitignore"
    ]

    path = os.path.abspath(self.path)
    precopy = self.values.get("precopy")
    postcopy = self.values.get("postcopy")

    repo = self.values["repo"]
    branch = self.values["branch"]
    remote_url = f"https://github.com/{repo}.git"
    repo_dir = os.path.join(TMP_DIR, repo)

    # Clone repository
    Git.clone(remote_url, branch, repo_dir, reclone=True)

    # Run precopy on tmp repo
    if precopy is not None:
      print("Running precopy script:", end="\n  ", file=sys.stderr)
      print(precopy.replace("\n", "\n  ", precopy.count("\n") - 1), file=sys.stderr)
      CommandRunner.run_or_fail(["bash", "-c", precopy], cwd=repo_dir, stage="Precopy")

    # Copy files from upstream repo
    print(f"Copying files from {repo_dir} to {path}", file=sys.stderr)
    shutil.copytree(repo_dir, path, dirs_exist_ok=True, ignore=shutil.ignore_patterns(*GLOBAL_IGNORE))

    # Run postcopy on our repository
    if postcopy is not None:
      print("Running postcopy script:", end="\n  ", file=sys.stderr)
      print(postcopy.replace("\n", "\n  ", postcopy.count("\n") - 1), file=sys.stderr)
      CommandRunner.run_or_fail(["bash", "-c", postcopy], cwd=path, stage="Postcopy")


class Git:
  default_branch = "master"

  @staticmethod
  def clone(remote_url: str, branch: str, repo_dir: str, reclone=False):
    # If repo needs to be fresh
    if reclone and os.path.exists(repo_dir):
      shutil.rmtree(repo_dir)

    # Clone repo in tmp directory and checkout branch
    if not os.path.exists(repo_dir):
      print(f"Cloning {remote_url} to {repo_dir} and checking out {branch}", file=sys.stderr)
      CommandRunner.run_or_fail(["git", "clone", "--depth=1", "-b", branch, remote_url, repo_dir], stage="Clone")

  @staticmethod
  def create_branch(path: str, version: str):
    # Get current branch name
    result = CommandRunner.run_or_fail(["git", "rev-parse", "--abbrev-ref", "HEAD"], stage="GetDefaultBranch")
    Git.default_branch = result.stdout.decode("utf-8").strip()

    # Create new branch and return created branch name
    branch_name = f"update/{path}/{version}"
    CommandRunner.run_or_fail(["git", "checkout", "-b", branch_name], stage="CreateBranch")
    return branch_name

  @staticmethod
  def add_and_commit(scope: str, version: str):
    user_name = os.environ.get("GIT_APP_NAME")
    user_email = os.environ.get("GIT_APP_EMAIL")

    # Add all files to git staging
    CommandRunner.run_or_fail(["git", "add", "-A", "-v"], stage="AddFiles")

    # Reset environment and git config
    clean_env = os.environ.copy()
    clean_env["LANG"]="C.UTF-8"
    clean_env["GIT_CONFIG_GLOBAL"]="/dev/null"
    clean_env["GIT_CONFIG_NOSYSTEM"]="1"

    # Commit with settings above
    CommandRunner.run_or_fail([
      "git",
      "-c", f"user.name={user_name}",
      "-c", f"user.email={user_email}",
      "commit",
      "-m", f"feat({scope}): update to {version}"
    ], stage="CreateCommit", env=clean_env)

  @staticmethod
  def push(branch: str):
    CommandRunner.run_or_fail(["git", "push", "-u", "origin", branch], stage="PushBranch")

  @staticmethod
  def clean_repo():
    CommandRunner.run_or_fail(["git", "reset", "--hard", "HEAD"], stage="ResetRepository")
    CommandRunner.run_or_fail(["git", "checkout", Git.default_branch], stage="CheckoutDefaultBranch")


class GitHub:
  @staticmethod
  def check_newer_tag(repo, current_tag) -> UpdateStatus:
    # GET /repos/:owner/:repo/git/refs/tags
    url = f"https://api.github.com/repos/{repo}/git/refs/tags"

    # Send a GET request to the GitHub API
    response = requests.get(url)

    # If the request was successful
    if response.status_code == 200:
      # Parse the JSON response
      data = response.json()

      if len(data) == 0:
        return {
          "has_updates": False,
        }

      latest_ref = data[-1]
      latest_tag = latest_ref["ref"].replace("refs/tags/", "")

      if latest_tag == current_tag:
        return {
          "has_updates": False,
        }

      return {
        "has_updates": True,
        "version": latest_tag,
        "compare_url": f"https://github.com/{repo}/compare/{current_tag}...{latest_tag}",
        "head_ref": latest_ref["object"]["sha"],
        "head_url": f"https://github.com/{repo}/releases/tag/{latest_tag}",
      }
    else:
      # If the request was not successful, raise an exception
      raise Exception(f"GitHub API request failed with status code {response.status_code}: {response.json()}")

  @staticmethod
  def check_updates(repo, branch, version) -> UpdateStatus:
    # TODO: add support for semver updating (based on tags)
    # Check if upstream github repo has a new version
    # GitHub API URL for comparing two commits
    url = f"https://api.github.com/repos/{repo}/compare/{version}...{branch}"

    # Send a GET request to the GitHub API
    response = requests.get(url)

    # If the request was successful
    if response.status_code == 200:
      # Parse the JSON response
      data = response.json()

      # If the base is behind the head, there is a newer version
      has_updates = data["status"] != "identical"

      if not has_updates:
        return {
          "has_updates": False,
        }

      return {
        "has_updates": data["status"] != "identical",
        "version": data["commits"][-1]["sha"],
        "compare_url": data["permalink_url"],
        "head_ref": data["commits"][-1]["sha"],
        "head_url": data["commits"][-1]["html_url"]
      }
    else:
      # If the request was not successful, raise an exception
      raise Exception(f"GitHub API request failed with status code {response.status_code}: {response.json()}")

  @staticmethod
  def create_issue(title: str, body: str) -> None:
    cmd = [
      "gh",
      "issue",
      "create",
      "-t", title,
      "-b", body
    ]
    CommandRunner.run_or_fail(cmd, stage="CreateIssue")

  @staticmethod
  def create_pr(branch: str, title: str, body: str) -> None:
    cmd = [
      "gh",
      "pr",
      "create",
      "-B", Git.default_branch,
      "-H", branch,
      "-t", title,
      "-b", body
    ]
    CommandRunner.run_or_fail(cmd, stage="CreatePullRequest")


def main():
  # Load the YAML file
  with open(DEPS_YAML_FILE, "r") as yaml_file:
    data: DependencyYAML = yaml.safe_load(yaml_file)

  if "dependencies" not in data:
    raise Exception(f"dependencies.yml not properly formatted")

  # Cache YAML version
  DependencyStore.set(data)

  dependencies = data["dependencies"]
  for path in dependencies:
    dependency = Dependency(path, dependencies[path])
    dependency.update_or_notify()

if __name__ == "__main__":
  main()
