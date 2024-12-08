CREATE TABLE ecommerce_data (
    cid INT NOT NULL,
    tid BIGINT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    age_group VARCHAR(20) NOT NULL,
    purchase_date TIMESTAMP NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    discount_availed VARCHAR(5) NOT NULL,
    discount_name VARCHAR(50),
    discount_amount_inr FLOAT NOT NULL,
    gross_amount FLOAT NOT NULL,
    net_amount FLOAT NOT NULL,
    purchase_method VARCHAR(20) NOT NULL,
    location VARCHAR(50) NOT NULL,
    PRIMARY KEY (cid, tid)
);

SELECT * FROM ecommerce_data ;
