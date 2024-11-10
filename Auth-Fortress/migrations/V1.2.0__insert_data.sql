INSERT INTO public.user (client_id, client_secret, scope)
VALUES ('test_client', 'secret123', ARRAY['read', 'write'])
ON CONFLICT (client_id) DO NOTHING;  