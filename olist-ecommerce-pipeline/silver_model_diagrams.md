# Modelagem Silver - Olist E-commerce

## 1. MER - Modelo Entidade-Relacionamento

CUSTOMERS (1)---(N) ORDERS (1)---(N) ORDER_ITEMS (N)---(1) PRODUCTS
                                 |                  |
                                 |                  +--(N) SELLERS
                                 |
                                 +--(1) REVIEWS
```



---

## 2. DER - Diagrama de Entidade e Relacionamento

| Entidade      | Relacionamento           | Entidade Relacionada | Cardinalidade |
|---------------|-------------------------|----------------------|--------------|
| customers     | faz                     | orders               | 1:N          |

---

### DER - Mermaid JS
```mermaid
classDiagram
    class Customers {
        customer_id
        customer_unique_id
        customer_zip_code_prefix
        customer_city
        customer_state
    }
    class Orders {
        order_id
        customer_id
        order_status
        order_purchase_timestamp
        order_approved_at
        order_delivered_carrier_date
        order_delivered_customer_date
        order_estimated_delivery_date
    }
    class OrderItems {
        order_id
        order_item_id
        product_id
        seller_id
        shipping_limit_date
        price
        freight_value
    }
    class Products {
        product_id
        product_category_name
        product_name_lenght
        product_description_lenght
        product_photos_qty
        product_weight_g
        product_length_cm
        product_height_cm
        product_width_cm
    }
    class Sellers {
        seller_id
        seller_zip_code_prefix
        seller_city
        seller_state
    }
    class Reviews {
        review_id
        order_id
        review_score
        review_comment_title
        review_comment_message
        review_creation_date
        review_answer_timestamp
    }
    Customers "1" -- "*" Orders : faz
    Orders "1" -- "*" OrderItems : contem
    OrderItems "*" -- "1" Products : refere-se
    OrderItems "*" -- "1" Sellers : vendido_por
    Orders "1" -- "1" Reviews : recebe
```

## 3. DLD - Diagrama Lógico de Dados

### Tabela: customers
| Campo                  | Tipo         | PK | FK |
|------------------------|--------------|----|----|
| customer_id            | VARCHAR(32)  | X  |    |
| customer_unique_id     | VARCHAR(32)  |    |    |
| customer_zip_code_prefix | INT        |    |    |
| customer_city          | VARCHAR(100) |    |    |
| customer_state         | CHAR(2)      |    |    |

### Tabela: orders
| Campo                        | Tipo         | PK | FK |
|------------------------------|--------------|----|----|
| order_id                     | VARCHAR(32)  | X  |    |
| customer_id                  | VARCHAR(32)  |    | X  |
| order_status                 | VARCHAR(20)  |    |    |
| order_purchase_timestamp     | TIMESTAMP    |    |    |
| order_approved_at            | TIMESTAMP    |    |    |
| order_delivered_carrier_date | TIMESTAMP    |    |    |
| order_delivered_customer_date| TIMESTAMP    |    |    |
| order_estimated_delivery_date| TIMESTAMP    |    |    |

### Tabela: order_items
| Campo              | Tipo         | PK | FK |
|--------------------|--------------|----|----|
| order_id           | VARCHAR(32)  | X  | X  |
| order_item_id      | INT          | X  |    |
| product_id         | VARCHAR(32)  |    | X  |
| seller_id          | VARCHAR(32)  |    | X  |
| shipping_limit_date| TIMESTAMP    |    |    |
| price              | DECIMAL(10,2)|    |    |
| freight_value      | DECIMAL(10,2)|    |    |

### Tabela: products
| Campo                    | Tipo         | PK | FK |
|--------------------------|--------------|----|----|
| product_id               | VARCHAR(32)  | X  |    |
| product_category_name    | VARCHAR(100) |    |    |
| product_name_lenght      | INT          |    |    |
| product_description_lenght| INT         |    |    |
| product_photos_qty       | INT          |    |    |
| product_weight_g         | INT          |    |    |
| product_length_cm        | INT          |    |    |
| product_height_cm        | INT          |    |    |
| product_width_cm         | INT          |    |    |

### Tabela: sellers
| Campo                  | Tipo         | PK | FK |
|------------------------|--------------|----|----|
| seller_id              | VARCHAR(32)  | X  |    |
| seller_zip_code_prefix | INT          |    |    |
| seller_city            | VARCHAR(100) |    |    |
| seller_state           | CHAR(2)      |    |    |

### Tabela: reviews
| Campo                   | Tipo         | PK | FK |
|-------------------------|--------------|----|----|
| review_id               | VARCHAR(32)  | X  |    |
| order_id                | VARCHAR(32)  |    | X  |
| review_score            | INT          |    |    |
| review_comment_title    | VARCHAR(100) |    |    |
| review_comment_message  | TEXT         |    |    |
| review_creation_date    | TIMESTAMP    |    |    |
| review_answer_timestamp | TIMESTAMP    |    |    |

---

> Diagrama textual para documentação e validação do modelo Silver.

