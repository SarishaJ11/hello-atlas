const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

export default async function handler(req, res) {
  const priceId = process.env.STRIPE_PRICE_ID;
  if (!priceId) {
    return res.status(500).send('STRIPE_PRICE_ID not configured');
  }

  try {
    const origin = req.headers.origin || req.headers.referer || 'https://example.com';
    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${origin}/?success=true`,
      cancel_url: `${origin}/?canceled=true`,
    });
    res.redirect(303, session.url);
  } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
  }
}
