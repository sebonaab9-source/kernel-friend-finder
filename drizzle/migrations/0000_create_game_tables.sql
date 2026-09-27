CREATE TABLE public.questions (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  question text NOT NULL,
  option_a text NOT NULL,
  option_b text NOT NULL,
  option_c text NOT NULL,
  option_d text NOT NULL,
  correct_answer char(1) NOT NULL,
  category text NOT NULL DEFAULT 'Genel Kültür',
  difficulty text NOT NULL DEFAULT 'Kolay',
  time_limit int NOT NULL DEFAULT 20,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT ALL ON public.questions TO service_role;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  room_code text NOT NULL UNIQUE,
  status text NOT NULL DEFAULT 'WAITING',
  current_question int NOT NULL DEFAULT 0,
  rope_position int NOT NULL DEFAULT 0,
  winner text,
  question_ids uuid[] NOT NULL DEFAULT '{}',
  question_started_at timestamptz,
  reveal boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.rooms TO anon, authenticated;
GRANT ALL ON public.rooms TO service_role;
ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;
CREATE POLICY "rooms_public_read" ON public.rooms FOR SELECT TO anon, authenticated USING (true);

CREATE TABLE public.players (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id uuid NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  name text NOT NULL,
  team int NOT NULL CHECK (team IN (1,2)),
  connected boolean NOT NULL DEFAULT true,
  last_seen timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (room_id, team)
);
GRANT SELECT ON public.players TO anon, authenticated;
GRANT ALL ON public.players TO service_role;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
CREATE POLICY "players_public_read" ON public.players FOR SELECT TO anon, authenticated USING (true);

CREATE TABLE public.answers (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id uuid NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  player_id uuid NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES public.questions(id),
  answer char(1) NOT NULL,
  is_correct boolean NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (player_id, question_id)
);
GRANT ALL ON public.answers TO service_role;
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;

ALTER PUBLICATION supabase_realtime ADD TABLE public.rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE public.players;

INSERT INTO public.questions (question, option_a, option_b, option_c, option_d, correct_answer, category, difficulty, time_limit) VALUES
('Türkiye''nin başkenti neresidir?', 'İstanbul', 'Ankara', 'İzmir', 'Bursa', 'B', 'Genel Kültür', 'Kolay', 20),
('Güneş sistemimizde kaç gezegen bulunur?', '7', '8', '9', '10', 'B', 'Genel Kültür', 'Kolay', 20),
('"Çalışkan" kelimesinin zıt anlamlısı hangisidir?', 'Gayretli', 'Tembel', 'Hızlı', 'Güçlü', 'B', 'Türkçe', 'Kolay', 20),
('Aşağıdakilerden hangisi bir sıfattır?', 'Koşmak', 'Kırmızı', 'Kitap', 'Hızlıca', 'B', 'Türkçe', 'Kolay', 20),
('İstiklal Marşı''nın söz yazarı kimdir?', 'Namık Kemal', 'Mehmet Akif Ersoy', 'Ziya Gökalp', 'Yahya Kemal', 'B', 'Genel Kültür', 'Kolay', 20),
('"Göz" kelimesi "Gözden düşmek" deyiminde hangi anlamda kullanılır?', 'Gerçek anlam', 'Mecaz anlam', 'Terim anlam', 'Eş anlam', 'B', 'Türkçe', 'Orta', 20),
('Türkiye''nin en uzun nehri hangisidir?', 'Sakarya', 'Kızılırmak', 'Fırat', 'Dicle', 'B', 'Genel Kültür', 'Orta', 20),
('Bir üçgenin iç açıları toplamı kaç derecedir?', '90', '180', '270', '360', 'B', 'Matematik', 'Kolay', 20),
('"Kitapları masaya koydum." cümlesinde altı çizili olabilecek nesne hangisidir?', 'masaya', 'kitapları', 'koydum', 'ben', 'B', 'Türkçe', 'Orta', 20),
('Atatürk hangi yılda Cumhurbaşkanı seçilmiştir?', '1920', '1923', '1925', '1930', 'B', 'Genel Kültür', 'Orta', 20),
('Suyun kaynama noktası kaç derecedir?', '50', '100', '150', '200', 'B', 'Fen Bilgisi', 'Kolay', 20),
('"Sevinç" kelimesinin eş anlamlısı hangisidir?', 'Üzüntü', 'Neşe', 'Korku', 'Öfke', 'B', 'Türkçe', 'Kolay', 20);