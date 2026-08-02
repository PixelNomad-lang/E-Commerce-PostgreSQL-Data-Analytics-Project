-- =========================================================
-- 01_create_tables.sql
-- E-Commerce PostgreSQL Data Analytics Project — Schema
-- =========================================================

DROP TABLE IF EXISTS returns CASCADE;
DROP TABLE IF EXISTS shipping CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- 1) CATEGORIES
CREATE TABLE categories (
    category_id     SERIAL PRIMARY KEY,
    category_name   VARCHAR(100) NOT NULL UNIQUE,
    description     TEXT
);

-- 2) CUSTOMERS
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(15),
    city            VARCHAR(50),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3) PRODUCTS
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(150) NOT NULL,
    category_id     INT NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
    price           DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity  INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    brand           VARCHAR(50)
);

-- 4) ORDERS
CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status    VARCHAR(20) NOT NULL
                    CHECK (order_status IN ('Pending','Shipped','Delivered','Cancelled')),
    total_amount    DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- 5) ORDER_ITEMS
CREATE TABLE order_items (
    order_item_id   SERIAL PRIMARY KEY,
    order_id        INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id      INT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity        INT NOT NULL CHECK (quantity > 0),
    unit_price      DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0)
);

-- 6) PAYMENTS
CREATE TABLE payments (
    payment_id      SERIAL PRIMARY KEY,
    order_id        INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_method  VARCHAR(20) NOT NULL
                    CHECK (payment_method IN ('UPI','COD','Net Banking','Credit Card','Debit Card')),
    payment_status  VARCHAR(20) NOT NULL
                    CHECK (payment_status IN ('Pending','Success','Failed','Refunded')),
    amount          DECIMAL(10,2) NOT NULL CHECK (amount >= 0)
);

-- 7) SHIPPING
CREATE TABLE shipping (
    shipping_id       SERIAL PRIMARY KEY,
    order_id          INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    courier_company   VARCHAR(50),
    tracking_number   VARCHAR(50),
    shipping_status   VARCHAR(20) NOT NULL
                      CHECK (shipping_status IN ('Pending','Shipped','Delivered','Cancelled')),
    shipped_date      DATE,
    delivered_date    DATE
);

-- 8) RETURNS
CREATE TABLE returns (
    return_id       SERIAL PRIMARY KEY,
    order_item_id   INT NOT NULL REFERENCES order_items(order_item_id) ON DELETE CASCADE,
    return_reason   VARCHAR(100),
    return_status   VARCHAR(20) NOT NULL
                    CHECK (return_status IN ('Requested','Approved','Rejected','Completed')),
    refund_amount   DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (refund_amount >= 0)
);

-- Helpful indexes for analytics queries
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_shipping_order ON shipping(order_id);
CREATE INDEX idx_returns_order_item ON returns(order_item_id);
