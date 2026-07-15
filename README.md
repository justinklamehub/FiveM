# Cops’N’Robbers RP

> Fortlaufende Planungsdokumentation für einen eigenständigen FiveM-Rollenspielserver, der ziviles Rollenspiel, eine spielergesteuerte Wirtschaft, Polizeiarbeit und organisierte Kriminalität verbindet.

## Projektstatus

Das Projekt befindet sich aktuell in der Planungsphase. Die eigentliche Programmierung erfolgt nach Abstimmung der Konzepte und Abhängigkeiten in separaten Projektchats.

Letzte Aktualisierung: 16.07.2026

## Sprach- und Entwicklungsvorgaben

- Planung, Erklärungen und sichtbare Dokumentation werden auf Deutsch verfasst.
- Ressourcen, Code, Datenbankobjekte, Events und technische Kommentare werden auf Englisch benannt.
- Alle Ressourcen erhalten dieselbe Struktur und denselben Dokumentationsstandard.
- Alle NUI-Oberflächen verwenden ein gemeinsames Designsystem.
- Preise, Vergütungen, Kapazitäten, Cooldowns und vergleichbare Spielwerte sind dynamisch konfigurierbar.
- Das Projekt ist vollständig Standalone und verwendet weder ESX noch QBCore als Roleplay-Framework.
- Bewährte technische Infrastruktur darf verwendet werden, wenn eine Eigenentwicklung unnötige Risiken erzeugen würde, beispielsweise beim Datenbanktreiber.

---

# 1. Servervision

**Cops’N’Robbers RP** verbindet drei gleichwertige Bereiche:

1. ziviles Rollenspiel;
2. eine spielergesteuerte Wirtschaft;
3. organisierte Kriminalität und ermittelnde Polizeiarbeit.

Der Server soll weder ein reiner Wirtschaftssimulator noch ein einfacher Gangwar- oder Polizeiserver sein. Entscheidungen eines Charakters sollen Auswirkungen auf andere Spieler, Unternehmen und die Serverwirtschaft haben.

## 1.1 Design-Säulen

### Zusammenhängende Wirtschaft

Nahezu jede Ware soll einen nachvollziehbaren Ursprung besitzen und mehrere Stationen durchlaufen.

Beispiele:

- Rohöl → Raffinerie → Kraftstoff → Tankstellen und Fahrzeuge
- Holz → Sägewerk → Möbel und Baumaterial
- Erz → Schmelzerei → Metall und Fahrzeugteile
- Landwirtschaft → Lebensmittelproduktion → Geschäfte und Restaurants
- Chemikalien → Medikamente oder illegale Substanzen
- Recycling → wiederverwendbare Rohstoffe
- Fahrzeugteile → Werkstätten und Fahrzeugproduktion

Spieler können sich auf einzelne Stationen spezialisieren. Niemand muss eine vollständige Lieferkette allein betreiben. Eine begrenzte und teure NPC-Notversorgung verhindert, dass wichtige Serverfunktionen vollständig stillstehen.

### Unterschiedliche Karrierewege

Legale Möglichkeiten:

- Arbeitnehmer
- Fahrer und Logistiker
- Rohstoffproduzent
- Handwerker
- Mechaniker
- Händler
- Unternehmer
- Immobilienbesitzer
- Polizei, Feuerwehr oder Rettungsdienst

Graue Möglichkeiten:

- Schwarzarbeit
- Handel ohne Lizenz
- Steuerhinterziehung
- Ankauf gestohlener Waren
- Verkauf von Informationen
- illegale Fahrzeugmodifikationen
- verdächtige Transportaufträge

Illegale Möglichkeiten:

- Einbruch
- Fahrzeugdiebstahl
- Raubüberfälle
- Schmuggel
- Geldwäsche
- Drogenproduktion
- Waffenhandel
- organisierte Kriminalität

Ein Charakter wird nicht dauerhaft auf einen Weg festgelegt. Ein legales Unternehmen kann heimlich Geld waschen, während ein ehemaliger Krimineller später ein legales Geschäft aufbaut.

### Vorbereitete Kriminalität

Größere Straftaten bestehen nicht nur aus dem Betreten eines Markers und dem Drücken einer Taste. Mögliche Vorbereitungen:

- Informationen sammeln
- Zugangskarten oder Codes beschaffen
- Werkzeuge kaufen oder herstellen
- Fahrzeuge und Lager organisieren
- Sicherheitsanlagen manipulieren
- Beute transportieren und verkaufen
- Geld waschen
- Spuren vermeiden oder beseitigen

Mögliche Vorgehensweisen sind Schleichen, Hacking, Insiderhilfe, Täuschung, Sabotage oder bewaffnete Gewalt. Jede Variante besitzt andere Kosten, Risiken, Beweise und Belohnungen.

### Ermittlungsorientierte Polizei

Polizeiarbeit umfasst:

