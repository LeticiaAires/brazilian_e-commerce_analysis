# Camada Bronze - Dicionário de dados

## 📊 Olist Brazilian E-Commerce Dataset

**Data Source**: Kaggle - Brazilian E-Commerce Public Dataset by Olist  
**URL**: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Este dicionário é a respeito de conjunto de dados públicos de e-commerce brasileiro com pedidos feitos na Olist Store. 
O conjunto de dados contém informações de 100 mil pedidos de 2016 a 2018, feitos em diversos marketplaces no Brasil. 
Seus recursos permitem visualizar um pedido sob diversas dimensões: desde o status do pedido, preço, pagamento e desempenho do frete até a localização do cliente, atributos do produto e, por fim, avaliações escritas por clientes. Além disso conta com um conjunto de dados de geolocalização que relaciona os CEPs brasileiros às coordenadas de latitude/longitude.

Esses são dados comerciais reais, foram anonimizados e as referências às empresas e parceiros no texto da análise foram substituídas pelos nomes das grandes casas de Game of Thrones.

**Atenção**

- Um pedido pode ter vários itens.

- Cada item pode ser atendido por um vendedor diferente.

- Todos os textos que identificam lojas e parceiros foram substituídos pelos nomes das grandes casas de Game of Thrones.

**Esquema de dados:**

![alt text](image.png)

---

## 1. ORDERS (Pedidos)

**Arquivo**: `olist_orders_dataset.csv`  
**Descrição**: Tabela principal contendo informações sobre os pedidos realizados no marketplace.  
**Registros**: 99,441 linhas | 8 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| order_id | ID do Pedido | texto | Identificador único do pedido | UUID (32 caracteres) | não | Chave primária |
| customer_id | ID do Cliente | texto | Identificador do cliente que realizou o pedido | UUID (32 caracteres) | não | Chave estrangeira → customers |
| order_status | Status do Pedido | categórica | Status atual do pedido | delivered, shipped, canceled, unavailable, invoiced, processing, created, approved | não | Maioria "delivered" (96.5%) |
| order_purchase_timestamp | Data/Hora da Compra | datetime | Timestamp do momento da compra | YYYY-MM-DD HH:MM:SS | não | Formato UTC-3 (Brasil) |
| order_approved_at | Data/Hora de Aprovação | datetime | Timestamp da aprovação do pagamento | YYYY-MM-DD HH:MM:SS | sim (0.2%) | Nulo para pedidos não aprovados |
| order_delivered_carrier_date | Data de Postagem | datetime | Data em que o pedido foi postado | YYYY-MM-DD HH:MM:SS | sim (1.8%) | Nulo para pedidos cancelados |
| order_delivered_customer_date | Data de Entrega | datetime | Data de entrega ao cliente | YYYY-MM-DD HH:MM:SS | sim (3.0%) | Nulo se não entregue |
| order_estimated_delivery_date | Data Estimada de Entrega | datetime | Previsão de entrega informada ao cliente | YYYY-MM-DD HH:MM:SS | não | Sempre preenchida na compra |

---

## 2. ORDER_ITEMS (Itens do Pedido)

**Arquivo**: `olist_order_items_dataset.csv`  
**Descrição**: Detalhes dos produtos incluídos em cada pedido.  
**Registros**: 112,650 linhas | 7 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| order_id | ID do Pedido | texto | Identificador do pedido | UUID (32 caracteres) | não | Chave estrangeira → orders |
| order_item_id | Número do Item | numérica | Número sequencial do item no pedido | 1-21 | não | Identifica itens múltiplos |
| product_id | ID do Produto | texto | Identificador único do produto | UUID (32 caracteres) | não | Chave estrangeira → products |
| seller_id | ID do Vendedor | texto | Identificador do vendedor | UUID (32 caracteres) | não | Chave estrangeira → sellers |
| shipping_limit_date | Data Limite de Envio | datetime | Prazo máximo para o vendedor enviar | YYYY-MM-DD HH:MM:SS | não | SLA do vendedor |
| price | Preço do Produto | numérica | Valor do produto em reais (R$) | 0.85 - 6,735.00 | não | Não inclui frete |
| freight_value | Valor do Frete | numérica | Custo do frete em reais (R$) | 0.00 - 409.68 | não | Pode ser zero (frete grátis) |

