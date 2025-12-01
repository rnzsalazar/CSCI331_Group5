USE PrestigeCars_Project3;
GO

--SalesOrder
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 1, '2015-04-06', 'EURFR009', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 2, '2015-04-04', 'USDUS010', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 3, '2015-02-03', 'GBPGB003', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 5, '2015-03-14', 'GBPGB018', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (6, 4, '2015-02-16', 'USDUS011', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (6, 6, '2015-01-25', 'USDUS012', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (7, 7, '2015-03-24', 'GBPGB019', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (7, 8, '2015-03-30', 'GBPGB020', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (8, 9, '2015-01-02', 'GBPGB021', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (9, 10, '2015-02-20', 'EURFR016', 0);

--SalesOrderDetail
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (1, 1, 1, 65000.00, 4.15, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (2, 2, 1, 220000.00, 27.27, 1);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (3, 3, 1, 19500.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (4, 4, 1, 11500.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (5, 5, 1, 19950.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (6, 6, 1, 29500.00, 4.24, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (7, 7, 1, 49500.00, 4.95, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (8, 8, 1, 76000.00, 7.24, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (9, 9, 1, 19600.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (10, 10, 1, 36500.00, 6.85, 0);