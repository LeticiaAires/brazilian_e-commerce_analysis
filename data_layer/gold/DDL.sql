CREATE SCHEMA IF NOT EXISTS DW;

-- Drop na ordem correta (fato antes das dimensões) para evitar erros por FK
DROP TABLE IF EXISTS DW.FATO_ITENS_PEDIDO;
DROP TABLE IF EXISTS DW.DIM_PEDIDOS;
DROP TABLE IF EXISTS DW.DIM_DATA;
DROP TABLE IF EXISTS DW.DIM_VENDEDORES;
DROP TABLE IF EXISTS DW.DIM_PRODUTOS;

CREATE TABLE IF NOT EXISTS DW.DIM_PRODUTOS (
  "SRK_prod" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "prod_category_name" VARCHAR(255),
  "prod_name_lenght" INTEGER,
  "prod_desc_lenght" INTEGER,
  "prod_photos_qty" INTEGER,
  "prod_weight_g" DECIMAL(10,2),
  "prod_length_cm" DECIMAL(10,2),
  "prod_height_cm" DECIMAL(10,2),
  "prod_width_cm" DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS DW.DIM_VENDEDORES (
  "SRK_vend" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "vend_zip_code_prefix" INTEGER,
  "vend_city" VARCHAR(255),
  "vend_state" VARCHAR(255),
  "geo_lat" DECIMAL(9,6),
  "geo_lng" DECIMAL(9,6)
);

CREATE TABLE IF NOT EXISTS DW.DIM_DATA (
  "SRK_data" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "data_completa" DATE,
  "ano" INTEGER,
  "mes" INTEGER,
  "dia" INTEGER,
  "dia_da_semana" VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS DW.DIM_PEDIDOS (
  "SRK_ord" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
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
  "geo_lat" DECIMAL(9,6),
  "geo_lng" DECIMAL(9,6)
);

CREATE TABLE IF NOT EXISTS DW.FATO_ITENS_PEDIDO (
  "SRK_ped_item" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "SRK_prod" INTEGER NOT NULL,
  "SRK_vend" INTEGER NOT NULL,
  "SRK_data_pedido" INTEGER NOT NULL,
  "SRK_ord" INTEGER NOT NULL,
  "ship_limit_date" TIMESTAMP,
  "price" DECIMAL(10,2),
  "freight_value" DECIMAL(10,2),
  FOREIGN KEY ("SRK_prod") REFERENCES DW.DIM_PRODUTOS ("SRK_prod"),
  FOREIGN KEY ("SRK_vend") REFERENCES DW.DIM_VENDEDORES ("SRK_vend"),
  FOREIGN KEY ("SRK_data_pedido") REFERENCES DW.DIM_DATA ("SRK_data"),
  FOREIGN KEY ("SRK_ord") REFERENCES DW.DIM_PEDIDOS ("SRK_ord") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Índices adicionais
CREATE INDEX idx_fato_itens_pedido_SRK_prod ON DW.FATO_ITENS_PEDIDO ("SRK_prod");
CREATE INDEX idx_fato_itens_pedido_SRK_vend ON DW.FATO_ITENS_PEDIDO ("SRK_vend");
CREATE INDEX idx_fato_itens_pedido_SRK_data_pedido ON DW.FATO_ITENS_PEDIDO ("SRK_data_pedido");
CREATE INDEX idx_fato_itens_pedido_SRK_ord ON DW.FATO_ITENS_PEDIDO ("SRK_ord");