|                             |                   |                               |
| --------------------------- | ----------------- | ----------------------------- |
| **Techniker HF Informatik** | **Datenbanken 2** | ![logo](../x_gitres/logo.png) |

# SQL Server Performance – Analyse & Optimierung

---

## Übersicht – Themenverteilung

Jede Gruppe erarbeitet einen spezifischen Themenbereich der SQL Server Performance-Analyse. Am Ende präsentiert jede Gruppe ihre Erkenntnisse der Klasse (ca. 15 Minuten Präsentation + 5 Minuten Diskussion).

| Gruppe | Thema                                  | Schwerpunkte                                                | Werkzeuge                |
| ------ | -------------------------------------- | ----------------------------------------------------------- | ------------------------ |
| 1      | Query-Analyse & Ausführungspläne       | Execution Plans, Statistiken, SARGability, Index Usage      | SSMS, SET STATISTICS     |
| 2      | Index-Management & Optimierung         | Fehlende Indizes, Fragmentierung, Covering Indexes, Wartung | DMVs, Index Advisor      |
| 3      | Warte-Statistiken & Bottleneck-Analyse | Wait Stats, Blocking, Deadlocks, Resource Monitor           | sys.dm_os_wait_stats, XE |
| 4      | Systemkonfiguration & Monitoring       | Memory, TempDB, I/O, Baselines, Automatisierung             | PerfMon, Query Store     |

### Gemeinsame Rahmenbedingungen

|                      |                                                                |
| -------------------- | -------------------------------------------------------------- |
| **Bearbeitungszeit** | ca. 90 Minuten (inkl. Vorbereitung der Präsentation)           |
| **Gruppengrösse**    | 3–5 Lernende                                                   |
| **Hilfsmittel**      | Eigene Notizen, Unterrichtsmaterial, Internet (keine KI-Tools) |
| **Abgabe**           | Kurzpräsentation (15 Min.) + 1–2 Seiten Dokumentation          |
| **Bewertung**        | Inhalt 40%, Präsentation 30%, Diskussionsfähigkeit 30%         |

> **Tipp:** Teilt die Aufgaben innerhalb der Gruppe auf – ein Teil recherchiert/experimentiert, ein Teil erstellt die Präsentation, ein Teil übt die Erklärung für die Klasse.

---

# Gruppe 1: Query-Analyse & Ausführungspläne
*Wie finde ich langsame Queries – und warum sind sie langsam?*

---

## Lernziele

- Du verstehst, wie SQL Server Ausführungspläne (Execution Plans) liest und interpretiert
- Du kannst teure Operatoren in einem Plan identifizieren (z.B. Table Scan, Key Lookup)
- Du kennst den Begriff SARGability und weisst, wann Indizes nicht genutzt werden
- Du kannst mit `SET STATISTICS IO/TIME` die Ressourcennutzung messen

---

## Theoretischer Hintergrund

### Was ist ein Ausführungsplan?

Der SQL Server Query Optimizer erstellt für jede Abfrage einen Ausführungsplan. Dieser zeigt, wie der Server die Daten physisch abruft – welche Indizes verwendet werden, wie Joins durchgeführt werden und welche Operatoren wie viele Ressourcen benötigen.

### Wichtige Operatoren

| Operator        | Bedeutung                                                                           |
| --------------- | ----------------------------------------------------------------------------------- |
| **Table Scan**  | Liest die gesamte Tabelle – fast immer ein Performance-Problem bei grossen Tabellen |
| **Index Scan**  | Liest den gesamten Index – besser als Table Scan, aber noch nicht optimal           |
| **Index Seek**  | Springt direkt zum gesuchten Eintrag – die effizienteste Operation                  |
| **Key Lookup**  | Nachlesen im Clustered Index – kann bei vielen Zeilen teuer werden                  |
| **Hash Join**   | Wird bei grossen, unsortieren Datenmengen verwendet – teuer in Memory               |
| **Nested Loop** | Effizient bei kleinen Datenmengen / gut indexierten Joins                           |
| **Sort**        | Explizite Sortierung – kann durch passende Indizes vermieden werden                 |

