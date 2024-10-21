SELECT
  d.driver_id,
  d.driver_name,
  COUNT(s.shipment_id) AS total_pengiriman
FROM
  app.driver d
JOIN
  app.shipment s ON d.driver_id = s.driver_id
WHERE
  s.sending_time BETWEEN '2023-05-01' AND '2023-05-31 23:59:59'
GROUP BY
  d.driver_id, d.driver_name
ORDER BY
  total_pengiriman DESC
LIMIT 2;


---------------------------------------------------------

SELECT
    p.product_id,
    p.product_name,
    COUNT(s.shipment_id) AS total_pengiriman
FROM
    app.product p
JOIN
    app.shipment s ON p.product_id = s.product_id
WHERE
    s.sending_time BETWEEN '2023-05-01' AND '2023-05-31 23:59:59'
GROUP BY
    p.product_id, p.product_name
ORDER BY
    total_pengiriman DESC
LIMIT 10;

---------------------------------------------------------
SELECT
  s.shipment_id,
  s.product_id,
  s.qty,
  s.store_id,
  s.operator_id,
  s.vehicle_id,
  s.driver_id,
  s.co_driver_id,
  s.sending_time
FROM
  app.shipment s
WHERE
  s.delivered_time IS NULL;