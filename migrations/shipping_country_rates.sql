DROP TABLE IF EXISTS shipping_country_rates;

CREATE TABLE IF NOT EXISTS shipping_country_rates (
    id SERIAL,
    shipping_country TEXT NOT NULL,
    shipping_country_base_rate DECIMAL NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO shipping_country_rates(shipping_country, shipping_country_base_rate)
(SELECT DISTINCT shipping_country,
        shipping_country_base_rate
 FROM public.shipping);