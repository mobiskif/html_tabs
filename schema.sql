CREATE TABLE IF NOT EXISTS apartment_listing (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(120) NOT NULL,
  description TEXT NOT NULL,
  city VARCHAR(80) NOT NULL,
  address VARCHAR(180) NOT NULL,
  rooms SMALLINT NOT NULL CHECK (rooms > 0),
  area_m2 NUMERIC(6,2) NOT NULL CHECK (area_m2 > 0),
  monthly_price_eur NUMERIC(10,2) NOT NULL CHECK (monthly_price_eur > 0),
  owner_email VARCHAR(255) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_apartment_city ON apartment_listing (city);
CREATE INDEX IF NOT EXISTS idx_apartment_price ON apartment_listing (monthly_price_eur);
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'chk_owner_email_format'
  ) THEN
    ALTER TABLE apartment_listing
      ADD CONSTRAINT chk_owner_email_format
      CHECK (owner_email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$');
  END IF;
END;
$$;
CREATE INDEX IF NOT EXISTS idx_apartment_rooms ON apartment_listing (rooms);
