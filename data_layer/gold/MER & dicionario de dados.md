# Data Selection & Gold Modeling Description

A camada Gold consolida em um modelo dimensional otimizado a camada Silver. Este modelo é composto por uma tabela fato central (**Fato_Itens_Pedido**) e suas dimensões descritivas. O objetivo é criar uma *Single Source of Truth* (fonte única da verdade) para as principais entidades de negócio, utilizando o **Star Schema**.

1. **Fact Table**: O núcleo do modelo continua sendo a `FATO_ITENS_PEDIDO`, representando a venda de um item de produto dentro de um pedido. Ela contém métricas quantitativas e as chaves estrangeiras para as dimensões.

2. **Dimension Tables**: As dimensões descrevem o contexto dos eventos da tabela fato.

   * `DIM_PEDIDOS`: Unifica informações dos pedidos, clientes, pagamentos e avaliações, incluindo dados de geolocalização do cliente.
   * `DIM_PRODUTOS`: Contém detalhes descritivos dos produtos.
   * `DIM_VENDEDORES`: Reúne informações dos vendedores e suas localizações.
   * `DIM_DATA`: Dimensão temporal derivada de colunas de timestamp para análises temporais.

O **SRK (Surrogate Key)** é uma **chave substituta** usada em modelagens dimensionais para identificar de forma única cada registro de uma tabela, sem depender de chaves naturais oriundas das fontes transacionais. Diferente das chaves de negócio — que podem mudar, conter valores nulos ou se repetir entre sistemas — o SRK é gerado artificialmente (geralmente como um número sequencial) e serve exclusivamente para manter a integridade referencial e otimizar o desempenho das consultas em ambientes de Data Warehouse. Esse tipo de chave simplifica a manutenção histórica das dimensões, facilita a integração de múltiplas origens de dados e garante estabilidade na estrutura do modelo mesmo que os dados de origem passem por alterações.

---

## MER - Modelo Entidade-Relacionamento

O Modelo Entidade-Relacionamento (MER) é uma abordagem conceitual utilizada no desenvolvimento de bancos de dados para representar entidades, seus atributos e os relacionamentos entre elas. Ele facilita a visualização da organização dos dados e da forma como as entidades interagem dentro do sistema de informações. O MER serve como a fundação conceitual para a criação dos Diagramas Entidade-Relacionamento (DER), que ilustram graficamente essa estrutura.

### Entidades

* FATO_ITENS_PEDIDO (Fact)
* DIM_PEDIDOS (Dimension)
* DIM_PRODUTOS (Dimension)
* DIM_VENDEDORES (Dimension)
* DIM_DATA (Dimension)

### Descrição das Entidades (Atributos)

**FATO_ITENS_PEDIDO**  
(<ins>`SRK_ped_item`</ins>, `SRK_prod`, `SRK_vend`, `SRK_data_pedido`, `SRK_ord`, `ship_limit_date`, `price`, `freight_value`)

**DIM_PEDIDOS**  
(<ins>`SRK_ord`</ins>, `review_comment_title`, `review_comment_message`, `customer_unique_id`, `order_status`, `qtd_payment_sequential`, `primeiro_payment_type`, `valor_total_pagamento`, `maximo_payment_installments`, `order_purchase_timestamp`, `order_delivered_customer_date`, `tempo_entrega_dias`, `flag_atraso`, `order_approved_at`, `order_delivered_carrier_date`, `order_estimated_delivery_date`, `review_score`, `review_creation_date`, `review_answer_timestamp`, `customer_zip_code_prefix`, `customer_city`, `customer_state`, `geo_lat`, `geo_lng`)

**DIM_PRODUTOS**  
(<ins>`SRK_prod`</ins>, `prod_category_name`, `prod_name_lenght`, `prod_desc_lenght`, `prod_photos_qty`, `prod_weight_g`, `prod_length_cm`, `prod_height_cm`, `prod_width_cm`)

**DIM_VENDEDORES**  
(<ins>`SRK_vend`</ins>, `vend_zip_code_prefix`, `vend_city`, `vend_state`, `geo_lat`, `geo_lng`)

