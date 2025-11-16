# Jump Quest - Payment System Setup Guide

This guide will help you set up the payment and subscription system for Jump Quest, allowing you to charge customers €50-100/month to play your game.

## 📋 What You'll Need

- Supabase account (free)
- Stripe account (free, but takes 2.9% + €0.30 per transaction)
- Cloudflare account for hosting (free)
- About 1-2 hours of setup time

## 💰 Pricing Structure

Your game now supports two subscription tiers:
- **Standard**: €50/month
- **Premium**: €100/month

**Your profit per subscriber:**
- Standard: ~€48.70 (after Stripe fees)
- Premium: ~€97.40 (after Stripe fees)
- **Profit margin: ~97%**

---

## 🚀 Step-by-Step Setup

### Part 1: Supabase Setup (Database & Authentication)

#### 1.1 Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up
2. Click "New Project"
3. Choose a name (e.g., "jump-quest")
4. Choose a strong database password and **save it**
5. Select a region close to your users
6. Wait 2-3 minutes for project creation

#### 1.2 Run Database Migration

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the entire contents of `supabase/migrations/001_initial_schema.sql`
3. Paste into the SQL editor
4. Click **RUN**
5. You should see: "✓ Database schema created successfully!"

#### 1.3 Get Your Supabase Credentials

1. Go to **Project Settings** (gear icon) → **API**
2. Copy these values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)
   - **service_role** key (longer string, keep this secret!)

#### 1.4 Configure Authentication

1. Go to **Authentication** → **Providers**
2. Make sure **Email** is enabled
3. Optional: Enable other providers (Google, Facebook, etc.)
4. Go to **Authentication** → **URL Configuration**
5. Add your site URL (e.g., `https://yourdomain.com` or for testing: `http://localhost:8000`)

---

### Part 2: Stripe Setup (Payment Processing)

#### 2.1 Create Stripe Account

