
--CREATE DATABASE stock_market;
--GO

--USE stock_market;
--GO
--CREATE TABLE stock_prices (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    date DATE,
--    symbol VARCHAR(20),
--    company VARCHAR(100),
--    sector VARCHAR(50),
--    open_price DECIMAL(12,2),
--    high_price DECIMAL(12,2),
--    low_price DECIMAL(12,2),
--    close_price DECIMAL(12,2),
--    volume BIGINT
--);
--USE stock_market;
--GO

--SELECT TOP 100 *
--FROM dbo.stock_prices_import;
--SELECT COUNT(*) AS total_rows  5200
--FROM dbo.stock_prices_import;
--SELECT COUNT(DISTINCT symbol) AS total_companies   20 company
--FROM dbo.stock_prices_import;
-- 1. Companies
--step - 1
--SELECT DISTINCT symbol, company, sector
--FROM dbo.stock_prices_import
--ORDER BY symbol;
----step 2
--SELECT 
--    MIN(date) AS start_date,      -- 2025-01-02                         
--    MAX(date) AS end_date         --2025-12-31
--FROM dbo.stock_prices_import;
----Step 3 — Sector-wise companies
--SELECT 
--    sector,
--    COUNT(DISTINCT symbol) AS company_count
--FROM dbo.stock_prices_import
--GROUP BY sector
--ORDER BY company_count DESC;
--select * from dbo.stock_prices_import
----step 4  real stock-market analysis  HIGHEST
--SELECT
--    symbol,
--    company,
--    MAX([close]) AS highest_close
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY highest_close DESC;
----step 5  real stock-market analysis  LOWEST
--SELECT
--    symbol,
--    company,
--    MIN([close]) AS lowest_close
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY lowest_close ASC;
----Highest Closing Price − Lowest Closing Price
--SELECT
--    symbol,
--    company,
--    MAX([close]) AS highest_close,
--    MIN([close]) AS lowest_close,
--    ROUND(MAX([close]) - MIN([close]), 2) AS price_range
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY price_range DESC;

--PRICE CHANGE
--select * from dbo.stock_prices_import
--SELECT
--    date,
--    symbol,
--    company,
--    [open],
--    [close],
--    ROUND([close] - [open], 2) AS price_change
--FROM dbo.stock_prices_import
--ORDER BY price_change DESC;
----Positive vs Negative pric
--SELECT
--    date,
--    symbol,
--    company,
--    [open],
--    [close],
--    ROUND([close] - [open], 2) AS price_change,
--    CASE
--        WHEN [close] > [open] THEN 'UP'
--        WHEN [close] < [open] THEN 'DOWN'
--        ELSE 'NO CHANGE'
--    END AS market_status
--FROM dbo.stock_prices_import
--ORDER BY price_change DESC;
----HIGHEST TO LOWERST
--SELECT
--    symbol,
--    company,
--    ROUND(MAX([close]), 2) AS highest_close,
--    ROUND(MIN([close]), 2) AS lowest_close
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY highest_close DESC;
----PRIFE RANGEEE
--SELECT
--    symbol,
--    company,
--    ROUND(MAX([close]) - MIN([close]), 2) AS price_range
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY price_range DESC;
----AVERAGE CLOSING PRICE
--SELECT
--    symbol,
--    company,
--    ROUND(AVG([close]), 2) AS average_close
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY average_close DESC;
--SELECT * fROM dbo.stock_prices_import
----TOTALL TRADING VOLUME
--SELECT
--    symbol,
--    company,
--    SUM(volume) AS total_volume
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY total_volume DESC;
----AVERAGE TRADING VOLUME
--SELECT
--    symbol,
--    company,
--    ROUND(AVG(volume), 0) AS avg_daily_volume
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY avg_daily_volume DESC;
----UP VS DOWN
--SELECT
--    symbol,
--    company,

