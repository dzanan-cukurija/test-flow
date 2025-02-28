#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <workflow_name> <branch_name>"
  echo "  <workflow_name>: The filename of the workflow to trigger (e.g., workflow2.yml)."
  echo "  <branch_name>: The name of the branch to use for the 'branch_name' input."
  exit 1
fi

WORKFLOW_NAME="$1"  # Workflow filename (e.g., workflow2.yml)
BRANCH_NAME="$2"  # Branch name (e.g., feat/something)

# Validate environment variables
if [ -z "$GITHUB_REPOSITORY" ]; then
  echo "Error: GITHUB_REPOSITORY environment variable not set."
  exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN environment variable not set."
  exit 1
fi

# Construct the JSON payload.  Important: put branch_name in client_payload
PAYLOAD=$(cat <<EOF
{
  "ref": "${GITHUB_REF}",
  "client_payload": {
    "branch_name": "${BRANCH_NAME}"
  }
}
EOF
)
# Construct the API URL
API_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/workflows/${WORKFLOW_NAME}/dispatches"

# Trigger the workflow using curl
curl -X POST \
  "$API_URL" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD"

# Check the exit code of curl for success/failure
if [ $? -eq 0 ]; then
  echo "Successfully triggered workflow '$WORKFLOW_NAME' with branch '$BRANCH_NAME'"
else
  echo "Failed to trigger workflow '$WORKFLOW_NAME' with branch '$BRANCH_NAME'"
  exit 1
fi

exit 0
