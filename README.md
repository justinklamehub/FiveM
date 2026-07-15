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
- `cnr_reputation`
- `cnr_licenses`
- `cnr_interactions`
- `cnr_zones`

### Ebene 4 – Eigentum und Wirtschaft

- `cnr_vehicles`
- `cnr_garages`
- `cnr_dealerships`
- `cnr_rentals`
- `cnr_impound`
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

# 7. Bargeld-, Banking- und Transaktionssystem

## 7.1 Grundprinzip

`cnr_banking` ist die einzige fachliche Instanz, die Geldbestände und Geldbewegungen verändern darf. Andere Module fordern Zahlungen, Reservierungen oder Auszahlungen über definierte Schnittstellen an.

Alle Geldbewegungen werden in einem doppelten Hauptbuch gespeichert. Eine Transaktion besteht aus mindestens zwei Buchungen, deren Summe immer null ergibt.

Beispiel für einen Kraftstoffkauf über 100 Dollar:

| Beteiligter | Buchung |
|---|---:|
| Käufer | -100 |
| Tankstellenunternehmen | +84 |
| staatliches Steuerkonto | +16 |
| Summe | 0 |

Dadurch kann Geld nicht unbemerkt entstehen oder verschwinden. Jede Geldquelle und jede Geldsenke ist messbar.

## 7.2 Geldarten

### Reguläres Bargeld

- wird als serverseitig geführte Charakter-Geldbörse verwaltet;
- kann übergeben, eingezahlt, abgehoben, beschlagnahmt oder gestohlen werden;
- verwendet dasselbe Hauptbuch wie Bankkonten;
- besitzt konfigurierbare Limits für Übergaben und Abhebungen;
- ist kein frei manipulierbares Clientfeld.

### Bankguthaben

- befindet sich auf persönlichen, geschäftlichen oder staatlichen Konten;
- kann überwiesen, reserviert, eingefroren oder gepfändet werden;
- besitzt eine vollständige Transaktionshistorie;
- bleibt auch bei Offline-Spielern verfügbar.

### Markiertes oder belastetes Bargeld

Beute aus Banken, Geldtransportern oder anderen überwachten Quellen wird nicht als magische zweite Währung gespeichert. Sie besteht aus physischen Geldbündeln mit Charge und Herkunft.

Mögliche Eigenschaften:

- Nennwert
- Chargennummer
- Herkunft
- Markierungsstatus
- Risikostufe
- ursprünglicher Besitzer
- Tat- oder Vorgangsreferenz
- Zeitpunkt der Entwendung

Markierte Geldbündel können nicht ohne Weiteres auf ein normales Bankkonto eingezahlt werden.

## 7.3 Kontotypen

| Typ | Zweck |
|---|---|
| `CASH_WALLET` | Bargeld eines Charakters |
| `PERSONAL_CHECKING` | persönliches Girokonto |
| `PERSONAL_SAVINGS` | späteres Sparkonto |
| `BUSINESS` | Firmenkonto |
| `GOVERNMENT` | staatliches Konto |
| `ESCROW` | Treuhand und abgesicherte Geschäfte |
| `LOAN` | Kredit und Rückzahlung |
| `SYSTEM_SOURCE` | kontrollierte Geldquelle |
| `SYSTEM_SINK` | kontrollierte Geldsenke |

Jeder neue Charakter erhält genau ein persönliches Hauptkonto und eine Bargeld-Geldbörse. Weitere Konten können später abhängig von Gebühren, Lizenzen oder Unternehmen eröffnet werden.

## 7.4 Kontostatus

- `ACTIVE`
- `RESTRICTED`
- `FROZEN`
- `BLOCKED`
- `CLOSED`
- `PENDING_CLOSURE`

Ein geschlossenes Konto wird archiviert. Seine Transaktionen werden nicht gelöscht.

## 7.5 Kontoinhaber und Zugriffsrechte

Ein Konto kann einem Charakter, einem Unternehmen oder einer staatlichen Stelle gehören.

Mögliche Kontorechte:

- Kontostand ansehen
- Transaktionen ansehen
- Überweisungen erstellen
- Rechnungen bezahlen
- Bargeld abheben
- Karten verwalten
- Mitarbeiter berechtigen
- hohe Zahlungen freigeben
- Konto administrieren

Firmenkonten unterstützen:

- mehrere Benutzer;
- rollenbasierte Rechte;
- Ausgabenlimits;
- zeitlich begrenzte Vollmachten;
- optionales Vier-Augen-Prinzip bei großen Zahlungen.

## 7.6 Transaktionen

Jede Transaktion besitzt:

- öffentliche Transaktionsnummer
- eindeutige `operation_uuid`
- Typ
- Status
- Betrag und Währung
- Absender und Empfänger
- Verwendungszweck
- auslösendes Modul
- Erstellungs- und Buchungszeitpunkt
- optionale Gebühren und Steuern
- Referenz auf Rechnung, Vertrag oder Kauf
- technische Korrelationsnummer

Mögliche Statuswerte:

- `PENDING`
- `POSTED`
- `FAILED`
- `CANCELLED`
- `REVERSED`
- `HELD`

Gebuchte Transaktionen werden niemals nachträglich verändert oder gelöscht. Eine Korrektur erfolgt über eine eindeutig verknüpfte Gegenbuchung.

## 7.7 Überweisungen

Eine Überweisung benötigt:

- Quellkonto
- Zielkonto oder Kontonummer
- Betrag
- Verwendungszweck
- optional Empfängername zur Kontrolle

Serverseitige Prüfungen:

- Konto aktiv
- ausreichendes verfügbares Guthaben
- Berechtigung des Ausführenden
- Überweisungslimit
- Empfängerkonto vorhanden
- kein gesperrter Empfänger
- Rate-Limit
- identische Vorgangsnummer noch nicht verwendet
- mögliche Sicherheits- oder Geldwäscheprüfung

Hohe oder ungewöhnliche Überweisungen können zunächst den Status `PENDING` erhalten.

## 7.8 Bargeldeinzahlung und Bargeldabhebung

Abhebungen und Einzahlungen sind echte Umbuchungen zwischen Bankkonto und Bargeld-Geldbörse. Es wird dabei kein neues Geld erzeugt.

Mögliche Regeln:

- Tageslimit
- Einzeltransaktionslimit
- Geldautomatengebühr
- nur bestimmte Geldautomaten akzeptieren Einzahlungen
- Bankfilialen erlauben höhere Beträge
- gesperrte oder markierte Geldbündel werden abgelehnt
- große Einzahlungen können eine Prüfung auslösen

Später können Geldautomaten eigene Bargeldbestände besitzen und durch Geldtransporte aufgefüllt werden.

## 7.9 Zahlungskarten

Eine Karte ist ein einzigartiges Item, das auf einen serverseitigen Kartendatensatz verweist.

Eigenschaften:

- Karten-ID
- verknüpftes Konto
- Karteninhaber
- Status
- tägliches Limit
- Abhebungslimit
- optionaler PIN-Hash
- Ablaufdatum
- letzte Verwendung

Statuswerte:

- `ACTIVE`
- `FROZEN`
- `LOST`
- `STOLEN`
- `EXPIRED`
- `REVOKED`

Eine verlorene Karte ändert nicht die Eigentümerschaft des Kontos. Sie kann gesperrt und ersetzt werden.

## 7.10 Rechnungen

Rechnungen können von Unternehmen, Dienstleistern und berechtigten Behörden erstellt werden.

Eine Rechnung enthält:

- Rechnungsnummer
- Aussteller
- Empfänger
- einzelne Positionen
- Nettobetrag
- Steuer
- Gesamtbetrag
- Ausstellungsdatum
- Fälligkeitsdatum
- Zahlungsstatus
- Verwendungszweck
- zugehörige Leistung oder Vertrag

Mögliche Statuswerte:

- `DRAFT`
- `ISSUED`
- `PARTIALLY_PAID`
- `PAID`
- `OVERDUE`
- `DISPUTED`
- `CANCELLED`

Spontane Rechnungen zwischen Spielern müssen vom Empfänger bestätigt werden. Behördliche Gebühren oder gerichtlich bestätigte Forderungen verwenden einen gesonderten Prozess und dürfen nicht als gewöhnliche Spielerrechnung missbraucht werden.

## 7.11 Reservierungen und Treuhand

Eine Zahlungsreservierung blockiert einen Betrag, ohne ihn sofort endgültig zu buchen.

Verwendungszwecke:

- Mietwagenkaution
- Fahrzeugkauf
- Auktion
- Immobilienkauf
- Transportvertrag
- Hotel- oder Lagermiete
- Kartenzahlung

Mögliche Zustände:

- `ACTIVE`
- `CAPTURED`
- `PARTIALLY_CAPTURED`
- `RELEASED`
- `EXPIRED`

Beispiel Mietwagen:

