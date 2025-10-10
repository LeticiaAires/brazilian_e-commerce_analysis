# Bronze Layer - Data Dictionary

## 📊 Olist Brazilian E-Commerce Dataset

*Gerado automaticamente via notebook de exploração*

---

## Dataset: ORDERS\n\n**Linhas**: 10,000  
**Colunas**: 8  
**Arquivo**: `olist_orders_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| order_id | object | 10,000 | 0.0% | 10,000 |
| customer_id | object | 10,000 | 0.0% | 10,000 |
| order_status | object | 10,000 | 0.0% | 7 |
| order_purchase_timestamp | datetime64[ns] | 10,000 | 0.0% | 9,995 |
| order_approved_at | object | 9,979 | 0.2% | 9,868 |
| order_delivered_carrier_date | object | 9,834 | 1.7% | 9,511 |
| order_delivered_customer_date | object | 9,720 | 2.8% | 9,710 |
| order_estimated_delivery_date | object | 10,000 | 0.0% | 421 |

---

## Dataset: ORDER_ITEMS\n\n**Linhas**: 10,000  
**Colunas**: 7  
**Arquivo**: `olist_order_items_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| order_id | object | 10,000 | 0.0% | 8,797 |
| order_item_id | int64 | 10,000 | 0.0% | 8 |
| product_id | object | 10,000 | 0.0% | 6,088 |
| seller_id | object | 10,000 | 0.0% | 1,574 |
| shipping_limit_date | object | 10,000 | 0.0% | 8,776 |
| price | float64 | 10,000 | 0.0% | 1,832 |
| freight_value | float64 | 10,000 | 0.0% | 2,618 |

---

## Dataset: CUSTOMERS\n\n**Linhas**: 10,000  
**Colunas**: 5  
**Arquivo**: `olist_customers_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| customer_id | object | 10,000 | 0.0% | 10,000 |
| customer_unique_id | object | 10,000 | 0.0% | 9,964 |
| customer_zip_code_prefix | int64 | 10,000 | 0.0% | 5,878 |
| customer_city | object | 10,000 | 0.0% | 1,594 |
| customer_state | object | 10,000 | 0.0% | 27 |

---

## Dataset: PRODUCTS\n\n**Linhas**: 10,000  
**Colunas**: 9  
**Arquivo**: `olist_products_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| product_id | object | 10,000 | 0.0% | 10,000 |
| product_category_name | object | 9,812 | 1.9% | 72 |
| product_name_lenght | float64 | 9,812 | 1.9% | 59 |
| product_description_lenght | float64 | 9,812 | 1.9% | 2,140 |
| product_photos_qty | float64 | 9,812 | 1.9% | 17 |
| product_weight_g | float64 | 9,999 | 0.0% | 1,203 |
| product_length_cm | float64 | 9,999 | 0.0% | 96 |
| product_height_cm | float64 | 9,999 | 0.0% | 95 |
| product_width_cm | float64 | 9,999 | 0.0% | 83 |

---

## Dataset: SELLERS\n\n**Linhas**: 3,095  
**Colunas**: 4  
**Arquivo**: `olist_sellers_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| seller_id | object | 3,095 | 0.0% | 3,095 |
| seller_zip_code_prefix | int64 | 3,095 | 0.0% | 2,246 |
| seller_city | object | 3,095 | 0.0% | 611 |
| seller_state | object | 3,095 | 0.0% | 23 |

---

## Dataset: REVIEWS\n\n**Linhas**: 10,000  
**Colunas**: 7  
**Arquivo**: `olist_order_reviews_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| review_id | object | 10,000 | 0.0% | 9,993 |
| order_id | object | 10,000 | 0.0% | 9,995 |
| review_score | int64 | 10,000 | 0.0% | 5 |
| review_comment_title | object | 1,190 | 88.1% | 676 |
| review_comment_message | object | 4,180 | 58.2% | 3,911 |
| review_creation_date | object | 10,000 | 0.0% | 555 |
| review_answer_timestamp | object | 10,000 | 0.0% | 9,989 |

---

## Dataset: PAYMENTS\n\n**Linhas**: 10,000  
**Colunas**: 5  
**Arquivo**: `olist_order_payments_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| order_id | object | 10,000 | 0.0% | 9,921 |
| payment_sequential | int64 | 10,000 | 0.0% | 18 |
| payment_type | object | 10,000 | 0.0% | 4 |
| payment_installments | int64 | 10,000 | 0.0% | 18 |
| payment_value | float64 | 10,000 | 0.0% | 7,052 |

---

## Dataset: GEOLOCATION\n\n**Linhas**: 10,000  
**Colunas**: 5  
**Arquivo**: `olist_geolocation_dataset.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| geolocation_zip_code_prefix | int64 | 10,000 | 0.0% | 186 |
| geolocation_lat | float64 | 10,000 | 0.0% | 4,257 |
| geolocation_lng | float64 | 10,000 | 0.0% | 4,273 |
| geolocation_city | object | 10,000 | 0.0% | 2 |
| geolocation_state | object | 10,000 | 0.0% | 1 |

---

## Dataset: CATEGORY_TRANSLATION\n\n**Linhas**: 71  
**Colunas**: 2  
**Arquivo**: `product_category_name_translation.csv`  

### Estrutura

| Coluna | Tipo | Não-Nulos | Nulos % | Únicos |
|--------|------|-----------|---------|--------|
| product_category_name | object | 71 | 0.0% | 71 |
| product_category_name_english | object | 71 | 0.0% | 71 |

---

