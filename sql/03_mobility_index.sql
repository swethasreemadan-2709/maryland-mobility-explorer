-- Mobility Barriers Index: the average of seven standardized indicators.
-- Higher score = more barriers. Scores are relative to other Maryland
-- counties in the same survey period (the average county = 0).

CREATE OR REPLACE VIEW mobility_index AS
WITH z_scores AS (
    SELECT
        fips,
        county_name,
        year,
        (poverty_rate - AVG(poverty_rate) OVER w)
            / STDDEV_SAMP(poverty_rate) OVER w                    AS z_poverty,
        (rent_burden_rate - AVG(rent_burden_rate) OVER w)
            / STDDEV_SAMP(rent_burden_rate) OVER w                AS z_rent_burden,
        (unemployment_rate - AVG(unemployment_rate) OVER w)
            / STDDEV_SAMP(unemployment_rate) OVER w               AS z_unemployment,
        (uninsured_rate - AVG(uninsured_rate) OVER w)
            / STDDEV_SAMP(uninsured_rate) OVER w                  AS z_uninsured,
        -(median_income_2024usd - AVG(median_income_2024usd) OVER w)
            / STDDEV_SAMP(median_income_2024usd) OVER w           AS z_income,
        -(bachelors_plus_rate - AVG(bachelors_plus_rate) OVER w)
            / STDDEV_SAMP(bachelors_plus_rate) OVER w             AS z_education,
        -(broadband_rate - AVG(broadband_rate) OVER w)
            / STDDEV_SAMP(broadband_rate) OVER w                  AS z_broadband
    FROM county_indicators
    WINDOW w AS (PARTITION BY year)
),
index_scores AS (
    SELECT
        fips,
        county_name,
        year,
        (z_poverty + z_rent_burden + z_unemployment + z_uninsured
         + z_income + z_education + z_broadband) / 7 AS barrier_index
    FROM z_scores
)
SELECT
    fips,
    county_name,
    year,
    ROUND(barrier_index, 2) AS barrier_index,
    RANK() OVER (PARTITION BY year ORDER BY barrier_index DESC) AS barrier_rank,
    CASE NTILE(3) OVER (PARTITION BY year ORDER BY barrier_index DESC)
        WHEN 1 THEN 'High barriers'
        WHEN 2 THEN 'Medium barriers'
        ELSE 'Low barriers'
    END AS barrier_tier
FROM index_scores;