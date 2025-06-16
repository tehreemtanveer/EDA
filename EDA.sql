-- EXPLORATORY DATA ANALYSIS --

SELECT * 
FROM layoffs_staging3;

-- EASIER QUERIES
SELECT MAX(total_laid_off)
FROM layoffs_staging3;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_staging3
WHERE  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

SELECT *
FROM layoffs_staging3
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoffs_staging3
ORDER BY 2 DESC ;
-- now that's just on a single day

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC ;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging3;
-- this it total in the past 3 years or in the dataset

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC ;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC ;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY `date`
ORDER BY 1 DESC ;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`date`)
ORDER BY 1 DESC ;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC ;



-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging3
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid
FROM layoffs_staging3
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid, SUM(total_laid) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
; 

-- Earlier was Companies with the most Layoffs. Now let's look at that per year. 


WITH Company_Year AS 
(
  SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging3
  GROUP BY company, YEAR(`date`)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC; #



WITH company_rank AS 
(
SELECT company, year(`date`) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging3
GROUP BY company, year(`date`)
),
company_year_rank AS
(
SELECT * , DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_rank
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5
;

                                                                                                                                 
