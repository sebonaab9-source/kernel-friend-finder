ALTER TABLE public.questions ADD COLUMN IF NOT EXISTS correct_answer_text text;
UPDATE public.questions SET correct_answer_text = trim(correct_answer) WHERE correct_answer_text IS NULL;
ALTER TABLE public.questions ALTER COLUMN correct_answer DROP NOT NULL;
ALTER TABLE public.answers ADD COLUMN IF NOT EXISTS answer_text text;
UPDATE public.answers SET answer_text = trim(answer) WHERE answer_text IS NULL;
ALTER TABLE public.answers ALTER COLUMN answer DROP NOT NULL;
COMMENT ON COLUMN public.questions.correct_answer IS 'DEPRECATED: replaced by correct_answer_text';
COMMENT ON COLUMN public.answers.answer IS 'DEPRECATED: replaced by answer_text';