#!/usr/bin/env bash
# Sends onboarding email via Resend API
set -e
cd "$(dirname "$0")/.."
set +e; source .env 2>/dev/null; set -e

: "${RESEND_API_KEY:?RESEND_API_KEY required - get from resend.com/api-keys}"
: "${CUSTOMER_EMAIL:?CUSTOMER_EMAIL required}"
FROM_EMAIL="${FROM_EMAIL:-onboarding@resend.dev}"

if [ -f .atlas_live_url ]; then
  LIVE_URL=$(cat .atlas_live_url)
else
  LIVE_URL="${1:-https://hello-atlas.vercel.app}"
fi

# Skip if we already sent for this URL (prevents duplicates from retries/multiple runs)
if [ -f .atlas_email_sent ]; then
  SENT_URL=$(cat .atlas_email_sent)
  if [ "$SENT_URL" = "$LIVE_URL" ]; then
    echo "Email already sent for $LIVE_URL (skipping)"
    exit 0
  fi
fi

SUBJECT="Your Atlas Pro is live"
BODY="Your app is live at: $LIVE_URL. Log in and start building. - ATLAS"
# Escape for JSON
BODY_ESC=$(echo "$BODY" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g')

RESP=$(curl -s -w "\n%{http_code}" -X POST https://api.resend.com/emails \
  -H "Authorization: Bearer $RESEND_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"from\":\"$FROM_EMAIL\",\"to\":[\"$CUSTOMER_EMAIL\"],\"subject\":\"$SUBJECT\",\"text\":\"$BODY_ESC\"}")
HTTP=$(echo "$RESP" | tail -1)
RESP_BODY=$(echo "$RESP" | sed '$d')
if [ "$HTTP" != "200" ] || ! echo "$RESP_BODY" | grep -q '"id"'; then
  echo "Resend API failed (HTTP $HTTP): $RESP_BODY" >&2
  exit 1
fi

echo "$LIVE_URL" > .atlas_email_sent
echo "Email sent to $CUSTOMER_EMAIL"
