-- ✅ Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS flight_data;

-- ✅ Create table for cleaned flight data
CREATE TABLE IF NOT EXISTS flight_data.cleaned_flight_data (
    flight_id VARCHAR(36) DEFAULT uuid_generate_v4(), -- Unique row ID
    icao24 VARCHAR(10),             -- Aircraft transponder code
    callsign VARCHAR(10),           -- Flight identifier
    origin_country VARCHAR(100),    -- Country of registration
    time_position TIMESTAMP,        -- Last position timestamp
    last_contact TIMESTAMP,         -- Last contact timestamp
    longitude FLOAT,                -- Geo position
    latitude FLOAT,
    baro_altitude FLOAT,            -- Barometric altitude
    geo_altitude FLOAT,             -- Geometric altitude
    velocity FLOAT,                 -- Speed in m/s
    vertical_rate FLOAT,            -- Climb/descent rate
    true_track FLOAT,               -- Heading
    on_ground BOOLEAN,              -- Aircraft on the ground
    squawk VARCHAR(10),             -- Transponder code
    spi BOOLEAN,                    -- Special purpose indicator
    position_source SMALLINT,       -- Data source (0: ADS-B, etc.)
    ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Load time
    year INT,
    month INT,
    day INT
)
DISTSTYLE AUTO
SORTKEY (time_position);
