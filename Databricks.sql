 SELECT
        year,
        make,
        model,
        body,
        transmission,
        state,
        color,
        interior,
        seller,
        COUNT(*) AS number_of_cars_sold,
        SUM(sellingprice) AS total_revenue,
        AVG(sellingprice) AS avg_selling_price,
        AVG(mmr) AS avg_mmr,
        AVG(sellingprice - mmr) AS avg_price_diff,
        MIN(
            TRY_TO_TIMESTAMP(
                saledate,
                'MMM dd yyyy HH:mm:ss'
            )
        ) AS sale_timestamp,
        DAYOFWEEK(
            MIN(
                TRY_TO_TIMESTAMP(
                    saledate,
                    'MMM dd yyyy HH:mm:ss'
                )
            )
        ) AS day_name,
        CAST(
            MIN(
                TRY_TO_TIMESTAMP(
                    saledate,
                    'MMM dd yyyy HH:mm:ss'
                )
            ) AS DATE
        ) AS sale_date,
        date_format(
            MIN(
                TRY_TO_TIMESTAMP(
                    saledate,
                    'MMM dd yyyy HH:mm:ss'
                )
            ),
            'HH:mm:ss'
        ) AS sale_time
    FROM car_sales_case_study_5
    GROUP BY
        year, make, model, body, transmission, state, color, interior, seller
)
SELECT
    year,
    make,
    model,
    body,
    transmission,
    state,
    color,
    interior,
    seller,
    sale_time,
    day_name,
    number_of_cars_sold,
    total_revenue,
    avg_selling_price,
    avg_mmr,
    avg_price_diff,
    CASE
        WHEN avg_price_diff > 0 THEN 'profit'
        WHEN avg_price_diff < 0 THEN 'loss'
        ELSE 'even'
    END AS profit_or_loss_bucket,
    CASE
        WHEN number_of_cars_sold > 100 THEN 'high'
        WHEN number_of_cars_sold BETWEEN 50 AND 100 THEN 'medium'
        ELSE 'low'
    END AS sales_volume_bucket,
    CASE
        WHEN avg_price_diff > 5000 THEN 'Expensive'
        WHEN avg_price_diff BETWEEN 2000 AND 5000 THEN 'Affordable'
        ELSE 'Cheaper'
    END AS price_diff_bucket,
    CASE
        WHEN total_revenue > 500000 THEN 'Outstanding'
        WHEN total_revenue BETWEEN 200000 AND 500000 THEN 'Average'
        ELSE 'Low'
    END AS revenue_bucket
FROM sales_summary
ORDER BY avg_price_diff DESC;
