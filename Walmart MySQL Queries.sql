

CREATE DATABASE IF NOT EXISTS walmart;

USE walmart;

CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT(20) NOT NULL,
vat FLOAT(6,4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4),
rating FLOAT(2, 1)
);

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'E:/Minh lam/Walmart Sales/Walmart Sales Data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT * from sales;

------------------- Feature Engineering -----------------------------
-- I. Tạo thêm cột phân loại thời gian "Time_of_day"
-- 		1️. Xem thử phân loại thời gian--
SELECT 
    time,
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;

-- 		2️. Thêm cột mới "Time_of_day"
ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

-- 		3️. Cập nhật dữ liệu cho cột mới time_of_day
UPDATE sales
SET time_of_day = CASE 
    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

-- II. Tạo thêm cột phân loại theo ngày "Day_name"
-- 		1. Xem thử tên ngày trong tuần
SELECT 
    date,
    DAYNAME(date) AS day_name
FROM sales;

-- 		2️. Thêm cột mới "day_name" vào bảng "sales"
ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(10);

-- 		3️. Cập nhật dữ liệu cho cột day_name
UPDATE sales
SET day_name = DAYNAME(date);

-- III. Tạo thêm cột phân loại theo tháng "Momth_name"
-- 		1. Xem thử tên tháng trong năm
SELECT 
    date,
    MONTHNAME(date) AS month_name
FROM sales;

-- 		2️. Thêm cột mới "month_name" vào bảng "sales"
ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

-- 		3️. Cập nhật dữ liệu cho cột month_name
UPDATE sales
SET month_name = MONTHNAME(date);

---------------- Exploratory Data Analysis (EDA) ----------------------
## Câu hỏi chung
-- 1. Có bao nhiêu thành phố khác nhau xuất hiện trong tập dữ liệu?
SELECT DISTINCT city FROM sales;
-- -> Có 3 thành phố là Yangon, Naypyitaw, Mandalay

-- 2. Mỗi chi nhánh được đặt tại thành phố nào?
SELECT DISTINCT branch, city FROM sales;
-- -> Branch A đặt tại thành phố Yangon , Branch C đặt tại thành phố Naypyitaw, Branch B đặt tại thành phố Mandalay

## Phân tích sản phẩm (Product Analysis)
-- 1. Có bao nhiêu dòng sản phẩm khác nhau trong tập dữ liệu?
SELECT COUNT(DISTINCT product_line) FROM sales;
-- -> Có 6 dòng sản phẩm khác nhau 

-- 2. Phương thức thanh toán nào được sử dụng phổ biến nhất?

SELECT payment, COUNT(payment) AS common_payment_method 
FROM sales
GROUP BY payment
ORDER BY common_payment_method DESC
LIMIT 1;

-- -> Là Ewallet với 345 lần thanh toán

-- 3. Dòng sản phẩm nào có số lượng sản phẩm được bán ra cao nhất?
SELECT product_line, COUNT(product_line) AS most_selling_product
FROM sales
GROUP BY product_line
ORDER BY most_selling_product DESC
LIMIT 1;

-- -> Là Fashion accessories với 178 sản phẩm

-- 4. Tổng doanh thu theo tháng là bao nhiêu?

SELECT month_name, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- -> Doanh thu	January		116291.8680
-- 				March		109455.5070
-- 				February	97219.3740


-- 5. Tháng nào ghi nhận giá vốn hàng bán (COGS) cao nhất?

SELECT month_name, SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- -> Giá vốn hàng bán cao nhất theo tháng là tháng January 110754.16

-- 6. Dòng sản phẩm nào tạo ra doanh thu cao nhất?

SELECT 
    product_line, 
    SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- -> Dòng sản phẩm Food and beverages có doanh thu cao nhất với 56144.8440

-- 7. Thành phố nào có doanh thu cao nhất?

SELECT 
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- ->Thành Phố Naypyitaw có doanh thu cao nhất với 110568.7065

-- 8. Dòng sản phẩm nào chịu thuế VAT cao nhất?

SELECT 
    product_line, 
    SUM(vat) AS VAT
FROM
    sales
GROUP BY product_line
ORDER BY VAT DESC
LIMIT 1;

-- -> Dòng sản phẩm Food and beverages chịu thuế VAT cao nhất với 2673.5640

-- 9. Liệt kê mỗi dòng sản phẩm và thêm một cột product_category để phân loại là “Tốt” hoặc “Kém”, dựa trên việc doanh số của dòng sản phẩm đó cao hơn hay thấp hơn mức trung bình.

-- 		1️. Xem thử phân loại tốt hay kém dựa trên doanh số--

SELECT 
    total,
    CASE 
        WHEN total  >= (SELECT AVG(total) FROM sales) THEN 'Good'
        ELSE 'Bad'
    END AS product_category 
FROM sales;

-- 		2️. Thêm cột mới "product_category"
ALTER TABLE sales 
ADD COLUMN product_category VARCHAR(20);

-- 		3️. Cập nhật dữ liệu cho cột mới "product_category"
UPDATE sales
SET product_category = 
  CASE
    WHEN total >= (
      SELECT avg_total
      FROM (SELECT AVG(total) AS avg_total FROM sales) AS tmp
    ) THEN 'Good'
    ELSE 'Bad'
  END;

-- 10. Chi nhánh nào bán được số lượng sản phẩm nhiều hơn mức trung bình?

