-- ─────────────────────────────────────────────────────────────────────────────
-- Migration: 00003_budgets
-- Creates the `budgets` table and supporting RLS policies.
-- ─────────────────────────────────────────────────────────────────────────────

-- Enum for budget recurrence period
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'budget_period') THEN
    CREATE TYPE budget_period AS ENUM ('weekly', 'monthly', 'yearly');
  END IF;
END
$$;

-- ── Table ─────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.budgets (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID          NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category_id   UUID          REFERENCES public.categories(id) ON DELETE SET NULL,
  name          TEXT          NOT NULL,
  amount        NUMERIC(12,2) NOT NULL CHECK (amount > 0),
  currency      TEXT          NOT NULL DEFAULT 'USD',
  period        budget_period NOT NULL DEFAULT 'monthly',
  start_date    TIMESTAMPTZ   NOT NULL,
  end_date      TIMESTAMPTZ   NOT NULL,
  is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  CONSTRAINT budgets_end_after_start CHECK (end_date > start_date)
);

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS budgets_user_id_idx      ON public.budgets (user_id);
CREATE INDEX IF NOT EXISTS budgets_category_id_idx  ON public.budgets (category_id);
CREATE INDEX IF NOT EXISTS budgets_is_active_idx    ON public.budgets (is_active);

-- ── updated_at trigger ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS budgets_set_updated_at ON public.budgets;
CREATE TRIGGER budgets_set_updated_at
  BEFORE UPDATE ON public.budgets
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- Users can only see their own budgets
CREATE POLICY "budgets_select_own"
  ON public.budgets FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own budgets
CREATE POLICY "budgets_insert_own"
  ON public.budgets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own budgets
CREATE POLICY "budgets_update_own"
  ON public.budgets FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own budgets
CREATE POLICY "budgets_delete_own"
  ON public.budgets FOR DELETE
  USING (auth.uid() = user_id);

-- ── Realtime ──────────────────────────────────────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE public.budgets;
