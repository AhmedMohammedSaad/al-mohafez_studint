-- Create the session_evaluations table
-- Run this SQL in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS session_evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL,
    student_id UUID NOT NULL,
    student_name TEXT NOT NULL,
    teacher_id UUID NOT NULL,
    
    -- Ratings (1-5)
    memorization_score INTEGER CHECK (memorization_score IS NULL OR (memorization_score >= 1 AND memorization_score <= 5)),
    tajweed_score INTEGER CHECK (tajweed_score IS NULL OR (tajweed_score >= 1 AND tajweed_score <= 5)),
    overall_score INTEGER CHECK (overall_score IS NULL OR (overall_score >= 1 AND overall_score <= 5)),
    
    -- Notes
    notes TEXT,
    strengths TEXT,
    improvements TEXT,
    next_goals TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_session_evaluations_teacher_id ON session_evaluations(teacher_id);
CREATE INDEX IF NOT EXISTS idx_session_evaluations_student_id ON session_evaluations(student_id);
CREATE INDEX IF NOT EXISTS idx_session_evaluations_session_id ON session_evaluations(session_id);

-- Enable RLS
ALTER TABLE session_evaluations ENABLE ROW LEVEL SECURITY;

-- Teachers can manage their evaluations
CREATE POLICY "Teachers can manage their evaluations"
ON session_evaluations
FOR ALL
TO authenticated
USING (teacher_id = auth.uid())
WITH CHECK (teacher_id = auth.uid());

-- Students can view their own evaluations
CREATE POLICY "Students can view their evaluations"
ON session_evaluations
FOR SELECT
TO authenticated
USING (student_id = auth.uid());
