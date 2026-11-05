-- Compares each county's indicators between the 2015–2019 and 2020–2024 surveys.
-- Income change is in percent; rate changes are in percentage points.

CREATE OR REPLACE VIEW county_change AS
SELECT
    a.fips,
    a.county_name,
    a.median_income_2024usd AS income_2019,
    b.median_income_2024usd AS income_2024,
    ROUND((b.median_income_2024usd - a.median_income_2024usd)
          / a.median_income_2024usd * 100, 1)              AS income_change_pct,
    a.rent_burden_rate                                     AS rent_burden_2019,
    b.rent_burden_rate                                     AS rent_burden_2024,
    ROUND(b.rent_burden_rate - a.rent_burden_rate, 1)       AS rent_burden_change_pts,
    ROUND(b.poverty_rate - a.poverty_rate, 1)               AS poverty_change_pts,
    ROUND(b.unemployment_rate - a.unemployment_rate, 1)     AS unemployment_change_pts,
    ROUND(b.uninsured_rate - a.uninsured_rate, 1)           AS uninsured_change_pts,
    ROUND(b.broadband_rate - a.broadband_rate, 1)           AS broadband_change_pts,
    ROUND(b.bachelors_plus_rate - a.bachelors_plus_rate, 1) AS bachelors_change_pts
FROM county_indicators AS a
JOIN county_indicators AS b
    ON a.fips = b.fips
WHERE a.year = 2019
  AND b.year = 2024;