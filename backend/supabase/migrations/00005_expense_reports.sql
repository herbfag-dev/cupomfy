-- ─────────────────────────────────────────────────────────────────────────────
-- Migration 00005: Expense Reports
--
-- Creates the `expense_reports` table for persisting generated report metadata
-- and the full report JSON payload.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Table ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.expense_reports (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID          NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Human-readable title, e.g. "January 2025 Report"
  title         TEXT          NOT NULL,

  -- Inclusive date range of the report
  start_date    TIMESTAMPTZ   NOT NULL,
  end_date      TIMESTAMPTZ   NOT NULL,

  -- Aggregated totals
  total_amount  NUMERIC(15,2) NOT NULL DEFAULT 0,
  currency      TEXT          NOT NULL DEFAULT 'USD',

  -- Full serialised report (JSON) including category breakdown, daily totals,
  -- and top expenses.  Stored as JSONB for efficient querying.
  report_data   JSONB         NOT NULL DEFAULT '{}',

  -- When the report was originally generated (may differ from created_at if
  -- the user saves it later)
  generated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ── Index ─────────────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_expense_reports_user_id
  ON public.expense_reports (user_id);

CREATE INDEX IF NOT EXISTS idx_expense_reports_created_at
  ON public.expense_reports (user_id, created_at DESC);

-- ── Row-Level Security ────────────────────────────────────────────────────────

ALTER TABLE public.expense_reports ENABLE ROW LEVEL SECURITY;

-- Users can only read their own reports
CREATE POLICY "expense_reports_select_own"
  ON public.expense_reports
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can only insert their own reports
CREATE POLICY "expense_reports_insert_own"
  ON public.expense_reports
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can only delete their own reports
CREATE POLICY "expense_reports_delete_own"
  ON public.expense_reports
  FOR DELETE
  USING (auth.uid() = user_id);

-- Users can update their own reports (e.g. re-save with updated data)
CREATE POLICY "expense_reports_update_own"
  ON public.expense_reports
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