- Notrufe und Leitstelle
- Verkehrskontrollen
- Fahndungen
- Zeugenaussagen
- Tatortarbeit
- Beweisaufnahme
- Observation
- Ermittlungsakten
- Durchsuchungsbeschlüsse
- Festnahmen
- Beschlagnahmungen
- Personen- und Fahrzeugabfragen

Die Polizei erhält verwertbare Hinweise, aber nicht automatisch die Identität eines Täters.

### Langfristiger Fortschritt

Fortschritt entsteht nicht nur durch Geld, sondern auch durch:

- Fähigkeiten und Spezialisierungen
- Lizenzen
- Ruf
- Geschäftskontakte
- Unternehmen
- Immobilien
- Fahrzeuge
- Produktionsanlagen
- Zugang zu besonderen Aufträgen
- legale und illegale Beziehungen

## 1.2 Realismusgrad

Der empfohlene Realismusgrad ist **mittel**:

- Fahrzeuge benötigen Kraftstoff und Wartung.
- Unternehmen benötigen Waren.
- Lizenzen haben eine echte Bedeutung.
- Straftaten hinterlassen Beweise.
- Verletzungen und Haft haben Konsequenzen.
- Transport, Lagerung und Produktion spielen eine Rolle.
- Wartezeiten und Bürokratie bleiben spielbar und werden nicht übertrieben.

Realismus soll das Rollenspiel fördern und nicht zur lästigen Pflicht werden.

## 1.3 Charaktermodell

- Standardmäßig drei Charakterplätze pro Account
- vollständig getrennte Finanzen, Inventare, Fahrzeuge und Immobilien
- getrennte Fähigkeiten, Lizenzen, Rufwerte und Vorstrafen
- keine direkte Übertragung zwischen eigenen Charakteren
- permanenter Charaktertod nur freiwillig oder genehmigt
- normaler Tod führt zu medizinischen Konsequenzen

## 1.4 Einstieg eines neuen Spielers

1. Ladebildschirm
2. Account- und Zugangsprüfung
3. Regelbestätigung
4. Charakterauswahl oder Charaktererstellung
5. interaktives Tutorial
6. Registrierung bei der Stadtverwaltung
7. grundlegende Dokumente und Bankkonto
8. erster Einführungsauftrag

Empfohlene Startausstattung:

- Personalausweis
- Mobiltelefon
- einfache Kleidung
- kleiner Bargeldbetrag
- persönliches Bankkonto
- temporäre Unterkunft
- Nahverkehrs- oder Mietguthaben

Ein dauerhaftes Fahrzeug wird bei der Charaktererstellung nicht verschenkt.

## 1.5 Cops-&-Robbers-Balance

| Kategorie | Beispiele | Empfohlene Polizei-Anforderung |
|---|---|---:|
| Klein | Diebstahl, Einbruch, kleiner Ladenraub | 0–1 |
| Mittel | Tankstelle, Lager, Geldautomat | 2–3 |
| Groß | Bank, Geldtransport, Raffinerie | 4–6 |
| Spezial | Zentralbank, Gefängnisausbruch, Großtransport | dynamisch |

Die genauen Werte werden dynamisch gepflegt. Wahlloses Töten und permanenter Gangwar gehören nicht zur Servervision.

---

# 2. Entwicklungsroadmap

## Phase 0 – Projektdefinition

- [ ] finaler Servername und Branding
- [x] grundlegende Servervision
- [x] empfohlener Realismusgrad
- [x] Entscheidung für Standalone
- [ ] Regelwerk
- [ ] UI-Designsystem
- [ ] verbindliche Entwicklungsrichtlinien
- [ ] genaue Abgrenzung von MVP, Alpha, Beta und Release

## Phase 1 – Technische Grundlage

- [ ] Core-Ressource
- [ ] Datenbankanbindung und Migrationen
- [ ] Modul-, Event- und Callback-System
- [ ] Konfigurationsverwaltung
- [ ] Übersetzungssystem
- [ ] Berechtigungs- und Rollensystem
- [ ] Audit- und Sicherheitslogs
- [ ] zentrale UI-Basis
- [ ] Fehlerbehandlung und Modulstatus

## Phase 2 – Ladebildschirm und Zugang

- [ ] thematischer Ladebildschirm
- [ ] dynamische Neuigkeiten und Changelog
- [ ] Accounterkennung
- [ ] Registrierung
- [ ] Whitelist-Modi
- [ ] Warteschlange und Prioritäten
- [ ] Bann- und Einschränkungssystem

## Phase 3 – Charaktere

- [ ] Charakterplätze
- [ ] Identität und Dokumente
- [ ] Aussehen
- [ ] Charakterauswahl
- [ ] prioritätsbasierter Spawn
- [ ] Tutorial
- [ ] sicherer Charakterwechsel
- [ ] Archivierung und Löschprozess

## Phase 4 – Grundlegendes Gameplay

