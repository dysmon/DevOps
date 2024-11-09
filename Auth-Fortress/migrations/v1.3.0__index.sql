CREATE INDEX IF NOT EXISTS idx_client_id ON public.user(client_id);
CREATE INDEX IF NOT EXISTS idx_access_token ON public.token(access_token);