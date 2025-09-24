CREATE TABLE TransactionsData (
    id NVARCHAR(MAX),
    [date] NVARCHAR(MAX),
    client_id NVARCHAR(MAX),
    card_id NVARCHAR(MAX),
    amount_$ NVARCHAR(MAX),
    use_chip NVARCHAR(MAX),
    merchant_name NVARCHAR(MAX),
    merchant_city NVARCHAR(MAX),
    merchant_state NVARCHAR(MAX),
    merchant_zip NVARCHAR(MAX),
    mcc NVARCHAR(MAX),
    errors NVARCHAR(MAX), 
	mcc_specialty NVARCHAR(MAX)
);

BULK INSERT TransactionsData
FROM 'C:\Users\elase\Downloads\transactions_cleaned_1.csv' 
WITH (
    FIRSTROW = 2,                
    FIELDTERMINATOR = ',',      
    ROWTERMINATOR = '0x0a',      
    CODEPAGE = '65001'          
);

SELECT COUNT(*) FROM TransactionsData;

SELECT COUNT(*) FROM cards_cleaned;

SELECT COUNT(*) FROM users_cleaned;

SELECT amount_$
FROM TransactionsData
WHERE TRY_CAST(amount_$ AS DECIMAL(18, 2)) IS NULL 
  AND amount_$ IS NOT NULL;

SELECT id
FROM TransactionsData
WHERE TRY_CAST(id AS BIGINT) IS NULL 
  AND id IS NOT NULL;

ALTER TABLE TransactionsData ALTER COLUMN id BIGINT;
ALTER TABLE TransactionsData ALTER COLUMN client_id INT;
ALTER TABLE TransactionsData ALTER COLUMN card_id INT;
ALTER TABLE TransactionsData ALTER COLUMN [amount_$] DECIMAL(18, 2);
ALTER TABLE TransactionsData ALTER COLUMN [date] DATETIME2(0); 
ALTER TABLE TransactionsData ALTER COLUMN use_chip VARCHAR(50);
ALTER TABLE TransactionsData ALTER COLUMN merchant_name NVARCHAR(255);
ALTER TABLE TransactionsData ALTER COLUMN merchant_city NVARCHAR(255);
ALTER TABLE TransactionsData ALTER COLUMN merchant_state NVARCHAR(255);
ALTER TABLE TransactionsData ALTER COLUMN merchant_zip VARCHAR(10);
ALTER TABLE TransactionsData ALTER COLUMN mcc VARCHAR(10);
ALTER TABLE TransactionsData ALTER COLUMN errors VARCHAR(255);
ALTER TABLE TransactionsData ALTER COLUMN mcc_specialty NVARCHAR(255);


ALTER TABLE TransactionsData
ADD     
    Transaction_Year INT,       
    Transaction_Month INT,      
    Transaction_Day INT;        

UPDATE TransactionsData
SET

    Transaction_Year = YEAR([date]),
    Transaction_Month = MONTH([date]),
    Transaction_Day = DAY([date]);


ALTER TABLE TransactionsData
ALTER COLUMN id BIGINT NOT NULL;

ALTER TABLE TransactionsData
ADD CONSTRAINT PK_Transactions PRIMARY KEY (id);

ALTER TABLE users_cleaned
ADD CONSTRAINT PK_users PRIMARY KEY (id);

ALTER TABLE cards_cleaned
ADD CONSTRAINT PK_cards PRIMARY KEY (id);



ALTER TABLE cards_cleaned
ADD CONSTRAINT FK_Cards_To_Users FOREIGN KEY (client_id) REFERENCES users_cleaned(id);

ALTER TABLE TransactionsData
ADD CONSTRAINT FK_Transactions_To_Cards FOREIGN KEY (card_id) REFERENCES cards_cleaned(id);

ALTER TABLE TransactionsData
ADD CONSTRAINT FK_Transactions_To_Users FOREIGN KEY (client_id) REFERENCES users_cleaned(id);

