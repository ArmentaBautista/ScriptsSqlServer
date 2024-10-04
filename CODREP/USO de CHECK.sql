
DROP TABLE Cuentas

CREATE TABLE Cuentas(
  NoCuenta INT PRIMARY KEY IDENTITY,
  Saldo NUMERIC(13,2)
)



INSERT INTO Cuentas (Saldo) VALUES (10000)
INSERT INTO Cuentas  (Saldo) VALUES (56)
INSERT INTO Cuentas  (Saldo) VALUES (-467)
INSERT INTO Cuentas  (Saldo) VALUES (346)


SELECT * FROM Cuentas c




ALTER TABLE Cuentas WITH NOCHECK
ADD CONSTRAINT CK_SaldoNegativo CHECK (Saldo>=0)
GO 

INSERT INTO Cuentas  (Saldo) VALUES (79)
INSERT INTO Cuentas  (Saldo) VALUES (-5)
INSERT INTO Cuentas  (Saldo) VALUES (9999)


SELECT * FROM Cuentas c