1. Kaution wird reserviert.
2. Fahrzeug wird zurückgegeben.
3. Schäden werden geprüft.
4. benötigter Teil wird eingezogen.
5. Restbetrag wird freigegeben.

## 7.12 Wiederkehrende Zahlungen

Geplante wiederkehrende Vorgänge:

- Mieten
- Versicherungen
- Kreditraten
- Mitarbeiterlöhne
- Lagergebühren
- Unternehmensgebühren
- Abonnements
- Steuervorauszahlungen

Jeder Vorgang besitzt Fälligkeit, Wiederholungsregel, maximale Versuche, Karenzzeit und Fehlerbehandlung.

Fehlgeschlagene Zahlungen erzeugen keine unendlichen Wiederholungen. Sie können Mahnung, Leistungsverlust, Vertragsstatus oder Schulden beeinflussen.

## 7.13 Löhne und Gehälter

Private Unternehmen zahlen Löhne aus ihrem Firmenkonto. Öffentliche Stellen zahlen aus einem staatlichen Konto.

Grundregeln:

- keine unbegrenzten Gehälter aus dem Nichts;
- Arbeitszeit oder Leistung muss nachvollziehbar sein;
- Unternehmen können Lohnmodelle und Freigaben verwalten;
- unzureichendes Firmenvermögen erzeugt ausstehende Lohnforderungen;
- öffentliche Grundversorgung erhält bei Bedarf eine kontrollierte staatliche Reserve;
- alle Lohnzahlungen besitzen Steuer- und Arbeitgeberreferenzen.

Rohstoff- und Logistikjobs werden bevorzugt durch tatsächliche Aufträge und Käufer bezahlt statt durch pauschale Markerbelohnungen.

## 7.14 Steuern und Gebühren

Mögliche Steuerarten:

- Verkaufssteuer
- Unternehmenssteuer
- Lohnsteuer
- Fahrzeugsteuer
- Immobiliensteuer
- Zulassungs- und Lizenzgebühren
- Einfuhr- oder Gefahrgutgebühren

Für das MVP wird mit wenigen verständlichen Abgaben begonnen:

- Verkaufssteuer
- ausgewählte Unternehmensgebühren
- Fahrzeug- und Lizenzgebühren

Steuersätze, Freibeträge, Grenzen und Empfängerkonten sind dynamisch konfigurierbar. Steuern fließen nachvollziehbar auf staatliche Konten.

## 7.15 Kredite

Kredite sind für eine spätere Ausbaustufe vorgesehen.

Geplante Eigenschaften:

- Kreditgeber
- Kreditnehmer
- Darlehensbetrag
- Zinssatz
- Laufzeit
- Ratenplan
- Sicherheiten
- Restschuld
- Mahnstatus
- Ausfallstatus
- mögliche Pfändung oder Rücknahme

Kredite werden nicht minütlich verzinst. Zinsen und Raten werden in nachvollziehbaren täglichen oder wöchentlichen Perioden berechnet.

Eine spätere Kreditwürdigkeit kann Einkommen, bestehende Schulden, Zahlungsverhalten, Firmenwert und Sicherheiten berücksichtigen.

## 7.16 Illegales Geld und Geldwäsche

Es gibt keine einfache globale Variable `black_money`. Illegales Geld besitzt Herkunft und Risiko.

Möglicher Geldwäscheablauf:

1. markiertes oder belastetes Bargeld wird zu einer geeigneten Stelle gebracht;
2. Herkunft und Risikostufe bestimmen Aufwand und Gebühren;
3. Geldwäscheunternehmen besitzt eine begrenzte Verarbeitungskapazität;
4. ein Teil des Wertes geht als Gebühr oder Verlust verloren;
5. der verbleibende Betrag wird über nachvollziehbare Scheinumsätze oder Auszahlungen legalisiert;
6. auffällige Häufigkeit und Höhe erhöhen das Ermittlungsrisiko.

Mögliche Waschmethoden:

- Scheinfirmen
- manipulierte Geschäftsumsätze
- illegale Wechselstuben
- Glücksspiel
- Fahrzeughandel
- gefälschte Rechnungen

Jede Methode besitzt andere Kapazitäten, Kosten, Dauer und Beweisrisiken.

## 7.17 Auffällige Transaktionen

Das System darf verdächtige Spieler nicht automatisch bestrafen. Es erzeugt stattdessen Hinweise für berechtigte Ermittlungen.

Mögliche Auslöser:

- ungewöhnlich hohe Bareinzahlung
- viele kleine Einzahlungen in kurzer Zeit
- häufige Zahlungen zwischen denselben Beteiligten
- Transfers an gesperrte oder auffällige Konten
- Firmenumsatz ohne passende Warenbewegung
- Geldbewegungen unmittelbar nach einem Raub
- Nutzung gestohlener Karten

Schwellenwerte sind dynamisch und dürfen für normale Spieler nicht sichtbar sein.

## 7.18 Offline-Vorgänge

Auch bei abgemeldeten Spielern können folgende Vorgänge stattfinden:

- Überweisungen empfangen
- Lohn erhalten
- Rechnung fällig werden
- Miete abbuchen
- Kreditrate verarbeiten
- Konto einfrieren
- Erstattung erhalten

Beim nächsten Login erhält der Spieler eine zusammengefasste Benachrichtigung. Kritische Vorgänge werden nicht allein durch einen Clienttimer ausgelöst.

## 7.19 Benutzeroberflächen

### Banking-App

- Kontenübersicht
- verfügbarer und reservierter Betrag
- Überweisungen
- Transaktionshistorie
- Rechnungen
- Kartenverwaltung
- wiederkehrende Zahlungen
- Firmenkonten abhängig von Berechtigung

### Geldautomat

- Bargeld abheben
- unterstützte Einzahlungen
- Kontostand
- kurze Transaktionsübersicht
- Karten- und PIN-Prüfung

### Bankschalter

- höhere Bargeldbeträge
- Kontoeröffnung
- Kartenersatz
- Kontosperren
- später Kredite und Beratung

Alle Oberflächen verwenden `cnr_ui` und zeigen keine internen Datenbank-IDs an.

## 7.20 Vorgesehene Tabellen

- `cnr_financial_accounts`
- `cnr_financial_account_members`
- `cnr_financial_transactions`
- `cnr_financial_entries`
- `cnr_financial_holds`
- `cnr_payment_cards`
- `cnr_invoices`
- `cnr_invoice_items`
- `cnr_scheduled_payments`
- `cnr_loans`
- `cnr_loan_installments`
- `cnr_cash_batches`
- `cnr_money_laundering_operations`
- `cnr_suspicious_transaction_flags`

Der Begriff `financial_accounts` verhindert eine Verwechslung mit den technischen Spieleraccounts in `cnr_accounts`.

## 7.21 Sicherheitsregeln

- Geldwerte ausschließlich als Ganzzahlen
- keine direkte Veränderung eines Balancefelds durch andere Module
- Hauptbuchbuchungen müssen je Transaktion null ergeben
- jede kritische Aktion mit eindeutiger `operation_uuid`
- atomare Datenbanktransaktionen
- Kontosperren und Versionsprüfungen bei Parallelzugriffen
- serverseitige Berechtigungsprüfung
- serverseitige Betrags- und Limitprüfung
- Rate-Limits für Zahlungen und Rechnungen
- gebuchte Transaktionen niemals löschen
- Korrekturen nur durch Gegenbuchung
- vollständige Audit- und Sicherheitslogs
- automatische Erkennung unmöglicher Kontostände

## 7.22 Control-Panel-Konfiguration

Dynamisch einstellbar:

- Startguthaben
- Bargeld- und Transferlimits
- Geldautomatengebühren
- Kartenlimits
- Kontogebühren
- Steuersätze
- Rechnungsfristen
- Mahn- und Karenzzeiten
- Reservierungsdauer
- Lohnregeln
- Kreditgrenzen und Zinsspannen
- Geldwäschegebühren und Kapazitäten
- Schwellenwerte für verdächtige Vorgänge
- aktivierte Kontotypen und Funktionen

Das Control Panel zeigt zusätzlich:

- gesamte Geldmenge
- Bargeld und Bankguthaben
- Firmen- und Staatsvermögen
- markiertes beziehungsweise belastetes Geld
- Geldquellen und Geldsenken
- Steueraufkommen
- größte Geldflüsse
- fehlgeschlagene oder auffällige Transaktionen

## 7.23 MVP-Umfang

- Bargeld-Geldbörse
- persönliches Girokonto
- doppelte Buchführung
- Überweisungen
- Ein- und Auszahlung
- Geldautomat
- einfache Zahlungskarte
- Transaktionshistorie
- Rechnungen
- Firmen- und Staatskonten
- Zahlungsreservierungen
- grundlegende wiederkehrende Zahlungen
- einfache Verkaufssteuer
- markierte Geldbündel
- erste einfache Geldwäschefunktion
- vollständige Auditierung

Nicht im ersten MVP:

