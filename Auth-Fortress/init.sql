CREATE TABLE IF NOT EXISTS public.user (
    client_id VARCHAR(50) UNIQUE NOT NULL,
    client_secret VARCHAR(100) NOT NULL,
    scope VARCHAR[]  
);

CREATE TABLE IF NOT EXISTS public.token (
    client_id VARCHAR(50) NOT NULL REFERENCES public.user(client_id),
    access_scope VARCHAR[],
    access_token VARCHAR DEFAULT SUBSTR(UPPER(md5(random()::text)), 2, 22),
    expiration_time TIMESTAMP DEFAULT current_timestamp + interval '2 hours'
);

INSERT INTO public.user (client_id, client_secret, scope)
VALUES ('test_client', 'secret123', ARRAY['read', 'write'])
ON CONFLICT (client_id) DO NOTHING;  