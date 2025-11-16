-- ============================================
-- Jump Quest - Database Schema
-- ============================================
-- This creates all the tables needed for authentication,
-- subscriptions, and cloud save functionality.

-- Enable UUID extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- SUBSCRIPTIONS TABLE
-- ============================================
-- Stores user subscription information synced from Stripe
CREATE TABLE IF NOT EXISTS public.subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    stripe_customer_id TEXT UNIQUE,
    stripe_subscription_id TEXT UNIQUE,
    status TEXT NOT NULL CHECK (status IN ('active', 'canceled', 'past_due', 'incomplete', 'trialing')),
    plan_type TEXT NOT NULL CHECK (plan_type IN ('standard', 'premium')),
    current_period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    current_period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    cancel_at_period_end BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Ensure one subscription per user
    CONSTRAINT unique_user_subscription UNIQUE (user_id)
);

-- Add index for faster lookups
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_stripe_customer ON public.subscriptions(stripe_customer_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_stripe_subscription ON public.subscriptions(stripe_subscription_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON public.subscriptions(status);

-- ============================================
-- GAME PROGRESS TABLE
-- ============================================
-- Stores cloud-saved game progress for each user
CREATE TABLE IF NOT EXISTS public.game_progress (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    high_score INTEGER DEFAULT 0,
    completed_levels JSONB DEFAULT '[]'::JSONB,
    unlocked_skins JSONB DEFAULT '["red_square"]'::JSONB,
    selected_skin TEXT DEFAULT 'red_square',
    euro_bucks DECIMAL(10,2) DEFAULT 0.00,
    game_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add index for faster queries
CREATE INDEX IF NOT EXISTS idx_game_progress_high_score ON public.game_progress(high_score DESC);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================
-- Ensures users can only access their own data

-- Enable RLS on subscriptions table
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

-- Users can only view their own subscription
CREATE POLICY "Users can view own subscription"
    ON public.subscriptions
    FOR SELECT
    USING (auth.uid() = user_id);

-- Service role can do anything (for webhooks)
CREATE POLICY "Service role has full access to subscriptions"
    ON public.subscriptions
    FOR ALL
    USING (auth.jwt()->>'role' = 'service_role')
    WITH CHECK (auth.jwt()->>'role' = 'service_role');

-- Enable RLS on game_progress table
ALTER TABLE public.game_progress ENABLE ROW LEVEL SECURITY;

-- Users can view and update their own game progress
CREATE POLICY "Users can view own game progress"
    ON public.game_progress
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own game progress"
    ON public.game_progress
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own game progress"
    ON public.game_progress
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================
-- AUTOMATIC TIMESTAMP UPDATES
-- ============================================
-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for subscriptions table
DROP TRIGGER IF EXISTS update_subscriptions_updated_at ON public.subscriptions;
CREATE TRIGGER update_subscriptions_updated_at
    BEFORE UPDATE ON public.subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for game_progress table
DROP TRIGGER IF EXISTS update_game_progress_updated_at ON public.game_progress;
CREATE TRIGGER update_game_progress_updated_at
    BEFORE UPDATE ON public.game_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- HELPFUL VIEWS (OPTIONAL)
-- ============================================
-- View to see active subscriptions with user info
CREATE OR REPLACE VIEW active_subscriptions_view AS
SELECT
    s.id,
    s.user_id,
    u.email,
    s.plan_type,
    s.status,
    s.current_period_end,
    s.cancel_at_period_end
FROM public.subscriptions s
JOIN auth.users u ON s.user_id = u.id
WHERE s.status = 'active'
AND s.current_period_end > NOW();

-- ============================================
-- SAMPLE DATA (FOR TESTING ONLY - REMOVE IN PRODUCTION)
-- ============================================
-- Uncomment these lines if you want to test with sample data

-- INSERT INTO public.subscriptions (
--     user_id,
--     stripe_customer_id,
--     stripe_subscription_id,
--     status,
--     plan_type,
--     current_period_start,
--     current_period_end
-- ) VALUES (
--     'YOUR_TEST_USER_ID_HERE',
--     'cus_test123',
--     'sub_test123',
--     'active',
--     'premium',
--     NOW(),
--     NOW() + INTERVAL '30 days'
-- );

-- ============================================
-- COMPLETION MESSAGE
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '✓ Database schema created successfully!';
    RAISE NOTICE '✓ Tables: subscriptions, game_progress';
    RAISE NOTICE '✓ Row Level Security enabled';
    RAISE NOTICE '✓ Triggers created for automatic timestamps';
END $$;
