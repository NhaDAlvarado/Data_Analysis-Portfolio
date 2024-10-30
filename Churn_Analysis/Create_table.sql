CREATE TABLE CustomerChurn (
    RowNumber INT,
    CustomerId INT PRIMARY KEY,
    Surname VARCHAR(50),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Tenure INT,
    Balance DECIMAL(15, 2),
    NumOfProducts INT,
    HasCrCard BOOLEAN,
    IsActiveMember BOOLEAN,
    EstimatedSalary DECIMAL(15, 2),
    Exited BOOLEAN
);

select * from customerchurn