CREATE TABLE public.question_sets (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT ALL ON public.question_sets TO service_role;
ALTER TABLE public.question_sets ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.questions ADD COLUMN set_id UUID REFERENCES public.question_sets(id) ON DELETE CASCADE;
ALTER TABLE public.rooms ADD COLUMN set_id UUID REFERENCES public.question_sets(id) ON DELETE SET NULL;

INSERT INTO public.question_sets (title, description) VALUES ('Genel Kültür Seti', 'Hazır sorular');
UPDATE public.questions SET set_id = (SELECT id FROM public.question_sets ORDER BY created_at LIMIT 1) WHERE set_id IS NULL;