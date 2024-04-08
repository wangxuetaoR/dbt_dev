-- 価格は200円以上の商品の比率
with product_price_200 AS (
 SELECT type_code, cast(COUNT(*) AS DECIMAL(18,2)) as count 
 from {{ ref('product') }}
 WHERE price >= 200
 GROUP BY type_code
),
type_info AS (
 SELECT type_name, type_code
 FROM {{ ref('type') }}
),
product_count AS (
 SELECT type_code, cast(COUNT(*) AS DECIMAL(18,2)) AS count
 from  {{ ref('product') }}
 GROUP BY type_code
)
SELECT type_info.type_code, type_info.type_name, cast(product_price_200.count / product_count.count AS DECIMAL(18,2)) AS percent
FROM product_count
JOIN product_price_200 ON (product_count.type_code = product_price_200.type_code)
JOIN type_info ON (product_count.type_code = type_info.type_code)
order by percent desc