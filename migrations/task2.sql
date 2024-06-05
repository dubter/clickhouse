CREATE TABLE payments (
    id String,
    date Date,
    category String,
    purpose String,
    money Int32,
    counter Int32
) ENGINE = ReplacingMergeTree(counter)
ORDER BY (category, date, id);

CREATE MATERIALIZED VIEW payments_mv TO payments AS
SELECT
    JSONExtractString(value, 'id') AS id,
    toDate(JSONExtractString(value, 'date')) AS date,
    JSONExtractString(value, 'category') AS category,
    JSONExtractString(value, 'purpose') AS purpose,
    JSONExtractInt(value, 'money') AS money,
    JSONExtractInt(value, 'index') AS counter
FROM source
WHERE JSONExtractString(value, 'type') = 'payment';