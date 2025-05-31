-- ✅ 1. Create the cleaned flight data table in Redshift
CREATE TABLE IF NOT EXISTS cleaned_flight_data (
    icao24 VARCHAR(10),
    callsign VARCHAR(10),
    origin_country VARCHAR(100),
    time_position TIMESTAMP,
    last_contact TIMESTAMP,
    longitude FLOAT,
    latitude FLOAT,
    baro_altitude FLOAT,
    on_ground BOOLEAN,
    velocity FLOAT,
    true_track FLOAT,
    vertical_rate FLOAT,
    geo_altitude FLOAT,
    squawk VARCHAR(10),
    spi BOOLEAN,
    position_source SMALLINT,
    year INT,
    month INT,
    day INT
);

-- ✅ 2. Sample query: Count of flights by country of origin
SELECT
    origin_country,
    COUNT(*) AS num_flights
FROM cleaned_flight_data
GROUP BY origin_country
ORDER BY num_flights DESC
LIMIT 10;

-- ✅ 3. Sample query: Hourly flight volume on a specific date
SELECT
    DATE_TRUNC('hour', time_position) AS hour,
    COUNT(*) AS flight_count
FROM cleaned_flight_data
WHERE year = 2025 AND month = 5 AND day = 31
GROUP BY hour
ORDER BY hour;

-- ✅ 4. Sample query: Top 5 fastest flights
SELECT
    callsign,
    origin_country,
    velocity,
    time_position
FROM cleaned_flight_data
WHERE velocity IS NOT NULL
ORDER BY velocity DESC
LIMIT 5;

-- ✅ 5. Sample query: Heatmap input – flight distribution by lat/lon grid
SELECT
    ROUND(latitude, 1) AS lat_bin,
    ROUND(longitude, 1) AS lon_bin,
    COUNT(*) AS flight_density
FROM cleaned_flight_data
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
GROUP BY lat_bin, lon_bin
ORDER BY flight_density DESC
LIMIT 100;

-- ✅ 6. Sample query: Grounded vs. in-air flights by hour
SELECT
    DATE_TRUNC('hour', time_position) AS hour,
    on_ground,
    COUNT(*) AS count
FROM cleaned_flight_data
GROUP BY hour, on_ground
ORDER BY hour, on_ground;