1. Go to [stripe.com](https://stripe.com) and sign up
2. Complete business verification (required to accept payments)
3. Toggle **Test mode** ON for now (top right)

#### 2.2 Create Products

**Create Standard Plan:**
1. Go to **Products** → **Add product**
2. Name: `Jump Quest - Standard`
3. Description: `Access to all levels, skins, and cloud saves`
4. Pricing: **€50.00 EUR** recurring **Monthly**
5. Click **Save product**
6. **Copy the Price ID** (looks like `price_xxxxxxxxxxxxx`) - you'll need this!

**Create Premium Plan:**
1. Click **Add product** again
2. Name: `Jump Quest - Premium`
3. Description: `Everything in Standard + priority support & commercial usage`
4. Pricing: **€100.00 EUR** recurring **Monthly**
5. Click **Save product**
6. **Copy the Price ID** (looks like `price_yyyyyyyyyyy`)

#### 2.3 Get Your Stripe API Keys

1. Go to **Developers** → **API keys**
2. Copy:
   - **Publishable key** (starts with `pk_test_...`)
   - **Secret key** (starts with `sk_test_...`) - keep this secret!

#### 2.4 Create Webhook Secret (we'll configure the endpoint later)

1. Go to **Developers** → **Webhooks**
2. Click **Add endpoint** (we'll fill this in Part 3)

---

### Part 3: Deploy Edge Functions to Supabase

#### 3.1 Install Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Or use npm
npm install -g supabase
```

#### 3.2 Login and Link Your Project

```bash
# Login to Supabase
supabase login

# Link to your project
cd /path/to/JumpQuest
supabase link --project-ref YOUR_PROJECT_REF
```

(Find YOUR_PROJECT_REF in Supabase dashboard → Project Settings → General → Reference ID)

#### 3.3 Set Environment Variables

```bash
# Set Stripe keys for Edge Functions
supabase secrets set STRIPE_SECRET_KEY=sk_test_YOUR_SECRET_KEY
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_WEBHOOK_SECRET
```

#### 3.4 Deploy Edge Functions

```bash
# Deploy both functions
supabase functions deploy create-checkout-session
supabase functions deploy stripe-webhook
```

You should see:
```
✓ Deployed create-checkout-session
✓ Deployed stripe-webhook
```

#### 3.5 Get Edge Function URLs

After deployment, you'll get URLs like:
- `https://xxxxx.supabase.co/functions/v1/create-checkout-session`
- `https://xxxxx.supabase.co/functions/v1/stripe-webhook`

**Copy the stripe-webhook URL** - you'll need it for Stripe!

---

### Part 4: Configure Stripe Webhook

#### 4.1 Add Webhook Endpoint

1. Back in Stripe → **Developers** → **Webhooks**
2. Click **Add endpoint**
3. Endpoint URL: Paste your `stripe-webhook` function URL
4. Click **Select events**
5. Select these events:
   - `checkout.session.completed`
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
6. Click **Add endpoint**

#### 4.2 Get Webhook Signing Secret

1. Click on your newly created webhook endpoint
2. Click **Reveal** under "Signing secret"
3. Copy the secret (starts with `whsec_...`)
4. Update your Supabase secret:

```bash
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_ACTUAL_SECRET
```

---

### Part 5: Update Your Game Files

#### 5.1 Update auth.html

Open `auth.html` and replace:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

With your actual Supabase URL and anon key.

#### 5.2 Update subscribe.html

Open `subscribe.html` and replace:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
const STRIPE_PUBLISHABLE_KEY = 'YOUR_STRIPE_PUBLISHABLE_KEY_HERE';

const STRIPE_PRICES = {
    standard: 'price_XXXXXXXXXXXXX', // Your Standard plan price ID
    premium: 'price_YYYYYYYYYYYYY'   // Your Premium plan price ID
};
```

With your actual credentials.

#### 5.3 Update success.html

Open `success.html` and replace:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

#### 5.4 Update game-v8.html

Open `game-v8.html` and replace:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

---

### Part 6: Deploy to Cloudflare Pages (FREE Hosting)

#### 6.1 Create Git Repository

```bash
cd /path/to/JumpQuest
git add .
git commit -m "Add payment system"
git push origin main
```

#### 6.2 Deploy to Cloudflare Pages

1. Go to [dash.cloudflare.com](https://dash.cloudflare.com)
2. Click **Pages** → **Create a project**
3. Connect your GitHub/GitLab account
4. Select your JumpQuest repository
5. Build settings:
   - Framework preset: **None**
   - Build command: (leave empty)
   - Build output directory: `/`
6. Click **Save and Deploy**

Your game will be live at: `https://your-project.pages.dev`

#### 6.3 Update Stripe Success/Cancel URLs

1. Open `supabase/functions/create-checkout-session/index.ts`
2. Replace the URLs with your actual Cloudflare Pages URL:

```typescript
success_url: `https://your-project.pages.dev/success.html?session_id={CHECKOUT_SESSION_ID}`,
cancel_url: `https://your-project.pages.dev/subscribe.html`,
```

3. Redeploy the function:
```bash
supabase functions deploy create-checkout-session
```

---

## ✅ Testing Your Setup

### Test Mode Testing

1. Visit your deployed site: `https://your-project.pages.dev/game-v8.html`
2. You should be redirected to `auth.html`
3. Create a test account
4. You should be redirected to `subscribe.html`
5. Click "Subscribe" on either plan
6. Use Stripe test card: `4242 4242 4242 4242`
   - Expiry: Any future date (e.g., `12/34`)
   - CVC: Any 3 digits (e.g., `123`)
   - ZIP: Any 5 digits (e.g., `12345`)
7. Complete checkout
8. You should be redirected to `success.html`
9. After 5 seconds, redirected to game
10. Play the game! Your progress is now saved to the cloud.

### Verify Database

1. Go to Supabase → **Table Editor**
2. Check `subscriptions` table - you should see your test subscription
3. Check `game_progress` table - you should see your game data

---

## 🎉 Going Live (Accept Real Payments)

### Switch to Production Mode

#### 1. In Stripe:

1. Toggle **Test mode** OFF (top right)
2. Complete account verification if not already done
3. Recreate your products in Live mode:
   - Standard: €50/month
   - Premium: €100/month
4. Get your **LIVE** API keys:
   - Publishable key (starts with `pk_live_...`)
   - Secret key (starts with `sk_live_...`)
5. Create a NEW webhook endpoint with your live function URL
6. Get the live webhook secret

#### 2. Update Supabase Secrets:

```bash
supabase secrets set STRIPE_SECRET_KEY=sk_live_YOUR_LIVE_SECRET
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_LIVE_WEBHOOK_SECRET
```

#### 3. Update Your HTML Files:

Replace all test keys with live keys in:
- `auth.html`
- `subscribe.html`
- `success.html`
- `game-v8.html`

#### 4. Redeploy:

```bash
git add .
git commit -m "Switch to live Stripe keys"
git push origin main
```

Cloudflare Pages will automatically redeploy.

---

## 🔒 Security Checklist

- [ ] Never commit API keys to Git
- [ ] Use environment variables for secrets
- [ ] Enable Row Level Security (already done in migration)
- [ ] Verify webhook signatures (already done in webhook handler)
- [ ] Use HTTPS only (Cloudflare provides this automatically)
- [ ] Test subscription flow thoroughly before going live

---

## 💡 Managing Subscriptions

### Customer Self-Service

Customers can manage their subscriptions through **Stripe Customer Portal**:

1. In Stripe Dashboard → **Settings** → **Customer Portal**
2. Activate the portal
3. Customize the appearance
4. Enable features:
   - Update payment method
   - Cancel subscription
   - View invoices

Add a "Manage Subscription" button to your game:

```html
<button onclick="manageSubscription()">Manage Subscription</button>

<script>
async function manageSubscription() {
    const { data: { session } } = await supabase.auth.getSession();
    const { data: sub } = await supabase
        .from('subscriptions')
        .select('stripe_customer_id')
        .eq('user_id', session.user.id)
        .single();

    // Create portal session via Edge Function
    const portalSession = await stripe.billingPortal.sessions.create({
        customer: sub.stripe_customer_id,
        return_url: window.location.href,
    });

    window.location.href = portalSession.url;
}
</script>
```

---

## 📊 Monitoring & Analytics

### View Revenue

1. Stripe Dashboard → **Home**
2. See revenue, subscriptions, customers

### View Active Subscriptions

1. Supabase → **Table Editor** → `subscriptions`
2. Filter by `status = 'active'`

### View User Stats

```sql
-- Run in Supabase SQL Editor
SELECT
    plan_type,
    COUNT(*) as subscribers,
    COUNT(*) * CASE
        WHEN plan_type = 'standard' THEN 50
        WHEN plan_type = 'premium' THEN 100
    END as monthly_revenue
FROM subscriptions
WHERE status = 'active'
GROUP BY plan_type;
```

---

## 🐛 Troubleshooting

### "Payment not working"
- Check Stripe is in correct mode (test vs live)
- Verify webhook is receiving events (Stripe → Webhooks → check logs)
- Check Supabase function logs: `supabase functions logs stripe-webhook`

### "Can't access game after payment"
- Check subscription in Supabase `subscriptions` table
- Verify `current_period_end` is in the future
- Check browser console for errors

### "Webhook failing"
- Verify webhook secret matches in Stripe and Supabase
- Check function logs: `supabase functions logs stripe-webhook`
- Ensure events are selected in Stripe webhook settings

---

## 💰 Expected Revenue

### Scenario: 100 Subscribers

| Plan | Subscribers | Price | Revenue |
|------|-------------|-------|---------|
| Standard | 60 | €50 | €3,000 |
| Premium | 40 | €100 | €4,000 |
| **Total** | **100** | | **€7,000/month** |
| Stripe fees (2.9% + €0.30) | | | -€234 |
| Hosting (Cloudflare + Supabase) | | | €0 |
| **Net Profit** | | | **€6,766/month** |
| **Annual** | | | **€81,192/year** |

### At Scale: 1,000 Subscribers

| Plan | Subscribers | Price | Revenue |
|------|-------------|-------|---------|
| Standard | 600 | €50 | €30,000 |
| Premium | 400 | €100 | €40,000 |
| **Total** | **1,000** | | **€70,000/month** |
| Stripe fees | | | -€2,340 |
| Hosting | | | -€25 |
| **Net Profit** | | | **€67,635/month** |
| **Annual** | | | **€811,620/year** |

---

## 🎯 Next Steps

After your payment system is live, consider:

1. **Add more levels** to justify premium pricing
2. **Email marketing** - collect emails, send updates
3. **Referral program** - give discounts for referrals
4. **Analytics** - track which levels are most played
5. **Custom domain** - buy a domain like `jumpquest.com` (€12/year)
6. **Premium features** - exclusive skins, levels for Premium tier

---

## 📞 Support

If you get stuck:

- **Supabase:** [supabase.com/docs](https://supabase.com/docs)
- **Stripe:** [stripe.com/docs](https://stripe.com/docs)
- **Cloudflare Pages:** [developers.cloudflare.com/pages](https://developers.cloudflare.com/pages)

---

## 📝 File Structure

```
JumpQuest/
├── auth.html                    # Login/signup page
├── subscribe.html               # Payment page
├── success.html                 # Post-payment confirmation
├── game-v8.html                 # The game (now with auth check)
├── supabase/
│   ├── migrations/
│   │   └── 001_initial_schema.sql   # Database setup
│   └── functions/
│       ├── create-checkout-session/
│       │   └── index.ts         # Creates Stripe checkout
│       └── stripe-webhook/
│           └── index.ts         # Handles Stripe events
└── SETUP_PAYMENT_SYSTEM.md     # This file
```

---

**Congratulations! Your game is now a subscription business.** 🎮💰

Time to start marketing and getting customers!