### SARGability

Eine Bedingung ist **SARGable** (Search ARGument Able), wenn SQL Server einen Index effizient nutzen kann. Nicht-SARGable Bedingungen erzwingen einen Table/Index Scan.

|                      | Beispiel                                                                         |
| -------------------- | -------------------------------------------------------------------------------- |
| ❌ **Nicht SARGable** | `WHERE YEAR(Bestelldatum) = 2024` → Funktion auf Spalte verhindert Index-Nutzung |
| ✅ **SARGable**       | `WHERE Bestelldatum >= '2024-01-01' AND Bestelldatum < '2025-01-01'`             |
| ❌ **Nicht SARGable** | `WHERE UPPER(Name) = 'MÜLLER'` → Funktion auf Spalte                             |
| ✅ **SARGable**       | `WHERE Name = 'Müller'` → direkte Wertvergleiche sind SARGable                   |

---

## Praktische Aufgaben

### Aufgabe 1 – Ausführungsplan lesen (20 Min.)

Öffnet SSMS und aktiviert **«Include Actual Execution Plan»** (`Ctrl+M`). Führt Abfragen auf der Beispieldatenbank aus und analysiert den Plan:

- Welche Operatoren erscheinen? Wieviel Prozent der Kosten entfallen auf welchen Schritt?
- Gibt es Table Scans? Was wäre die Ursache?
- Wo würde ein Index helfen? (Gelber Hinweis im Plan beachten!)

### Aufgabe 2 – SET STATISTICS IO/TIME (15 Min.)