--    SUM(CASE
--        WHEN [close] > [open] THEN 1
--        ELSE 0
--    END) AS up_days,
--    SUM(CASE
--        WHEN [close] < [open] THEN 1
--        ELSE 0
--    END) AS down_days,
--    SUM(CASE
--        WHEN [close] = [open] THEN 1
--        ELSE 0
--    END) AS no_change_days
--FROM dbo.stock_prices_import
--GROUP BY symbol, company
--ORDER BY up_days DESC;
-- Daily Return %
SELECT
	DATE,
	Symbol,
	company,
	[open],
	[close],
	Round(
		(([close] - [open]) / [open]) * 100, 2
	) AS return_prcntg
FROM dbo.stock_prices_import
ORDER BY return_prcntg DESC;
--Average returnnn %
SELECT
    symbol,
    company,
    ROUND(
        AVG((([close] - [open]) / [open]) * 100),
        2
    ) AS avg_return_percentage
FROM dbo.stock_prices_import
GROUP BY symbol, company
ORDER BY avg_return_percentage DESC;
--Best & Worst Daily Return
SELECT
    symbol,
    company,
    ROUND(MAX((([close] - [open]) / [open]) * 100), 2) AS highest_return,
    ROUND(MIN((([close] - [open]) / [open]) * 100), 2) AS lowest_return
FROM dbo.stock_prices_import
GROUP BY symbol, company
ORDER BY highest_return DESC;
----------------------------------------------------------------------------------------
select * from dbo.stock_prices_import
--Monthly Performance Analysis
SELECT
    symbol,
    company,
    YEAR([date]) AS year,
    MONTH([date]) AS month,
    ROUND(
        AVG((([close] - [open]) / [open]) * 100),
        2
    ) AS avg_monthly_return
FROM dbo.stock_prices_import
GROUP BY
    symbol,
    company,
    YEAR([date]),
    MONTH([date])
ORDER BY
    year,
    month,
    avg_monthly_return DESC;
SELECT
    [date],
    symbol,
    company,
    volume
FROM dbo.stock_prices_import
ORDER BY volume DESC;
--Moving Average
SELECT
    [date],
    symbol,
    company,
    [close],

    ROUND(
        AVG([close]) OVER (
            PARTITION BY symbol
            ORDER BY [date]
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_7_day

FROM dbo.stock_prices_import
ORDER BY symbol, [date];
--Stock Volatility / Risk
SELECT
    symbol,
    company,
    ROUND(
        STDEV((([close] - [open]) / [open]) * 100),
        2
    ) AS volatility
FROM dbo.stock_prices_import
GROUP BY symbol, company
ORDER BY volatility DESC;
--Stock Ranking
WITH stock_returns AS (
    SELECT
        symbol,
        company,
        ROUND(
            AVG((([close] - [open]) / [open]) * 100),
            2
        ) AS avg_return
    FROM dbo.stock_prices_import
    GROUP BY symbol, company
)

SELECT
    symbol,
    company,
    avg_return,
    RANK() OVER (
        ORDER BY avg_return DESC
    ) AS stock_rank
FROM stock_returns
ORDER BY stock_rank;
--------------------------------------------Stock Performance Summary------------------
SELECT
    symbol,
    company,

    ROUND(AVG([close]), 2) AS avg_close,

    ROUND(MAX([close]), 2) AS highest_close,

    ROUND(MIN([close]), 2) AS lowest_close,

    ROUND(MAX([close]) - MIN([close]), 2) AS price_range,

    SUM(volume) AS total_volume,

    ROUND(AVG(volume), 0) AS avg_daily_volume,

    ROUND(
        AVG((([close] - [open]) / [open]) * 100),
        2
    ) AS avg_return,

    ROUND(
        STDEV((([close] - [open]) / [open]) * 100),
        2
    ) AS volatility,

    SUM(CASE
        WHEN [close] > [open] THEN 1
        ELSE 0
    END) AS up_days,

    SUM(CASE
        WHEN [close] < [open] THEN 1
        ELSE 0
    END) AS down_days

FROM dbo.stock_prices_import
GROUP BY
    symbol,
    company
ORDER BY avg_return DESC;