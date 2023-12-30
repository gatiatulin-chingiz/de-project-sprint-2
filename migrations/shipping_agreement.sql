DROP TABLE IF EXISTS shipping_agreement;

CREATE TABLE IF NOT EXISTS shipping_agreement(
    agreement_id int,
    agreement_number text NOT NULL,
    agreement_rate decimal NOT NULL,
    agreement_commission decimal NOT NULL,
    PRIMARY KEY (agreement_id)
);

INSERT INTO shipping_agreement(agreement_id, agreement_number, agreement_rate, agreement_commission)
(SELECT DISTINCT CAST(vendor_agreement_description[1] AS int) AS agreement_id,
                CAST(vendor_agreement_description[2] AS text) AS agreement_number,
                CAST(vendor_agreement_description[3] AS decimal) AS agreement_rate,
                CAST(vendor_agreement_description[4] AS decimal) AS agreement_commission
 FROM 
     (SELECT regexp_split_to_array(vendor_agreement_description, ':') AS vendor_agreement_description
      FROM public.shipping) AS shipping
 ORDER BY CAST(vendor_agreement_description[1] AS int));