Führt vor euren Abfragen folgendes aus:

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
```

- Notiert «logical reads» für verschiedene Abfragevarianten
- Vergleicht: mit und ohne WHERE-Klausel, mit Funktion vs. ohne
- Was bedeutet «logical reads» für die Performance?

### Aufgabe 3 – SARGability testen (15 Min.)

Schreibt je eine nicht-SARGable und eine SARGable Version einer Abfrage. Messt mit `STATISTICS IO` den Unterschied. Erklärt in eigenen Worten, warum der Unterschied entsteht.

---

## Lieferobjekte & Bewertung

| #   | Lieferobjekt                                                                 | Format     | Punkte       |
| --- | ---------------------------------------------------------------------------- | ---------- | ------------ |
| 1   | Annotierter Screenshot eines Ausführungsplans mit Erläuterung der Operatoren | Folie/Bild | 20 Pkt.      |
| 2   | STATISTICS IO-Vergleich: zwei Abfragevarianten mit Interpretation            | Folie/Text | 20 Pkt.      |
| 3   | SARGability-Beispiel: schlecht vs. gut mit Messergebnis                      | Folie/Code | 20 Pkt.      |
| 4   | Präsentation der Erkenntnisse (15 Min.) + Beantwortung von Fragen            | Live       | 40 Pkt.      |
|     | **Total**                                                                    |            | **100 Pkt.** |

## Weiterführende Ressourcen

- SQL Server Execution Plans – Brent Ozar (brentozar.com)
- MSDN: Logical and Physical Operators Reference
- SARGability – Use The Index, Luke (use-the-index-luke.com)

---

# Gruppe 2: Index-Management & Optimierung
*Richtige Indizes – der schnellste Weg zu besserer Performance*

---

## Lernziele

- Du verstehst den Unterschied zwischen Clustered Index, Non-Clustered Index und Covering Index
- Du kannst fehlende Indizes mit DMVs (Dynamic Management Views) identifizieren
- Du kennst das Problem der Index-Fragmentierung und weisst, wie man sie behebt
- Du kannst eine einfache Index-Wartungsstrategie erklären

---

## Theoretischer Hintergrund

### Index-Typen im Überblick

| Typ                     | Beschreibung                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Clustered Index**     | Bestimmt die physische Speicherreihenfolge der Tabelle. Pro Tabelle nur einer möglich. Meist auf PK.          |
| **Non-Clustered Index** | Separate Indexstruktur mit Zeigern zur Basistabelle. Mehrere pro Tabelle möglich.                             |
| **Covering Index**      | Non-Clustered Index, der alle für eine Abfrage benötigten Spalten enthält (`INCLUDE`). Kein Key Lookup nötig. |
| **Filtered Index**      | Index nur für eine Teilmenge der Daten (WHERE-Klausel). Kleiner, effizienter für spezifische Queries.         |
| **Columnstore Index**   | Spaltenorientierter Index – ideal für analytische Queries auf grossen Datenmengen (DWH).                      |

### Fehlende Indizes finden – DMVs

SQL Server protokolliert intern, welche Indizes bei Abfragen gefehlt hätten. Diese Informationen sind über DMVs abrufbar:

```sql
sys.dm_db_missing_index_details
sys.dm_db_missing_index_groups
sys.dm_db_missing_index_group_stats
```

> **Wichtig:** Diese Hinweise sind Empfehlungen, keine Befehle. Zu viele Indizes schaden der Write-Performance – jeder INSERT/UPDATE/DELETE muss alle Indizes pflegen.

### Index-Fragmentierung

Durch viele INSERT/UPDATE/DELETE-Operationen entstehen Lücken und Unordnung im Index. Über `sys.dm_db_index_physical_stats` lässt sich der Fragmentierungsgrad messen:

| Fragmentierung | Massnahme                  |
| -------------- | -------------------------- |
| 0–10 %         | Keine Massnahme nötig      |
| 10–30 %        | `ALTER INDEX … REORGANIZE` |
| > 30 %         | `ALTER INDEX … REBUILD`    |

---

## Praktische Aufgaben

### Aufgabe 1 – Fehlende Indizes identifizieren (20 Min.)

Führt mehrere Abfragen auf der Beispieldatenbank aus (ohne Index-Optimierung). Fragt danach die DMV für fehlende Indizes ab:

- Welche Indizes schlägt SQL Server vor?
- Was bedeuten die Spalten `avg_user_impact` und `user_seeks`?
- Bewertet: Sollte der Index tatsächlich erstellt werden? Begründung!

### Aufgabe 2 – Covering Index erstellen und messen (20 Min.)

Identifiziert eine Abfrage mit einem **Key Lookup** im Ausführungsplan. Erstellt einen Covering Index mit `INCLUDE`-Spalten und messt den Unterschied (`STATISTICS IO`, Ausführungsplan).

- Wie hat sich die Anzahl logical reads verändert?
- Ist der Key Lookup verschwunden?

### Aufgabe 3 – Fragmentierungsanalyse (10 Min.)

Prüft den Fragmentierungsgrad der Indizes in eurer Beispieldatenbank:

```sql
SELECT *
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
ORDER BY avg_fragmentation_in_percent DESC;
```

- Welche Indizes sind fragmentiert?
- Welche Massnahme wäre jeweils angemessen?

---

## Lieferobjekte & Bewertung

| #   | Lieferobjekt                                                               | Format     | Punkte       |
| --- | -------------------------------------------------------------------------- | ---------- | ------------ |
| 1   | Auswertung der DMV für fehlende Indizes: Top-3-Empfehlungen mit Begründung | Folie/Text | 20 Pkt.      |
| 2   | Vorher/Nachher-Vergleich: Abfrage mit und ohne Covering Index              | Folie/Code | 25 Pkt.      |
| 3   | Fragmentierungsanalyse: Screenshot + Massnahmenempfehlung                  | Folie/Bild | 15 Pkt.      |
| 4   | Präsentation der Erkenntnisse (15 Min.) + Beantwortung von Fragen          | Live       | 40 Pkt.      |
|     | **Total**                                                                  |            | **100 Pkt.** |

## Weiterführende Ressourcen

- Ola Hallengren – SQL Server Index and Statistics Maintenance (ola.hallengren.com)
- MSDN: sys.dm_db_missing_index_details
- Kimberly Tripp – Index Internals (sqlskills.com)

---

# Gruppe 3: Warte-Statistiken & Bottleneck-Analyse
*Wo wartet mein SQL Server – und warum?*

---

## Lernziele

- Du verstehst das Konzept der Wait Statistics als Diagnosewerkzeug
- Du kannst die wichtigsten Wait-Typen interpretieren und dem richtigen Engpass zuordnen
- Du weisst, wie Blocking und Deadlocks entstehen und wie man sie erkennt
- Du kannst Extended Events für die Deadlock-Aufzeichnung erklären

---

## Theoretischer Hintergrund

### Das Wait-Statistics-Modell

Wenn ein SQL Server-Thread auf eine Ressource warten muss, protokolliert der Server dies in den Wait Statistics. Die Gesamtheit dieser Warteinformationen gibt einen sehr guten Überblick darüber, wo der Server die meiste Zeit «verliert».

Die wichtigste DMV dafür: `sys.dm_os_wait_stats`

### Die wichtigsten Wait-Typen

| Wait-Typ                | Ursache                          | Mögliche Massnahme                     |
| ----------------------- | -------------------------------- | -------------------------------------- |
| `PAGEIOLATCH_SH/EX`     | Warten auf Disk-I/O              | Mehr RAM, SSD, I/O-Tuning              |
| `LCK_M_*`               | Lock-Blocking zwischen Sessions  | Transaktionen verkürzen, NOLOCK prüfen |
| `CXPACKET / CXCONSUMER` | Parallele Query-Verarbeitung     | MAXDOP anpassen, Queries prüfen        |
| `ASYNC_NETWORK_IO`      | Client verarbeitet Daten langsam | Ergebnismengen reduzieren              |
| `WRITELOG`              | Warten auf Log-Flush             | Schnelleres Disk-I/O für Log-Dateien   |
| `SOS_SCHEDULER_YIELD`   | CPU-Druck, zu viele Threads      | CPU-Ressourcen prüfen                  |
| `RESOURCE_SEMAPHORE`    | Wartet auf Memory für Query      | Memory-Grants, Indizes prüfen          |

### Blocking & Deadlocks

**Blocking:** Session A hält einen Lock, Session B wartet. Temporäres Problem – wenn A committed, kann B weitermachen.

**Deadlock:** Session A wartet auf B, Session B wartet auf A. SQL Server löst dies automatisch auf, indem er eine Session als «Deadlock Victim» beendet. Diese Session erhält Fehler 1205.

| Szenario            | Werkzeug / Abfrage                                                       |
| ------------------- | ------------------------------------------------------------------------ |
| Blocking erkennen   | `sys.dm_exec_requests` (blocking_session_id) / `sys.dm_os_waiting_tasks` |
| Deadlock erkennen   | System Health Extended Events / Trace Flag 1222                          |
| Blocking verhindern | Kurze Transaktionen, RCSI Isolation Level, Indizes auf Join-Spalten      |

---

## Praktische Aufgaben

### Aufgabe 1 – Wait Statistics analysieren (20 Min.)

Fragt die aktuellen Wait Statistics auf dem SQL Server ab und interpretiert die Top-10-Waits:

```sql
SELECT TOP 10
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    'SLEEP_TASK', 'BROKER_TO_FLUSH', 'BROKER_TASK_STOP',
    'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
    'HADR_WORK_QUEUE', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'XE_TIMER_EVENT'
) -- idle waits filtern
ORDER BY wait_time_ms DESC;
```

- Welche Wait-Typen sind dominant?
- Was sagen `signal_wait_time_ms` vs. `wait_time_ms` über den Ressourcentyp aus?

### Aufgabe 2 – Blocking simulieren (25 Min.)

Öffnet zwei SSMS-Fenster. In **Fenster 1:** `BEGIN TRAN` und `UPDATE` ohne `COMMIT`. In **Fenster 2:** `SELECT` auf dieselbe Tabelle.

- Was zeigt `sys.dm_exec_requests` in einer dritten Verbindung?
- Wie sieht `blocking_session_id` aus?
- Wie löst ihr das Blocking auf? (`ROLLBACK` / `COMMIT`)

### Aufgabe 3 – Deadlock analysieren (10 Min., theoretisch)

Analysiert ein mitgeliefertes Deadlock-XML aus dem System Health XE. Beantwortet:

- Welche zwei Sessions waren beteiligt?
- Auf welche Ressourcen haben sie gewartet?
- Welche Session wurde als Victim gewählt – und warum?

---

## Lieferobjekte & Bewertung

| #   | Lieferobjekt                                                              | Format     | Punkte       |
| --- | ------------------------------------------------------------------------- | ---------- | ------------ |
| 1   | Wait Statistics Auswertung: Top-5-Waits mit Interpretation und Massnahmen | Folie/Text | 20 Pkt.      |
| 2   | Blocking-Demo: Screenshots + Erklärung der sys.dm_exec_requests-Ausgabe   | Folie/Bild | 20 Pkt.      |
| 3   | Deadlock-Analyse: Erklärung des Szenarios und Lösungsansatz               | Folie/Text | 20 Pkt.      |
| 4   | Präsentation der Erkenntnisse (15 Min.) + Beantwortung von Fragen         | Live       | 40 Pkt.      |
|     | **Total**                                                                 |            | **100 Pkt.** |

## Weiterführende Ressourcen

- Brent Ozar – Wait Stats Library (brentozar.com/wait-stats)
- Paul Randal – SQL Server Deadlock Troubleshooting (sqlskills.com)
- MSDN: sys.dm_os_wait_stats

---

# Gruppe 4: Systemkonfiguration & Monitoring
*Den SQL Server kennen – Baselines messen und Probleme frühzeitig erkennen*

---

## Lernziele

- Du kennst die wichtigsten SQL Server-Konfigurationsparameter für Performance
- Du verstehst das Konzept einer Performance-Baseline und kannst eine einfache Baseline erstellen
- Du kannst Query Store für die historische Abfrageüberwachung einsetzen
- Du weisst, wie TempDB und Memory richtig konfiguriert werden

---

## Theoretischer Hintergrund

### Kritische Konfigurationsparameter

| Parameter                              | Beschreibung                                                                                                                        |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Max Server Memory**                  | Begrenzt den RAM-Verbrauch des SQL Servers. Ohne Limit kann Windows ausgehungert werden. Faustformel: Gesamt-RAM minus 4 GB für OS. |
| **Max Degree of Parallelism (MAXDOP)** | Maximale CPU-Cores für parallele Queries. Empfehlung: Anzahl physische Cores / 2, max. 8.                                           |
| **Cost Threshold for Parallelism**     | Ab welcher Kosteneinheit wird eine Query parallelisiert. Default 5 ist meist zu tief – empfohlen: 25–50.                            |
| **TempDB – Dateianzahl**               | TempDB sollte mehrere Datendateien haben (= Anzahl logischer CPU-Cores, max. 8), um Contention zu reduzieren.                       |
| **Instant File Initialization**        | Erlaubt schnelles Datenwachstum ohne Nullschreiben. Nur für Datendateien, nicht für Log.                                            |
| **Backup Compression**                 | Standardmässig aktivieren – reduziert Backup-Zeit und Speicherplatz deutlich.                                                       |

### Query Store

Der **Query Store** (ab SQL Server 2016) speichert historische Ausführungspläne und Laufzeitstatistiken direkt in der Datenbank. Er erlaubt:

- Erkennen von Plan-Regressionen (plötzlich schlechtere Pläne)
- Erzwingen eines bestimmten Ausführungsplans (Plan Forcing)
- Identifikation von Top-N-teuersten Queries historisch
  - Auswertbar über SSMS GUI oder `sys.query_store_*` DMVs

### Performance-Baseline

Eine Baseline ist eine Aufzeichnung des «Normalzustands». Nur wer weiss, wie der Server normalerweise läuft, kann erkennen, wann etwas nicht stimmt.

**Was gehört in eine Baseline?**
- CPU-, Memory-, I/O-Nutzung (`sys.dm_os_performance_counters`)
- Durchschnittliche Wait Statistics
- Top-Queries nach CPU/Dauer/Reads
- Datenbankgrössen und Wachstumsraten

---

## Praktische Aufgaben

### Aufgabe 1 – Konfigurationscheck (15 Min.)

Prüft die aktuelle Konfiguration des SQL Servers mit `sp_configure`:

```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure;
```

- Ist «max server memory» korrekt gesetzt?
- Wie ist MAXDOP konfiguriert? Ist das für diesen Server sinnvoll?
- Ist «cost threshold for parallelism» noch auf dem veralteten Default 5?

### Aufgabe 2 – Query Store aktivieren und auswerten (25 Min.)

Aktiviert den Query Store auf einer Testdatenbank und führt mehrere Abfragen aus:

```sql
ALTER DATABASE [TestDB]
SET QUERY_STORE = ON
WITH (OPERATION_MODE = READ_WRITE);
```

Wertet dann aus:

- Welche Queries verbrauchen am meisten CPU/Duration?
- Gibt es Queries mit mehreren verschiedenen Ausführungsplänen?
- Wie könnte man einen Plan «einfrieren»? (Plan Forcing)

### Aufgabe 3 – Einfache Baseline erstellen (20 Min.)

Erstellt eine «Punkt-in-Zeit»-Baseline mit folgenden Abfragen und dokumentiert die Ergebnisse:

```sql
-- Page Life Expectancy und Batch Requests/sec
SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name IN ('Page life expectancy', 'Batch Requests/sec');

