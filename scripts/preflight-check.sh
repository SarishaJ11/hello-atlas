#!/usr/bin/env bash
# Pre-flight: validate required env vars before running the full demo
set -e
cd "$(dirname "$0")/.."
set +e; source .env 2>/dev/null; set -e

MISSING=()
[ -z "$VERCEL_TOKEN" ] && MISSING+=("VERCEL_TOKEN - get from vercel.com/account/tokens")
[ -z "$STRIPE_SECRET_KEY" ] && MISSING+=("STRIPE_SECRET_KEY")
[ -z "$NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY" ] && MISSING+=("NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY")
[ -z "$STRIPE_PRICE_ID" ] && [ ! -f .atlas_demo_price_id ] && MISSING+=("STRIPE_PRICE_ID - required for checkout (or run create-stripe-product.sh)")
[ -z "$RESEND_API_KEY" ] && MISSING+=("RESEND_API_KEY")
[ -z "$OPENAI_API_KEY" ] && MISSING+=("OPENAI_API_KEY")
[ -z "$CUSTOMER_EMAIL" ] && MISSING+=("CUSTOMER_EMAIL - recipient for onboarding emails")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "Pre-flight FAILED. Add these to demo/hello-atlas/.env:" >&2
  for m in "${MISSING[@]}"; do echo "  - $m" >&2; done
  echo "" >&2
  echo "See .env.example for the full template." >&2
  exit 1
fi

echo "Pre-flight OK: VERCEL_TOKEN, Stripe, Resend, OpenAI configured."
