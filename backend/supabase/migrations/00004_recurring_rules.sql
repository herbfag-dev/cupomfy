-- ─────────────────────────────────────────────────────────────────────────────
-- Migration: 00004_recurring_rules
-- Creates the `recurring_rules` table and supporting RLS policies.
-- ─────────────────────────────────────────────────────────────────────────────

-- Enum for recurrence frequency
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'recurrence_frequency') THEN
    CREATE TYPE recurrence_frequency AS ENUM (
      'daily', 'weekly', 'biweekly', 'monthly', 'yearly'
    );
  END IF;
END
$$;

-- ── Table ─────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.recurring_rules (
  id                  UUID                  PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID                  NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category_id         UUID                  REFERENCES public.categories(id) ON DELETE SET NULL,
  title               TEXT                  NOT NULL,
  amount              NUMERIC(12,2)         NOT NULL CHECK (amount > 0),
  currency            TEXT                  NOT NULL DEFAULT 'USD',
  notes               TEXT,
  frequency           recurrence_frequency  NOT NULL DEFAULT 'monthly',
  start_date          TIMESTAMPTZ           NOT NULL,
  end_date            TIMESTAMPTZ,
  last_generated_at   TIMESTAMPTZ,
  next_due_date       TIMESTAMPTZ           NOT NULL,
  is_active           BOOLEAN               NOT NULL DEFAULT TRUE,
  created_at          TIMESTAMPTZ           NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ           NOT NULL DEFAULT NOW(),

  CONSTRAINT recurring_end_after_start CHECK (
    end_date IS NULL OR end_date > start_date
  )
);

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS recurring_rules_user_id_idx
  ON public.recurring_rules (user_id);

CREATE INDEX IF NOT EXISTS recurring_rules_next_due_date_idx
  ON public.recurring_rules (next_due_date)
  WHERE is_active = TRUE;

-- ── updated_at trigger ────────────────────────────────────────────────────────
-- Reuse the function created in 00003_budgets if it exists, otherwise create it.
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS recurring_rules_set_updated_at ON public.recurring_rules;
CREATE TRIGGER recurring_rules_set_updated_at
  BEFORE UPDATE ON public.recurring_rules
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE public.recurring_rules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "recurring_rules_select_own"
  ON public.recurring_rules FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "recurring_rules_insert_own"
  ON public.recurring_rules FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "recurring_rules_update_own"
  ON public.recurring_rules FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "recurring_rules_delete_own"
  ON public.recurring_rules FOR DELETE
  USING (auth.uid() = user_id);

-- ── Realtime ──────────────────────────────────────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE public.recurring_rules;
