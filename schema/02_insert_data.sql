-- 10_fix_sequences.sql
-- Run this AFTER all inserts, since categories/customers/products/orders/order_items
-- were inserted with explicit IDs -- their SERIAL sequences need to be bumped up
-- so the next auto-generated INSERT doesn't collide.

SELECT setval('categories_category_id_seq', (SELECT MAX(category_id) FROM categories));
SELECT setval('customers_customer_id_seq', (SELECT MAX(customer_id) FROM customers));
SELECT setval('products_product_id_seq', (SELECT MAX(product_id) FROM products));
SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));
SELECT setval('order_items_order_item_id_seq', (SELECT MAX(order_item_id) FROM order_items));