- komplexe Kredite
- Kreditwürdigkeit
- Spielerbanken
- umfassende Pfändungen
- mehrere Währungen
- vollständig physisch befüllte Geldautomaten

---

# 8. Fähigkeiten-, Level-, Ruf- und Lizenzsystem

## 8.1 Trennung der Fortschrittsarten

Das Fortschrittssystem unterscheidet vier eigenständige Bereiche:

| Bereich | Bedeutung | Beispiel |
|---|---|---|
| Fähigkeit | praktische Erfahrung eines Charakters | Ölförderung, Hacking, Mechanik |
| Level | Fortschrittsstufe innerhalb einer Fähigkeit | Ölförderung Level 8 |
| Lizenz | rechtliche oder berufliche Erlaubnis | LKW- oder Gefahrgutlizenz |
| Ruf | Vertrauen bei einer Organisation oder Gruppe | Raffinerieverband, Unterweltkontakt |

Zusätzlich können Berufe, Firmenränge und Polizeidienstgrade existieren. Sie werden nicht automatisch durch ein Level vergeben.

Ein Charakter kann beispielsweise ein sehr erfahrener Fahrer sein, aber aufgrund einer entzogenen Fahrerlaubnis trotzdem nicht legal fahren.

## 8.2 Kein globales Machtlevel

Es gibt kein einzelnes globales Charakterlevel, das pauschal alle Fähigkeiten verbessert.

Gründe:

- Ein Mechaniker wird nicht automatisch zu einem besseren Hacker.
- Ein krimineller Charakter erhält nicht durch Gesamtspielzeit Zugang zu Polizeifunktionen.
- Neue Charaktere bleiben in einzelnen Tätigkeiten konkurrenzfähig.
- Fortschritt bleibt nachvollziehbar und thematisch passend.

Optional kann ein allgemeiner Charakterfortschritt für Statistiken, kosmetische Auszeichnungen oder Meilensteine angezeigt werden. Er verleiht keine direkten Gameplay-Vorteile.

## 8.3 Fähigkeitskategorien

### Industrie und Logistik

- Ölförderung
- Raffinerieverarbeitung
- Gefahrguthandhabung
- LKW-Logistik
- Lagerlogistik
- Fahrzeugbeladung
- Bergbau
- Holzverarbeitung
- Landwirtschaft
- Recycling

### Handwerk und Dienstleistungen

- Fahrzeugmechanik
- Fahrzeuglackierung
- Elektronik
- Reparatur
- Medizinische Versorgung
- Handel
- Verhandlung
- Kochen und Lebensmittelproduktion

### Kriminalität

- Einbruch
- Schlossknacken
- Hacking
- Fahrzeugdiebstahl
- Geldwäsche
- Schmuggel
- illegale Herstellung
- Spurenvermeidung

### Öffentliche Tätigkeiten

- Ermittlung
- Beweissicherung
- Einsatzfahren
- medizinische Behandlung
- Brandbekämpfung
- Verwaltung

Polizei-, Medizin- oder Feuerwehrfähigkeiten ersetzen keine Einstellung, Ausbildung oder Dienstfreigabe.

## 8.4 Levelmodell

Empfohlen werden standardmäßig 20 Level pro Fähigkeit. Die maximale Stufe bleibt pro Fähigkeit dynamisch konfigurierbar.

Grundregeln:

- Level 1 ist der Einstieg.
- höhere Level benötigen zunehmend mehr Erfahrung.
- Levelkurven sind nicht linear.
- einzelne Tätigkeiten können eine Mindeststufe besitzen.
- Spezialisierungen werden an definierten Meilensteinen freigeschaltet.
- hohe Level erhöhen Zuverlässigkeit und Möglichkeiten, nicht unbegrenzt den Gewinn.

Empfohlene Meilensteine:

| Level | Bedeutung |
|---:|---|
| 1 | Anfänger und Grundaufträge |
| 5 | erste Spezialisierung oder bessere Werkzeuge |
| 10 | fortgeschrittene Aufträge und Verfahren |
| 15 | Expertenfunktionen |
| 20 | Meisterschaft und besondere Spezialisierung |

## 8.5 Erfahrungspunkte

Erfahrungspunkte werden ausschließlich serverseitig nach einer sinnvollen Aktion vergeben.

Mögliche Berechnungsfaktoren:

- Grundwert der Tätigkeit
- Schwierigkeit
- tatsächlich benötigte Zeit
- Entfernung
- Warenmenge
- Qualität des Ergebnisses
- Zustand verwendeter Ausrüstung
- aktuelle Nachfrage
- Risiko
- eigener Beitrag innerhalb einer Gruppe
- erstmalige oder abwechslungsreiche Tätigkeit

Keine Erfahrung gibt es allein für:

- das Drücken einer Taste;
- das Starten eines Fortschrittsbalkens;
- dauerhaftes Herumfahren ohne Auftrag;
- Aufenthalt in einer Zone;
- wiederholtes Abbrechen;
- dieselbe Vorgangsnummer;
- vom Client gemeldete Mengen ohne Servernachweis.

## 8.6 Ablauf einer Erfahrungsvergabe

1. Ein Fachmodul meldet eine abgeschlossene Tätigkeit.
2. `cnr_progression` prüft Charakter, Vorgang und Fähigkeitsdefinition.
3. Schwierigkeit und tatsächlicher Beitrag werden bewertet.
4. Anti-Farming-Regeln werden angewendet.
5. Erfahrung wird als eigene Transaktion gespeichert.
6. ein möglicher Levelaufstieg wird berechnet.
7. Freischaltungen oder Spezialisierungspunkte werden verarbeitet.
8. der Spieler erhält eine dezente Benachrichtigung.

Andere Module dürfen das Erfahrungsfeld nicht direkt erhöhen.

## 8.7 Schutz vor AFK- und Wiederholungsfarming

Geplante Schutzmaßnahmen:

- eindeutige `operation_uuid` pro Tätigkeit;
- Mindest- und Höchstdauer für plausible Abläufe;
- serverseitige Prüfung von Position und Strecke;
- Prüfung tatsächlich bewegter oder verarbeiteter Waren;
- abnehmende Erfahrung bei identischen Wiederholungen;
- Abwechslungsmultiplikator für unterschiedliche Aufträge;
- reduzierte Erfahrung bei wiederholten Abbrüchen;
- weiche Tagesgrenzen statt harter Spielverbote;
- Erkennung unnatürlicher Eingabe- und Bewegungsmuster;
- keine Erfahrung für gegenseitig künstlich erzeugte Aktionen;
- Sicherheitslogs für auffällige Erfahrungsraten.

Ein weiches Limit reduziert nach sehr hoher Tagesaktivität schrittweise den Erfahrungsgewinn. Spielen bleibt möglich und wirtschaftliche Erträge werden davon getrennt behandelt.

## 8.8 Teamarbeit

Gruppenaufträge verteilen Erfahrung anhand des tatsächlichen Beitrags.

Mögliche Rollen:

- Fahrer
- Maschinenführer
- Verlader
- Verarbeiter
- Disponent
- Sicherheitsbegleitung
- Techniker

Jede Rolle besitzt eigene Beitragsereignisse. Reines Mitfahren oder AFK-Anwesenheit reicht nicht für die volle Belohnung.

Unterstützende Rollen dürfen trotzdem Fortschritt erhalten, auch wenn sie nicht den finalen Verkaufs- oder Abschlussknopf betätigen.

## 8.9 Spezialisierungen und Vorteile

Spezialisierungen ermöglichen individuelle Charakterwege, ohne vollständige Klassen zu erzwingen.

Mögliche Vorteile:

- geringerer Materialverlust
- stabilere Produktqualität
- reduzierte Bearbeitungszeit
- geringerer Werkzeugverschleiß
- bessere Fehlererkennung
- größere oder schwierigere Aufträge
- neue Maschinen
- zusätzliche Rezeptvarianten
- bessere Risikoabschätzung
- besondere Dialog- oder Verhandlungsoptionen

Vorteile dürfen nicht zu extremen Multiplikatoren führen. Als Balancing-Richtung gelten kleine, kombinierbare Verbesserungen statt einer Verdopplung von Geschwindigkeit oder Ertrag.

Beispielhafte Obergrenzen können dynamisch festgelegt werden:

- maximal etwa 25 Prozent Zeitvorteil;
- maximal etwa 15 Prozent direkter Ertragsvorteil;
- weitere Vorteile hauptsächlich über Qualität, Zuverlässigkeit und neue Möglichkeiten.

Diese Werte sind Planungsrichtwerte und keine endgültigen Balancewerte.

## 8.10 Spezialisierungspunkte

An bestimmten Leveln erhält ein Charakter Spezialisierungspunkte.

Regeln:

- Punkte werden nur innerhalb der passenden Fähigkeit verwendet.
- nicht alle Vorteile können gleichzeitig gewählt werden.
- Entscheidungen sollen verschiedene Spielweisen ermöglichen.
- Zurücksetzen ist möglich, aber mit Kosten und Cooldown verbunden.
- Level und gesammelte Erfahrung werden bei einer Umspezialisierung nicht gelöscht.