**DIM_DATA**  
(<ins>`SRK_data`</ins>, `data_completa`, `ano`, `mes`, `dia`, `dia_da_semana`)

### Relacionamentos

* **PEDIDO — contém — ITEM DE PEDIDO**
    * Um PEDIDO (`Dim_Pedidos`) pode conter um ou vários ITENS DE PEDIDO (`Fato_Itens_Pedido`), enquanto que um ITEM DE PEDIDO pertence a apenas um PEDIDO.
    * Cardinalidade: (1:n)

* **PRODUTO — é vendido como — ITEM DE PEDIDO**
    * Um PRODUTO (`Dim_Produtos`) pode ser vendido como nenhum ou vários ITENS DE PEDIDO (`Fato_Itens_Pedido`), enquanto que um ITEM DE PEDIDO refere-se a apenas um PRODUTO.
    * Cardinalidade: (1:n)

* **VENDEDOR — vende — ITEM DE PEDIDO**
    * Um VENDEDOR (`Dim_Vendedores`) pode vender nenhum ou vários ITENS DE PEDIDO (`Fato_Itens_Pedido`), enquanto que um ITEM DE PEDIDO é vendido por apenas um VENDEDOR.
    * Cardinalidade: (1:n)

* **DATA — registra a venda de — ITEM DE PEDIDO**
    * Em uma DATA (`Dim_Data`) podem ser registrados nenhum ou vários ITENS DE PEDIDO (`Fato_Itens_Pedido`), enquanto que um ITEM DE PEDIDO é registrado em apenas uma DATA.
    * Cardinalidade: (1:n)


## DER - Diagrama de Entidade e Relacionamento

O Diagrama Entidade-Relacionamento (DER) é uma representação visual empregada em projetos de bancos de dados. Ele ilustra as entidades (objetos), seus atributos (características) e os relacionamentos existentes entre elas. Nesse diagrama, as entidades são representadas por retângulos, os atributos por elipses, e as conexões entre entidades são feitas por linhas que indicam seus relacionamentos. O DER é uma ferramenta essencial para visualizar e planejar a estrutura do banco de dados antes da implementação, auxiliando na definição de como os dados serão armazenados e acessados.

![DER](DER.png)

---

## DLD - Diagrama Lógico de Dados

O Diagrama Lógico de Dados (DLD) é uma representação gráfica que descreve a estrutura lógica de um banco de dados. Ele mostra detalhes importantes, como os tipos de atributos de cada entidade, além das chaves estrangeiras e restrições, como as chaves únicas (unique key). O principal objetivo do DLD é fornecer uma visão clara e estruturada de como o banco de dados deve ser projetado. Em síntese, o DLD serve como um guia visual para a implementação eficaz do banco de dados.

![DLD](DLD.png)

---

## Dicionário de Dados

O Dicionário de Dados é uma ferramenta fundamental no gerenciamento de dados. Trata-se de um documento ou repositório que descreve de forma detalhada os elementos de um banco de dados, como tabelas, campos, relacionamentos e regras de negócios associadas. Esse dicionário funciona como uma fonte confiável de informações para desenvolvedores, analistas e outros envolvidos, assegurando que os dados sejam compreendidos e utilizados de maneira consistente em todo o sistema. Ele oferece dados essenciais sobre a estrutura e o significado das informações, facilitando a manutenção, a integração e o uso eficiente das informações dentro de uma organização.

### Convenção de Nomenclatura (Mnemônicos)

| Prefixo | Significado                                | Exemplo               |
| ------- | ------------------------------------------ | --------------------- |
| `SRK_`  | Surrogate Key (chave substituta)           | `SRK_ord`, `SRK_data` |
| `prod_` | Atributos da tabela DIM_PRODUTOS           | `prod_weight_g`       |
| `vend_` | Atributos da tabela DIM_VENDEDORES         | `vend_city`           |
| `geo_`  | Geolocalização (usado em várias dimensões) | `geo_lat`, `geo_lng`  |
| `ord_`  | ordem (pedido)                             | `SRK_ord`             |
| ...     | ...                                        | ...                   |

