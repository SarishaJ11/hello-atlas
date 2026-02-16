#!/usr/bin/env bash
# Creates Stripe product "Atlas Pro" $29/mo and outputs price ID to .atlas_demo_price_id
set -e
cd "$(dirname "$0")/.."
# Load .env (vars may also be inherited from atlas). Use quoted values in .env for paths with spaces.
set +e
source .env 2>/dev/null
set -e
if [ -z "$STRIPE_SECRET_KEY" ]; then
  echo "Error: STRIPE_SECRET_KEY is not set. Add it to .env (see .env.example)" >&2
  exit 1
fi

PRODUCT=$(curl -s -X POST https://api.stripe.com/v1/products \
  -u "$STRIPE_SECRET_KEY:" \
  -d "name=Atlas Pro" \
  -d "description=Atlas Pro - Monthly subscription")

PROD_ID=$(echo "$PRODUCT" | grep -o '"id": "prod_[^"]*"' | head -1 | cut -d'"' -f4)
if [ -z "$PROD_ID" ]; then
  echo "Error: Stripe product creation failed. Check STRIPE_SECRET_KEY. Response: $PRODUCT" >&2
  exit 1
fi
PRICE=$(curl -s -X POST https://api.stripe.com/v1/prices \
  -u "$STRIPE_SECRET_KEY:" \
  -d "product=$PROD_ID" \
  -d "unit_amount=2900" \
  -d "currency=usd" \
  -d "recurring[interval]=month")

PRICE_ID=$(echo "$PRICE" | grep -o '"id": "price_[^"]*"' | head -1 | cut -d'"' -f4)
if [ -z "$PRICE_ID" ]; then
  echo "Error: Stripe price creation failed. Response: $PRICE" >&2
  exit 1
fi
echo "$PRICE_ID" > .atlas_demo_price_id
echo "Created Atlas Pro - price ID: $PRICE_ID"