Mögliche Zweige der Ölförderung:

- Geschwindigkeit
- Qualität
- Maschinenschonung
- Gefahrgutsicherheit
- mobile Förderung

## 8.11 Beispiel: Fortschritt eines Öl-Farmers

| Levelbereich | Möglicher Fortschritt |
|---|---|
| 1–4 | öffentliche Förderstellen, kleine Pumpen, Grundlagen |
| 5–9 | Qualitätsprüfung, geringerer Verlust, erste Spezialisierung |
| 10–14 | größere Pumpen, schwierigere Felder, bessere Chargen |
| 15–19 | Prozessoptimierung, Expertenaufträge, seltene Förderstellen |
| 20 | Meister-Spezialisierung und besondere Industrieverträge |

Zusätzliche Voraussetzungen bleiben getrennt:

- LKW-Lizenz zum legalen Fahren eines Tanklasters;
- Gefahrgutlizenz für entsprechende Transporte;
- Ruf bei Auftraggebern für hochwertige Verträge;
- Unternehmen oder Vertrag für den Betrieb eigener Anlagen;
- Kapital und Genehmigung für Eigentum.

Ein hohes Ölförderungslevel allein schenkt keine Raffinerie und kein Unternehmen.

## 8.12 Rufsystem

Ruf wird getrennt nach Organisation, Industrie oder Gruppierung gespeichert.

Beispiele:

- Stadtverwaltung
- Polizei
- bestimmte Unternehmen
- Raffineriebetreiber
- Logistikverband
- Fahrzeughändler
- Werkstattnetzwerk
- Unterweltgruppen
- Schmugglerkontakte

Empfohlene Rufstufen:

- `HOSTILE`
- `DISTRUSTED`
- `NEUTRAL`
- `TRUSTED`
- `RESPECTED`
- `ELITE`

Ruf kann positiv oder negativ sein. Nicht jeder Ruf ist öffentlich sichtbar. Die Polizei kann den internen Ruf bei einer kriminellen Organisation nicht einfach im Charakterprofil ablesen.

## 8.13 Rufveränderungen

Positive Einflüsse:

- zuverlässige Vertragsabschlüsse
- hohe Produktqualität
- fristgerechte Lieferungen
- erfolgreiche Zusammenarbeit
- ehrliche Geschäftsvorgänge
- gruppenspezifische Aufgaben

Negative Einflüsse:

- Vertragsbruch
- beschädigte oder fehlende Waren
- Betrug
- Verrat
- nicht bezahlte Forderungen
- Straftaten gegen die betreffende Gruppe
- unzuverlässige Auftragsabbrüche

Rufänderungen werden wie Geld und Erfahrung als einzelne Transaktionen gespeichert. Manuelle Adminänderungen benötigen einen Grund.

Ruf kann langsam in Richtung neutral zurückkehren, sofern die jeweilige Definition einen Verfall vorsieht. Fähigkeiten verfallen standardmäßig nicht.

## 8.14 Lizenzarten

### Fahrzeug und Transport

- Pkw-Führerschein
- Motorradführerschein
- LKW-Führerschein
- Busführerschein
- Anhängerberechtigung
- Gefahrgutlizenz
- Taxilizenz

### Wirtschaft und Unternehmen

- Gewerbelizenz
- Handelslizenz
- Lagergenehmigung
- Gefahrgutlagergenehmigung
- Raffineriebetriebserlaubnis
- Tankstellenbetriebserlaubnis
- Waffenhandelslizenz

### Weitere Bereiche

- Waffenlizenz
- Jagdlizenz
- medizinische Zulassung
- Mechanikerzertifizierung
- Sicherheitsdienstlizenz
- Berufsausweise öffentlicher Stellen

Nicht jede berufliche Ausbildung ist eine staatliche Lizenz. Interne Firmenzertifikate und Dienstgrade bleiben eigene Systeme.

## 8.15 Erwerb einer Lizenz

Eine Lizenz kann folgende Voraussetzungen besitzen:

- Mindestalter
- benötigte Fähigkeit
- theoretische Prüfung
- praktische Prüfung
- medizinische Untersuchung
- Gebühren
- vorhandene Grundlizenz
- sauberes oder zulässiges Führungszeugnis
- Unternehmens- oder Berufszugehörigkeit
- vorgeschriebene Ausbildung

Der Erwerb besteht je nach Lizenz aus:

1. Antrag
2. Prüfung der Voraussetzungen
3. Bezahlung oder Kostenübernahme
4. Theorieprüfung
5. Praxisprüfung
6. Ausstellung
7. optionaler Aushändigung eines Dokuments

## 8.16 Lizenzstatus

- `PENDING`
- `PROVISIONAL`
- `ACTIVE`
- `EXPIRED`
- `SUSPENDED`
- `REVOKED`
- `DENIED`

Jede Statusänderung enthält Zeitpunkt, Grund, verantwortliche Stelle und optionales Enddatum.

## 8.17 Lizenzen als Erlaubnis statt unsichtbare Wand

Eine fehlende Lizenz blockiert nicht automatisch jede technisch mögliche Handlung.

Beispiele:

- Ein Charakter kann ein Fahrzeug ohne Fahrerlaubnis bewegen, handelt aber illegal.
- Gefahrgut kann ohne Lizenz transportiert werden, erzeugt jedoch rechtliche und versicherungsbezogene Risiken.
- Eine staatlich registrierte Firma kann dagegen nicht ohne notwendige Genehmigung offiziell eröffnet werden.
- Bestimmte sichere oder behördliche Anlagen dürfen eine technische Zugangssperre besitzen.

Dadurch entstehen Rollenspiel, Kontrollen und Konsequenzen, ohne jede Straftat durch eine unsichtbare Systemwand zu verhindern.

## 8.18 Prüfungen

Theorieprüfungen verwenden versionierte Fragenkataloge mit zufälliger Auswahl. Praktische Prüfungen bewerten nachvollziehbare Aufgaben.

Regeln:

- begrenzte Versuche innerhalb eines Zeitraums;
- Wartezeit nach Nichtbestehen;
- keine Antwortauswertung ausschließlich auf dem Client;
- unterschiedliche Prüfungsvarianten;
- Protokollierung von Beginn, Ergebnis und Prüfer;
- manuelle Prüfungen durch berechtigte Spieler möglich;
- automatisierte Alternative bei fehlendem Personal.

## 8.19 Entzug und Wiedererteilung

Lizenzen können ausgesetzt oder entzogen werden durch:

- behördliche Entscheidung
- Gerichtsurteil
- Punktesystem
- abgelaufene Gültigkeit
- fehlende Pflichtuntersuchung
- administrative Korrektur

Eine Wiedererteilung kann Gebühren, Wartezeit, Schulung oder erneute Prüfung benötigen.

Dokumente im Inventar spiegeln nur den Datensatz wider. Das Vernichten der physischen Karte entfernt nicht die rechtliche Lizenz.

## 8.20 Jobränge und öffentliche Rollen

Berufsränge werden nicht automatisch anhand einer Fähigkeit vergeben.

Beispiele:

- Ein Polizist erhält seinen Dienstgrad durch die Organisation.
- Ermittlungsfähigkeit kann Werkzeuge oder Auswertungen verbessern.
- Sie erteilt aber keine Personal- oder Führungsrechte.
- Ein Mechanikerlevel erlaubt bessere Arbeit.
- Die Firmenrolle entscheidet weiterhin über Kasse, Mitarbeiter und Lager.

Damit bleiben Rollenspielhierarchie, fachliche Erfahrung und technische Berechtigungen sauber getrennt.

## 8.21 Tod, Haft und Charakterwechsel

- Tod oder Krankenhausaufenthalt entfernt keine Fähigkeitslevel.
- Haft entfernt keine Erfahrung, kann aber Lizenzen und Ruf beeinflussen.
- Charaktere eines Accounts besitzen getrennten Fortschritt.
- Erfahrung kann nicht zwischen eigenen Charakteren übertragen werden.
- Accountweite Belohnungen bleiben auf kosmetische oder organisatorische Inhalte beschränkt.

## 8.22 Neue Spieler und Aufholmechaniken

Neue Spieler müssen sofort sinnvoll mitarbeiten können.

Geplante Mechaniken:

- Anfängeraufträge mit echtem Nutzen;
- Mentoren- und Auszubildendensystem;
- Gruppenbonus für gemeinsames Lernen, nicht für AFK-Anwesenheit;
- abwechslungsreiche Wochenaufgaben;
- schneller Einstieg in Grundlagenlevel;
- zunehmende Anforderungen erst in höheren Stufen;
- keine mit Echtgeld kaufbaren Erfahrungsboosts.

Erfahrene Charaktere gewinnen Effizienz und Möglichkeiten, dürfen Anfänger aber nicht vollständig aus dem Markt verdrängen.