- [ ] Items und Inventar
- [ ] Bargeld und Banking
- [ ] Fähigkeiten und Lizenzen
- [ ] Fahrzeuge und Vermietung
- [ ] Garagen
- [ ] Interaktions- und Zonensystem

## Phase 5 – Wirtschaft

- [ ] Unternehmen und Mitarbeiter
- [ ] Verträge und Rechnungen
- [ ] Lager
- [ ] Logistik
- [ ] Ölförderung
- [ ] Raffinerieverarbeitung
- [ ] Tankstellenversorgung
- [ ] dynamische Preise und NPC-Notversorgung

## Phase 6 – Cops & Robbers

- [ ] kleiner Ladenraub
- [ ] Fahrzeugdiebstahl
- [ ] Dispatch
- [ ] Polizei-MDT
- [ ] Beweissystem
- [ ] Personen- und Fahrzeugfahndungen
- [ ] Geldwäsche
- [ ] Gefängnis
- [ ] große Überfälle

## Phase 7 – Erweiterungen

- [ ] Häuser und Immobilien
- [ ] Feuerwehr und Rettungsdienst
- [ ] Justizsystem
- [ ] weitere Industriezweige
- [ ] Smartphone
- [ ] dynamische Ereignisse und Saisons
- [ ] externes Control Panel

---

# 3. Core- und Modularchitektur

Der Core stellt nur gemeinsame technische Dienste bereit. Geld, Fahrzeuge, Inventare, Jobs und andere Fachbereiche bleiben eigenständige Module.

## 3.1 Architektur-Ebenen

### Ebene 1 – Technische Basis

- `cnr_core`
- `cnr_database`
- `cnr_logs`
- `cnr_locales`
- `cnr_config`
- `cnr_ui`

### Ebene 2 – Account und Charakter

- `cnr_accounts`
- `cnr_sessions`
- `cnr_characters`
- `cnr_identity`
- `cnr_permissions`
- `cnr_whitelist`

### Ebene 3 – Grundlegende Spielsysteme

- `cnr_items`
- `cnr_inventory`
- `cnr_banking`
- `cnr_progression`
- `cnr_licenses`
- `cnr_interactions`
- `cnr_zones`

### Ebene 4 – Eigentum und Wirtschaft

- `cnr_vehicles`
- `cnr_garages`
- `cnr_properties`
- `cnr_storage`
- `cnr_businesses`
- `cnr_contracts`
- `cnr_fuel`

### Ebene 5 – Gameplay

- `cnr_jobs`
- `cnr_logistics`
- `cnr_industry`
- `cnr_crime`
- `cnr_police`
- `cnr_dispatch`
- `cnr_evidence`
- `cnr_medical`

### Ebene 6 – Administration

- `cnr_admin`
- `cnr_world_editor`
- `cnr_controlpanel_api`
- `cnr_analytics`

Niedrige Ebenen dürfen nicht von späteren Gameplay-Ebenen abhängig werden.

## 3.2 Verantwortlichkeiten

### `cnr_core`

- registrierte Module
- Spieler-Verbindungen
- gemeinsame Callbacks
- standardisierte Antworten
- Rate-Limits
- gemeinsame Konstanten
- Modulstatus
- zentrale Fehlercodes
- Wartungsstatus

Nicht im Core gespeichert werden Geld, Inventar, Fahrzeuge, Jobs, Immobilien oder Level.

### `cnr_database`

- einheitlicher Datenbankadapter
- Transaktionen
- Migrationen
- Fehlerbehandlung
- Erkennung langsamer Abfragen
- Datenbankstatus

### `cnr_config`

Statische Konfiguration enthält technische Abhängigkeiten, Sicherheitsgrenzen und unveränderliche Konstanten. Dynamische Konfiguration enthält Preise, Vergütungen, Positionen, Kapazitäten, Rezepte, Steuern, Erfahrungspunkte, Cooldowns und Polizei-Anforderungen.

### `cnr_logs`

Geplante Kategorien:

- `authentication`
- `character`
- `money`
- `inventory`
- `vehicle`
- `property`
- `business`
- `job`
- `crime`
- `police`
- `admin`
- `security`
- `system`

Discord-Logs sind nur eine zusätzliche Anzeige und ersetzen keine strukturierten Audit-Daten.

## 3.3 Einheitliche Ressourcenstruktur

```text
cnr_module_name/
├── fxmanifest.lua
├── README.md
├── config/
│   ├── shared.lua
│   ├── client.lua
│   └── server.lua
├── shared/
│   ├── constants.lua
│   ├── types.lua
│   └── functions.lua
├── client/
│   ├── main.lua
│   ├── events.lua
│   └── modules/
├── server/
│   ├── main.lua
│   ├── events.lua
│   ├── services/
│   └── repositories/
├── locales/
│   ├── de.lua
│   └── en.lua
├── migrations/
└── tests/
```

