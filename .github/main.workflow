workflow "Triage Pull Request" {
  on = "pull_request"
  resolves = ["Triage"]
}

# Only act if there are code changes: if the pull_request
# event's action is either 'opened' (new PR) or 'synchronize' (new commits)
action "Filter actions" {
  uses = "actions/bin/filter@0ac6d44"
  args = "action 'opened|synchronize'"
}

action "Triage" {
  needs = ["Filter actions"]
  uses = "ohmyzsh/github-actions/pull-request-triage@master"
  secrets = ["GITHUB_TOKEN"]
}