> **Observação:** Foram aplicados mnemônicos consistentes para unificação de nomenclatura, substituindo colunas antigas como `product_id` → `SRK_prod`, `seller_city` → `vend_city`, `data_id` → `SRK_data` e `order_id` → `SRK_ord`. Essas e outras nomeclaturas estão disponiveis no arquivo de mnemônicos.

---

### Tabela `DIM_PRODUTOS`

| Nome do Campo        | Tipo de Dado  | Descrição                                     | Observações |
| -------------------- | ------------- | --------------------------------------------- | ----------- |
| `SRK_prod`           | INTEGER       | Identificador único (Surrogate Key).          | **PK**      |
| `prod_category_name` | VARCHAR(255)  | Nome da categoria à qual o produto pertence.  |             |
| `prod_name_lenght`   | INTEGER       | Número de caracteres no nome do produto.      |             |
| `prod_desc_lenght`   | INTEGER       | Número de caracteres na descrição do produto. |             |
| `prod_photos_qty`    | INTEGER       | Quantidade de fotos publicadas do produto.    |             |
| `prod_weight_g`      | DECIMAL(10,2) | Peso do produto em gramas.                    |             |
| `prod_length_cm`     | DECIMAL(10,2) | Comprimento do produto em centímetros.        |             |
| `prod_height_cm`     | DECIMAL(10,2) | Altura do produto em centímetros.             |             |
| `prod_width_cm`      | DECIMAL(10,2) | Largura do produto em centímetros.            |             |

---

### Tabela `DIM_VENDEDORES`

| Nome do Campo          | Tipo de Dado | Descrição                                        | Observações |
| ---------------------- | ------------ | ------------------------------------------------ | ----------- |
| `SRK_vend`             | INTEGER      | Identificador único (Surrogate Key).             | **PK**      |
| `vend_zip_code_prefix` | INTEGER      | Os 5 primeiros dígitos do CEP do vendedor.       |             |
| `vend_city`            | VARCHAR(255) | Cidade do vendedor.                              |             |
| `vend_state`           | VARCHAR(255) | Estado (UF) do vendedor.                         |             |
| `geo_lat`              | DECIMAL(9,6) | Latitude da localização geográfica do vendedor.  |             |
| `geo_lng`              | DECIMAL(9,6) | Longitude da localização geográfica do vendedor. |             |

---

### Tabela `DIM_DATA`

Tabela de dimensão de tempo, usada para analisar dados em diferentes granularidades de data.

| Nome do Campo   | Tipo de Dado | Descrição                                    | Observações |
| --------------- | ------------ | -------------------------------------------- | ----------- |
| `SRK_data`      | INTEGER      | Identificador único (Surrogate Key).         | **PK**      |
| `data_completa` | DATE         | A data completa no formato AAAA-MM-DD.       |             |
| `ano`           | INTEGER      | Ano extraído da data completa.               |             |
| `mes`           | INTEGER      | Mês extraído da data completa (1 a 12).      |             |
| `dia`           | INTEGER      | Dia extraído da data completa (1 a 31).      |             |
| `dia_da_semana` | VARCHAR(10)  | Nome do dia da semana (ex: 'Segunda-feira'). |             |

---

### Tabela `DIM_PEDIDOS`