Jede Datei erhält einen englischen Kopfkommentar mit Zweck, Verantwortlichkeit, Abhängigkeiten und sicherheitsrelevanten Hinweisen.

## 3.4 Kommunikation zwischen Modulen

- Server-Exports für direkte interne Serviceanfragen
- Serverevents für abgeschlossene Domain-Ereignisse
- Clientevents ausschließlich für UI und Darstellung
- keine direkten Schreibzugriffe auf Tabellen fremder Module
- keine Entscheidung über Geld, Besitz oder Belohnungen durch den Client

Standardablauf:

1. Client fordert eine Aktion an.
2. Server prüft Session und Charakter.
3. Server prüft Position, Berechtigung und Voraussetzungen.
4. zuständiger Service führt die Aktion aus.
5. Datenbanktransaktion speichert das Ergebnis.
6. Audit-Log wird geschrieben.
7. betroffene Clients erhalten das Ergebnis.

## 3.5 Namenskonventionen

- Ressource: `cnr_banking`
- Serverevent: `cnr_banking:server:transferMoney`
- Clientevent: `cnr_banking:client:openAccount`
- Tabelle: `cnr_bank_transactions`
- Spalten: `character_id`, `created_at`, `is_active`
- Fehlercodes: `INSUFFICIENT_FUNDS`, `PERMISSION_DENIED`

## 3.6 Modulstatus

- `starting`
- `ready`
- `degraded`
- `unavailable`
- `stopping`

Module müssen kontrolliert ausfallen. Wenn Banking nicht erreichbar ist, werden Käufe blockiert, aber vorhandene Fahrzeuge bleiben nutzbar.

---

# 4. Account-, Login- und Charakterkonzept

## 4.1 Trennung

| Ebene | Bedeutung |
|---|---|
| Account | technischer Serverzugang und serverweite Maßnahmen |
| Charakter | Rollenspielidentität und Besitz |
| Session | aktuelle Verbindung und ausgewählter Charakter |

## 4.2 Loginmodell

- FiveM-/Rockstar-Authentifizierung als primäre technische Identität
- kein klassisches Benutzername-Passwort-System als primärer Ingame-Login
- optionaler Sicherheits-PIN
- IP-Adresse nur als Sicherheitssignal
- keine doppelten aktiven Sessions
- isolierter Ladezustand bis alle Pflichtdaten bereitstehen

## 4.3 Verbindungsablauf

1. Wartungsstatus
2. Identifier-Prüfung
3. Bann- und Einschränkungsprüfung
4. Accountsuche oder Registrierung
5. Whitelistprüfung
6. Prüfung auf doppelte Session
7. Warteschlange und Priorität
8. Sessionerstellung
9. Charakterauswahl
10. Laden der Pflichtmodule
11. Spawnentscheidung
12. Freigabe für die Spielwelt

## 4.4 Accountstatus

- `PENDING_REGISTRATION`
- `PENDING_WHITELIST`
- `ACTIVE`
- `SUSPENDED`
- `BANNED`
- `RESTRICTED`
- `ARCHIVED`

## 4.5 Whitelist-Modi

- offen
- automatisch
- manuell
- hybrid mit eingeschränktem Einstieg

Für den späteren Produktivbetrieb wird der Hybrid-Modus empfohlen: Neue Spieler können den Server kennenlernen, sensible Berufe, große Unternehmen und schwere Kriminalität benötigen weitere Freigaben oder Fortschritt.

## 4.6 Charaktererstellung

1. Grundidentität
2. Aussehen
3. unverbindliches Startprofil
4. Vorschau und Bestätigung

Namens- und Altersregeln sind dynamisch konfigurierbar. Realistische Namensdopplungen sind möglich, da interne IDs und Dokumentennummern eindeutig bleiben.

## 4.7 Charakterstatus

- `DRAFT`
- `ACTIVE`
- `INJURED`
- `JAILED`
- `RESTRICTED`
- `ARCHIVED`
- `DECEASED`
- `PENDING_DELETION`

## 4.8 Spawnpriorität

1. administrativ festgelegter Spawn
2. Gefängnis
3. Krankenhaus
4. Tutorial
5. letzter sicherer Standort
6. gewählte eigene Immobilie
7. zentraler Standardspawn

## 4.9 Charakterwechsel und Löschung

Ein Wechsel ist während Kampf, Festnahme, Verfolgung, Bewusstlosigkeit, Transport, Raub und anderen kritischen Aktionen gesperrt. Ein Verbindungsabbruch entfernt diese Zustände nicht.

Eine Löschung wird beantragt, verzögert und bleibt für eine konfigurierbare Frist widerrufbar. Danach wird der Charakter zunächst archiviert. Relevante Geld-, Besitz-, Polizei- und Administrationsdaten bleiben für die Nachvollziehbarkeit erhalten.

## 4.10 Dokumente

Mögliche Dokumente:

