#!/bin/bash
# Copyright 2018 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script will create a git repo on the configured project and push a
# modified version of the default content that includes a page titled
# 'Example Page' which includes some example markdown.

# Make Bash a little less error-prone.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Script requires your Endpoints service name as an argument"
  echo "Usage: add_example_page.sh <SERVICE_NAME>"
  exit 1
fi

service_name=$1

get_project_id() {
  # Find the project ID first by DEVSHELL_PROJECT_ID (in Cloud Shell)
  # and then by querying the gcloud default project.
  local project="${DEVSHELL_PROJECT_ID:-}"
  if [[ -z "$project" ]]; then
    project=$(gcloud config get-value project 2> /dev/null)
  fi
  if [[ -z "$project" ]]; then
    >&2 echo "No default project was found, and DEVSHELL_PROJECT_ID is not set."
    >&2 echo "Please use the Cloud Shell or set your default project by typing:"
    >&2 echo "gcloud config set project YOUR-PROJECT-NAME"
  fi
  echo "$project"
}

main() {
  # Get our working project, or exit if it's not set.
  local project_id=$(get_project_id)
  if [[ -z "$project_id" ]]; then
    exit 1
  fi

  if ! $(gcloud endpoints configs list --service="${service_name}" \
           >/dev/null 2>&1); then
    echo "Service ${service_name} not found or permission denied."
    exit 1
  fi

  # Set credential helper to gcloud for authenticating to Cloud Source Repositories.
  git config credential.'https://source.developers.google.com'.helper gcloud.sh

  # Get the string before the first period from the service name to use as a prefix to the repo name
  local repo_prefix="${service_name%%.*}"
  # Get the epoch seconds to use as a suffix so the command doesn't fail if ran multiple times
  local epoch_seconds=$(date +'%s')
  # Create a repository
  local repo_name="${repo_prefix}_portal_content_${epoch_seconds}"
  gcloud --project "${project_id}" source repos create "${repo_name}"

  # Get the url of the repo we just created and set it as the remote of this one
  local git_url=$(gcloud --project "${project_id}" source repos describe \
                    "${repo_name}" --format="value(url)")
  git remote set-url origin "${git_url}"
  git remote add upstream "${git_url}" >/dev/null 2>&1 || git remote set-url upstream "${git_url}" >/dev/null 2>&1

  # Copy and rename the host directory
  cp -rfT "../default.api.host" "../${service_name}"

  # Copy the Example Page to the Guides folder
  cp "script_data/Example Page.md" "../${service_name}/Guides/"

  # Add Example Page to navigation
  perl -i -lne 'print $_;print "    - Example Page" if(/\- Getting Started/);' \
      "../${service_name}/navigation.yaml"

  # Commit and push changes to the repo that was previously created
  git add --all
  git commit -m "Example Page added by add_example_page.sh script" || \
      git commit -m "Example Page added by add_example_page.sh script" | \
      grep -q -E "Your branch is up to date|Your branch is ahead of 'origin/master'"
  git push -u origin master

  echo
  echo "Successfully forked example repository"
  echo
  echo "To update your portal, go to the following settings link and sync your content"
  echo
  echo "Your API's portal settings:  https://endpointsportal.${project_id}.cloud.goog/settings/${service_name}"
  echo
  echo "Your git URL:  ${git_url}"
}

main
