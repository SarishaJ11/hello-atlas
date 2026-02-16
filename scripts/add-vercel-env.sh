#!/usr/bin/env bash
# Adds Stripe env vars to Vercel project via API
set -e
cd "$(dirname "$0")/.."
set +e; source .env 2>/dev/null; set -e

: "${VERCEL_TOKEN:?VERCEL_TOKEN required - get from vercel.com/account/tokens}"
: "${STRIPE_SECRET_KEY:?STRIPE_SECRET_KEY required}"
: "${NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY:?NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY required}"
[ -f .atlas_demo_price_id ] || { echo ".atlas_demo_price_id not found - run create-stripe-product first"; exit 1; }

PRICE_ID=$(cat .atlas_demo_price_id)
PROJECT="hello-atlas"
RESP_FILE=$(mktemp)
trap "rm -f $RESP_FILE" EXIT

# type "sensitive" accepts raw values; "secret" requires pre-created secret IDs
add_var() {
  local KEY=$1
  local VAL=$2
  local TYPE="plain"
  [[ "$KEY" == *"SECRET"* || "$KEY" == *"KEY"* ]] && TYPE="sensitive"
  HTTP=$(curl -s -w "%{http_code}" -o "$RESP_FILE" -X POST "https://api.vercel.com/v10/projects/$PROJECT/env?upsert=true" \
    -H "Authorization: Bearer $VERCEL_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"key\":\"$KEY\",\"value\":\"$VAL\",\"type\":\"$TYPE\",\"target\":[\"production\",\"preview\"]}")
  if [ "$HTTP" != "200" ] && [ "$HTTP" != "201" ]; then
    echo "Vercel API failed for $1 (HTTP $HTTP). Check project exists and token." >&2
    cat "$RESP_FILE" >&2
    exit 1
  fi
}

add_var "STRIPE_SECRET_KEY" "$STRIPE_SECRET_KEY"
add_var "NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY" "$NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY"
add_var "STRIPE_PRICE_ID" "$PRICE_ID"

echo "Vercel env vars added. Trigger redeploy for them to take effect."