## 8.23 Vorgesehene Tabellen

- `cnr_skill_definitions`
- `cnr_character_skills`
- `cnr_skill_xp_transactions`
- `cnr_specialization_definitions`
- `cnr_character_specializations`
- `cnr_reputation_definitions`
- `cnr_character_reputations`
- `cnr_reputation_transactions`
- `cnr_license_types`
- `cnr_character_licenses`
- `cnr_license_events`
- `cnr_exam_definitions`
- `cnr_exam_attempts`
- `cnr_achievement_definitions`
- `cnr_character_achievements`

## 8.24 Sicherheit und Auditierung

- Erfahrung ausschließlich durch serverseitige Fachmodule
- jede Vergabe mit Vorgangsnummer und Quelle
- keine direkte Levelveränderung durch den Client
- keine doppelte Erfahrungsvergabe für denselben Vorgang
- Plausibilitätsprüfung von Zeit, Strecke, Menge und Beitrag
- getrennte Transaktionshistorie für Erfahrung und Ruf
- manuelle Änderungen nur mit Berechtigung und Begründung
- Lizenzänderungen mit vollständiger Ereignishistorie
- auffällige Fortschrittsraten als Sicherheitsereignis
- Korrekturen durch Ausgleichstransaktion statt Löschen der Historie

## 8.25 Control-Panel-Konfiguration

Dynamisch einstellbar:

- aktive Fähigkeiten
- maximale Level
- Erfahrungskurven
- Erfahrungswerte einzelner Tätigkeiten
- Multiplikatoren und weiche Tagesgrenzen
- Anti-Wiederholungsregeln
- Spezialisierungen und Voraussetzungen
- Stärke und Obergrenzen von Vorteilen
- Rufstufen und Rufverfall
- Lizenztypen
- Prüfungsanforderungen
- Gebühren
- Gültigkeitsdauer
- Wartezeiten und Wiederholungsversuche
- Abhängigkeiten zwischen Fähigkeiten, Ruf und Lizenzen

Administratoren erhalten Auswertungen über:

- durchschnittliche Levelgeschwindigkeit;
- häufigste Erfahrungsquellen;
- ungewöhnliche Erfahrungsraten;
- Verteilung der Spezialisierungen;
- ausgestellte, abgelaufene und entzogene Lizenzen;
- Rufverteilung;
- Auswirkungen auf Produktion und Wirtschaft.

## 8.26 MVP-Umfang

- getrennte Charakterfähigkeiten
- standardmäßig 20 Level
- steigende Erfahrungskurve
- serverseitige Erfahrungstransaktionen
- Anti-Wiederholungs- und Plausibilitätsprüfungen
- erste Spezialisierungen
- Ruf pro Organisation oder Branche
- Pkw-, LKW- und Gefahrgutlizenz
- Lizenzstatus und Ereignishistorie
- einfache Theorie- und Praxisprüfungen
- Fortschrittsübersicht im einheitlichen UI
- Adminauswertung und Audit-Logs

Erste MVP-Fähigkeiten:

- Ölförderung
- Raffinerieverarbeitung
- LKW-Logistik
- Lagerlogistik
- Fahrzeugmechanik

---

# 9. Fahrzeug-, Eigentums-, Miet- und Garagensystem

## 9.1 Verantwortliche Module

### `cnr_vehicles`

Verantwortet:

- dauerhafte Fahrzeugidentität;
- Eigentum und Eigentumshistorie;
- Fahrzeugzustand;
- Schlüssel und Zugriffsrechte;
- Kilometerstand;
- Modifikationen;
- Zulassungsdaten;
- Spawnstatus;
- Zugmaschinen und Trailer als Fahrzeuge.

### `cnr_garages`

Verantwortet:

- Garagen und Stellplätze;
- Ein- und Auslagerung;
- Kapazitäten;
- Zugriffsrechte;
- unterstützte Fahrzeuggrößen;
- Park- und Lagerereignisse.

### `cnr_dealerships`

Verantwortet:

- Fahrzeugkataloge;
- Händlerbestände;
- Neu- und Gebrauchtfahrzeuge;
- Probefahrten;
- Kaufangebote;
- Auslieferungen.

### `cnr_rentals`

Verantwortet:

- Mietangebote;
- Mietverträge;
- Kautionen;
- Kilometer- und Zeitabrechnung;
- Zustandsprotokolle;
- Rückgabe und Verspätung;
- temporäre Fahrerrechte.

### `cnr_impound`

Verantwortet:

- Abschleppvorgänge;
- Polizeiverwahrung;
- Beschlagnahmung;
- Freigabebedingungen;
- Verwahrgebühren;
- Rückgabe oder Verwertung.

## 9.2 Dauerhafte Fahrzeugidentität

Jedes persistente Fahrzeug erhält:

- interne Fahrzeug-ID;
- öffentliche Fahrzeug-UUID;
- eindeutige Fahrgestellnummer beziehungsweise VIN;
- aktuelles Kennzeichen;
- Fahrzeugdefinition und Modell;
- Fahrzeugtyp und Klasse;
- Eigentümerart und Eigentümer-ID;
- Erstellungs- oder Importdatum;
- aktuelle Zustandsversion.

Das Kennzeichen ist niemals der Primärschlüssel eines Fahrzeugs. Kennzeichen können geändert, gestohlen oder gefälscht werden. Die VIN bleibt die dauerhafte technische Identität.

Die FiveM-Netzwerk-ID einer gespawnten Entity ist ebenfalls nur temporär und wird niemals als dauerhafte Fahrzeug-ID verwendet.

## 9.3 Eigentümerarten

Ein Fahrzeug kann gehören zu:

- einem Charakter;
- einem Unternehmen;
- einer staatlichen Stelle;
- einem Fahrzeughändler;
- einem Vermietungsunternehmen;
- einer Finanzierungsgesellschaft;
- einer anderen systemverwalteten Organisation.

Eigentum, Fahrerlaubnis und tatsächlicher Besitz werden getrennt behandelt. Ein Dieb kann ein Fahrzeug kontrollieren, ohne rechtlicher Eigentümer zu werden.

## 9.4 Getrennte Fahrzeugzustände

Statt eines einzigen überladenen Statusfeldes werden mehrere Zustandsbereiche verwendet.

### Betriebszustand

- `STORED`
- `SPAWNED`
- `PARKED`
- `IN_MAINTENANCE`
- `DESTROYED`
- `ARCHIVED`

### Rechtlicher Zustand

- `LEGAL`
- `UNREGISTERED`
- `REPORTED_STOLEN`
- `IMPOUNDED`
- `SEIZED`
- `REPOSSESSED`
- `EVIDENCE_HOLD`

### Vertragszustand

- eigenes Fahrzeug ohne Vertrag
- aktiv vermietet
- finanziert
- Händlerbestand
- staatlich zugewiesen
- Jobfahrzeug

So kann ein Fahrzeug beispielsweise gleichzeitig beschädigt, als gestohlen gemeldet und aktiv gespawnt sein.

## 9.5 Fahrzeugdefinitionen

Eine Fahrzeugdefinition beschreibt einen Modelltyp und enthält:

- technischer Modellname;
- sichtbare Bezeichnung;
- Hersteller;
- Fahrzeugklasse;
- Fahrzeugart;
- Kauf- und Basispreis;
- zulässige Händler;
- Sitzplätze;
- Leergewicht;
- Kofferraumkapazität;
- Tankgröße und Kraftstoffart;
- Anhängelast;
- erlaubte Trailerarten;
- benötigte Lizenz;
- mögliche Modifikationen;
- Wartungsgrundwerte;
- aktiv oder deaktiviert.

Nur serverseitig registrierte und aktivierte Fahrzeugdefinitionen können dauerhaft gekauft oder gemietet werden.

## 9.6 Fahrzeugarten

- Pkw
- Motorrad
- Transporter
- LKW-Zugmaschine
- Tankfahrzeug
- Bus
- Einsatzfahrzeug
- landwirtschaftliches Fahrzeug
- Arbeitsmaschine
- Anhänger und Trailer
- Boot
- später gegebenenfalls Luftfahrzeug

Fahrzeugklasse, Eigentum, Lizenzanforderung und Nutzung bleiben voneinander getrennt.

## 9.7 Fahrzeugkauf

Möglicher Kaufablauf:

1. Händlerangebot auswählen.
2. Bestand und Preis serverseitig prüfen.
3. Käufer und mögliche Firmenberechtigung prüfen.
4. Zahlungsbetrag über `cnr_banking` reservieren.
5. Fahrzeugdatensatz und VIN erzeugen.
6. Zulassung und Kennzeichen anlegen.
7. Eigentum eintragen.
8. Zahlung endgültig buchen.
9. Fahrzeugschlüssel und Dokumente ausstellen.
10. Fahrzeug ausliefern oder in einer Abholgarage bereitstellen.

