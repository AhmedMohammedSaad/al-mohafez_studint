-- Create the teacher_ratings table
-- Run this SQL in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS teacher_ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID,
    student_id UUID NOT NULL,
    student_name TEXT NOT NULL,
    teacher_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_teacher_ratings_teacher_id ON teacher_ratings(teacher_id);
CREATE INDEX IF NOT EXISTS idx_teacher_ratings_student_id ON teacher_ratings(student_id);
CREATE INDEX IF NOT EXISTS idx_teacher_ratings_created_at ON teacher_ratings(created_at DESC);

-- Enable Row Level Security
ALTER TABLE teacher_ratings ENABLE ROW LEVEL SECURITY;

-- Policy: Teachers can read their own ratings
CREATE POLICY "Teachers can view their ratings"
ON teacher_ratings
FOR SELECT
TO authenticated
USING (teacher_id = auth.uid());

-- Policy: Students can insert ratings for teachers
CREATE POLICY "Students can rate teachers"
ON teacher_ratings
FOR INSERT
TO authenticated
WITH CHECK (student_id = auth.uid());

-- Insert sample rating (optional - for testing)
/*
INSERT INTO teacher_ratings (student_id, student_name, teacher_id, rating, comment) VALUES
    ('student-uuid-here', 'أحمد محمد', 'teacher-uuid-here', 5, 'الشيخ ممتاز في التدريس');
*/
