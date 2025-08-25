-- Create storage bucket for resume uploads
INSERT INTO storage.buckets (id, name, public)
VALUES ('resumes', 'resumes', true);

-- Set up storage policies for resume uploads
CREATE POLICY "Anyone can upload resumes"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'resumes');

CREATE POLICY "Anyone can view resumes"
ON storage.objects FOR SELECT
USING (bucket_id = 'resumes');

-- Allow file types: PDF, DOC, DOCX
CREATE POLICY "Restrict file types for resumes"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'resumes' AND
  (storage.extension(name) = 'pdf' OR 
   storage.extension(name) = 'doc' OR 
   storage.extension(name) = 'docx')
);

-- Limit file size to 5MB
CREATE POLICY "Limit resume file size"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'resumes' AND
  (octet_length(decode(encode(raw_data, 'base64'), 'base64')) < 5242880)
);