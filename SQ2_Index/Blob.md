|                                 |                   |                               |
| ------------------------------- | ----------------- | ----------------------------- |
| **Informatik Techniker/-in HF** | **Datenbank Da2** | ![Logo](../x_gitres/logo.png) |

- [1. SQL Binary Large Object (BLOB)](#1-sql-binary-large-object-blob)
  - [1.1. Einführung](#11-einführung)
  - [1.2. Datentypen für BLOBs in SQL Server](#12-datentypen-für-blobs-in-sql-server)
  - [1.3. Speicherung von BLOBs mit VARBINARY(MAX)](#13-speicherung-von-blobs-mit-varbinarymax)
  - [1.4. Speicherung mit FILESTREAM](#14-speicherung-mit-filestream)
  - [1.5. Vor- und Nachteile](#15-vor--und-nachteile)
  - [1.6. Best Practices](#16-best-practices)
- [2. C#-Beispiel](#2-c-beispiel)
  - [2.1. Datei speichern (INSERT)](#21-datei-speichern-insert)
  - [2.2. Datei wieder auslesen (SELECT \& speichern auf Festplatte)](#22-datei-wieder-auslesen-select--speichern-auf-festplatte)
- [3. Aufgaben](#3-aufgaben)
  - [3.1. Aufgabe Blob Datenbank](#31-aufgabe-blob-datenbank)

---

# 1. SQL Binary Large Object (BLOB)

## 1.1. Einführung

**BLOB = Binary Large Object**
Darunter versteht man grosse binäre Daten, z.B.:

- Bilder (JPG, PNG, BMP)
- Dokumente (PDF, Word, Excel)
- Audio- und Videodateien
- beliebige Binärdateien

SQL Server bietet verschiedene Möglichkeiten, solche Daten in einer Datenbank zu speichern oder zu verwalten.

## 1.2. Datentypen für BLOBs in SQL Server

| **Datentyp**     | **Beschreibung**                                                                                                      | **Empfehlung**                                               |
| ---------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `VARBINARY(MAX)` | Speichert binäre Daten direkt in der Datenbank (bis 2 GB)                                                             | Standardlösung für kleine bis mittlere Dateien               |
| `IMAGE`          | Veraltet, wurde durch `VARBINARY(MAX)` ersetzt                                                                        | Nicht mehr verwenden                                         |
| `FILESTREAM`     | Speichert Dateien physisch im Dateisystem, verwaltet sie aber transaktional über SQL Server                           | Für sehr grosse Dateien (> 100 MB)                           |
| `FileTable`      | Erweiterung von FILESTREAM, Dateien können wie in einem normalen Ordner genutzt und parallel per SQL abgefragt werden | Für Szenarien, in denen Benutzer direkt mit Dateien arbeiten |

## 1.3. Speicherung von BLOBs mit VARBINARY(MAX)

**Tabelle anlegen:**

```sql
CREATE TABLE Dokumente (
    DokumentID INT IDENTITY PRIMARY KEY,
    Titel NVARCHAR(255) NOT NULL,
    Datei VARBINARY(MAX) NOT NULL
);
```

**Datei speichern (INSERT):**

```sql
INSERT INTO Dokumente (Titel, Datei)
SELECT 'Beispiel PDF',
       BulkColumn
FROM OPENROWSET(BULK 'C:\Temp\beispiel.pdf', SINGLE_BLOB) AS Datei;
```

> Die Datei beispiel.pdf wird direkt in der Datenbank gespeichert.

**Datei abrufen (SELECT):**

```sql
SELECT DokumentID, Titel, DATALENGTH(Datei) AS Dateigrösse_Bytes
FROM Dokumente;
```

> Damit lässt sich z. B. die Dateigrösse ermitteln.
> Die eigentlichen Binärdaten werden von Clientprogrammen (C#, SSMS, bcp, PowerShell) wieder zu einer Datei geschrieben.

<div class="page"/>

## 1.4. Speicherung mit FILESTREAM

**FILESTREAM** kombiniert die Vorteile von Datenbanken (Transaktionen, Sicherheit, Backup) mit der Effizienz des Dateisystems.

- Dateien werden im NTFS-Dateisystem abgelegt.
- In der Datenbank wird nur ein Zeiger gespeichert.
- Zugriff ist möglich über:
  - T-SQL (z. B. für Metadaten und Verwaltung)
  - Win32-Dateisystemzugriff (direkter Datei-Zugriff über Pfade)

> Wichtig: **FILESTREAM** aktivieren (über SQL Server Configuration Manager).

**Datenbank mit FILESTREAM erstellen:**

```sql
CREATE DATABASE BlobDB
ON PRIMARY
( NAME = BlobDB,
  FILENAME = 'C:\SQLData\BlobDB.mdf'),
FILEGROUP FG_Dokumente CONTAINS FILESTREAM
( NAME = BlobDB_FS,
  FILENAME = 'C:\SQLData\BlobDB')
LOG ON
( NAME = BlobDB_log,
  FILENAME = 'C:\SQLData\BlobDB.ldf');
```

**Tabelle anlegen mit FILESTREAM-Spalte:**

```sql
CREATE TABLE DokumenteFS (
    DokumentID UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
    Titel NVARCHAR(255),
    Datei VARBINARY(MAX) FILESTREAM NULL
);
```

<div class="page"/>

## 1.5. Vor- und Nachteile

**Vorteile:**

- Einheitliche Verwaltung von Daten (Metadaten + Dateien)
- Sicherheit und Backup über SQL Server
- Transaktionssicherheit auch für Dateien
- Abfragen auf Metadaten kombinierbar mit Inhalten

**Nachteile:**

- Datenbankgrösse wächst sehr schnell (bei VARBINARY(MAX))
- Performance leidet bei sehr grossen Dateien
- **FILESTREAM** erfordert spezielle Konfiguration

## 1.6. Best Practices

- Kleine bis mittlere Dateien (z. B. Profilbilder, kleine PDFs) →**VARBINARY(MAX)**
- Grosse Dateien (> 100 MB, Videos, Archive) → **FILESTREAM**
- Szenarien, bei denen Benutzer mit Dateien wie in einem Ordner arbeiten → **FileTable**

<div class="page"/>

# 2. C#-Beispiel

**Voraussetzung:**
Die Datenbank (z.B. BlobDB) und die Tabelle (Dokumente)  muss vorgängig mit SQL erstellt sein.

```sql
CREATE TABLE Dokumente (
    DokumentID INT IDENTITY PRIMARY KEY,
    Titel NVARCHAR(255) NOT NULL,
    Datei VARBINARY(MAX) NOT NULL
);
```

## 2.1. Datei speichern (INSERT)

```c#
using Microsoft.Data.SqlClient;

class BlobBeispiel
{
    static void Main()
    {
        string connectionString = "Server=localhost;Database=BlobDB;Trusted_Connection=True;TrustServerCertificate=true";
        string filePath = @"C:\Temp\beispiel.pdf";
        string titel = "Beispiel PDF";

        byte[] fileData = File.ReadAllBytes(filePath);

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string sql = "INSERT INTO Dokumente (Titel, Datei) VALUES (@Titel, @Datei)";
            
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Titel", titel);
                cmd.Parameters.AddWithValue("@Datei", fileData);
                cmd.ExecuteNonQuery();
            }
        }

        Console.WriteLine("Datei erfolgreich gespeichert!");
    }
}
```

## 2.2. Datei wieder auslesen (SELECT & speichern auf Festplatte)

```c#
using Microsoft.Data.SqlClient;

class BlobLesen
{
    static void Main()
    {
        string connectionString = "Server=localhost;Database=BlobDB;Trusted_Connection=True;TrustServerCertificate=true";
        string outputPath = @"C:\Temp\ausgabe.pdf";

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string sql = "SELECT Datei FROM Dokumente WHERE DokumentID = @ID";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@ID", 1); // Beispiel: erste Datei
                byte[] fileData = (byte[])cmd.ExecuteScalar();

                File.WriteAllBytes(outputPath, fileData);
            }
        }

        Console.WriteLine("Datei erfolgreich exportiert nach: " + outputPath);
    }
}
```

<div class="page"/>

# 3. Aufgaben

## 3.1. Aufgabe Blob Datenbank

| **Vorgabe**         | **Beschreibung**                                         |
| :------------------ | :------------------------------------------------------- |
| **Lernziele**       | Können BLOB Möglichkeiten in einer DB erläutern          |
|                     | Kann eine Tabelle mit BLOB Attributen erstellen          |
|                     | Kann Daten in ein BLOB Attribut einfügen und exportieren |
| **Sozialform**      | Einzelarbeit                                             |
| **Auftrag**         | siehe unten                                              |
| **Hilfsmittel**     |                                                          |
| **Zeitbedarf**      | 40min                                                    |
| **Lösungselemente** | Funktionierendes Programm                                |

1. Erstelle eine neue SQL-Datenbanken (z.B. BlobDB) mit einer Tabelle (z.B. Dokumente)
2. Füge per SQL-Befehl (`INSERT INTO`) ein belliebiges PDF-Dokument in die Datenbank ein.
3. Prüfe ob das Dokument in der DB gespeichert wurde (`select ...`)
4. Erstelle mit Visual Studio eine C#-Konsolen Applikation (z.B. Name=`BlobApp`)
5. Füge dem Konsolen-Projekt das erforderliche NuGet Paket hinzu. (Install NuGet package: `Microsoft.Data.SqlClient`)
6. Schreibe eine Methoden, die ein Dokument in die Datenbank einfügt.
7. Schreibe eine Methode, die ein Dokument aus der Datenbank exportiert.

---

© 2026 Lukas Müller – Licensed under CC BY-NC-ND 4.0
See [LICENSE](..\license.md) file for details.