- Personalausweis
- Führerschein
- LKW-Führerschein
- Gefahrgutlizenz
- Waffenlizenz
- Gewerbelizenz
- Berufsausweise
- Fahrzeugpapiere

Mögliche Zustände:

- `ACTIVE`
- `EXPIRED`
- `SUSPENDED`
- `REVOKED`
- `LOST`
- `STOLEN`
- `DESTROYED`

---

# 5. Datenbank-Grundmodell

## 5.1 Standards

- MySQL-kompatible relationale Datenbank
- Tabellenpräfix `cnr_`
- englisches `snake_case`
- numerische interne IDs
- öffentliche UUIDs für APIs und Logs
- UTC-Zeitstempel
- Geldwerte als Ganzzahlen
- JSON nur für flexible Zusatzdaten
- überwiegend Archivierung statt direkter Löschung
- versionierte Migrationen
- getrennte Development-, Testing- und Production-Datenbanken

## 5.2 Accounttabellen

- `cnr_accounts`
- `cnr_account_identifiers`
- `cnr_account_sessions`
- `cnr_account_restrictions`
- `cnr_whitelist_entries`
- `cnr_whitelist_applications`

## 5.3 Rollen und Berechtigungen

- `cnr_roles`
- `cnr_permissions`
- `cnr_role_permissions`
- `cnr_account_roles`

Technische Teamrechte gehören zum Account. Jobs, Firmenränge und berufliche Berechtigungen gehören zum Charakter.

## 5.4 Charaktertabellen

- `cnr_characters`
- `cnr_character_identities`
- `cnr_character_appearances`
- `cnr_character_locations`
- `cnr_onboarding_progress`
- `cnr_document_types`
- `cnr_character_documents`

## 5.5 Konfigurationstabellen

- `cnr_config_entries`
- `cnr_config_revisions`
- `cnr_feature_flags`

Lager, Unternehmen, Tankstellen, Fahrzeuge und Raffinerien erhalten eigene fachliche Tabellen und werden nicht als beliebiges Konfigurations-JSON gespeichert.

## 5.6 Logs

- `cnr_audit_logs`
- `cnr_security_logs`

Audit-Logs ersetzen keine fachlichen Tabellen wie Banktransaktionen oder Itemübertragungen.

## 5.7 Transaktionen und Parallelzugriffe

- Charaktererstellung erfolgt atomar.
- Kritische Vorgänge erhalten eine `operation_uuid`.
- Dieselbe Vorgangsnummer kann keine doppelte Auszahlung erzeugen.
- gemeinsame Bestände werden durch Transaktionen, Sperren oder Versionsprüfungen geschützt.
- Konfigurationen und Besitzobjekte verwenden Versionsnummern.
- Kaskadenlöschungen werden nur für entbehrliche Daten verwendet.

## 5.8 Migrationen

Jedes Modul besitzt nummerierte Migrationen:

```text
0001_create_accounts
0002_create_account_identifiers
0003_add_account_language
```

Destruktive Produktivmigrationen werden nicht unkontrolliert beim normalen Serverstart ausgeführt. Backup und Testlauf sind vorher Pflicht.

## 5.9 Backups

- tägliches Vollbackup
- zusätzliche kurzfristige Wiederherstellungspunkte
- verschlüsselte und getrennte Aufbewahrung
- mehrere Generationen
- Backup vor Migrationen
- regelmäßige Wiederherstellungstests

---

# 6. Item- und Inventarsystem

## 6.1 Grundmodell

Das Inventar verwendet eine Kombination aus Slots und Gewicht:

- Slots begrenzen und strukturieren die möglichen Stapel.
- Gewicht verhindert unrealistische Mengen.
- Container können kontrolliert zusätzlichen Stauraum bieten.
- Flüssigkeiten und große Fracht werden nicht als tausende Taschenitems dargestellt.

## 6.2 Inventartypen

- Spielerinventar
- Kleidung und Ausrüstung
- Rucksack
- Handschuhfach
- Fahrzeugkofferraum
- Trailerladung
- Flüssigkeitstanker
- privates Lager
- Firmenlager
- Hauslager
- Asservatenlager
- Gegenstände am Boden
- temporäre Jobcontainer

## 6.3 Itemkategorien

- Verbrauchsgegenstände
- Werkzeuge
- Dokumente
- Schlüssel und Zugangsmedien
- Waffen
- Munition
- medizinische Gegenstände
- Rohstoffe
- verarbeitete Waren
- Fahrzeugteile
- Container
- Beweismittel
- illegale Waren

## 6.4 Itemdefinition und Iteminstanz

Eine Itemdefinition beschreibt einen allgemeinen Typ wie `water_bottle` oder `repair_kit`. Eine Iteminstanz repräsentiert einen konkreten einzigartigen Gegenstand, beispielsweise eine Waffe mit Seriennummer oder einen bestimmten Personalausweis.

Gewöhnliche stapelbare Items verwenden Definition und Menge. Einzigartige Gegenstände erhalten eine eigene öffentliche Item-UUID.