| Nome do Campo                   | Tipo de Dado  | Descrição                                                  | Observações  |
| ------------------------------- | ------------- | ---------------------------------------------------------- | ------------ |
| `SRK_ord`                       | INTEGER       | Identificador único (Surrogate Key).                       | **PK**       |
| `review_comment_title`          | VARCHAR(255)  | Título do comentário de avaliação do cliente.              |              |
| `review_comment_message`        | TEXT          | Texto completo do comentário de avaliação.                 |              |
| `customer_unique_id`            | VARCHAR(255)  | Identificador único para cada cliente.                     | **NOT NULL** |
| `order_status`                  | VARCHAR(50)   | Status atual do pedido (ex: 'delivered', 'shipped').       | **NOT NULL** |
| `qtd_payment_sequential`        | INTEGER       | Quantidade de métodos de pagamento usados no pedido.       |              |
| `primeiro_payment_type`         | VARCHAR(50)   | O primeiro ou principal método de pagamento.               |              |
| `valor_total_pagamento`         | DECIMAL(10,2) | Soma total paga pelo pedido.                               |              |
| `maximo_payment_installments`   | INTEGER       | Número máximo de parcelas escolhido.                       |              |
| `order_purchase_timestamp`      | TIMESTAMP     | Data e hora em que o pedido foi realizado.                 | **NOT NULL** |
| `order_delivered_customer_date` | TIMESTAMP     | Data e hora em que o pedido foi entregue ao cliente.       |              |
| `tempo_entrega_dias`            | INTEGER       | Número de dias entre a compra e a entrega.                 |              |
| `flag_atraso`                   | SMALLINT      | Indicador de atraso (ex: 1 para sim, 0 para não).          |              |
| `order_approved_at`             | TIMESTAMP     | Data e hora da aprovação do pagamento.                     |              |
| `order_delivered_carrier_date`  | TIMESTAMP     | Data e hora em que o pedido foi postado na transportadora. |              |
| `order_estimated_delivery_date` | TIMESTAMP     | Data estimada de entrega informada no momento da compra.   |              |
| `review_score`                  | SMALLINT      | Nota da avaliação do cliente (valor de 1 a 5).             |              |
| `review_creation_date`          | TIMESTAMP     | Data e hora em que a avaliação foi criada.                 |              |
| `review_answer_timestamp`       | TIMESTAMP     | Data e hora em que o vendedor respondeu à avaliação.       |              |
| `customer_zip_code_prefix`      | INTEGER       | Os 5 primeiros dígitos do CEP do cliente.                  |              |
| `customer_city`                 | VARCHAR(255)  | Cidade do cliente.                                         |              |
| `customer_state`                | VARCHAR(255)  | Estado (UF) do cliente.                                    |              |
| `geo_lat`                       | DECIMAL(9,6)  | Latitude da localização geográfica do cliente.             |              |
| `geo_lng`                       | DECIMAL(9,6)  | Longitude da localização geográfica do cliente.            |              |

---

### Tabela `FATO_ITENS_PEDIDO`

Tabela fato que conecta todas as dimensões e contém as principais métricas de negócio por item de pedido.

| Nome do Campo     | Tipo de Dado  | Descrição                                            | Observações      |
| ----------------- | ------------- | ---------------------------------------------------- | ---------------- |
| `SRK_ped_item`    | INTEGER       | Identificador único (Surrogate Key).                 | **PK**           |
| `SRK_prod`        | INTEGER       | Ref. `DIM_PRODUTOS`.                                 | **FK**           |
| `SRK_vend`        | INTEGER       | Ref. `DIM_VENDEDORES`.                               | **FK**           |
| `SRK_data_pedido` | INTEGER       | Ref. `DIM_DATA`.                                     | **FK**           |
| `SRK_ord`         | INTEGER       | Ref. `DIM_PEDIDOS`.                                  | **FK**           |
| `ship_limit_date` | TIMESTAMP     | Data e hora limite para o vendedor postar o produto. |                  |
| `price`           | DECIMAL(10,2) | Preço do produto (valor unitário).                   | **Métrica/Fato** |
| `freight_value`   | DECIMAL(10,2) | Valor do frete para o item.                          | **Métrica/Fato** |

---


## Bibliografia