Schlägt ein Schritt fehl, werden Reservierung und unvollständige Datensätze kontrolliert zurückgerollt.

Eine Fahrerlaubnis ist keine Voraussetzung für den Besitz eines Fahrzeugs. Sie ist jedoch für die legale Nutzung im Straßenverkehr erforderlich.

## 9.8 Händler und Fahrzeugbestände

Mögliche Händlertypen:

- öffentlicher Basishändler;
- Gebrauchtwagenhändler;
- Nutzfahrzeughändler;
- Motorradhandel;
- staatlicher Fuhrpark;
- Spielerunternehmen;
- Spezial- oder Importhändler.

Händler können besitzen:

- tatsächlichen Bestand;
- Lieferzeiten;
- Mindest- und Höchstpreise;
- Einkaufskosten;
- Ausstellungsfahrzeuge;
- Probefahrzeuge;
- Verkaufsprovisionen;
- konfigurierbare Öffnungszeiten.

Für den MVP stellt ein kontrollierter NPC-Händler eine Grundversorgung sicher. Später können Spielerhändler echte Bestände und Lieferketten verwalten.

## 9.9 Gebrauchtfahrzeuge und Eigentumsübertragung

Ein Eigentumswechsel benötigt einen Kauf- oder Übertragungsvertrag.

Vor Abschluss werden geprüft:

- aktueller Eigentümer;
- Verkaufsberechtigung;
- aktiver Kredit oder Pfand;
- Beschlagnahmung oder Fahndung;
- aktiver Mietvertrag;
- offene Eigentumssperre;
- Fahrzeugidentität;
- Kaufpreis und Zahlungsreservierung.

Nach Abschluss werden gespeichert:

- alter und neuer Eigentümer;
- Kaufpreis;
- Kilometerstand;
- Fahrzeugzustand;
- bekannte Schäden;
- Vertragsreferenz;
- Zeitpunkt;
- übertragene oder entzogene Zugriffsrechte.

Die Eigentumshistorie wird niemals gelöscht.

## 9.10 Finanzierung

Eine Fahrzeugfinanzierung kann enthalten:

- Fahrzeugpreis;
- Anzahlung;
- finanzierter Betrag;
- Zinssatz;
- Laufzeit;
- Ratenplan;
- Fälligkeit;
- Karenzzeit;
- Restschuld;
- finanzierendes Institut;
- Fahrzeug als Sicherheit.

Während einer aktiven Finanzierung:

- bleibt das Fahrzeug nutzbar;
- darf es nicht ohne Freigabe verkauft werden;
- ist die Finanzierung in der Eigentumsakte sichtbar;
- können versäumte Raten Mahnungen auslösen;
- kann das Fahrzeug nach geregeltem Prozess zurückgenommen werden.

Finanzierung ist nicht Teil des ersten MVP, wird aber im Datenmodell vorbereitet.

## 9.11 Fahrzeugmiete

Ein Mietvertrag enthält:

- Vermieter;
- Mieter;
- Fahrzeug;
- erlaubte Fahrer;
- Mietbeginn und Mietende;
- Grundpreis;
- Kaution;
- enthaltene Kilometer;
- Mehrkilometerpreis;
- Kraftstoffregel;
- Ausgangszustand;
- Rückgabeort;
- Verspätungsregeln;
- Schadensregeln;
- Vertragsstatus.

Mögliche Statuswerte:

- `DRAFT`
- `RESERVED`
- `ACTIVE`
- `OVERDUE`
- `RETURN_PENDING`
- `COMPLETED`
- `CANCELLED`
- `DEFAULTED`

Der Mietvertrag bleibt bei Disconnect oder Serverneustart bestehen.

## 9.12 Mietkaution und Abrechnung

Die Kaution wird über `cnr_banking` reserviert und nicht sofort als gewöhnliche Zahlung abgezogen.

Rückgabeablauf:

1. Fahrzeug und Vertrag identifizieren.
2. Rückgabeort prüfen.
3. Kilometerstand vergleichen.
4. Kraftstoffstand prüfen.
5. neue Schäden feststellen.
6. Verspätung berechnen.
7. berechtigte Kosten aus der Kaution einziehen.
8. Restbetrag freigeben.
9. Mietzugriffe entfernen.
10. Fahrzeug zurück in den Vermieterbestand überführen.

Ausgangs- und Rückgabezustand werden getrennt gespeichert, damit Schäden nachvollziehbar bleiben.

## 9.13 Jobbezogene Vermietung

Für den Einstieg in die Wirtschaft können Fahrzeuge jobbezogen gemietet werden.

Beispiel Ölförderung:

- Zugmaschine separat mieten;
- passenden Tanktrailer separat mieten;
- benötigte Lizenzen prüfen;
- Kaution reservieren;
- Auftrag oder Vertragsreferenz hinterlegen;
- Mietkosten später mit Auftragserlös verrechnen;
- Fahrzeug und Trailer nach Abschluss getrennt zurückgeben.

Ein Jobfahrzeug wird nicht automatisch Eigentum des Spielers. Mietverträge können zeitlich oder auftragsbezogen gelten.

## 9.14 Trailer und Anhänger

Trailer sind vollwertige Fahrzeuge mit eigener Identität.

Sie besitzen:

- eigene Fahrzeug-ID und VIN;
- optional eigenes Kennzeichen;
- eigenen Eigentümer;
- eigenen Miet- oder Finanzierungsvertrag;
- Fahrzeugtyp;
- maximale Ladungsmenge;
- zulässige Ladungsarten;
- Leergewicht;
- Achs- und Reifenzustand;
- eigenen Standort und Garagenstatus;
- Kompatibilität mit Zugmaschinen;
- eigene Schadenshistorie.

Mögliche Trailerarten:

- Tanktrailer
- Kühltrailer
- geschlossener Trailer
- Pritsche
- Tieflader
- Containerchassis
- Fahrzeugtransporter
- Gefahrguttrailer

Zugmaschine, Trailer und Ladung bleiben drei getrennte Objekte.

## 9.15 Fahrzeugzugriff und Schlüssel

Ein Schlüssel ist ein Zugangsnachweis und kein Eigentumsnachweis.

Mögliche Zugriffsrollen:

- Eigentümer;
- Miteigentümer;
- dauerhaft berechtigter Fahrer;
- Firmenmitarbeiter;
- temporärer Mieter;
- Werkstattmitarbeiter;
- Abschleppdienst;
- Polizei im Rahmen einer Maßnahme.

Zugriffsrechte können erlauben:

- aufschließen;
- Motor starten;
- Kofferraum öffnen;
- Trailer ankoppeln;
- Fahrzeug einlagern;
- Zugriffe weitergeben;
- Fahrzeug verwalten.

Physische oder digitale Schlüsselitems verweisen nur auf einen serverseitigen Zugriffsdatensatz.

## 9.16 Gestohlene Schlüssel und Fahrzeugdiebstahl

- Ein gestohlener Schlüssel kann Zugang ermöglichen.
- Er überträgt kein Eigentum.
- Schlüssel können gesperrt oder Fahrzeugschlösser neu codiert werden.
- Hotwiring kann einen temporären Motorzugriff erzeugen.
- Manipulation kann Spuren und Schäden hinterlassen.
- Diebstahlstatus und Eigentum bleiben getrennt.
- gestohlene Fahrzeuge können zur Fahndung ausgeschrieben werden.
- Kennzeichenwechsel entfernt die VIN-Fahndung nicht.

Später können Schlüsselkopien, elektronische Angriffe, Wegfahrsperren und Alarmanlagen ergänzt werden.

## 9.17 Spawn- und Persistenzsystem

Für jedes dauerhafte Fahrzeug darf nur eine aktive Entity existieren.

Geplante Schutzmechanismen:

- `spawn_session_uuid`;
- serverseitige Spawn-Sperre;
- aktive Entity-Referenz;
- Heartbeat beziehungsweise Zustandslease;
- Versionsprüfung;
- kontrollierte Freigabe beim Einlagern;
- Wiederherstellung nach Ressourcenrestart;
- Bereinigung verwaister Entities.

Vor jedem Spawn wird geprüft:

- Fahrzeug existiert;
- Fahrzeug ist nicht bereits aktiv;
- Benutzer besitzt Zugriff;
- Garage oder Abholort ist gültig;
- Spawnpunkt ist frei;
- Fahrzeug ist nicht beschlagnahmt oder zerstört;
- Miet- oder Jobvertrag erlaubt die Nutzung.

Netzwerk-IDs werden niemals zur dauerhaften Duplikaterkennung verwendet.

## 9.18 Speicherung des Fahrzeugzustands

Gespeichert werden unter anderem:

- Position bei aktiv geparkten Fahrzeugen;
- Garage oder Stellplatz;
- Kraftstoffmenge;
- Kilometerstand;
- Motorzustand;
- Karosseriezustand;
- Reifenzustände;
- Verschmutzung;
- Türen und Fenster;
- Modifikationen;
- angekoppelter Trailer;
- Zustandsversion;
- letzter Fahrer;
- letzter Speicherzeitpunkt.