## 6.5 Itemeigenschaften

- technischer Name
- übersetzte Bezeichnung und Beschreibung
- Kategorie
- Grundgewicht
- optionales Volumen
- maximale Stapelgröße
- Haltbarkeit
- Qualität
- Ablaufdatum
- rechtliche Einstufung
- handelbar ja/nein
- ablegbar ja/nein
- zuständiger Use-Handler
- Icon
- erlaubtes Metadatenschema

Metadaten können Seriennummer, Charge, Eigentümer, Qualität, Haltbarkeit, Ablaufdatum, Kontamination, Munitionsstand oder Dokumentenreferenz enthalten. Der Client darf keine vertrauenswürdigen Metadaten frei erzeugen.

## 6.6 Flüssigkeiten und große Ladungen

Rohöl, Benzin und Diesel werden als Warencharge beziehungsweise `cargo lot` gespeichert.

Eine Charge enthält:

- Produkttyp
- Menge in Litern
- Qualität oder Reinheit
- Chargennummer
- Herkunft
- Eigentümer
- Kontaminationsstatus
- Förder- und Verarbeitungszeitpunkte

Tanker, Raffinerietanks und Tankstellen besitzen Kapazitäten und zugelassene Produkttypen. Das Frachtgewicht ergibt sich aus Menge und Produktdichte.

## 6.7 Container

- Container besitzen ein eigenes Inventar und Eigengewicht.
- Inhalt zählt zum Gesamtgewicht des übergeordneten Inventars.
- Verschachtelung wird begrenzt.
- Ein Container kann sich nicht selbst enthalten.
- Container dürfen Gewichts- und Kapazitätsgrenzen nicht umgehen.
- Zugriffsrechte werden serverseitig geprüft.

## 6.8 Itemaktionen

- hinzufügen
- entfernen
- übertragen
- teilen
- zusammenführen
- benutzen
- ausrüsten
- ablegen
- aufnehmen
- reservieren
- Reservierung freigeben
- verbrauchen oder zerstören

Jede kritische Übertragung prüft Quelle, Ziel, Menge, Zugriff, Gewicht, Slots, Entfernung und Itemzustand serverseitig.

## 6.9 Reservierungen

Längere Aktionen reservieren benötigte Gegenstände, bevor Animation oder Fortschrittsanzeige beginnen. Bei erfolgreichem Abschluss wird der Gegenstand verbraucht oder verändert. Bei Abbruch wird die Reservierung freigegeben.

So kann dasselbe Werkzeug oder Material nicht gleichzeitig für mehrere Vorgänge verwendet werden.

## 6.10 Gewichtsauswirkungen

Empfohlene, dynamisch konfigurierbare Stufen:

- normale Belastung: keine Einschränkung
- hohe Belastung: geringere Sprintausdauer
- Überladung: eingeschränkte Bewegung und kein Sprint
- starke Überladung: Umlagerung erforderlich

Die Auswirkungen sollen nachvollziehbar bleiben und normale Inventarverwaltung nicht zu unnötigem Mikromanagement machen.

## 6.11 Gegenstände am Boden

- einzigartige oder wertvolle Items bleiben länger erhalten.
- gewöhnliche Gegenstände verschwinden nach einer konfigurierbaren Zeit.
- Position und Routing Bucket werden gespeichert.
- Beweismittel können gesammelt und protokolliert werden.
- aktive oder reservierte Items dürfen nicht durch Cleanup gelöscht werden.

## 6.12 Vorgesehene Tabellen

- `cnr_item_definitions`
- `cnr_item_instances`
- `cnr_inventories`
- `cnr_inventory_items`
- `cnr_inventory_access`
- `cnr_item_reservations`
- `cnr_item_transactions`
- `cnr_item_batches`
- `cnr_cargo_lots`

## 6.13 Schutz vor Item-Duplizierung

- serverautorisierte Mengen und Metadaten
- atomare Übertragung zwischen Quelle und Ziel
- eindeutige Vorgangsnummern
- Versionsprüfung des Inventars
- kurze serverseitige Sperre während Änderungen
- keine Iteminstanz-IDs vom Client
- keine negativen oder leeren Mengen
- Entfernungs- und Eigentumsprüfung
- Rate-Limits
- strukturierte Transferprotokolle
- sichere Wiederherstellung nach Disconnect oder Ressourcenrestart

## 6.14 MVP-Umfang

- Spielerinventar
- Rucksack
- Handschuhfach und Kofferraum
- einfaches Lagerinventar
- stapelbare und einzigartige Items
- Slots und Gewicht
- Itembenutzung und Reservierung
- Dokumente als referenzierte einzigartige Items
- einfache Bodenablage
- Itemtransaktionshistorie
- Warenchargen für Rohöl und Kraftstoff

---

# 7. Öl- und Kraftstoffwirtschaft

