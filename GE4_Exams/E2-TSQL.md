|                             |                     |                                 |
| --------------------------- | ------------------- | ------------------------------- |
| **Techniker HF Informatik** | **Datenbanken Da2** | ![logo](./../x_gitres/logo.png) |

- [1. Arbeitsauftrag "TSQL-Prozedurale Elemente"](#1-arbeitsauftrag-tsql-prozedurale-elemente)
  - [1.1. Organisation und Zielsetzung](#11-organisation-und-zielsetzung)
  - [1.2. Allgemeines](#12-allgemeines)
  - [1.3. Auftrag](#13-auftrag)
  - [1.4. Gruppe 1: T-SQL Variablen, Ablaufsteuerung und Cursors](#14-gruppe-1-t-sql-variablen-ablaufsteuerung-und-cursors)
    - [1.4.1. Thema](#141-thema)
    - [1.4.2. Auftrag](#142-auftrag)
  - [1.5. Gruppe 2: TSQL-Stored Procedures und Funktionen](#15-gruppe-2-tsql-stored-procedures-und-funktionen)
    - [1.5.1. Thema](#151-thema)
    - [1.5.2. Auftrag](#152-auftrag)
  - [1.6. Gruppe 3: TSQL - Trigger](#16-gruppe-3-tsql---trigger)
    - [1.6.1. Thema](#161-thema)
    - [1.6.2. Auftrag](#162-auftrag)
  - [1.7. Bewertungen](#17-bewertungen)
  - [1.8. Termine](#18-termine)

</br>

# 1. Arbeitsauftrag "TSQL-Prozedurale Elemente"

## 1.1. Organisation und Zielsetzung

|                         |                                                                                                                          |
| :---------------------- | :----------------------------------------------------------------------------------------------------------------------- |
| **Lernziele**           | Die Studierenden sollen die verschiedenen prozeduralen Elemente von T-SQL in Microsoft SQL Server verstehen und anwenden |
| **Sozialform**          | Teamarbeit mit max. Grösse von 3 Personen                                                                                |
| **Auftrag**             | siehe unten                                                                                                              |
| **Hilfsmittel**         | Skript                                                                                                                   |
| **Erwartete Resultate** | - Jede Gruppe muss eine Präsentation erstellen, die die Konzepte erklärt, die in ihrer Arbeit behandelt werden.          |
|                         | - Jede Gruppe muss ein SQL-Skript entwickeln, das die jeweiligen Anforderungen umsetzt                                   |
| **Zeitbedarf**          | ca. 2h pro Teammitglied, 15-20 min (Präsentation)                                                                        |
| **Lösungselemente**     | Eine Präsentation (Powerpoint oder Markdown) muss die Lösung der Gruppe                                                  |
|                         | vorstellen und die wichtigsten Schritte und Herausforderungen erläutern                                                  |

## 1.2. Allgemeines

- Sie setzen sich in die **Dozenten-/innen Rolle** und vermitteln der Klasse das zugeteilte Thema möglichst anschaulich, interessant und verständlich (**Flipped Classroom**).
- Nutzen Sie dabei die Ihnen bekannten **Präsentationstechniken**.
- Bestimmen Sie für die Arbeitszuteilungen, Koordination und Zusammenführung der Teilresultate einen Gruppenchef/-inn.

## 1.3. Auftrag

- Recherchieren Sie alle wichtigen Informationen über das Ihnen zugeteilte Themengebiet und fassen Sie diese mittels konkreten Code Beispielen zusammen.
- Stellen Sie Ihre Ergebnisse mittels einer Kurzpräsentation der Klasse vor.
- Verwenden Sie dabei die Hilfsmittel wie Flow-Charts, Beamer, Wandtafel usw. und verweisen Sie ggf. auf weitere die Literatur.
- Geben Sie der Klasse Ihre Lernziele bekannt.
- Überlegen Sie wie die Klasse für das Thema motiviert werden kann.
- Stellen Sie sicher, dass die Klasse Ihr Thema verstanden hat (Quiz, kleine Aufgaben usw.)
- Die Zusammenfassungen und Beispiel sind dann den anderen Klassenkameraden zur Verfügung

> **Bemerkung: Erstellen Sie die Beispiele, wenn möglich in der Schulverwaltungsdatenbank.**

---

</br>

## 1.4. Gruppe 1: T-SQL Variablen, Ablaufsteuerung und Cursors

### 1.4.1. Thema

- Erstellen Sie ein SQL-Skript, das mit T-SQL Variablen, Ablaufsteuerung (wie `IF, WHILE, BEGIN...END`) und Cursors arbeitet, um eine komplexe Logik zu implementieren.

### 1.4.2. Auftrag

- Erklären Sie, was T-SQL Variablen sind und wie sie im SQL-Server verwendet werden.
- Erstellen Sie eine `WHILE`-Schleife, die alle Datensätze aus einer Tabelle liest und für jeden Datensatz eine Berechnung vornimmt.
- Implementieren Sie einen `CURSOR`, der durch die Datensätze einer Tabelle iteriert und für jeden Datensatz eine Logik anwendet.
- Verwenden Sie eine Bedingung (`IF`), um bestimmte Datensätze zu filtern und nur für diese die Berechnungen durchzuführen.
- Erstellen Sie ein Beispiel, das mit Variablen, einer Schleife und einem Cursor Daten bearbeitet (z.B. Berechnung eines Umsatzes für alle Bestellungen in einer Tabelle Bestellungen).
- Erklären Sie, wie Laufzeitfehler in einer Fehlerbehandlung (Exception Handling) abgefangen und ausgwertet (Fehlernummer, Fehlermeldung usw.) werden.

---

</br>

## 1.5. Gruppe 2: TSQL-Stored Procedures und Funktionen

### 1.5.1. Thema

- Erstellen Sie eine **Stored Procedure**, die Ein- und Ausgabewerte verwendet, und implementieren Sie eine Funktion, die eine Berechnung vornimmt.

### 1.5.2. Auftrag

- Erklären Sie, was **Stored Procedures** sind und wie sie verwendet werden.
- Erstellen Sie eine **Stored Procedure**, die Eingabeparameter empfängt (z.B. BestellID, Menge) und eine Ausgabe zurückgibt (z.B. berechneter Rabatt).
- Erstellen Sie eine **Funktion**, die eine Berechnung vornimmt (z.B. Berechnung des Gesamtpreises nach Rabatt).
- Erklären Sie den Unterschied zwischen einer **Stored Procedure** und einer **Funktion** in SQL-Server.
- Demonstrieren Sie, wie Sie Funktionen und **Stored Procedures** zusammen verwenden können, um eine komplexe Logik zu implementieren (z.B. Berechnung des Gesamtumsatzes für einen bestimmten Zeitraum).

---

</br>

## 1.6. Gruppe 3: TSQL - Trigger

### 1.6.1. Thema

- Erstellen Sie einen **Trigger**, der automatisch auf Datenänderungen reagiert und eine Aktion ausführt (z.B. Protokollierung von Änderungen oder automatische Aktualisierung).

### 1.6.2. Auftrag

- Erklären Sie, was **Trigger** sind und wie sie in SQL-Server verwendet werden.
- Erstellen Sie einen `AFTER INSERT` **Trigger**, der bei jeder Einfügung in die Tabelle Bestellungen automatisch den Lagerbestand in der Tabelle Artikel aktualisiert.
- Erstellen Sie einen `AFTER UPDATE` **Trigger**, der automatisch Änderungen an den Preisen in der Tabelle Produkte protokolliert (z.B. in einer Preisänderungsprotokoll-Tabelle).
- Beschreiben Sie, wie **Trigger** dazu verwendet werden können, die Datenintegrität zu gewährleisten.
- Stellen Sie sicher, dass der **Trigger** fehlerfrei funktioniert, auch wenn die Daten ungültig sind (z.B. durch Validierung vor der Ausführung).

---

</br>

## 1.7. Bewertungen

| **Kriterium**                                                                 | **Punkte** |
| ----------------------------------------------------------------------------- | :--------: |
| **Präsentation**                                                              |            |
| Systematischer Aufbau der Präsentation                                        |     2      |
| - Einstieg mit Überblick                                                      |            |
| - Medienvielfalt                                                              |            |
| - roter Faden                                                                 |            |
| - Abschluss und Fazit                                                         |            |
| Wesentliche Aspekte, Schwerpunkte und Konzepte der Lösung vorgetragen         |     2      |
| Verhältnis zwischen Text und Grafik ist ausgewogen                            |     2      |
| Gestaltung und Lesbarkeit der Folien                                          |     2      |
| Fehlerfrei Demo                                                               |     2      |
| Zeitvorgabe eingehalten                                                       |     2      |
| Fazit und Reflexion zur Zielerreichung                                        |     2      |
| Fragen werden fachlich richtig beantwortet                                    |     2      |
|                                                                               |            |
| **Projekt / Arbeit**                                                          |            |
| Themengebiet vollständig mit praktischen Beispielen umgesetzt                 |     2      |
| Richtigkeit und Vollständigkeit der SQL-Skripte                               |     2      |
| Dokumentation und Erklärung der verwendeten T-SQL-Konzepte in Code Beispielen |     2      |
| Komplexität und Innovation der Lösung                                         |     2      |
|                                                                               |            |
| **Total**                                                                     |   **24**   |

> **Notenskala: Erreichte Punktzahl x 5 / Max. Punktzahl + 1 = Note (auf 1/10 Noten gerundet)**

## 1.8. Termine

Termin für Projektabgabe: **10.06.2026, 23:59 Uhr, OpenOLAT (Ordner Studierende)**

---

© 2026 Lukas Müller – Licensed under CC BY-NC-ND 4.0
See [LICENSE](..\license.md) file for details.
