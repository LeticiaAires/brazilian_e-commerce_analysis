# Data Selection & Gold Modeling Description

A camada Gold irá consolidar em um modelo dimensional otimizado a cabada Silver. Este modelo será composto por uma tabela fato central (FatoItensPedido) e suas dimensões descritivas. A modelagem visa criar uma "fonte única da verdade" (Single Source of Truth) para as principais entidades de negócio. Para isso nessa modelagem usamos o esquema em estrela. 

1. **Tabela Fato** (Fact Table): O núcleo do modelo continua sendo a FatoItensPedido, representando a venda de um item de produto dentro de um pedido. Ela conterá métricas quantitativas e as chaves estrangeiras para as dimensões.

2. **Tabelas de Dimensão** (Dimension Tables): As dimensões descreverão o contexto dos eventos da tabela fato.

   * DimPedidos: Agora unificará informações dos pedidos (orders), clientes (customers), pagamentos (payments) e avaliações (reviews). Além disso, os dados de geolocalização do cliente (geolocation) serão incorporados diretamente nesta tabela. Serão mantidos os campos calculados, como tempo de entrega e flag de atraso.
   * DimProdutos: Conterá os detalhes dos produtos (products).
   * DimVendedores: Agrupará as informações dos vendedores (sellers), agora enriquecidas com seus respectivos dados de geolocalização (geolocation).
   * DimData: Uma dimensão de data será criada a partir das colunas de timestamp para permitir análises temporais.

As transformações incluirão: limpeza de dados, enriquecimento (junção de tabelas, incluindo a desnormalização da geografia) e criação de métricas de negócio (cálculo de datas e flags).

## MER - Modelo Entidade-Relacionamento

O Modelo Entidade-Relacionamento (MER) é uma abordagem conceitual utilizada no desenvolvimento de bancos de dados para representar entidades, seus atributos e os relacionamentos entre elas. Ele facilita a visualização da organização dos dados e da forma como as entidades interagem dentro do sistema de informações. O MER serve como a fundação conceitual para a criação dos Diagramas Entidade-Relacionamento (DER), que ilustram graficamente essa estrutura.

### Entidades

* FATOITENSPEDIDO (Fact)
* DIMPEDIDOS (Dimension)
* DIMPRODUTOS (Dimension)
* DIMVENDEDORES (Dimension)
* DIMDATA (Dimension)

### Descrição das Entidades (Atributos)

* **FATOITENSPEDIDO&#x20;**(order\_id, <ins>order\_item\_id</ins>, product\_id, seller\_id, data\_pedido\_id, shipping_limit_date, price, freight_value)

* **DIMPEDIDOS&#x20;**(<ins>order\_id</ins>, customer\_unique\_id, order_status, qtd_payment_sequential, primeiro_payment_type, valor\_total\_pagamento, maximo_payment_installments, order_purchase_timestamp, order_delivered_customer_date, tempo\_entrega\_dias, flag\_atraso, order_approved_at, order_delivered_carrier_date, order_estimated_delivery_date, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp, customer_zip_code_prefix, customer_city, customer_state, geolocation_lat, geolocation_lng)

* **DIMPRODUTOS&#x20;**(<ins>product\_id</ins>, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)

* **DIMVENDEDORES&#x20;**(<ins>seller\_id</ins>, seller_zip_code_prefix, seller_city, seller_state, geolocation_lat, geolocation_lng)

* **DIMDATA&#x20;**(<ins>data\_id</ins>, data\_completa, ano, mes, dia, dia\_da\_semana)

### Relacionamentos

* **PEDIDO — contém — ITEM DE PEDIDO**
    * Um PEDIDO (`DimPedidos`) pode conter um ou vários ITENS DE PEDIDO (`FatoItensPedido`), enquanto que um ITEM DE PEDIDO pertence a apenas um PEDIDO.
    * Cardinalidade: (1:n)

* **PRODUTO — é vendido como — ITEM DE PEDIDO**
    * Um PRODUTO (`DimProdutos`) pode ser vendido como nenhum ou vários ITENS DE PEDIDO (`FatoItensPedido`), enquanto que um ITEM DE PEDIDO refere-se a apenas um PRODUTO.
    * Cardinalidade: (1:n)

* **VENDEDOR — vende — ITEM DE PEDIDO**
    * Um VENDEDOR (`DimVendedores`) pode vender nenhum ou vários ITENS DE PEDIDO (`FatoItensPedido`), enquanto que um ITEM DE PEDIDO é vendido por apenas um VENDEDOR.
    * Cardinalidade: (1:n)

* **DATA — registra a venda de — ITEM DE PEDIDO**
    * Em uma DATA (`DimData`) podem ser registrados nenhum ou vários ITENS DE PEDIDO (`FatoItensPedido`), enquanto que um ITEM DE PEDIDO é registrado em apenas uma DATA.
    * Cardinalidade: (1:n)


