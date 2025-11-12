-- -----------------------------------------------------
-- Tabelas Olist para PostgreSQL
-- -----------------------------------------------------

-- DIMPRODUTOS
CREATE TABLE IF NOT EXISTS "DIMPRODUTOS" (
  "product_id" INTEGER PRIMARY KEY,
  "product_category_name" VARCHAR(255),
  "product_name_lenght" INTEGER,
  "product_description_lenght" INTEGER,
  "product_photos_qty" INTEGER,
  "product_weight_g" DECIMAL(10,2),
  "product_length_cm" DECIMAL(10,2),
  "product_height_cm" DECIMAL(10,2),
  "product_width_cm" DECIMAL(10,2)
);

-- DIMVENDEDORES
CREATE TABLE IF NOT EXISTS "DIMVENDEDORES" (
  "seller_id" INTEGER PRIMARY KEY,
  "seller_zip_code_prefix" INTEGER,
  "seller_city" VARCHAR(255),
  "seller_state" VARCHAR(255),
  "geolocation_lat" DECIMAL(9,6),
  "geolocation_lng" DECIMAL(9,6)
);

-- DIMDATA
CREATE TABLE IF NOT EXISTS "DIMDATA" (
  "data_id" INTEGER PRIMARY KEY,
  "data_completa" DATE,
  "ano" INTEGER,
  "mes" INTEGER,
  "dia" INTEGER,
  "dia_da_semana" VARCHAR(10)
);

-- DIMPEDIDOS
CREATE TABLE IF NOT EXISTS "DIMPEDIDOS" (
  "order_id" INTEGER PRIMARY KEY,
  "review_comment_title" VARCHAR(255),
  "review_comment_message" TEXT,
  "customer_unique_id" VARCHAR(255) NOT NULL,
  "order_status" VARCHAR(50) NOT NULL,
  "qtd_payment_sequential" INTEGER,
  "primeiro_payment_type" VARCHAR(50),
  "valor_total_pagamento" DECIMAL(10,2),
  "maximo_payment_installments" INTEGER,
  "order_purchase_timestamp" TIMESTAMP NOT NULL,
  "order_delivered_customer_date" TIMESTAMP,
  "tempo_entrega_dias" INTEGER,
  "flag_atraso" SMALLINT,
  "order_approved_at" TIMESTAMP,
  "order_delivered_carrier_date" TIMESTAMP,
  "order_estimated_delivery_date" TIMESTAMP,
  "review_score" SMALLINT,
  "review_creation_date" TIMESTAMP,
  "review_answer_timestamp" TIMESTAMP,
  "customer_zip_code_prefix" INTEGER,
  "customer_city" VARCHAR(255),
  "customer_state" VARCHAR(255),
  "geolocation_lat" DECIMAL(9,6),
  "geolocation_lng" DECIMAL(9,6),
  UNIQUE ("order_id")
);

-- FATOITENSPEDIDO
CREATE TABLE IF NOT EXISTS "FATOITENSPEDIDO" (
  "order_item_id" INTEGER PRIMARY KEY,
  "product_id" INTEGER NOT NULL,
  "seller_id" INTEGER NOT NULL,
  "data_pedido_id" INTEGER NOT NULL,
  "order_id" INTEGER NOT NULL,
  "shipping_limit_date" TIMESTAMP,
  "price" DECIMAL(10,2),
  "freight_value" DECIMAL(10,2),
  UNIQUE ("order_item_id"),
  FOREIGN KEY ("product_id") REFERENCES "DIMPRODUTOS" ("product_id"),
  FOREIGN KEY ("seller_id") REFERENCES "DIMVENDEDORES" ("seller_id"),
  FOREIGN KEY ("data_pedido_id") REFERENCES "DIMDATA" ("data_id"),
  FOREIGN KEY ("order_id") REFERENCES "DIMPEDIDOS" ("order_id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Índices adicionais
CREATE INDEX idx_fatoitenspedido_product_id ON "FATOITENSPEDIDO" ("product_id");
CREATE INDEX idx_fatoitenspedido_seller_id ON "FATOITENSPEDIDO" ("seller_id");
CREATE INDEX idx_fatoitenspedido_data_pedido_id ON "FATOITENSPEDIDO" ("data_pedido_id");
CREATE INDEX idx_fatoitenspedido_order_id ON "FATOITENSPEDIDO" ("order_id");
