TOKEN=$1
URL=$2
BRANCH=$3

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $TOKEN" \
   $URL \
  -d '{"ref":"main","inputs":{"branch_name": "$BRANCH"}}'