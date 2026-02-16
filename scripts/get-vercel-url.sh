#!/usr/bin/env bash
# Gets production URL for hello-atlas. Saves to .atlas_live_url for email step.
set -e
cd "$(dirname "$0")/.."
set +e; source .env 2>/dev/null; set -e
DEFAULT_URL="https://hello-atlas.vercel.app"
if [ -n "$VERCEL_TOKEN" ]; then
  RES=$(curl -s -H "Authorization: Bearer $VERCEL_TOKEN" \
    "https://api.vercel.com/v6/deployments?projectId=hello-atlas&target=production&limit=1" 2>/dev/null || true)
  URL=$(echo "$RES" | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)
  [ -n "$URL" ] && DEFAULT_URL="https://$URL"
fi
echo "$DEFAULT_URL" > .atlas_live_url
cat .atlas_live_url
