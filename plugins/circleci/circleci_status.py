#!/usr/bin/env python3

import requests
import os
import sys

CIRCLECI_API = "https://circleci.com/api/v2"
org_slug = os.environ.get("CIRCLECI_ORG_SLUG")
args = sys.argv


class COLORS:
    reset = '\033[0m'

    class FG:
        red = '\033[31m'
        green = '\033[32m'
        yellow = '\033[93m'


def get_resp_items(resp):
    if resp.status_code != 200:
        sys.exit(0)
    items = resp.json()["items"]
    if len(items) == 0:
        sys.exit(0)
    return items


def get_status_text(status):
    if status == "success":
        return COLORS.FG.green + "✓" + COLORS.reset
    elif status in ("running", "not_run", "retried"):
        return COLORS.FG.yellow + "•" + COLORS.reset
    else:
        return COLORS.FG.red + "✗" + COLORS.reset


if not org_slug or len(args) != 3:
    sys.exit(0)

branch_name = args[1]
repo_name = args[2]

# Here we query for all the pipelines belonging to the current branch in the current repo
headers = {"Circle-token": os.environ.get("CIRCLECI_API_TOKEN")}
url = f"{CIRCLECI_API}/project/{org_slug}/{repo_name}/pipeline"
params = {"branch": branch_name}
response = requests.get(url, headers=headers, params=params)
pipelines = get_resp_items(response)
# use the latest pipeline
pipeline_id = pipelines[0]["id"]

# Now fetch the workflows for the selected pipeline
url = f"{CIRCLECI_API}/pipeline/{pipeline_id}/workflow"
response = requests.get(url, headers=headers)
workflows = get_resp_items(response)
# use the latest workflow
workflow_id = workflows[0]["id"]

url = f"{CIRCLECI_API}/workflow/{workflow_id}/job"
response = requests.get(url, headers=headers)
jobs = get_resp_items(response)

for job in jobs:
    status = job["status"]
    if status in ("success", "running", "failed", "retried", "timedout",
                  "on_hold", "canceled", "terminated_unknown"):
      name = job["name"]
      project_slug = job["project_slug"]
      job_number = job["job_number"]
      url = f"https://circleci.com/{project_slug}/{job_number}"
      print("{}  {:<50}  {}".format(get_status_text(status), name, url))