Der Zustand wird bei wichtigen Übergängen und in kontrollierten Intervallen gespeichert, nicht bei jedem Frame.

Nach einem Serverneustart können aktive Fahrzeuge abhängig von Konfiguration und Zustand am letzten sicheren Standort wiederhergestellt oder in eine Wiederherstellungsgarage gebracht werden.

## 9.19 Parken und Einlagern

Parken und Einlagern sind unterschiedliche Vorgänge.

### Parken

- Fahrzeug bleibt als Weltobjekt bestehen;
- Position wird gespeichert;
- Fahrzeug kann gefunden, gestohlen oder abgeschleppt werden;
- es belegt keinen virtuellen Garagenslot, aber realen Raum.

### Einlagern

- Fahrzeug wird kontrolliert aus der Welt entfernt;
- Zustand wird vollständig gespeichert;
- Fahrzeug befindet sich in einer Garage oder einem Depot;
- Zugriff erfolgt über den entsprechenden Garagenprozess.

Dadurch kann ein Spieler sein Fahrzeug nicht beliebig aus der Welt verschwinden lassen, um einer Kontrolle, Verfolgung oder Beschädigung zu entgehen.

## 9.20 Garagentypen

- öffentliche Garage
- Wohnhausgarage
- Firmen- oder Betriebshof
- LKW-Depot
- Trailerstellplatz
- Jobgarage
- Vermietungsdepot
- Händlerlager
- Werkstatt
- Polizeiverwahrung
- Asservatengelände
- Abschlepphof
- Wiederherstellungsgarage

## 9.21 Garagen und Stellplätze

Eine Garage besitzt:

- Position und Einfahrtszone;
- Ausfahrt beziehungsweise Spawnpunkte;
- Besitzer oder Betreiber;
- Zugriffsregeln;
- Kapazität;
- unterstützte Fahrzeugklassen;
- separate Trailerplätze;
- Miet- oder Nutzungskosten;
- Öffnungszeiten optional;
- Einlagerungsregeln;
- Status.

Ein kleiner Wohnstellplatz kann keinen Tanktrailer aufnehmen. Fahrzeuggröße und Stellplatztyp werden geprüft.

## 9.22 Remote-Rückholung

Fahrzeuge können nicht kostenlos an jede beliebige Garage teleportiert werden.

Mögliche Rückholoptionen:

- Abschleppauftrag an Spielerunternehmen;
- NPC-Notabschleppung gegen höhere Gebühr;
- Fahrzeuglieferdienst;
- Wiederherstellung nach technischem Fehler;
- administrative Wiederherstellung mit Begründung.

Die Rückholung besitzt Kosten, Dauer und Protokollierung. Aktive Verfolgungen, Beschlagnahmungen oder Mietverstöße blockieren sie.

## 9.23 Fahrzeugzustand und Schäden

Für den mittleren Realismusgrad werden zunächst folgende Werte verwendet:

- Motorzustand;
- Karosseriezustand;
- Reifen pro Achse oder Rad;
- Kraftstoffstand;
- allgemeiner Verschleiß;
- Kilometerstand.

Spätere Erweiterungen:

- Batterie;
- Bremsen;
- Getriebe;
- Öl und Flüssigkeiten;
- Kühlung;
- elektrische Systeme;
- einzelne Fahrzeugkomponenten.

Schäden werden nachvollziehbar aus Fahrzeugzustand und Ereignissen abgeleitet. Zufällige Totalausfälle ohne Warnung werden vermieden.

## 9.24 Wartung und Reparatur

Wartung basiert auf:

- Kilometerstand;
- Betriebsstunden;
- Fahrzeugklasse;
- transportiertem Gewicht;
- Fahrverhalten;
- Kollisionen;
- vorherigen Schäden;
- Wartungsintervallen.

Reparaturen benötigen abhängig vom Schaden:

- Ersatzteile;
- Werkzeug;
- Mechanikerfähigkeit;
- Arbeitszeit;
- Werkstattzugang;
- Bezahlung oder Firmenfreigabe.

Ein Reparaturvorgang setzt nicht pauschal alle Fahrzeugwerte auf den Maximalwert. Jede reparierte Komponente wird nachvollziehbar erfasst.

## 9.25 Wartungshistorie

Gespeichert werden:

- Fahrzeug;
- Werkstatt;
- Mechaniker;
- Kilometerstand;
- festgestellte Probleme;
- ausgeführte Arbeiten;
- verwendete Teile;
- Kosten;
- Zeitpunkt;
- Ergebnis und Restmängel.

Die Historie kann Kaufpreise, Versicherungen und technische Kontrollen beeinflussen.

## 9.26 Kraftstoff und Ladung

Fahrzeugkraftstoff und transportierte Flüssigkeit sind getrennte Bestände.

Beispiel Tanklastzug:

- Zugmaschine besitzt einen Dieseltank für den eigenen Motor.
- Tanktrailer besitzt eine Ladung aus Rohöl, Benzin oder Diesel.
- Fahrzeugverbrauch verändert niemals automatisch die Trailerladung.
- Trailerladung wird als `cargo lot` mit Menge, Qualität und Herkunft geführt.

Kraftstoffverbrauch kann berücksichtigen:

- Fahrzeugdefinition;
- Geschwindigkeit;
- Beschleunigung;
- Gewicht;
- Anhänger;
- Motorzustand;
- Fahrstil.

## 9.27 Zulassung und Kennzeichen

Eine Fahrzeugzulassung enthält:

- VIN;
- Kennzeichen;
- Halter;
- Fahrzeugklasse;
- Zulassungsstatus;
- Ausstellungsdatum;
- Ablaufdatum optional;
- zuständige Behörde;
- Steuerstatus;
- technische Einschränkungen.

Mögliche Zustände:

- `ACTIVE`
- `EXPIRED`
- `SUSPENDED`
- `REVOKED`
- `UNREGISTERED`

Ein abgelaufenes oder fehlendes Dokument verhindert nicht zwangsläufig das Fahren, macht die Nutzung aber illegal und kann Versicherungsschutz beeinflussen.

## 9.28 Modifikationen

Persistente Modifikationen können umfassen:

- Farbe;
- Felgen;
- Fahrwerk;
- Motor- und Bremskomponenten;
- Beleuchtung;
- Kennzeichen;
- Kofferraumerweiterungen;
- Anhängerkupplung;
- Firmenlackierungen;
- Sicherheitsausstattung;
- illegale Leistungsmodifikationen.

Jede Modifikation besitzt:

- technische Kompatibilität;
- Kosten;
- benötigte Teile;
- Einbauvoraussetzungen;
- mögliche Zulassungspflicht;
- Auswirkungen auf Zustand und Leistung.

## 9.29 Versicherung

Versicherungen sind für eine spätere Ausbaustufe vorgesehen.

Mögliche Policen:

- Haftpflicht;
- Teilkasko;
- Vollkasko;
- gewerbliche Versicherung;
- Mietwagenversicherung;
- Frachtversicherung.

Eine Police kann Prämie, Selbstbeteiligung, Deckung, Ausschlüsse, Laufzeit und Schadenshistorie besitzen.

Versicherungen ersetzen Fahrzeuge nicht automatisch. Ein Schadensfall benötigt Prüfung, mögliche Selbstbeteiligung und Schutz vor Versicherungsbetrug.

## 9.30 Abschleppen, Verwahrung und Beschlagnahmung

Mögliche Gründe:

- Falschparken;
- Verkehrsbehinderung;
- Unfall;
- verlassenes Fahrzeug;
- Polizeimaßnahme;
- Beweismittel;
- gestohlenes Fahrzeug;
- Kreditrückstand;
- abgelaufener Mietvertrag.

Ein Verwahrdatensatz enthält:

- Fahrzeug;
- Grund;
- einliefernde Person oder Organisation;
- Verwahrort;
- Zeitpunkt;
- Beweis- oder Fallreferenz;
- Freigabebedingungen;
- frühestes Freigabedatum;
- Gebühren;
- Status.

Ein Fahrzeug im `EVIDENCE_HOLD` kann nicht allein durch Zahlung freigegeben werden.

## 9.31 Diebstahlanzeige und Fahndung

Ein berechtigter Halter kann ein Fahrzeug als gestohlen melden.

Die Meldung kann enthalten:

- Fahrzeug und VIN;
- Kennzeichen zum Meldezeitpunkt;
- letzter bekannter Standort;
- Zeitpunkt;
- meldende Person;
- bekannte Fahrer;
- Beschreibung;
- Polizeivorgang.

Kennzeichen- und VIN-Fahndungen bleiben getrennt. Ein gefälschtes Kennzeichen kann eine Sichtkontrolle erschweren, entfernt aber nicht die zugrunde liegende Fahrzeugidentität.

## 9.32 Benutzeroberflächen

