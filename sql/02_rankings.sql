-- Ranks counties on each 2020–2024 indicator.
-- Rank 1 = the most barriers (highest poverty, lowest income, etc.).

CREATE OR REPLACE VIEW county_rankings AS
SELECT
    fips,
    county_name,
    RANK() OVER (ORDER BY poverty_rate DESC)          AS poverty_rank,
    RANK() OVER (ORDER BY rent_burden_rate DESC)      AS rent_burden_rank,
    RANK() OVER (ORDER BY unemployment_rate DESC)     AS unemployment_rank,
    RANK() OVER (ORDER BY uninsured_rate DESC)        AS uninsured_rank,
    RANK() OVER (ORDER BY median_income_2024usd ASC)  AS income_rank,
    RANK() OVER (ORDER BY bachelors_plus_rate ASC)    AS education_rank,
    RANK() OVER (ORDER BY broadband_rate ASC)         AS broadband_rank
FROM county_indicators
WHERE year = 2024;