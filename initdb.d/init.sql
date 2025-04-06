-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS service_logs;

-- Main logs table with proper TTL expression
CREATE TABLE IF NOT EXISTS service_logs.logs (
    timestamp DateTime64(3) DEFAULT now64(3),
    level LowCardinality(String) DEFAULT '',
    message String DEFAULT '',
    service LowCardinality(String) DEFAULT '',

    -- Standard request fields
    requestId String DEFAULT '',
    operation LowCardinality(String) DEFAULT '',
    method LowCardinality(String) DEFAULT '',
    durationMs UInt32 DEFAULT 0,
    status UInt16 DEFAULT 0,

    -- Auth-specific fields
    email String DEFAULT '',
    authId String DEFAULT '',

    -- Error handling
    error String DEFAULT '',
    stack String DEFAULT '',

    -- Container metadata
    container_id String DEFAULT '',
    container_name String DEFAULT '',

    -- Indexes
    INDEX idx_requestId requestId TYPE bloom_filter GRANULARITY 3,
    INDEX idx_operation operation TYPE bloom_filter GRANULARITY 3
) ENGINE = MergeTree()
ORDER BY (timestamp, level, operation)
TTL toDateTime(timestamp) + INTERVAL 30 DAY;