## DER - Diagrama de Entidade e Relacionamento

O Diagrama Entidade-Relacionamento (DER) é uma representação visual empregada em projetos de bancos de dados. Ele ilustra as entidades (objetos), seus atributos (características) e os relacionamentos existentes entre elas. Nesse diagrama, as entidades são representadas por retângulos, os atributos por elipses, e as conexões entre entidades são feitas por linhas que indicam seus relacionamentos. O DER é uma ferramenta essencial para visualizar e planejar a estrutura do banco de dados antes da implementação, auxiliando na definição de como os dados serão armazenados e acessados.

![DER](DER.png)

## DLD - Diagrama Lógico de Dados

O Diagrama Lógico de Dados (DLD) é uma representação gráfica que descreve a estrutura lógica de um banco de dados. Ele mostra detalhes importantes, como os tipos de atributos de cada entidade, além das chaves estrangeiras e restrições, como as chaves únicas (unique key). O principal objetivo do DLD é fornecer uma visão clara e estruturada de como o banco de dados deve ser projetado. Em síntese, o DLD serve como um guia visual para a implementação eficaz do banco de dados.

![DLD](DLD.png)

## Dicionário de Dados

O Dicionário de Dados é uma ferramenta fundamental no gerenciamento de dados. Trata-se de um documento ou repositório que descreve de forma detalhada os elementos de um banco de dados, como tabelas, campos, relacionamentos e regras de negócios associadas. Esse dicionário funciona como uma fonte confiável de informações para desenvolvedores, analistas e outros envolvidos, assegurando que os dados sejam compreendidos e utilizados de maneira consistente em todo o sistema. Ele oferece dados essenciais sobre a estrutura e o significado das informações, facilitando a manutenção, a integração e o uso eficiente das informações dentro de uma organização.

### Visão Geral do Esquema

Este esquema de banco de dados é modelado como um **Star Schema**, comumente usado em Data Warehousing e Business Intelligence.

* **Tabela Fato:** `FATOITENSPEDIDO` é a tabela fato central. Ela armazena as métricas ou "fatos" de negócio (preço, valor do frete) e as chaves estrangeiras que a conectam às tabelas de dimensão.
* **Tabelas de Dimensão:** `DIMPRODUTOS`, `DIMVENDEDORES`, `DIMDATA` e `DIMPEDIDOS` são as tabelas de dimensão. Elas contêm os atributos descritivos que contextualizam os fatos (quem, o quê, quando, onde).


### Tabela `DIMPRODUTOS`

Armazena os atributos descritivos de cada produto.

| Nome do Campo | Tipo de Dado | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `product_id` | `INTEGER` | Identificador único para cada produto. | Chave Primária (PK) |
| `product_category_name` | `VARCHAR(255)` | Nome da categoria à qual o produto pertence. | |
| `product_name_lenght` | `INTEGER` | Número de caracteres no nome do produto. | |
| `product_description_lenght`| `INTEGER` | Número de caracteres na descrição do produto. | |
| `product_photos_qty` | `INTEGER` | Quantidade de fotos publicadas do produto. | |
| `product_weight_g` | `DECIMAL(10,2)` | Peso do produto em gramas. | |
| `product_length_cm` | `DECIMAL(10,2)` | Comprimento do produto em centímetros. | |
| `product_height_cm` | `DECIMAL(10,2)` | Altura do produto em centímetros. | |
| `product_width_cm` | `DECIMAL(10,2)` | Largura do produto em centímetros. | |

---

### Tabela `DIMVENDEDORES`

Armazena os atributos e informações de localização dos vendedores.

| Nome do Campo | Tipo de Dado | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `seller_id` | `INTEGER` | Identificador único para cada vendedor. | Chave Primária (PK) |
| `seller_zip_code_prefix` | `INTEGER` | Os 5 primeiros dígitos do CEP do vendedor. | |
| `seller_city` | `VARCHAR(255)` | Cidade do vendedor. | |
| `seller_state` | `VARCHAR(255)` | Estado (UF) do vendedor. | |
| `geolocation_lat` | `DECIMAL(9,6)` | Latitude da localização geográfica do vendedor. | |
| `geolocation_lng` | `DECIMAL(9,6)` | Longitude da localização geográfica do vendedor. | |

---

### Tabela `DIMDATA`

Tabela de dimensão de tempo, usada para analisar dados em diferentes granularidades de data.