### Fahrzeugübersicht

- eigene und berechtigte Fahrzeuge;
- Standortstatus;
- Garage;
- Kraftstoff;
- Zustand;
- Kilometerstand;
- Zulassung;
- Miet- oder Finanzierungsstatus;
- Schlüssel und Fahrerrechte.

### Händler

- Fahrzeugkatalog;
- Bestand;
- Preis;
- technische Daten;
- Probefahrt;
- Kauf und Finanzierung;
- Lieferstatus.

### Vermietung

- verfügbare Fahrzeuge und Trailer;
- Mietdauer;
- Kaution;
- Kilometerregeln;
- erlaubte Fahrer;
- Zustandsprotokoll;
- Rückgabe.

### Garage und Verwahrung

- eingelagerte Fahrzeuge;
- passende Stellplätze;
- Auslagerung;
- Gebühren;
- Rückholauftrag;
- Freigabebedingungen.

Alle Oberflächen verwenden `cnr_ui`.

## 9.33 Vorgesehene Tabellen

- `cnr_vehicle_definitions`
- `cnr_vehicles`
- `cnr_vehicle_ownership_history`
- `cnr_vehicle_access`
- `cnr_vehicle_keys`
- `cnr_vehicle_state_snapshots`
- `cnr_vehicle_components`
- `cnr_vehicle_modifications`
- `cnr_vehicle_service_records`
- `cnr_vehicle_registrations`
- `cnr_vehicle_insurance_policies`
- `cnr_vehicle_financing_contracts`
- `cnr_vehicle_rental_contracts`
- `cnr_vehicle_rental_inspections`
- `cnr_garages`
- `cnr_garage_spaces`
- `cnr_vehicle_storage_events`
- `cnr_impound_records`
- `cnr_dealerships`
- `cnr_dealership_stock`
- `cnr_vehicle_theft_reports`

## 9.34 Sicherheit und Schutz vor Duplizierung

- Fahrzeugmodelle nur aus serverseitigen Definitionen
- Eigentum niemals anhand des Kennzeichens bestimmen
- nur eine aktive Entity pro dauerhaftem Fahrzeug
- serverseitige Spawn-Sperren
- eindeutige `spawn_session_uuid`
- Käufe, Mieten und Übertragungen mit `operation_uuid`
- atomare Verbindung mit Zahlungen und Verträgen
- serverseitige Zugriffs- und Entfernungsprüfung
- validierte Zustandsübergänge
- keine vertrauenswürdigen Schadens-, Kilometer- oder Tankwerte direkt vom Client
- vollständige Eigentums- und Zugriffslogs
- Wiederherstellung verwaister Spawnzustände
- administrative Fahrzeugerzeugung nur mit Berechtigung und Grund

## 9.35 Control-Panel-Konfiguration

Dynamisch einstellbar:

- Fahrzeugdefinitionen;
- Klassen und Typen;
- Kauf- und Basispreise;
- Händlerbestände;
- Lieferzeiten;
- Tank- und Kofferraumkapazitäten;
- Anhängelasten und Trailerkompatibilität;
- Mietpreise und Kautionen;
- Kilometer- und Verspätungsgebühren;
- Kraftstoffregeln;
- Wartungsintervalle;
- Verschleißfaktoren;
- Garagenkapazitäten;
- Stellplatztypen;
- Verwahrgebühren;
- Rückholkosten;
- Zulassungs- und Steuerregeln;
- erlaubte Modifikationen;
- Restart- und Wiederherstellungsverhalten.

Über den Ingame-Editor können Händler, Mietstationen, Garagen, Depots, Stellplätze, Abschlepphöfe und Auslieferungsorte erstellt werden.

## 9.36 MVP-Umfang

- dauerhafte Fahrzeugidentität mit VIN;
- Charakter- und Firmeneigentum;
- NPC-Basishändler;
- Fahrzeugkauf;
- Eigentumshistorie;
- Zugriffs- und Schlüsselsystem;
- genau eine aktive Entity;
- Parken und Einlagern;
- öffentliche und Firmen-Garagen;
- Zugmaschinen und Trailer als getrennte Fahrzeuge;
- Fahrzeug- und Trailermiete;
- Kaution und Rückgabeprüfung;
- jobbezogene Vermietung für die Öllieferkette;
- Kilometerstand;
- Kraftstoff;
- grundlegende Motor-, Karosserie- und Reifenschäden;
- einfache Wartungshistorie;
- Zulassung und Kennzeichen;
- Abschlepphof und Polizeiverwahrung;
- Diebstahlanzeige;
- vollständige Auditierung.

Nicht im ersten MVP:

- komplexe Finanzierung;
- umfassende Versicherungen;
- Spieler-Fahrzeugproduktion;
- vollständige Komponentenphysik;
- Luftfahrzeuge;
- tiefes Tuning- und Homologationssystem.

---

# 10. Öl- und Kraftstoffwirtschaft

## 10.1 Förderung

- Öl-Farmer-Job oder Lizenz
- gemieteter oder gekaufter LKW
- gemieteter oder gekaufter Tanktrailer
- Pumpenausrüstung
- Fördergeschwindigkeit und Ertrag abhängig von Fähigkeiten
- Maschinenverschleiß und mögliche Defekte
- Qualität und Chargenverfolgung

## 10.2 Lagerung

- mobile Tanks
- gemietete Lager
- gekaufte Lager
- Kapazitätsgrenzen
- Gebühren
- Zugriffsrechte
- Versicherung und Sicherheit
- Ein- und Auslagerungsprotokolle

## 10.3 Raffinerie

- öffentliche Verarbeitung gegen Gebühr
- mietbare oder kaufbare Raffinerie
- Produktionsaufträge
- Produktionsdauer
- Energieverbrauch
- Wartung und Ausfälle
- verschiedene Qualitätsstufen
- Benzin, Diesel, Kerosin, Heizöl, Schmiermittel, Bitumen und Nebenprodukte

## 10.4 Tankstellen

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

# 11. Weitere geplante Systeme

## 11.1 Legale Berufe

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

## 11.2 Unternehmen

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

## 11.3 Lager und Immobilien

- mietbare und kaufbare Lager
- Gefahrgut- und Kühllager
- Lagergebühren und Sicherheit
- Mietwohnungen und Häuser
- Möbel, Kleiderschrank und Hauslager
- Schlüssel und Mitbewohner
- Mietverträge, Nebenkosten und Hypotheken
- Einbruch und Alarmanlagen

## 11.4 Kriminalität

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

## 11.5 Polizeisystem

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

## 11.6 Beweissystem

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

---

# 12. Dynamische Administration

## 12.1 Ingame-Editor

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

## 12.2 Externes Control Panel

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

# 13. Einheitliches UI-System

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

# 14. Sicherheitsgrundsätze

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

# 15. Aktuelle verbindliche Entscheidungen

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
| Finanzmodell | doppeltes Hauptbuch mit ausgeglichenen Buchungen |
| Bargeld | serverseitige Geldbörse innerhalb des Hauptbuchs |
| illegales Geld | physische Chargen mit Herkunft statt `black_money` |
| Korrekturen | Gegenbuchung statt Löschen gebuchter Transaktionen |
| globales Charakterlevel | nein; getrennte Fähigkeiten |
| Fähigkeitslevel | standardmäßig 20, pro Fähigkeit konfigurierbar |
| Spezialisierungen | begrenzte Auswahl mit Umspezialisierung |
| Ruf | getrennt nach Organisation oder Branche |
| Lizenzen | rechtliche Erlaubnis, getrennt von Fähigkeit und Jobrang |
| Fähigkeitsverlust | kein Verlust durch Tod oder Haft |
| Echtgeldboosts | keine kaufbare Erfahrung oder Gameplay-Vorteile |
| Fahrzeugidentität | dauerhafte VIN und UUID, niemals Kennzeichen oder Netzwerk-ID |
| aktive Fahrzeuge | maximal eine Entity pro dauerhaftem Fahrzeug |
| Trailer | eigenständige Fahrzeuge mit Eigentum, Zustand und Vertrag |
| Schlüssel | Zugriffsrecht, kein Eigentumsnachweis |
| Parken und Einlagern | getrennte Vorgänge |
| Fahrzeugmiete | persistenter Vertrag mit Kaution und Zustandsvergleich |
| Fahrzeugrealismus | Kilometer, Kraftstoff sowie grundlegender Verschleiß und Schaden |
| Remote-Rückholung | nur als kostenpflichtiger und protokollierter Dienst |
| Codesprache | Englisch |
| UI-Sprache | zunächst Deutsch, vollständig übersetzbar |

## Nächster Planungsschritt

Als Nächstes wird das Unternehmens-, Mitarbeiter-, Vertrags- und Auftragssystem geplant. Dazu gehören Firmengründung, Rollen, Firmenkonten, Mitarbeiter, Löhne, Lager, Fuhrpark, Lieferverträge, Ausschreibungen und Insolvenzregeln.
