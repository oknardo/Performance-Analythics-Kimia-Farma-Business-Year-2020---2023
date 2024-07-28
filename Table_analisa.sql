-- |-------------------------------------------------------------------------------------------------------|
-- |Created By:                                                                                            |
-- |     Oknardo Budi Setiawan Tulung                                                                      |
-- |     Email: oknardotulung@gmail.com                                                                    | 
-- |     LinkedIn: www.linkedin.com/in/oknardo-tulung                                                      | 
-- |     GitHub: https://github.com/oknardo                                                                |
-- |                                                                                                       |
-- |-------------------------------------------------------------------------------------------------------|


-- Membuat tabel analisa
CREATE OR REPLACE TABLE rakamin-kf-analytics-430323.kimia_farma.analisa AS
SELECT
-- Memilih kolom 'transaction_id' dari tabel 'kf_final_transaction'
  t.transaction_id,
  
-- Memilih kolom 'date' dari tabel 'kf_final_transaction'
  t.date,
  
-- Memilih kolom 'branch_id' dari tabel 'kf_final_transaction'
  t.branch_id,
  
-- Memilih kolom 'branch_name' dari tabel 'kf_kantor_cabang'
  c.branch_name,
  
-- Memilih kolom 'kota' dari tabel 'kf_kantor_cabang'
  c.kota,
  
-- Memilih kolom 'provinsi' dari tabel 'kf_kantor_cabang'
  c.provinsi,
  
-- Memilih kolom 'rating' dari tabel 'kf_kantor_cabang' dan memberi alias 'rating_cabang'
  c.rating AS rating_cabang,
  
-- Memilih kolom 'customer_name' dari tabel 'kf_final_transaction'
  t.customer_name,
  
-- Memilih kolom 'product_id' dari tabel 'kf_final_transaction'
  t.product_id,
  
-- Memilih kolom 'product_name' dari tabel 'kf_product'
  p.product_name,
  
-- Memilih kolom 'price' dari tabel 'kf_final_transaction' dan memberi alias 'actual_price'
  t.price AS actual_price,
  
-- Memilih kolom 'discount_percentage' dari tabel 'kf_final_transaction'
  t.discount_percentage,
  
-- Menghitung 'persentase_gross_laba' berdasarkan harga produk
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  
-- Menghitung 'nett_sales' berdasarkan harga setelah diskon
  t.price * (1 - t.discount_percentage) AS nett_sales,
  
-- Menghitung 'nett_profit' berdasarkan harga setelah diskon dan persentase laba
  t.price * (1 - t.discount_percentage) * CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,
  
-- Memilih kolom 'rating' dari tabel 'kf_final_transaction' dan memberi alias 'rating_transaksi'
  t.rating AS rating_transaksi
-- Menggabungkan tabel 'kf_final_transaction' dengan 'kf_kantor_cabang' berdasarkan 'branch_id'
FROM
  rakamin-kf-analytics-430323.kimia_farma.kf_final_transaction t
JOIN
  rakamin-kf-analytics-430323.kimia_farma.kf_kantor_cabang c
ON
  t.branch_id = c.branch_id
JOIN
-- Menggabungkan hasil gabungan sebelumnya dengan 'kf_product' berdasarkan 'product_id'
  rakamin-kf-analytics-430323.kimia_farma.kf_product p
ON
  t.product_id = p.product_id;

-- Melihat tabel analisa
SELECT * FROM rakamin-kf-analytics-430323.kimia_farma.analisa LIMIT 100








