CREATE OR REPLACE FUNCTION app.generator_kode_pengiriman()
RETURNS CHAR(8)
LANGUAGE plpgsql
AS $function$
DECLARE
    last_id INT;
    new_id CHAR(8);
BEGIN
    -- Mengambil nomor urut terakhir untuk tanggal yang sama
    SELECT COALESCE(MAX(CAST(SUBSTRING(kode_pengiriman FROM 7) AS INT)), 0)
    INTO last_id
    FROM app.shipment
    WHERE LEFT(kode_pengiriman, 6) = TO_CHAR(NOW(), 'YYMMDD');

    -- Membuat ID baru dengan format yymmddxxx
    new_id := TO_CHAR(NOW(), 'YYMMDD') || LPAD((last_id + 1)::TEXT, 3, '0');
    
    RETURN new_id;
END;
$function$;





INSERT INTO app.shipment (
    kode_pengiriman,
    product_id,
    qty,
    unit,
    store_id,
    operator_id,
    vehicle_id,
    driver_id,
    co_driver_id,
    sending_time,
    delivered_time,
    received_by
) VALUES (
    app.generator_kode_pengiriman(),
    1, 10, 'box', 1, 1, 1, 1, 1, '2023-05-01 10:00:00', NULL, 'Calista'
);

---------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE app.create_new_shipment(
    IN product_id INT,
    IN store_id INT,
    IN sending_time TIMESTAMPTZ,
    IN driver_id INT,
    IN receiver VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    shipment_code CHAR(8);
BEGIN
    -- Mendapatkan kode pengiriman menggunakan fungsi yang telah dibuat
    shipment_code := app.generator_kode_pengiriman();

    -- Menyisipkan data ke dalam tabel shipment
    INSERT INTO app.shipment (product_id, store_id, sending_time, driver_id, co_driver_id, receiver, kode_pengiriman)
    VALUES (product_id, store_id, sending_time, driver_id, NULL, receiver, shipment_code);
END;
$$;





-- Prosedur untuk menambahkan product ke dalam shipment
CREATE OR REPLACE PROCEDURE app.add_product_to_shipment(
    IN product_id INT,
    IN store_id INT,
    IN driver_id INT,
    IN receiver VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Mendapatkan kode pengiriman menggunakan fungsi yang telah dibuat
    DECLARE
        kode_pengiriman CHAR(8);
    BEGIN
        SELECT app.generator_kode_pengiriman() INTO kode_pengiriman;
    END;

    -- Insert ke dalam tabel shipment
    INSERT INTO app.shipment (product_id, store_id, sending_time, driver_id, co_driver_id, receiver, kode_pengiriman)
    VALUES (product_id, store_id, NOW(), driver_id, NULL, receiver, kode_pengiriman);

    -- Commit transaksi
    COMMIT;
END;
$$;

-- Menambahkan data ke dalam tabel "shipment" dengan shipment_id dimulai dari 15
INSERT INTO app.shipment (shipment_id, product_id, store_id, sending_time, driver_id, co_driver_id, receiver, kode_pengiriman)
VALUES 
    (15, 1, 1, NOW(), 1, NULL, 'Wulan', app.generator_kode_pengiriman()),
    (16, 2, 2, NOW(), 2, NULL, 'Limerence', app.generator_kode_pengiriman()),
    (17, 3, 3, NOW(), 3, NULL, 'Aslan', app.generator_kode_pengiriman());

-- Melakukan commit transaksi
COMMIT;

