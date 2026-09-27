CREATE POLICY "questions_server_only" ON public.questions FOR ALL TO anon, authenticated USING (false) WITH CHECK (false);
CREATE POLICY "answers_server_only" ON public.answers FOR ALL TO anon, authenticated USING (false) WITH CHECK (false);
CREATE POLICY "question_sets_server_only" ON public.question_sets FOR ALL TO anon, authenticated USING (false) WITH CHECK (false);