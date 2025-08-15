CREATE TABLE IF NOT EXISTS device (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('temperature') NOT NULL,
    location VARCHAR(255) NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS temperature (
    id INT AUTO_INCREMENT PRIMARY KEY,
    value DOUBLE NOT NULL,
    recorded_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    device_id INT NOT NULL,
    FOREIGN KEY (device_id) REFERENCES device(id),
    INDEX idx_temperature_device_id (device_id)
);