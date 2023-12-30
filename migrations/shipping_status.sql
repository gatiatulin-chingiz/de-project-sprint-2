DROP TABLE IF EXISTS shipping_status;
CREATE TABLE shipping_status (
    shipping_id int, 
    status text, 
    state text,
    shipping_start_fact_datetime timestamp,
    shipping_end_fact_datetime timestamp,
    PRIMARY KEY (shipping_id));
WITH sh AS (
    SELECT shipping_id,
           status,
           state,
           state_datetime AS max_dt, 
           ROW_NUMBER() OVER (PARTITION BY shipping_id ORDER BY state_datetime desc) rn
    FROM public.shipping)
INSERT INTO shipping_status (shipping_id, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
SELECT sh.shipping_id,
       sh.status,
       sh.state,
       shb.state_datetime AS shipping_start_fact_datetime,
       shr.state_datetime AS shipping_end_fact_datetime
FROM sh
LEFT JOIN public.shipping shb ON shb.shipping_id = sh.shipping_id AND shb.state = 'booked'
LEFT JOIN public.shipping shr ON shr.shipping_id = sh.shipping_id AND shr.state = 'received'
WHERE sh.rn = 1;