# Giới thiệu
Chúng tôi đang phân tích dữ liệu bán hàng của Walmart nhằm xác định các chi nhánh và sản phẩm hoạt động hiệu quả, phân tích xu hướng bán hàng của các sản phẩm khác nhau, và hiểu rõ hành vi của khách hàng. Mục tiêu chính là nâng cao và tối ưu hóa các chiến lược bán hàng. Bộ dữ liệu được sử dụng trong dự án này được lấy từ cuộc thi Walmart Sales Forecasting trên Kaggle.

## Mục đích của dự án
Mục tiêu chính của dự án này là khai thác và hiểu rõ dữ liệu bán hàng của Walmart, từ đó phân tích các yếu tố ảnh hưởng đến doanh số tại những chi nhánh khác nhau.

## Thông tin về dữ liệu
Dữ liệu của dự án được thu thập từ cuộc thi Walmart Sales Forecasting trên Kaggle, bao gồm các giao dịch bán hàng từ ba chi nhánh Walmart đặt tại Mandalay, Yangon và Naypyitaw. Bộ dữ liệu này có 17 cột và 1000 dòng.

| Column            | Description                                   | Data Type        |
|-------------------|-----------------------------------------------|------------------|
| invoice_id        | Invoice of the sales made                     | VARCHAR(30)      |
| branch            | Branch at which sales were made               | VARCHAR(5)       |
| city              | The location of the branch                    | VARCHAR(30)      |
| customer_type     | The type of the customer                       | VARCHAR(30)      |
| gender            | Gender of the customer making purchase        | VARCHAR(10)      |
| product_line      | Product line of the product sold               | VARCHAR(100)     |
| unit_price        | The price of each product                     | DECIMAL(10, 2)   |
| quantity          | The amount of the product sold                 | INT              |
| VAT               | The amount of tax on the purchase             | FLOAT(6, 4)      |
| total             | The total cost of the purchase                | DECIMAL(12, 4)   |
| date              | The date on which the purchase was made       | DATETIME         |
| time              | The time at which the purchase was made       | TIME             |
| payment           | The total amount paid                         | DECIMAL(10, 2)   |
| cogs              | Cost Of Goods sold                            | DECIMAL(10, 2)   |
| gross_margin_pct  | Gross margin percentage                       | FLOAT(11, 9)     |
| gross_income      | Gross Income                                  | DECIMAL(12, 4)   |
| rating            | Rating                                        | FLOAT(2, 1)      |

## Danh sách phân tích:

1. Phân tích sản phẩm
> Thực hiện phân tích dữ liệu để rút ra những hiểu biết về các dòng sản phẩm khác nhau, xác định các dòng sản phẩm hoạt động hiệu quả nhất, đồng thời nhận diện những lĩnh vực cần cải thiện ở các dòng sản phẩm khác.

2. Phân tích doanh số
> Mục tiêu của phân tích này là giải quyết câu hỏi liên quan đến xu hướng bán hàng của sản phẩm. Kết quả phân tích có thể hỗ trợ trong việc đánh giá hiệu quả của từng chiến lược bán hàng đã áp dụng trong doanh nghiệp và xác định những điều chỉnh cần thiết để gia tăng doanh số.

3. Phân tích khách hàng
> Phân tích này tập trung vào việc xác định các phân khúc khách hàng khác nhau, hiểu rõ xu hướng mua sắm và đánh giá mức độ lợi nhuận gắn liền với từng phân khúc khách hàng đó.

## Phương pháp tiếp cận

***1. Xử lý dữ liệu (Data Wrangling)***

Trong giai đoạn ban đầu này, dữ liệu được kiểm tra để phát hiện các giá trị NULL hoặc bị thiếu, và các chiến lược thay thế dữ liệu được áp dụng nhằm xử lý và thay thế các giá trị này một cách hiệu quả.

- Xây dựng cơ sở dữ liệu

- Tạo bảng và chèn dữ liệu.

- Lựa chọn các cột có chứa giá trị NULL. Tuy nhiên, trong cơ sở dữ liệu của chúng tôi không có giá trị NULL, bởi khi tạo bảng đã quy định NOT NULL cho từng trường, nhờ đó loại bỏ hoàn toàn các giá trị NULL.