OLIST. **Brazilian E-Commerce Public Dataset by Olist**. Plataforma Kaggle, 2018. Disponível em: [https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Acesso em: 5 out. 2025.

AIRBYTE. **Conceptual Data Model**. Airbyte, [s.d.]. Disponível em: [https://airbyte.com/data-engineering-resources/conceptual-data-model](https://airbyte.com/data-engineering-resources/conceptual-data-model). Acesso em: 5 out. 2025.

BANGASH, Fahad. **Building a Retail Data Warehouse: A Case Study in Star Schema Design**. Medium, [s.d.]. Disponível em: [https://medium.com/@bangashfahad98/building-a-retail-data-warehouse-a-case-study-in-star-schema-design-deea776dcd97](https://medium.com/@bangashfahad98/building-a-retail-data-warehouse-a-case-study-in-star-schema-design-deea776dcd97). Acesso em: 5 out. 2025.

DATABRICKS. **What is a medallion architecture?**. Databricks, [s.d.]. Disponível em: [https://www.databricks.com/glossary/medallion-architecture](https://www.databricks.com/glossary/medallion-architecture). Acesso em: 5 out. 2025.

DATABRICKS. **What is a star schema?**. Databricks, [s.d.]. Disponível em: [https://www.databricks.com/glossary/star-schema](https://www.databricks.com/glossary/star-schema). Acesso em: 5 out. 2025.

DREXEL UNIVERSITY. **Translation of Star Schema into Entity-Relationship Diagrams**. Drexel University CCI, [s.d.]. Disponível em: [https://cci.drexel.edu/faculty/song/publications/p_DEXA97-Star.pdf](https://cci.drexel.edu/faculty/song/publications/p_DEXA97-Star.pdf). Acesso em: 5 out. 2025.

GASPARINI, Sarah Rylie. **Your Conceptual Guide to Building a Star Schema Data Warehouse**. Medium, [s.d.]. Disponível em: [https://medium.com/@sarahryliegasparini/your-conceptual-guide-to-building-a-star-schema-data-warehouse-3ea25ccf0fce](https://medium.com/@sarahryliegasparini/your-conceptual-guide-to-building-a-star-schema-data-warehouse-3ea25ccf0fce). Acesso em: 5 out. 2025.

GEEKSFORGEEKS. **Star Schema in Data Warehouse Modeling**. GeeksforGeeks, [s.d.]. Disponível em: [https://www.geeksforgeeks.org/dbms/star-schema-in-data-warehouse-modeling/](https://www.geeksforgeeks.org/dbms/star-schema-in-data-warehouse-modeling/). Acesso em: 5 out. 2025.

MICROSOFT. **Medallion architecture**. Microsoft Learn, 2025. Disponível em: [https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion). Acesso em: 5 out. 2025.

MICROSOFT. **Understand star schema and the importance for Power BI**. Microsoft Learn, [s.d.]. Disponível em: [https://learn.microsoft.com/en-us/power-bi/guidance/star-schema](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema). Acesso em: 5 out. 2025.

MOTHERDUCK. **Star Schema Data Warehouse Guide**. MotherDuck, [s.d.]. Disponível em: [https://motherduck.com/learn-more/star-schema-data-warehouse-guide/](https://motherduck.com/learn-more/star-schema-data-warehouse-guide/). Acesso em: 5 out. 2025.

OWOX. **Star Schema Explained**. OWOX, [s.d.]. Disponível em: [https://www.owox.com/blog/articles/star-schema-explained](https://www.owox.com/blog/articles/star-schema-explained). Acesso em: 5 out. 2025.

Engenharia de Dados Academy. **Data Lakehouse para Dummies**. YouTube, [s.d.]. Disponível em: [https://www.youtube.com/watch?v=q33K4FWo0Lk](https://www.youtube.com/watch?v=q33K4FWo0Lk). Acesso em: 5 out. 2025.

VERTABELO. **What Is a Star Schema Data Model and Why Is It Important?**. Vertabelo, [s.d.]. Disponível em: [https://vertabelo.com/blog/star-chema-data-model/](https://vertabelo.com/blog/star-chema-data-model/). Acesso em: 5 out. 2025.

---

## Histórico de Versão

| Versão | Data       | Descrição                                                                      | Autor                                           |
| ------ | ---------- | ------------------------------------------------------------------------------ | ----------------------------------------------- |
| 1.0    | 06/10/2025 | Criação do documento                                                           | [Pablo S. Costa](https://github.com/pabloheika) |
| 1.1    | 11/11/2025 | Atualização de nomenclatura e mnemônicos (SRK, prod, vend), renomeia atributos | [Pablo S. Costa](https://github.com/pabloheika) |