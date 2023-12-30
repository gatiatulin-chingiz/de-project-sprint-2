DROP TABLE IF EXISTS shipping_info;

CREATE TABLE IF NOT EXISTS shipping_info(
    shipping_id int,
    vendor_id int NOT NULL,
    payment_amount numeric(14, 2) NOT NULL,
    shipping_plan_datetime timestamp NOT NULL,
    shipping_transfer_id int NOT NULL,
    shipping_agreement_id int NOT NULL,
    shipping_country_rate_id int NOT NULL,
    PRIMARY KEY (shipping_id),
    FOREIGN KEY (shipping_transfer_id) REFERENCES shipping_transfer (id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_agreement_id) REFERENCES shipping_agreement (agreement_id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_country_rate_id) REFERENCES shipping_country_rates (id) ON DELETE CASCADE
);

INSERT INTO shipping_info (shipping_id, shipping_country_rate_id, shipping_agreement_id, shipping_transfer_id, shipping_plan_datetime, payment_amount, vendor_id)
(SELECT 
        s.shipping_id,
        MAX(scr.id) AS shipping_country_rate_id,
        MAX(sa.agreement_id) AS shipping_agreement_id,
        MAX(st.id) AS shipping_transfer_id,
        MAX(s.shipping_plan_datetime) AS shipping_plan_datetime,
        MAX(s.payment_amount) AS payment_amount,
        MAX(s.vendor_id) AS vendor_id
 FROM shipping s
 LEFT JOIN shipping_country_rates scr ON scr.shipping_country = s.shipping_country
 LEFT JOIN shipping_agreement sa ON sa.agreement_id = CAST((regexp_split_to_array(s.vendor_agreement_description, ':'))[1] AS INT)
 LEFT JOIN shipping_transfer st ON st.transfer_type = (regexp_split_to_array(s.shipping_transfer_description, ':'))[1] 
                               AND st.transfer_model = (regexp_split_to_array(s.shipping_transfer_description, ':'))[2]
 GROUP BY s.shipping_id);