-- Top-5 Wait Types
SELECT TOP 5 wait_type, wait_time_ms
FROM sys.dm_os_wait_stats
ORDER BY wait_time_ms DESC;

-- Top-5 Queries nach CPU
SELECT TOP 5 total_worker_time, execution_count,
    total_worker_time / execution_count AS avg_cpu,
    SUBSTRING(st.text, 1, 100) AS query_text
FROM sys.dm_exec_query_stats
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS st
ORDER BY total_worker_time DESC;
```

Diskutiert: Welche Werte wären «Alarm-Schwellwerte» für euren Server?

---

## Lieferobjekte & Bewertung

| #   | Lieferobjekt                                                          | Format        | Punkte       |
| --- | --------------------------------------------------------------------- | ------------- | ------------ |
| 1   | Konfigurationscheck: Ist-Zustand + Empfehlungen mit Begründung        | Folie/Tabelle | 20 Pkt.      |
| 2   | Query Store Auswertung: Top-3 teuerste Queries + Screenshots          | Folie/Bild    | 20 Pkt.      |
| 3   | Baseline-Snapshot: Dokumentierte Kennzahlen + Schwellwertempfehlungen | Folie/Text    | 20 Pkt.      |
| 4   | Präsentation der Erkenntnisse (15 Min.) + Beantwortung von Fragen     | Live          | 40 Pkt.      |
|     | **Total**                                                             |               | **100 Pkt.** |

## Weiterführende Ressourcen

- Glenn Berry – SQL Server Diagnostic Queries (sqlserverperformance.wordpress.com)
- Microsoft Docs – Query Store Best Practices
- SQL Server Configuration Checklist – brentozar.com
