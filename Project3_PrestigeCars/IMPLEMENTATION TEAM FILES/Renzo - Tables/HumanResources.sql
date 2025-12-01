USE PrestigeCars_Project3;
GO

--Staff
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Amelia', NULL, 'Executive', 1);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Gerard', 1, 'Finance', 2);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Chloe', 1, 'Marketing', 2);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Susan', 1, 'Sales', 2);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Andy', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Steve', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Stan', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Nathan', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Maggie', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Jenny', 2, 'Finance', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Chris', 2, 'Finance', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Megan', 3, 'Marketing', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Sandy', 11, 'Finance', 4);

--Customer
INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Pierre', 'Dubois', 'pierred@gmail.com', '347-123-1234', '14, Rue De La Hutte', 'Marseille', NULL, 2);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Sondra', 'Horowitz', 'sondrah@gmail.com', '347-123-1235', '10040 Great Western Road', 'Los Angeles', NULL, 7);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Alexei', 'Tolstoi', 'alexeit@gmail.com', '347-123-1236', '83, Abbey Road', 'London', 'N4 2CV', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Theo', 'Kowalski', 'theok@gmail.com', '347-123-1237', '1000 East 51st Street', 'New York', NULL, 7);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Peter', 'McLuckie', 'peterm@gmail.com', '347-123-1238', '73, Entwhistle Street', 'London', 'W10 BN', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Jason', 'Wight', 'jasonw@gmail.com', '347-123-1239', '5300 Star Boulevard', 'Washington', NULL, 7);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Peter', 'Smith', 'peters@gmail.com', '347-123-1240', '82, Ell Pie Lane', 'Birmingham', 'B5 5SD', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Ivana', 'Telford', 'ivanat@gmail.com', '347-123-1241', '52, Gerrard Mansions', 'Liverpool', 'L2 9RT', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Kieran', 'O''Harris', 'kierano@gmail.com', '347-123-1242', '71, Askwith Ave', 'Liverpool', 'L7 6OP', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Laurence', 'Saint Yves', 'laurences@gmail.com', '347-123-1243', '49, Rue Quicampoix', 'Marseille', NULL, 2);