## 7.1 Förderung

- Öl-Farmer-Job oder Lizenz
- gemieteter oder gekaufter LKW
- gemieteter oder gekaufter Tanktrailer
- Pumpenausrüstung
- Fördergeschwindigkeit und Ertrag abhängig von Fähigkeiten
- Maschinenverschleiß und mögliche Defekte
- Qualität und Chargenverfolgung

## 7.2 Lagerung

- mobile Tanks
- gemietete Lager
- gekaufte Lager
- Kapazitätsgrenzen
- Gebühren
- Zugriffsrechte
- Versicherung und Sicherheit
- Ein- und Auslagerungsprotokolle

## 7.3 Raffinerie

- öffentliche Verarbeitung gegen Gebühr
- mietbare oder kaufbare Raffinerie
- Produktionsaufträge
- Produktionsdauer
- Energieverbrauch
- Wartung und Ausfälle
- verschiedene Qualitätsstufen
- Benzin, Diesel, Kerosin, Heizöl, Schmiermittel, Bitumen und Nebenprodukte

## 7.4 Tankstellen

- getrennte Tanks pro Produkt
- individuelle Kapazitäten und Bestände
- Spielerbesitz
- Verkaufspreise innerhalb konfigurierter Grenzen
- Lieferverträge
- automatische Aufträge bei niedrigem Bestand
- teure NPC-Notversorgung
- Lieferbelege
- Unfall-, Leckage- und Brandrisiken

---

# 8. Weitere geplante Systeme

## 8.1 Legale Berufe

- Öl-Farmer
- LKW-Fahrer
- Kraftstofflieferant
- Lagerarbeiter
- Gabelstaplerfahrer
- Hafenarbeiter
- Raffineriemitarbeiter
- Abschleppdienst
- Mechaniker
- Müllentsorgung und Recycling
- Bergbau
- Holzfällerei
- Landwirtschaft
- Fischerei
- Taxi und Bus
- Polizei, Feuerwehr und Rettungsdienst
- Justiz und Stadtverwaltung
- Immobilienmakler
- Sicherheitsdienst
- Anwalt und Journalist

Berufe sollen einen tatsächlichen Nutzen für andere Spieler besitzen und nicht nur aus dem Abfahren von Markern bestehen.

## 8.2 Unternehmen

- Unternehmensgründung
- Firmenkonto
- Mitarbeiter und Ränge
- Rechteverwaltung
- Arbeitsverträge und Löhne
- Rechnungen
- Lager
- Fuhrpark
- Immobilien
- Steuern
- Gewinn- und Verlustübersicht
- Insolvenz
- Verkauf oder Übertragung
- Lizenzen
- Ausschreibungen und Lieferverträge

## 8.3 Fahrzeuge und Vermietung

- Neu- und Gebrauchtfahrzeuge
- Schlüssel
- Eigentümerwechsel
- Kennzeichen und Fahrgestellnummer
- Kilometerstand
- Schäden und Wartung
- Versicherung und Fahrzeugsteuer
- Finanzierung
- Beschlagnahmung
- Diebstahl
- Mietdauer und Kaution
- Kilometerbegrenzung
- Schadensabrechnung
- verspätete Rückgabe
- separate Vermietung von Zugmaschine und Trailer

## 8.4 Garagen, Lager und Immobilien

- öffentliche, private und Firmen-Garagen
- Abschlepphof und Polizeiverwahrung
- Garagenkapazität und Zugriffsrechte
- mietbare und kaufbare Lager
- Gefahrgut- und Kühllager
- Lagergebühren und Sicherheit
- Mietwohnungen und Häuser
- Möbel, Kleiderschrank und Hauslager
- Schlüssel und Mitbewohner
- Mietverträge, Nebenkosten und Hypotheken
- Einbruch und Alarmanlagen

## 8.5 Kriminalität

- Laden-, Tankstellen- und Bankraub
- Geldtransporter
- Haus- und Lagereinbruch
- Fahrzeugdiebstahl
- Schmuggel
- Drogenproduktion
- Waffenhandel
- Geldwäsche
- Hehlerei
- Überfälle auf Transporte
- Sabotage
- organisierte Kriminalität

## 8.6 Polizeisystem

- Dienstsystem und Dienstgrade
- Fahrzeuge und Ausrüstung
- Leitstelle und Notrufe
- Live-Einsatzkarte
- Personen- und Kennzeichenabfrage
- Bußgelder und Festnahmen
- Durchsuchungen
- Asservatenkammer
- Gefängnis
- Fahndungen
- Einsatzberichte
- Bodycam
- Polizei-MDT

## 8.7 Beweissystem

- Fingerabdrücke
- DNA
- Patronenhülsen
- Blutspuren
- Schuhabdrücke
- Fahrzeugspuren
- Kameraaufnahmen
- Beweismittelbeutel
- Laboruntersuchung
- Beweiskette
- Kontamination und Verfall

