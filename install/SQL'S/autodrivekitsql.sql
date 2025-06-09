CREATE TABLE IF NOT EXISTS tuner_autodrive_kits (
    plate VARCHAR(20) PRIMARY KEY,
    installed BOOLEAN NOT NULL DEFAULT TRUE
);
