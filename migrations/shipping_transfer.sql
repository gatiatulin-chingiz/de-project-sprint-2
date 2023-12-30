DROP TABLE IF EXISTS shipping_transfer;

CREATE TABLE IF NOT EXISTS shipping_transfer(
    id SERIAL,
    transfer_type text NOT NULL,
    transfer_model text NOT NULL,
    shipping_transfer_rate numeric(4, 3) NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO shipping_transfer(transfer_type, transfer_model, shipping_transfer_rate)
(SELECT DISTINCT CAST(shipping_transfer_description[1] AS text) AS transfer_type,
                CAST(shipping_transfer_description[2] AS text) AS transfer_model,
                CAST(shipping_transfer_rate AS numeric(4, 3)) AS shipping_transfer_rate
 FROM 
     (SELECT shipping_transfer_rate,
             regexp_split_to_array(shipping_transfer_description, ':') AS shipping_transfer_description
      FROM public.shipping) AS shipping);