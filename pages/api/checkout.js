const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || '')
  .split(',')
  .map((o) => o.trim())
  .filter(Boolean);

function getTrustedBaseUrl(req) {
  const baseUrl = process.env.BASE_URL
    || (process.env.VERCEL_URL ? `https://${process.env.VERCEL_URL}` : null);
  const reqOrigin = req.headers.origin || req.headers.referer;
  if (reqOrigin) {
    try {
      const u = new URL(reqOrigin);
      const origin = `${u.protocol}//${u.host}`;
      if (ALLOWED_ORIGINS.length === 0 || ALLOWED_ORIGINS.some((a) => origin === a || u.hostname === a)) {
        return origin;
      }
    } catch (_) {
      /* ignore invalid */
    }
  }
  return baseUrl || 'https://example.com';
}

export default async function handler(req, res) {
  const priceId = process.env.STRIPE_PRICE_ID;
  if (!priceId) {
    return res.status(500).send('STRIPE_PRICE_ID not configured');
  }

  try {
    const base = getTrustedBaseUrl(req);
    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${base}/?success=true`,
      cancel_url: `${base}/?canceled=true`,
    });
    res.redirect(303, session.url);
  } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
  }
}