SELECT
    branch,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (
    SELECT AVG(total_sold)
    FROM (
        SELECT SUM(quantity) AS total_sold
        FROM sales
        GROUP BY branch
    ) AS avg_table
)
ORDER BY total_quantity DESC
LIMIT 1;

-- -> Chi nhánh A với số lượng 1859 sản phẩm.

-- 11. Dòng sản phẩm phổ biến nhất theo giới tính là gì?

(
    SELECT 'Male' AS gender, product_line, COUNT(*) AS total
    FROM sales
    WHERE gender = 'Male'
    GROUP BY product_line
    ORDER BY total DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 'Female' AS gender, product_line, COUNT(*) AS total
    FROM sales
    WHERE gender = 'Female'
    GROUP BY product_line
    ORDER BY total DESC
    LIMIT 1
);

-- Nam mua nhiều nhất dòng Health and beauty
-- Nữ mua nhiều nhất dòng Fashion accessories

-- 12. Điểm đánh giá trung bình (rating) của từng dòng sản phẩm là bao nhiêu?

SELECT product_line,
		ROUND(AVG(rating),2) AS average_rating
FROM sales
GROUP BY product_line
ORDER BY average_rating DESC;

-- Food and beverages có rating trung bình là: 7.11
-- Fashion accessories có rating trung bình là: 7.03
-- Health and beauty có rating trung bình là: 7
-- Electronic accessories có rating trung bình là: 6.92
-- Sports and travel có rating trung bình là: 6.91
-- Home and lifestyle có rating trung bình là: 6.84

## Phân tích doanh số (Sales Analysis)
-- 1. Số lượng giao dịch bán hàng trong từng khung giờ trong ngày (sáng, chiều, tối) theo từng ngày trong tuần là bao nhiêu?
 
SELECT 
	time_of_day, 
    day_name,
    COUNT(invoice_id) AS total_sales
FROM sales
GROUP BY day_name, time_of_day;

-- 2. Loại khách hàng nào tạo ra doanh thu cao nhất?

SELECT 
    customer_type,
    ROUND(SUM(total),2) AS total_sales
FROM
    sales
GROUP BY customer_type
ORDER BY total_sales DESC
LIMIT 1;

-- Khách hàng thành viên tạo ra doanh thu cao nhất.


-- 3. Thành phố nào có tỷ lệ thuế VAT cao nhất?

SELECT 
	city,
    ROUND(SUM(vat), 2) AS total_vat
FROM sales
GROUP BY city
ORDER BY total_vat DESC
LIMIT 1;

-- Thành phố Naypyitaw có tỷ lệ thuế VAT cao nhất.

-- 4. Loại khách hàng nào trả nhiều VAT nhất?

SELECT 
    customer_type,
    ROUND(SUM(vat),2) AS total_vat
FROM
    sales
GROUP BY customer_type
ORDER BY total_vat DESC
LIMIT 1;

-- Khách hàng thành viên trả nhiều VAT nhất.

## Phân tích khách hàng (Customer Analysis)

-- 1. Có bao nhiêu loại khách hàng khác nhau trong dữ liệu?

SELECT 
    COUNT(DISTINCT customer_type) AS type_numbers
FROM
    sales;

-- Có 2 loại khách hàng khác nhau trong dữ liệu.

-- 2. Có bao nhiêu phương thức thanh toán khác nhau?

SELECT 
    COUNT(DISTINCT payment) AS payment_type_numbers
FROM
    sales;
-- Có 3 loại phương thức thanh toán khác nhau trong dữ liệu.

-- 3. Loại khách hàng phổ biến nhất là gì?

SELECT 
	customer_type,
    COUNT(customer_type) AS common_customer
FROM
    sales
GROUP BY customer_type
ORDER BY common_customer DESC
LIMIT 1;

-- Khách hàng thành viên là khách hàng phổ biến nhất.

-- 4. Loại khách hàng nào mua hàng nhiều nhất?

SELECT 
	customer_type,
    SUM(total) AS total_sales
FROM
    sales
GROUP BY customer_type
ORDER BY total_sales DESC
LIMIT 1;

-- Khách hàng thành viên là khách hàng mua nhiều nhất.

-- 5. Giới tính nào chiếm đa số trong tập khách hàng?

SELECT 
	gender,
    COUNT(gender) AS common_gender
FROM
    sales
GROUP BY gender
ORDER BY common_gender DESC
LIMIT 1;

-- Khách hàng nữ chiếm đa số trong tập khách hàng.

-- 6. Phân bố giới tính theo từng chi nhánh như thế nào?

SELECT 
	branch,
    gender,
    COUNT(gender) AS gender_distribution
FROM sales
GROUP BY branch, gender
ORDER BY branch;

-- 7. Khung giờ nào trong ngày khách hàng đưa ra nhiều đánh giá nhất?

SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC
LIMIT 1;

-- Khung giờ buổi chiều thì khách hàng đưa ra nhiều đánh giá nhất.

-- 8. Khung giờ nào trong ngày, theo từng chi nhánh, khách hàng đưa ra nhiều đánh giá nhất?

SELECT 
	branch,
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;

-- 9. Ngày nào trong tuần có điểm đánh giá trung bình cao nhất?

SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC
LIMIT 1;

-- Vào thứ 2 thì điểm đánh giá trung bình cao nhất.

-- 10. Ngày nào trong tuần, theo từng chi nhánh, có điểm đánh giá trung bình cao nhất?

SELECT 
	branch,
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC
LIMIT 1;

-- Vào thứ 2 tại branh B thì điểm đánh giá trung bình cao nhất.