**Chave Primária Composta**: (order_id, order_item_id)

---

## 3. CUSTOMERS (Clientes)

**Arquivo**: `olist_customers_dataset.csv`  
**Descrição**: Informações cadastrais dos clientes.  
**Registros**: 99,441 linhas | 5 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| customer_id | ID do Cliente | texto | Identificador único por pedido | UUID (32 caracteres) | não | Chave primária |
| customer_unique_id | ID Único do Cliente | texto | Identificador único permanente | UUID (32 caracteres) | não | Mesmo cliente em pedidos diferentes |
| customer_zip_code_prefix | CEP (5 dígitos) | numérica | Primeiros 5 dígitos do CEP | 01000-99990 | não | Relaciona com geolocation |
| customer_city | Cidade | texto | Nome da cidade do cliente | - | não | Nomes podem ter grafia variada |
| customer_state | Estado (UF) | categórica | Sigla do estado brasileiro | SP, RJ, MG, etc (27 estados) | não | Formato: 2 letras maiúsculas |

---

## 4. PRODUCTS (Produtos)

**Arquivo**: `olist_products_dataset.csv`  
**Descrição**: Catálogo de produtos com características físicas.  
**Registros**: 32,951 linhas | 9 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| product_id | ID do Produto | texto | Identificador único do produto | UUID (32 caracteres) | não | Chave primária |
| product_category_name | Categoria (PT) | categórica | Nome da categoria em português | 73 categorias únicas | sim (1.9%) | Ver tabela de tradução |
| product_name_lenght | Tamanho do Nome | numérica | Quantidade de caracteres no nome | 2-76 | sim (1.9%) | Qualidade da descrição |
| product_description_lenght | Tamanho da Descrição | numérica | Quantidade de caracteres na descrição | 4-3,992 | sim (1.9%) | Completude do cadastro |
| product_photos_qty | Quantidade de Fotos | numérica | Número de fotos do produto | 1-20 | sim (1.9%) | Impacta conversão |
| product_weight_g | Peso (gramas) | numérica | Peso do produto em gramas | 0-40,425 | sim (0.0%) | Para cálculo de frete |
| product_length_cm | Comprimento (cm) | numérica | Comprimento da embalagem | 7-105 | sim (0.0%) | Dimensão para frete |
| product_height_cm | Altura (cm) | numérica | Altura da embalagem | 2-105 | sim (0.0%) | Dimensão para frete |
| product_width_cm | Largura (cm) | numérica | Largura da embalagem | 6-118 | sim (0.0%) | Dimensão para frete |

---

## 5. SELLERS (Vendedores)

**Arquivo**: `olist_sellers_dataset.csv`  
**Descrição**: Cadastro dos vendedores do marketplace.  
**Registros**: 3,095 linhas | 4 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| seller_id | ID do Vendedor | texto | Identificador único do vendedor | UUID (32 caracteres) | não | Chave primária |
| seller_zip_code_prefix | CEP (5 dígitos) | numérica | Primeiros 5 dígitos do CEP | 01000-99990 | não | Localização do seller |
| seller_city | Cidade | texto | Cidade onde o vendedor está localizado | - | não | 611 cidades únicas |
| seller_state | Estado (UF) | categórica | Estado onde o vendedor está | SP, RJ, MG, etc (23 estados) | não | Concentração em SP (78%) |

---

## 6. REVIEWS (Avaliações)

**Arquivo**: `olist_order_reviews_dataset.csv`  
**Descrição**: Avaliações e comentários dos clientes sobre os pedidos.  
**Registros**: 99,224 linhas | 7 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| review_id | ID da Avaliação | texto | Identificador único da avaliação | UUID (32 caracteres) | não | Chave primária |
| order_id | ID do Pedido | texto | Pedido sendo avaliado | UUID (32 caracteres) | não | Chave estrangeira → orders |
| review_score | Nota da Avaliação | numérica | Nota de 1 a 5 estrelas | 1, 2, 3, 4, 5 | não | Média geral: 4.09 |
| review_comment_title | Título do Comentário | texto | Título opcional do review | - | sim (88.3%) | Em português |
| review_comment_message | Mensagem do Comentário | texto | Comentário detalhado opcional | - | sim (58.7%) | Em português |
| review_creation_date | Data de Criação | datetime | Data em que o review foi criado | YYYY-MM-DD HH:MM:SS | não | Após entrega do pedido |
| review_answer_timestamp | Data/Hora de Resposta | datetime | Quando o review foi respondido | YYYY-MM-DD HH:MM:SS | não | Sistema de resposta |

