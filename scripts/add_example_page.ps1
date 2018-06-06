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

if ($args.Length -ne 1)
{
    Write-Output "Script requires your Endpoints service name as an argument"
    Write-Output "Usage: add_example_page.ps1 <SERVICE_NAME>"
    exit
}

$service_name=$args[0]

##############################################################################
#.SYNOPSIS
# Get the project id that Google Cloud commands will use by default.
#
#.OUTPUTs
# The current project id.
##############################################################################

Function GetProjectId()
{
    # Find the project ID first by DEVSHELL_PROJECT_ID (in Cloud Shell)
    # and then by querying the gcloud default project.
    $project = $env:DEVSHELL_PROJECT_ID
    if (!$project)
    {
        ($project = gcloud config get-value project) 2>$null
    }
    if (!$project)
    {
        Write-Error "No default project was found, and DEVSHELL_PROJECT_ID is not set."
        Write-Error "Please use the Cloud Shell or set your default project by typing:"
        Write-Error "gcloud config set project YOUR-PROJECT-NAME"
    }
    Write-Host "Project is set to $project"
}

Function Main()
{
    # Get our working project, or exit if it's not set.
    $project_id = GetProjectId
    if (!$project_id)
    {
        exit 1
    }

    gcloud endpoints configs list --service=$service_name 2>&1 | Out-Null
    if (!$?)
    {
        Write-Host "Service $service_name not found or permission denied."
        exit 1
    }
    else {
        Write-Host "Service $service_name was found"
    }

    # Set credential helper to gcloud for authenticating to Cloud Source Repositories.
    git config credential.https://source.developers.google.com.helper gcloud.cmd

    # Get the string before the first period from the service name to use as a prefix to the repo name
    $repo_prefix = ($service_name).Split('.')[0]
    # Get the epoch seconds to use as a suffix so the command doesn't fail if ran multiple times
    $epoch_seconds = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds
    # Create a repository
    $repo_name=$repo_prefix + "_portal_content_" + $epoch_seconds
    gcloud --project "$project_id" source repos create "$repo_name"

    # Get the url of the repo we just created and set it as the remote of this one
    $git_url=(gcloud --project "$project_id" source repos describe "$repo_name" --format="value(url)")
    git remote set-url origin "$git_url"
    git remote add upstream "$git_url" >$null 2>&1
    if ($?)
    {
        git remote set-url upstream "$git_url" >$null 2>&1
    }

    # Copy and rename the host directory
    Copy-Item "../default.api.host" -Destination "../$service_name" -Recurse -Force

    # Copy the Example Page to the Guides folder
    Copy-Item "script_data/Example Page.md" -Destination "../$service_name/Guides/"

    # Add Example Page to navigation
    Add-Content -Path "../$service_name/navigation.yaml" -Value "    - Example Page"

    # Commit and push changes to the repo that was previously created
    git add --all
    git commit -m "Example Page added by add_example_page.sh script"
    if (!$?)
    {
        # If commit failed, check if it's because we're already in an OK state
        # to push (possibly from a failed previous run), or if it's because
        # something else went wrong.
        $searchresults = git commit -m "Example Page added by add_example_page.sh script" | select-string -pattern "(Your branch is up to date)|(Your branch is ahead of origin/master')"
        if ($searchresults -eq $null) {
            Write-Host "git repository not in a good state to push."
            exit 1
        }
    }
    git push -u origin master

    Write-Host "Successfully forked example repository"
    Write-Host
    Write-Host "To update your portal, go to the following settings link and sync your content"
    Write-Host
    Write-Host "Your API's portal settings:  https://endpointsportal.$project_id.cloud.goog/settings/$service_name"
    Write-Host
    Write-Host "Your git URL:  $git_url"
}

Main
