--
-- Speicherstrukturen Datenbanken
--
-- Index Beispiele
--
-- ----------------------------------------------------------------------------

USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'Indices'
)
DROP DATABASE Indices
GO

CREATE DATABASE Indices
GO

use Indices;

-- Beispiel-Tabelle erstellen
create table Employees
(
	Id          int		not null identity,
	[Name]      nvarchar(50),
	Email       nvarchar(50),
	Department  nvarchar(50)
	constraint pk_employees primary key (Id)
)
go

-- Datensätze einfügen
set nocount on
declare @counter int = 1

while(@counter <= 1000000)
begin
	declare @Name nvarchar(50) = 'ABC ' + RTRIM(@counter)
	declare @Email nvarchar(50) = 'abc' + RTRIM(@counter) + '@hbu.ch'
	declare @Dept nvarchar(10) = 'Dept ' + RTRIM(@counter)

	insert into Employees values (@Name, @Email, @Dept)

	set @counter = @counter +1

	if(@Counter%100000 = 0)
		print rtrim(@Counter) + ' rows inserted'
end


--
-- Analyse
--

--
-- Clustered Index Struktur
--

-- EmployeeId ist der Primärschlüssel, daher wird standardmäßig ein Cluster-Index für 
-- die Spalte EmployeeId erstellt. 
-- Das bedeutet, dass die Mitarbeiterdaten nach der Spalte "EmployeeId" sortiert 
-- und physisch in einer Reihe von Datenseiten in einer baumartigen Struktur gespeichert sind.

--
-- Find a row by row ID
select * from Employees 
	where Id = 932000
go

-- Resultat:
-- Hier wird der clustered index für die Suche verwendet (index seek)
-- Number of rows read = 1
-- Actual number of rows for all executions = 1


-- Clustered Index Scan
-- Nun suchen wir über eine nicht indexierte Spalte
select * from Employees 
	where Name = 'ABC 932000'
go

-- Resultat:
-- Die Datenbank muss alle Zeilen lesen und folglich ineffizient.
-- Allgemein haben Index-Scan Operationen eine schlechte Performance.

-- Number of rows read = 1000000
-- Actual number of rows for all executions = 1


-- Non-Clustered Index

-- Im non clustered Index haben wir Schlüsselwerte und Row-Locators (z.B. Name und Id)
-- Die Daten im Index werden sortiert gespeichert.

-- Nun erstellen wir über die Spalte einen non clustered index
CREATE NONCLUSTERED INDEX IX_Employees_Name
	ON [dbo].[Employees] ([Name])
go

-- Nun suchen wir einen Angestellten über diesen Index.
select * from Employees 
	Where Name = 'ABC 932000'
go

-- Resultat:
-- Im Index wid der Name gesucht (Index Seek)
-- Da beim Namen auch der clustered key gespeichert ist kann nun 
-- zum clustered index gesprungen werden (Key Lookup) um den vollständigen Datensatz auszugeben.
-- Der Vergleich zur Ausführung (Estimated Subtree Cost) mit und ohne Index ist immens.



--
-- Heap Table
--


-- Tabellen ohne Cluster-Index werden Heap-Tabellen genannt.
-- Eine Heap-Tabelle kann einen oder mehrere nicht geclusterte Indizes haben, aber keinen geclusterten Index.
-- Bei Suchabfragen wird oft ein Table-Scan gemacht.

-- Tabelle erstellen
Create Table Gender
(
	GenderId int,
	GenderName nvarchar(20)
)
go

-- Datensätze einfügen
insert into Gender values(1, 'Male')
insert into Gender values(3, 'Not Specified')
insert into Gender values(2, 'Female')
go


-- Abfrage (Table-Scan)
select * from Gender where GenderName = 'Male'


-- Nun erstellen wir einen non clustered index
create nonclustered index IX_Gender_GenderName
	on Gender(GenderName)
go

-- Hier wird immer noch ein Table-Scan gemacht (schneller als index da nur 3 Zeilen)
select * from Gender where GenderName = 'Male'

-- Explicit Verwendung eines Indexes erwingen
select * from Gender with (Index(IX_Gender_GenderName))
	where GenderName = 'Male'
go

-- Fazit
-- Ein Heap kann als Staging-Tabelle für grosse und ungeordnete Einfügeoperationen verwendet werden. 
-- Da die Daten ohne Einhaltung einer strengen Reihenfolge eingefügt werden, ist der Einfügevorgang 
-- in der Regel schneller als der entsprechende Einfügevorgang in eine Tabelle mit geclustertem Index.
-- Die Tabelle ist klein und enthält nur wenige Zeilen.


--
-- Key lookup und RID lookup
--

-- Heap Tabelle erstellen
Create Table EmployeesHeap
(
	Id int identity,
	[Name] nvarchar(50),
	Email nvarchar(50),
	Department nvarchar(50)
)
Go

set nocount on

declare @counter int = 1

While(@counter <= 1000000)
Begin
	Declare @Name nvarchar(50) = 'ABC ' + RTRIM(@counter)
	Declare @Email nvarchar(50) = 'abc' + RTRIM(@counter) + '@pragimtech.com'
	Declare @Dept nvarchar(10) = 'Dept ' + RTRIM(@counter)

	Insert into EmployeesHeap values (@Name, @Email, @Dept)

	Set @counter = @counter +1

	If(@Counter%100000 = 0)
		Print RTRIM(@Counter) + ' rows inserted'
End
go

-- Tablescan
select * from EmployeesHeap 
	where Name = 'ABC 932000'
go

-- Index über Spalte Name erstellen
create nonclustered index IX_EmployeesHeap_Name on EmployeesHeap(Name)
go

-- Nun wird ein Index-Seek ausgeführt
-- über die RID Lookup Operation wird zum Datensatz gesprungen (es existiert ja kein clustered key)
select * from EmployeesHeap 
	where Name = 'ABC 932000'
go

-- Nun selektieren wir nur die Name-Spalte
-- jetzt wird ein Index-Seek ausgeführt, da im Index der name enthalten und somit keine weitere
-- Operation mehr nötig ist.
select name from EmployeesHeap 
	where Name = 'ABC 932000'
go


-- Key lookup

-- Clustered Index estellen
create clustered index IX_EmployeesHeap_Id on EmployeesHeap(Id)
go

-- Nun findet nach dem Index-Seek ein Key-Lookup statt
-- Da im index auch der clustered key abgespeichert ist, kann direkt zur Tabelle gesprungen werden.
select * from EmployeesHeap 
	where Name = 'ABC 932000'
go

-- Prüfung, was wird im Index gespeichert?
-- Selektieren wir nur Id mit Name können die Infos ausschliesslich aus 
-- dem Index gelesen werden (Index-Seek)
select Id, Name from EmployeesHeap 
	where Name = 'ABC 932000'
go
