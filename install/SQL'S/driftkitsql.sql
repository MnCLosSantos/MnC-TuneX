CREATE TABLE IF NOT EXISTS driftkits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(32) NOT NULL UNIQUE,
    installed BOOLEAN NOT NULL DEFAULT TRUE,
    installed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

