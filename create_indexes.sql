CREATE INDEX idx_product_name ON app.product USING btree (product_name);

CREATE INDEX idx_store_name ON app.store USING btree (store_name);

CREATE INDEX idx_operator_name ON app.operator USING btree (operator_name);

CREATE INDEX idx_shipment_product_id ON app.shipment USING btree (product_id);

CREATE INDEX idx_shipment_store_id ON app.shipment USING btree (store_id);

CREATE INDEX idx_driver_id ON app.shipment(driver_id);

CREATE INDEX idx_sending_time ON app.shipment(sending_time);
