CREATE TABLE IF NOT EXISTS public.user (
    client_id VARCHAR(50) UNIQUE NOT NULL,
    client_secret VARCHAR(100) NOT NULL,
    scope VARCHAR[]  
);