| Nome do Campo | Tipo de Dado | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `data_id` | `INTEGER` | Identificador único para cada data (chave substituta). | Chave Primária (PK) |
| `data_completa` | `DATE` | A data completa no formato AAAA-MM-DD. | |
| `ano` | `INTEGER` | Ano extraído da data completa. | |
| `mes` | `INTEGER` | Mês extraído da data completa (1 a 12). | |
| `dia` | `INTEGER` | Dia extraído da data completa (1 a 31). | |
| `dia_da_semana` | `VARCHAR(10)` | Nome do dia da semana (ex: 'Segunda-feira'). | |

---

### Tabela `DIMPEDIDOS`

Armazena atributos relacionados ao pedido, ao cliente, à entrega e às avaliações. É uma dimensão complexa que agrupa diversas informações.

| Nome do Campo | Tipo de Dado | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `order_id` | `INTEGER` | Identificador único para cada pedido. | Chave Primária (PK) |
| `review_comment_title` | `VARCHAR(255)` | Título do comentário de avaliação do cliente. | |
| `review_comment_message`| `TEXT` | Texto completo do comentário de avaliação. | |
| `customer_unique_id` | `VARCHAR(255)` | Identificador único para cada cliente. | `NOT NULL` |
| `order_status` | `VARCHAR(50)` | Status atual do pedido (ex: 'delivered', 'shipped'). | `NOT NULL` |
| `qtd_payment_sequential`| `INTEGER` | Quantidade de métodos de pagamento usados no pedido. | |
| `primeiro_payment_type` | `VARCHAR(50)` | O primeiro ou principal método de pagamento. | |
| `valor_total_pagamento` | `DECIMAL(10,2)` | Soma total paga pelo pedido. | |
| `maximo_payment_installments`| `INTEGER` | Número máximo de parcelas escolhido. | |
| `order_purchase_timestamp`| `TIMESTAMP` | Data e hora em que o pedido foi realizado. | `NOT NULL` |
| `order_delivered_customer_date`| `TIMESTAMP` | Data e hora em que o pedido foi entregue ao cliente. | |
| `tempo_entrega_dias` | `INTEGER` | Número de dias entre a compra e a entrega. | |
| `flag_atraso` | `SMALLINT` | Indicador de atraso (ex: 1 para sim, 0 para não). | |
| `order_approved_at` | `TIMESTAMP` | Data e hora da aprovação do pagamento. | |
| `order_delivered_carrier_date`| `TIMESTAMP` | Data e hora em que o pedido foi postado na transportadora.| |
| `order_estimated_delivery_date`| `TIMESTAMP` | Data estimada de entrega informada no momento da compra.| |
| `review_score` | `SMALLINT` | Nota da avaliação do cliente (valor de 1 a 5). | |
| `review_creation_date` | `TIMESTAMP` | Data e hora em que a avaliação foi criada. | |
| `review_answer_timestamp`| `TIMESTAMP` | Data e hora em que o vendedor respondeu à avaliação. | |
| `customer_zip_code_prefix`| `INTEGER` | Os 5 primeiros dígitos do CEP do cliente. | |
| `customer_city` | `VARCHAR(255)` | Cidade do cliente. | |
| `customer_state` | `VARCHAR(255)` | Estado (UF) do cliente. | |
| `geolocation_lat` | `DECIMAL(9,6)` | Latitude da localização geográfica do cliente. | |
| `geolocation_lng` | `DECIMAL(9,6)` | Longitude da localização geográfica do cliente. | |

---

### Tabela `FATOITENSPEDIDO`

Tabela fato que conecta todas as dimensões e contém as principais métricas de negócio por item de pedido.

| Nome do Campo | Tipo de Dado | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `order_item_id` | `INTEGER` | Identificador único para cada item dentro de um pedido. | Chave Primária (PK) |
| `product_id` | `INTEGER` | Chave que referencia a tabela `DIMPRODUTOS`. | Chave Estrangeira (FK) |
| `seller_id` | `INTEGER` | Chave que referencia a tabela `DIMVENDEDORES`. | Chave Estrangeira (FK) |
| `data_pedido_id` | `INTEGER` | Chave que referencia a tabela `DIMDATA`. | Chave Estrangeira (FK) |
| `order_id` | `INTEGER` | Chave que referencia a tabela `DIMPEDIDOS`. | Chave Estrangeira (FK) |
| `shipping_limit_date` | `TIMESTAMP` | Data e hora limite para o vendedor postar o produto. | |
| `price` | `DECIMAL(10,2)` | Preço do produto (valor unitário). | **Métrica/Fato** |
| `freight_value` | `DECIMAL(10,2)` | Valor do frete para o item. | **Métrica/Fato** |


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

| Versão | Data       | Descrição            | Autor                                           |
| ------ | ---------- | -------------------- | ----------------------------------------------- |
| 1.0    | 06/10/2025 | Criação do documento | [Pablo S. Costa](https://github.com/pabloheika) |