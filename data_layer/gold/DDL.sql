CREATE SCHEMA IF NOT EXISTS DW;

-- Drop na ordem correta (fato antes das dimensões) para evitar erros por FK
DROP TABLE IF EXISTS DW.FAT_ITS_ORD;
DROP TABLE IF EXISTS DW.DIM_ORD;
DROP TABLE IF EXISTS DW.DIM_DAT;
DROP TABLE IF EXISTS DW.DIM_VND;
DROP TABLE IF EXISTS DW.DIM_PRD;

CREATE TABLE IF NOT EXISTS DW.DIM_PRD (
  "SRK_prd" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "prd_cat_nam" VARCHAR(255),
  "prd_nam_lgt" INTEGER,
  "prd_dsc_lgt" INTEGER,
  "prd_pic_qty" INTEGER,
  "prd_wei_g" DECIMAL(10,2),
  "prd_lgt_cm" DECIMAL(10,2),
  "prd_hei_cm" DECIMAL(10,2),
  "prd_wid_cm" DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS DW.DIM_VND (
  "SRK_vnd" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "vnd_zip_cod_prf" INTEGER,
  "vnd_cit" VARCHAR(255),
  "vnd_sta" VARCHAR(255),
  "geo_lat" DECIMAL(9,6),
  "geo_lng" DECIMAL(9,6)
);

CREATE TABLE IF NOT EXISTS DW.DIM_DAT (
  "SRK_dat" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "dat_cmp" DATE,
  "ano" INTEGER,
  "mes" INTEGER,
  "dia" INTEGER,
  "dia_da_sem" VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS DW.DIM_ORD (
  "SRK_ord" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "rev_com_tit" VARCHAR(255),
  "rev_com_msn" TEXT,
  "cli_unq_id" VARCHAR(255) NOT NULL,
  "ord_stt" VARCHAR(50) NOT NULL,
  "qtd_pay_seq" INTEGER,
  "pri_pay_typ" VARCHAR(50),
  "val_tot_pay" DECIMAL(10,2),
  "max_pay_prc" INTEGER,
  "ord_pcs_ttp" TIMESTAMP NOT NULL,
  "ord_env_cli_dat" TIMESTAMP,
  "tem_de_env_dia" INTEGER,
  "flg_atr" SMALLINT,
  "ord_apd_dat" TIMESTAMP,
  "ord_env_pst_dat" TIMESTAMP,
  "ord_est_env_dat" TIMESTAMP,
  "rev_sco" SMALLINT,
  "rev_cre_dat" TIMESTAMP,
  "rev_ans_ttp" TIMESTAMP,
  "cli_zip_cod_prf" INTEGER,
  "cli_cit" VARCHAR(255),
  "cli_sta" VARCHAR(255),
  "geo_lat" DECIMAL(9,6),
  "geo_lng" DECIMAL(9,6)
);

CREATE TABLE IF NOT EXISTS DW.FAT_ITS_ORD (
  "SRK_ord_its" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "SRK_prd" INTEGER NOT NULL,
  "SRK_vnd" INTEGER NOT NULL,
  "SRK_dat_ord" INTEGER NOT NULL,
  "SRK_ord" INTEGER NOT NULL,
  "env_lmt_dat" TIMESTAMP,
  "val" DECIMAL(10,2),
  "frt_val" DECIMAL(10,2),
  FOREIGN KEY ("SRK_prd") REFERENCES DW.DIM_PRD ("SRK_prd"),
  FOREIGN KEY ("SRK_vnd") REFERENCES DW.DIM_VND ("SRK_vnd"),
  FOREIGN KEY ("SRK_dat_ord") REFERENCES DW.DIM_DAT ("SRK_dat"),
  FOREIGN KEY ("SRK_ord") REFERENCES DW.DIM_ORD ("SRK_ord") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Índices adicionais
CREATE INDEX idx_fato_itens_ord_SRK_prd ON DW.FAT_ITS_ORD ("SRK_prd");
CREATE INDEX idx_fato_itens_ord_SRK_vnd ON DW.FAT_ITS_ORD ("SRK_vnd");
CREATE INDEX idx_fato_itens_ord_SRK_dat_ord ON DW.FAT_ITS_ORD ("SRK_dat_ord");
CREATE INDEX idx_fato_itens_ord_SRK_ord ON DW.FAT_ITS_ORD ("SRK_ord");