***2. Kỹ thuật đặc trưng (Feature Engineering)***

Bước này giúp tạo ra một số cột mới từ các cột hiện có.

- Thêm một cột mới tên là time_of_day để cung cấp cái nhìn về doanh số bán hàng theo Buổi sáng, Buổi chiều và Buổi tối. Điều này giúp trả lời câu hỏi: Doanh số bán hàng chủ yếu diễn ra vào thời điểm nào trong ngày.

- Thêm một cột mới tên là day_name chứa tên các ngày trong tuần (Mon, Tue, Wed, Thu, Fri) tương ứng với ngày giao dịch diễn ra. Điều này giúp trả lời câu hỏi: Ngày nào trong tuần từng chi nhánh hoạt động sôi động nhất.

- Thêm một cột mới tên là month_name chứa tên các tháng trong năm (Jan, Feb, Mar) tương ứng với thời điểm giao dịch. Điều này giúp xác định: Tháng nào trong năm có doanh số và lợi nhuận cao nhất.

***3. Phân tích dữ liệu khám phá (Exploratory Data Analysis - EDA)***

Thực hiện phân tích dữ liệu khám phá là bước quan trọng để giải quyết các câu hỏi và mục tiêu đã đề ra trong dự án.

## Các câu hỏi kinh doanh cần trả lời

### Câu hỏi chung

1. Có bao nhiêu thành phố khác nhau xuất hiện trong tập dữ liệu?

2. Mỗi chi nhánh được đặt tại thành phố nào?

### Phân tích sản phẩm (Product Analysis)

1. Có bao nhiêu dòng sản phẩm khác nhau trong tập dữ liệu?
2. Phương thức thanh toán nào được sử dụng phổ biến nhất?
3. Dòng sản phẩm nào có doanh số cao nhất?
4. Tổng doanh thu theo tháng là bao nhiêu?
5. Tháng nào ghi nhận giá vốn hàng bán (COGS) cao nhất?
6. Dòng sản phẩm nào tạo ra doanh thu cao nhất?
7. Thành phố nào có doanh thu cao nhất?
8. Dòng sản phẩm nào chịu thuế VAT cao nhất?
9. Liệt kê mỗi dòng sản phẩm và thêm một cột product_category để phân loại là “Tốt” hoặc “Kém”, dựa trên việc doanh số của dòng sản phẩm đó cao hơn hay thấp hơn mức trung bình.
10. Chi nhánh nào bán được số lượng sản phẩm nhiều hơn mức trung bình?
11. Dòng sản phẩm phổ biến nhất theo giới tính là gì?
12. Điểm đánh giá trung bình (rating) của từng dòng sản phẩm là bao nhiêu?

### Phân tích doanh số (Sales Analysis)

1. Số lượng giao dịch bán hàng trong từng khung giờ trong ngày (sáng, chiều, tối) theo từng ngày trong tuần là bao nhiêu?
2. Loại khách hàng nào tạo ra doanh thu cao nhất?
3. Thành phố nào có tỷ lệ thuế VAT cao nhất?
4. Loại khách hàng nào trả nhiều VAT nhất?

### Phân tích khách hàng (Customer Analysis)

1. Có bao nhiêu loại khách hàng khác nhau trong dữ liệu?
2. Có bao nhiêu phương thức thanh toán khác nhau?
3. Loại khách hàng phổ biến nhất là gì?
4. Loại khách hàng nào mua hàng nhiều nhất?
5. Giới tính nào chiếm đa số trong tập khách hàng?
6. Phân bố giới tính theo từng chi nhánh như thế nào?
7. Khung giờ nào trong ngày khách hàng đưa ra nhiều đánh giá nhất?
8. Khung giờ nào trong ngày, theo từng chi nhánh, khách hàng đưa ra nhiều đánh giá nhất?
9. Ngày nào trong tuần có điểm đánh giá trung bình cao nhất?
10. Ngày nào trong tuần, theo từng chi nhánh, có điểm đánh giá trung bình cao nhất?