**Distribuição de Notas**:
- 5 estrelas: 57.8%
- 4 estrelas: 19.3%
- 1 estrela: 11.5%

---

## 7. PAYMENTS (Pagamentos)

**Arquivo**: `olist_order_payments_dataset.csv`  
**Descrição**: Informações de pagamento dos pedidos.  
**Registros**: 103,886 linhas | 5 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| order_id | ID do Pedido | texto | Identificador do pedido | UUID (32 caracteres) | não | Chave estrangeira → orders |
| payment_sequential | Sequencial do Pagamento | numérica | Ordem do pagamento no pedido | 1-29 | não | Pedidos podem ter múltiplos pagamentos |
| payment_type | Tipo de Pagamento | categórica | Método de pagamento utilizado | credit_card, boleto, voucher, debit_card, not_defined | não | 73.9% cartão de crédito |
| payment_installments | Número de Parcelas | numérica | Quantidade de parcelas | 0-24 | não | 0 = à vista |
| payment_value | Valor do Pagamento | numérica | Valor pago em reais (R$) | 0.00 - 13,664.08 | não | Soma dos payments = valor total |

**Chave Primária Composta**: (order_id, payment_sequential)

---

## 8. GEOLOCATION (Geolocalização)

**Arquivo**: `olist_geolocation_dataset.csv`  
**Descrição**: Coordenadas geográficas dos CEPs brasileiros.  
**Registros**: 1,000,364 linhas | 5 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| geolocation_zip_code_prefix | CEP (5 dígitos) | numérica | Prefixo do CEP | 01000-99990 | não | Pode ter múltiplas coordenadas |
| geolocation_lat | Latitude | numérica | Coordenada de latitude | -33.75 a 5.27 | não | Precisão de 6 casas decimais |
| geolocation_lng | Longitude | numérica | Coordenada de longitude | -73.98 a -32.81 | não | Precisão de 6 casas decimais |
| geolocation_city | Cidade | texto | Nome da cidade | - | não | Pode ter grafias diferentes |
| geolocation_state | Estado (UF) | categórica | Sigla do estado | 27 estados brasileiros | não | Relaciona com customer/seller state |

**Nota**: Um mesmo CEP pode ter múltiplas coordenadas devido a imprecisões no dataset.

---

## 9. CATEGORY_TRANSLATION (Tradução de Categorias)

**Arquivo**: `product_category_name_translation.csv`  
**Descrição**: Tradução das categorias de produtos de português para inglês.  
**Registros**: 71 linhas | 2 colunas

| Variável | Nome Variável | Tipo de Variável | Descrição | Valores Permitidos | Possui valores nulos? | Anotações |
|----------|---------------|------------------|-----------|-------------------|---------------------|-----------|
| product_category_name | Categoria (PT) | categórica | Nome da categoria em português | 71 categorias | não | Chave primária |
| product_category_name_english | Categoria (EN) | categórica | Nome da categoria em inglês | 71 categorias | não | Para internacionalização |

**Exemplos**: beleza_saude → health_beauty, moveis_decoracao → furniture_decor

---



## Observações sobre os dados

1. **Dados faltantes**:
   - Orders: Datas de entrega ausentes em pedidos cancelados (esperado)
   - Products: 1.9% sem informações de categoria/descrição
   - Reviews: 88.3% sem título, 58.7% sem comentário (opcional)

2. **Duplicatas**:
   - Geolocation: Múltiplas coordenadas para mesmo CEP (característica do dataset)
   - Clientes: customer_id único por pedido, customer_unique_id para histórico

3. **Inconsistências**:
   - Nomes de cidades podem ter grafias variadas
   - Alguns produtos com peso/dimensões zerados

---

## Histórico de Versão

| Versão | Data | Descrição | Autor |
|--------|------|-----------|-------|
| 1.0 | 30/09/2025 | Criação inicial do dicionário de dados | Ana Beatriz |

---

**Última Atualização**: 30/09/2025  
**Gerado por**: Notebook de exploração automatizado