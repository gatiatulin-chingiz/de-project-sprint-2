CREATE OR REPLACE VIEW public.shipping_datamart AS (
    SELECT si.shipping_id,
           si.vendor_id,
           st.transfer_type,
           DATE_PART('day', age(ss.shipping_end_fact_datetime ,ss.shipping_start_fact_datetime)) AS full_day_at_shipping,
           (CASE WHEN ss.shipping_end_fact_datetime > si.shipping_plan_datetime THEN 1 ELSE 0 END) AS is_delay,
           (CASE WHEN status = 'finished' THEN 1 ELSE 0 END) AS is_shipping_finish,
           (CASE WHEN ss.shipping_end_fact_datetime > si.shipping_plan_datetime THEN 
                      DATE_PART('day', age(ss.shipping_end_fact_datetime, si.shipping_plan_datetime)) ELSE 0 END) AS delay_day_at_shipping,
           si.payment_amount,
           (payment_amount * (shipping_country_base_rate + agreement_rate + shipping_transfer_rate)) AS vat,
           payment_amount * sa.agreement_commission AS profit
    FROM shipping_info si
    LEFT JOIN shipping_transfer st ON si.shipping_transfer_id = st.id 
    LEFT JOIN shipping_status ss ON si.shipping_id = ss.shipping_id 
    LEFT JOIN shipping_country_rates scr ON si.shipping_country_rate_id = scr.id 
    LEFT JOIN shipping_agreement sa ON si.shipping_agreement_id = sa.agreement_id
);