## 8.8 Fähigkeiten und Level

Mögliche Fähigkeiten:

- Ölförderung
- Raffinerieverarbeitung
- LKW-Fahren
- Lagerlogistik
- Mechanik
- Handel
- Landwirtschaft
- Bergbau
- Medizin
- Polizeiarbeit
- Einbruch
- Hacking
- Waffenhandhabung
- Ausdauer
- Fahrzeugkontrolle

Mögliche Vorteile:

- schnellere Abläufe
- geringerer Materialverlust
- bessere Qualität
- größere Aufträge
- geringerer Verschleiß
- neue Maschinen und Rezepte
- neue Lizenzen
- Spezialisierungen

Fortschritt soll Komfort, Zuverlässigkeit und neue Möglichkeiten schaffen, aber neue Spieler nicht chancenlos machen.

---

# 9. Dynamische Administration

## 9.1 Ingame-Editor

Administratoren können erstellen und konfigurieren:

- Interaktionspunkte
- NPCs
- Marker und Blips
- Garagen
- Lager
- Häuser
- Geschäfte
- Tankstellen
- Raffinerien
- Ölfelder
- Polizeistationen
- Krankenhäuser
- Mietstationen
- Produktionsanlagen
- Lieferzonen
- Raubziele

Änderungen besitzen Vorschau, Entwurf, Veröffentlichung, Audit-Historie und Wiederherstellung älterer Versionen.

## 9.2 Externes Control Panel

Das Control Panel kommuniziert über eine geprüfte API und schreibt nicht unkontrolliert direkt in Gameplaytabellen.

Konfigurierbar sind unter anderem:

- Accounts und Whitelist
- Rollen und Berechtigungen
- Preise und Steuern
- Produktionsrezepte
- Lagerkapazitäten
- Fahrzeugmieten
- Erfahrungspunkte und Levelanforderungen
- Raub-Cooldowns und Polizei-Anforderungen
- Feature Flags
- Ladebildschirm
- Audit- und Sicherheitslogs

---

# 10. Einheitliches UI-System

`cnr_ui` stellt bereit:

- Farben und Schriftarten
- Buttons und Eingabefelder
- Dialoge und Modals
- Tabellen
- Benachrichtigungen
- Fortschrittsanzeigen
- Kontextmenüs
- Bestätigungen
- Tastatur- und Controllerbedienung
- Fokusverwaltung
- responsive Skalierung
- Übersetzungen

Fachmodule liefern Daten und reagieren auf validierte Aktionen. Das UI entscheidet nicht über Geld, Besitz, Items oder Berechtigungen.

---

# 11. Sicherheitsgrundsätze

- Der Client wird bei Geld, Items, Besitz und Belohnungen niemals als vertrauenswürdig behandelt.
- Position, Entfernung und Spielerzustand werden serverseitig geprüft.
- Alle Eingaben erhalten Typ-, Werte- und Längenprüfungen.
- Kritische Events besitzen Rate-Limits.
- Kritische Datenbankänderungen verwenden Transaktionen.
- Administrative Aktionen werden vollständig protokolliert.
- Sensible Daten werden nicht in allgemein sichtbaren Player States gespeichert.
- Dieselbe Vorgangsnummer kann keine doppelte Auszahlung erzeugen.
- Module reagieren kontrolliert auf ausgefallene Abhängigkeiten.
- Development-, Testing- und Production-Secrets bleiben getrennt.

---

# 12. Aktuelle verbindliche Entscheidungen

| Thema | Entscheidung |
|---|---|
| Framework | vollständig Standalone |
| Setting | modernes San Andreas |
| Realismus | mittel |
| Wirtschaft | überwiegend spielergesteuert |
| Notversorgung | begrenzte und teure NPC-Versorgung |
| Charakterplätze | standardmäßig drei |
| permanenter Tod | freiwillig oder genehmigt |
| Zugang | mehrere Whitelist-Modi, Hybrid empfohlen |
| PvP | nur mit Rollenspielhintergrund |
| Polizei | Ermittlungen statt automatischer Markerjagd |
| Fortschritt | Fähigkeiten, Ruf, Lizenzen und Besitz |
| kostenloses Startfahrzeug | nein |
| UI | ein gemeinsames Designsystem |
| Konfiguration | Ingame-Editor und später externes Control Panel |
| Datenbank | MySQL-kompatibel, UTC, ganzzahlige Geldwerte |
| Inventar | Kombination aus Slots und Gewicht |
| Flüssigkeiten | Warenchargen mit Menge und Qualität |
| Codesprache | Englisch |
| UI-Sprache | zunächst Deutsch, vollständig übersetzbar |

## Nächster Planungsschritt

Als Nächstes wird das Bargeld-, Banking- und Transaktionssystem geplant. Dazu gehören persönliche und geschäftliche Konten, Rechnungen, Steuern, Kredite, markiertes Geld und Geldwäsche.
