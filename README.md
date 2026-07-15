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
- `cnr_facilities`
- `cnr_businesses`
- `cnr_employment`
- `cnr_contracts`
- `cnr_marketplace`
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

# 10. Unternehmens-, Mitarbeiter-, Vertrags- und Auftragssystem

## 10.1 Verantwortliche Module

### `cnr_businesses`

Verantwortet:

- Unternehmensidentität;
- Gründung und Status;
- Eigentümer und Beteiligungen;
- interne Rollen und Rechte;
- Standorte und Niederlassungen;
- Firmenvermögen;
- Lizenzen;
- Unternehmenshistorie.

### `cnr_employment`

Verantwortet:

- Arbeitsverträge;
- Mitarbeiterstatus;
- Positionen und Rollen;
- Arbeitszeiterfassung;
- Lohnmodelle;
- Lohnabrechnungen;
- Kündigung und Freistellung.

### `cnr_contracts`

Verantwortet:

- gewerbliche Verträge;
- Vertragspartner;
- Leistungen und Waren;
- Preise und Zahlungsbedingungen;
- Laufzeiten;
- Meilensteine;
- Vertragsänderungen;
- Vertragsverletzungen und Streitfälle.

### `cnr_marketplace`

Verantwortet:

- öffentliche und private Aufträge;
- Ausschreibungen;
- Angebote;
- Vergabe;
- Auftragsstatus;
- automatische Bedarfsaufträge;
- Bewertung der Vertragserfüllung.

## 10.2 Unternehmensidentität

Jedes Unternehmen erhält:

- interne Unternehmens-ID;
- öffentliche UUID;
- eindeutige Registrierungsnummer;
- rechtlichen Namen;
- optionalen Handelsnamen;
- Unternehmensform;
- Branche;
- Gründungsdatum;
- Gründer;
- aktuellen Status;
- Hauptsitz oder registrierte Anschrift;
- zuständige Lizenzen;
- Versionsnummer.

Unternehmensname, Handelsname und Registrierungsnummer werden getrennt behandelt. Eine Namensänderung verändert nicht die dauerhafte Unternehmensidentität.

## 10.3 Unternehmensformen

Die genauen Bezeichnungen können an das fiktive San-Andreas-Recht angepasst werden.

Geplante Grundformen:

- Einzelunternehmen;
- Personengesellschaft;
- Kapitalgesellschaft;
- gemeinnützige Organisation;
- staatliches Unternehmen;
- öffentliche Behörde;
- kriminelle oder nicht registrierte Organisation als getrennte Struktur.

Für den MVP werden Einzelunternehmen und eine einfache Gesellschaftsform priorisiert. Das System soll wirtschaftliche Unterschiede ermöglichen, aber keine unnötig komplizierte reale Rechtsberatung simulieren.

## 10.4 Unternehmensstatus

- `DRAFT`
- `PENDING_REGISTRATION`
- `ACTIVE`
- `RESTRICTED`
- `SUSPENDED`
- `AT_RISK`
- `INSOLVENT`
- `IN_LIQUIDATION`
- `CLOSED`
- `ARCHIVED`

Ein geschlossenes Unternehmen wird archiviert. Seine Transaktionen, Verträge, Mitarbeiter- und Eigentumsdaten bleiben nachvollziehbar.

## 10.5 Unternehmensgründung

Möglicher Ablauf:

1. Unternehmensform und Branche auswählen.
2. Unternehmensname prüfen und reservieren.
3. Gründer und mögliche Beteiligte festlegen.
4. erforderliches Startkapital nachweisen.
5. Gründungsgebühr über `cnr_banking` reservieren.
6. benötigte Lizenzen und Voraussetzungen prüfen.
7. Satzung beziehungsweise Gründungsdaten bestätigen.
8. Unternehmen und Registrierungsnummer erzeugen.
9. Firmenkonto anlegen.
10. Eigentümer, Geschäftsführung und Standardrollen eintragen.
11. Gebühr buchen und Unternehmen aktivieren.

Alle Schritte erfolgen kontrolliert. Bei einem Fehler entstehen weder halbfertige Firmen noch verlorene Gründungszahlungen.

## 10.6 Persönliches und geschäftliches Vermögen

Unternehmensvermögen gehört dem Unternehmen und nicht automatisch dem Charakter des Eigentümers.

Getrennt werden:

- persönliches Bankkonto;
- Firmenkonto;
- persönliche Fahrzeuge;
- Firmenfahrzeuge;
- private Immobilien;
- Unternehmensstandorte;
- privates Inventar;
- Firmenlager;
- persönliche und geschäftliche Verträge.

Ein Eigentümer darf Firmengeld nicht ohne Buchungsgrund in Privatvermögen umwandeln.

Legale Wege zur privaten Auszahlung:

- Gehalt;
- Auslagenerstattung;
- dokumentierte Gewinnausschüttung;
- Rückzahlung eines Gesellschafterdarlehens;
- Verkauf eines privaten Vermögenswertes an die Firma;
- andere definierte und auditierte Buchung.

## 10.7 Eigentümer und Beteiligungen

Ein Unternehmen kann einen oder mehrere Eigentümer besitzen.

Eine Beteiligung enthält:

- Unternehmen;
- Charakter oder berechtigte Organisation;
- Anteil in Basispunkten;
- Stimmrecht;
- Beginn und Ende;
- Erwerbsgrund;
- Kaufpreis oder Einlage;
- Vertragsreferenz.

Alle Anteile ergeben zusammen 10.000 Basispunkte beziehungsweise 100 Prozent.

Eine Beteiligung verleiht nicht automatisch jede operative Berechtigung. Eigentum, Geschäftsführung und Mitarbeiterrolle bleiben getrennt.

Komplexer Anteilshandel ist nicht Teil des ersten MVP, wird aber im Datenmodell vorbereitet.

## 10.8 Interne Rollen und Rechte

Beispielrollen:

- Eigentümer;
- Geschäftsführung;
- Finanzleitung;
- Personalverwaltung;
- Disposition;
- Lagerleitung;
- Fuhrparkleitung;
- Niederlassungsleitung;
- Mitarbeiter;
- Auszubildender;
- externer Dienstleister;
- Nur-Lesen-Zugriff.

Mögliche Berechtigungen:

- `business.view`
- `business.settings.manage`
- `business.members.view`
- `business.members.hire`
- `business.members.terminate`
- `business.roles.manage`
- `business.finance.view`
- `business.finance.pay`
- `business.payroll.approve`
- `business.storage.access`
- `business.storage.manage`
- `business.fleet.use`
- `business.fleet.manage`
- `business.contracts.create`
- `business.contracts.sign`
- `business.orders.assign`

Unternehmen können eigene Rollen aus freigegebenen Berechtigungen zusammenstellen. Sicherheitskritische Rechte benötigen zusätzliche Einschränkungen.

## 10.9 Niederlassungen und Abteilungen

Ein Unternehmen kann mehrere Standorte besitzen:

- Hauptsitz;
- Büro;
- Lager;
- Betriebshof;
- Werkstatt;
- Tankstelle;
- Raffinerie;
- Verkaufsstelle;
- Förderstelle;
- Niederlassung.

Mitarbeiter, Fahrzeuge, Lager und Budgets können einem Standort oder einer Abteilung zugeordnet werden.

Abteilungen können beispielsweise sein:

- Geschäftsführung;
- Finanzen;
- Personal;
- Einkauf;
- Verkauf;
- Produktion;
- Logistik;
- Wartung;
- Sicherheit.

## 10.10 Arbeitsverträge

Ein Arbeitsvertrag enthält:

- Unternehmen;
- Charakter;
- Position;
- zugewiesene Rolle;
- Arbeitsort oder Abteilung;
- Vertragsbeginn;
- optionales Vertragsende;
- Lohnmodell;
- Lohnhöhe;
- Probezeit optional;
- Arbeitszeitregeln;
- Kündigungsfrist;
- Vertragsstatus;
- unterzeichnende Personen.

Mögliche Statuswerte:

- `OFFERED`
- `PENDING_SIGNATURE`
- `ACTIVE`
- `SUSPENDED`
- `NOTICE_GIVEN`
- `TERMINATED`
- `EXPIRED`
- `CANCELLED`

Ein Charakter kann mehrere Arbeitsverhältnisse besitzen, sofern Verträge, Rollen und mögliche Interessenkonflikte dies erlauben.

## 10.11 Einstellung eines Mitarbeiters

1. berechtigte Person erstellt ein Angebot;
2. Position, Rechte und Lohn werden festgelegt;
3. Bewerber prüft den Vertrag;
4. beide Seiten bestätigen;
5. Arbeitsvertrag wird aktiv;
6. Rollen und Zugriffe werden erzeugt;
7. Firmenstandorte und Arbeitsmittel werden zugewiesen;
8. Vorgang wird protokolliert.

Ein Mitarbeiter erhält keine pauschalen Zugriffe nur aufgrund eines sichtbaren Jobnamens.

## 10.12 Lohnmodelle

Unterstützte Modelle:

- Stundenlohn;
- Festlohn pro Abrechnungsperiode;
- Vergütung pro abgeschlossenem Auftrag;
- Provision;
- Kombination aus Grundlohn und Provision;
- Auszubildenden- oder Praktikumsvergütung;
- unbezahlte Eigentümer- oder Ehrenamtsrolle.

Alle Löhne werden über `cnr_banking` aus einem Firmen- oder Staatskonto gebucht.

Bei unzureichendem Guthaben:

- entsteht keine Geldschöpfung;
- Zahlung erhält einen Fehler- oder Rückstandsstatus;
- Mitarbeiter erhält eine ausstehende Lohnforderung;
- Unternehmen und berechtigte Personen werden informiert;
- wiederholte Ausfälle können Unternehmensstatus und Ruf beeinflussen.

## 10.13 Arbeitszeiterfassung

Eine Arbeitssitzung enthält:

- Mitarbeiter;
- Unternehmen;
- Position;
- Startzeit;
- Endzeit;
- Pausen;
- Standort oder Auftrag;
- Aktivitätsstatus;
- Freigabestatus;
- Korrekturhistorie.

Arbeitszeit entsteht nicht allein dadurch, dass ein Spieler online ist.

Mögliche Prüfungen:

- Einstempeln an einem erlaubten Ort oder über eine freigegebene Funktion;
- aktive Auftrags- oder Tätigkeitszuordnung;
- automatische Pausen- oder Timeout-Erkennung;
- kontrolliertes Ausstempeln bei Disconnect;
- maximale plausible Schichtdauer;
- Freigabe auffälliger Zeiten durch Vorgesetzte;
- vollständige Historie manueller Korrekturen.

## 10.14 Lohnabrechnung

Eine Lohnabrechnung verarbeitet:

- freigegebene Arbeitszeit;
- Festlohn;
- Auftragsvergütung;
- Provision;
- Zuschläge;
- Abzüge;
- Steuern;
- Vorschüsse;
- offene Forderungen;
- Nettobetrag.

Möglicher Ablauf:

1. Abrechnungsperiode schließen.
2. Arbeitszeiten und Aufträge prüfen.
3. Bruttolohn berechnen.
4. Steuer und Abzüge berechnen.
5. Firmenliquidität prüfen.
6. Lohnzahlungen als zusammengehörigen Payroll-Vorgang buchen.
7. Lohnabrechnungen ausstellen.
8. Fehler und Rückstände melden.

## 10.15 Firmenkonten und Budgets

Firmenkonten werden durch `cnr_banking` geführt. Das Unternehmensmodul liefert die fachlichen Rollen und Berechtigungen.

Mögliche Funktionen:

- Hauptkonto;
- Lohnkonto;
- Steuerkonto;
- Standortkonto;
- Projektbudget;
- Ausgabenlimit;
- Vier-Augen-Freigabe;
- Kostenstellen;
- Zahlungsreferenzen.

Das Unternehmen erhält Übersichten über:

- Umsatz;
- Wareneinkauf;
- Löhne;
- Mieten;
- Fahrzeuge;
- Wartung;
- Steuern;
- offene Rechnungen;
- Forderungen und Verbindlichkeiten;
- verfügbare und reservierte Beträge.

## 10.16 Firmenvermögen

Mögliche Unternehmenswerte:

- Bankkonten;
- Bargeldbestände;
- Fahrzeuge und Trailer;
- Immobilien;
- gemietete oder eigene Lager;
- Maschinen;
- Produktionsanlagen;
- Warenbestände;
- Lizenzen;
- Vertragsrechte;
- Forderungen;
- Marken- und Handelsnamen.

Vermögenswerte werden über die jeweiligen Fachmodule verwaltet und im Unternehmensdashboard zusammengeführt.

Ein Assetwechsel zwischen Charakter und Firma benötigt immer Kauf, Einlage, Ausschüttung oder einen anderen dokumentierten Vorgang.

## 10.17 Firmenfuhrpark

Firmenfahrzeuge werden `cnr_vehicles` zugeordnet.

Fuhrparkfunktionen:

- Fahrzeugübersicht;
- Standort und Garagenstatus;
- Fahrerzuweisung;
- temporäre Schlüssel;
- Schichtzugriffe;
- Kilometerstand;
- Kraftstoffkosten;
- Wartung und Schäden;
- Anhängerzuordnung;
- Miet- oder Finanzierungsstatus;
- Einsatzbereich;
- Stilllegung.

Mitarbeiterzugriffe können automatisch mit Schicht, Rolle oder Arbeitsvertrag beginnen und enden.

## 10.18 Firmenlager

Firmenlager werden durch `cnr_storage` und `cnr_inventory` geführt.

Unternehmensfunktionen:

- Lagerzuordnung;
- Mitarbeiterrechte;
- Wareneingang und Warenausgang;
- Mindest- und Höchstbestand;
- Reservierungen für Aufträge;
- Chargen und Qualität;
- Inventur;
- Bestandskorrekturen mit Grund;
- automatische Nachbestellung;
- Bewertung des Warenbestands.

Ein Unternehmensadministrator kann keinen Bestand ohne protokollierten Fachvorgang erzeugen.

## 10.19 Vertragstypen

Geplante gewerbliche Vertragstypen:

- Kaufvertrag;
- Liefervertrag;
- Rahmenvertrag;
- Dienstleistungsvertrag;
- Transportvertrag;
- Miet- oder Pachtvertrag;
- Wartungsvertrag;
- Lagervertrag;
- Subunternehmervertrag;
- exklusiver Abnahmevertrag;
- staatlicher Auftrag.

Arbeits-, Fahrzeugmiet- und Kreditverträge besitzen eigene Fachmodule, können aber auf gemeinsame Vertragsgrundlagen und Signaturen zurückgreifen.

## 10.20 Vertragsinhalt

Ein gewerblicher Vertrag enthält:

- Vertragsnummer;
- Vertragspartner;
- Vertragstyp;
- Waren oder Leistungen;
- Menge und Einheit;
- Qualitätsanforderungen;
- Preis oder Preisformel;
- Steuerregeln;
- Liefer- oder Leistungsort;
- Beginn und Ende;
- Fristen;
- Zahlungsbedingungen;
- Kaution oder Treuhand;
- Vertragsstrafen;
- Kündigungsregeln;
- erlaubte Subunternehmer;
- Signaturen;
- Versionsnummer.

## 10.21 Vertragsstatus

- `DRAFT`
- `OFFERED`
- `IN_NEGOTIATION`
- `PENDING_SIGNATURE`
- `ACTIVE`
- `FULFILLED`
- `BREACHED`
- `DISPUTED`
- `TERMINATED`
- `EXPIRED`
- `CANCELLED`

Ein unterzeichneter Vertrag wird nicht nachträglich überschrieben. Änderungen erfolgen durch eine neue Vertragsversion oder einen Nachtrag, den die betroffenen Parteien erneut bestätigen.

## 10.22 Digitale Signaturen

Eine Signatur enthält:

- Vertrag;
- Vertragsversion;
- unterzeichnender Charakter;
- vertretenes Unternehmen;
- verwendete Firmenberechtigung;
- Zeitpunkt;
- Signaturstatus;
- technische Bestätigung.

Eine Signatur ist nur gültig, wenn der Charakter zum Zeitpunkt der Unterzeichnung die erforderliche Vertretungsberechtigung besitzt.

Der spätere Verlust der Rolle macht bereits rechtmäßig abgeschlossene Verträge nicht automatisch ungültig.

## 10.23 Unterschied zwischen Vertrag und Auftrag

Ein Vertrag definiert die längerfristigen Regeln. Ein Auftrag ist ein konkreter ausführbarer Vorgang.

Beispiel:

- Liefervertrag: Eine Raffinerie darf zwölf Wochen Kraftstoff an eine Tankstelle liefern.
- Auftrag: Lieferung von 8.000 Litern Diesel bis Mittwoch um 18:00 Uhr.

Ein Rahmenvertrag kann viele einzelne Aufträge erzeugen.

## 10.24 Auftragstypen

- einmalige Lieferung;
- wiederkehrende Lieferung;
- Transportauftrag;
- Produktionsauftrag;
- Beschaffungsauftrag;
- Lagerumlagerung;
- Reparaturauftrag;
- Abschleppauftrag;
- Sicherheitsauftrag;
- staatlicher Auftrag;
- Notversorgungsauftrag.

## 10.25 Auftragsstatus

- `DRAFT`
- `PUBLISHED`
- `RESERVED`
- `ACCEPTED`
- `IN_PROGRESS`
- `PARTIALLY_DELIVERED`
- `DELIVERED`
- `UNDER_INSPECTION`
- `COMPLETED`
- `FAILED`
- `DISPUTED`
- `CANCELLED`
- `EXPIRED`

Statuswechsel erfolgen nur über erlaubte Übergänge und werden als Auftragsevents gespeichert.

## 10.26 Dynamische Bedarfsaufträge

Aufträge entstehen bevorzugt aus tatsächlichem Bedarf.

Beispiele:

- Tankstelle unterschreitet ihren Diesel-Mindestbestand.
- Raffinerie benötigt Rohöl.
- Werkstatt benötigt Ersatzteile.
- Lager besitzt zu viel Ware und benötigt eine Umlagerung.
- Unternehmen benötigt einen Abschleppdienst.
- staatliche Stelle schreibt eine Versorgung aus.

Ein Bedarfsauftrag enthält echte Zielmenge, Qualitätsanforderung, Zielort und verfügbares Budget.

Ist kein Spielerunternehmen verfügbar, kann eine teure oder weniger profitable NPC-Notversorgung einspringen.

## 10.27 Auftragsmarktplatz

Sichtbarkeitsarten:

- öffentlich;
- nur eingeladene Unternehmen;
- nur bestimmte Branchen;
- ab bestimmtem Ruf;
- mit bestimmter Lizenz;
- nur bestehende Vertragspartner;
- intern innerhalb eines Unternehmens.

Filtermöglichkeiten:

- Branche;
- Auftragstyp;
- Start- und Zielort;
- Ware;
- Menge;
- Frist;
- Vergütung;
- benötigte Fahrzeuge;
- Lizenzanforderung;
- Rufanforderung.

## 10.28 Ausschreibungen und Angebote

Eine Ausschreibung kann enthalten:

- Leistungsbeschreibung;
- Mengen und Qualitätswerte;
- Zeitraum;
- maximales Budget;
- erforderliche Lizenzen;
- Mindest-Ruf;
- Sicherheitsleistung;
- Bewertungskriterien;
- Angebotsfrist;
- öffentliche oder eingeladene Bieter.

Unternehmen reichen Angebote mit Preis, Lieferzeit, Kapazität und Bedingungen ein.

Mögliche Vergabearten:

- direkte Auswahl;
- niedrigster gültiger Preis;
- beste Gesamtbewertung;
- automatisch nach definierter Formel;
- verdeckte Angebote bis Fristende.

## 10.29 Auftragsannahme

Vor der Annahme werden geprüft:

- Unternehmen aktiv;
- Benutzer vertretungsberechtigt;
- Auftrag noch verfügbar;
- benötigte Lizenz vorhanden;
- ausreichender Ruf;
- Kapazität und mögliche Sicherheitsleistung;
- kein unzulässiger Interessenkonflikt;
- Auftrag nicht bereits exklusiv vergeben;
- Vertragsbedingungen bestätigt.

Ein Auftrag kann danach Mitarbeitern, Fahrzeugen, Trailern und Warenchargen zugewiesen werden.

## 10.30 Erfüllung und Abnahme

Bei einer Lieferung prüft der Server:

- Auftrag und Vertrag aktiv;
- richtige Quelle und richtiges Ziel;
- tatsächliches Fahrzeug und Trailer;
- tatsächliche Warencharge;
- Produktart;
- Menge;
- Qualität;
- Frist;
- Beschädigung oder Kontamination;
- berechtigte Fahrer und Mitarbeiter.

Teillieferungen sind möglich, wenn der Auftrag sie erlaubt.

Nach Lieferung folgt je nach Vertrag:

1. automatische oder manuelle Eingangskontrolle;
2. Annahme, Teilannahme oder Ablehnung;
3. Bestandsbuchung;
4. Rechnung oder automatische Zahlung;
5. Steuerbuchung;
6. Ruf- und Statistikänderung;
7. Abschluss des Auftrags.

## 10.31 Vertragsstrafen und Abweichungen

Mögliche Abweichungen:

- verspätete Lieferung;
- Unterlieferung;
- falsches Produkt;
- unzureichende Qualität;
- beschädigte Ware;
- fehlende Dokumente;
- unzulässiger Subunternehmer;
- Abbruch nach Annahme.

Automatische Vertragsstrafen sind nur zulässig, wenn sie vorab klar vereinbart wurden.

Mögliche Folgen:

- reduzierte Zahlung;
- Nachlieferung;
- Vertragsstrafe;
- Rückabwicklung;
- Rufverlust;
- Streitfall;
- Kündigung des Rahmenvertrags.

## 10.32 Streitfälle

Ein Streitfall enthält:

- Vertrag oder Auftrag;
- beteiligte Parteien;
- beanstandete Leistung;
- Belege und Ereignisse;
- Waren-, Fahrzeug- und Zahlungsdaten;
- Forderungen der Parteien;
- Status;
- Entscheidung oder Einigung.

Mögliche Lösungswege:

- direkte Einigung;
- vertraglich definierte Schlichtung;
- staatliche oder gerichtliche Entscheidung;
- administrative Korrektur nur bei technischem Fehler.

Administratoren sollen wirtschaftliche Rollenspielkonflikte nicht automatisch außerhalb des Spiels entscheiden.

## 10.33 Subunternehmer

Ein Vertrag kann Subunternehmer erlauben, begrenzen oder verbieten.

Bei erlaubter Weitergabe:

- Hauptauftragnehmer bleibt gegenüber dem Auftraggeber verantwortlich;
- Subauftrag erhält eigene Vergütung und Bedingungen;
- Waren- und Leistungskette bleibt nachvollziehbar;
- benötigte Lizenzen gelten weiterhin;
- versteckte Weitergabe kann als Vertragsverletzung gelten.

## 10.34 Unternehmensruf

Unternehmensruf ist vom persönlichen Ruf eines Eigentümers getrennt.

Bewertungsfaktoren:

- Vertragstreue;
- Pünktlichkeit;
- Warenqualität;
- Schadensquote;
- Zahlungszuverlässigkeit;
- Stornoquote;
- Streitfälle;
- behördliche Maßnahmen;
- Kunden- und Partnerhistorie.

Es wird keine leicht manipulierbare einfache Fünf-Sterne-Bewertung verwendet. Das System berechnet nachvollziehbare Rufwerte aus tatsächlichen Vorgängen.

## 10.35 Inaktive Unternehmen

Ein Unternehmen wird nicht allein wegen weniger Onlinezeit sofort gelöscht.

Mögliche Inaktivitätsfolgen:

- Hinweis an Eigentümer;
- Einschränkung neuer Aufträge;
- Auslaufen freiwilliger Angebote;
- fortlaufende vertragliche Kosten;
- späterer Status `DORMANT` oder `SUSPENDED`;
- geregelte Reaktivierung;
- erst langfristig Schließungsprozess.

Kritische Wirtschaftsbetriebe können bei längerer Inaktivität verpachtet, verkauft oder durch NPC-Notversorgung ersetzt werden.

## 10.36 Zahlungsprobleme und Insolvenz

Mögliche Warnsignale:

- wiederholt nicht gezahlte Löhne;
- überfällige Steuern;
- unbezahlte Mieten;
- fällige Kreditraten;
- negative verfügbare Liquidität;
- mehrere nicht erfüllte Verträge;
- Pfändungen oder Beschlagnahmungen.

Geplanter Ablauf:

1. Warnstatus `AT_RISK`;
2. Benachrichtigung und Karenzzeit;
3. mögliche Restrukturierung;
4. Zahlungsplan oder Kapitalzuführung;
5. Status `INSOLVENT`, wenn keine Lösung erfolgt;
6. Einschränkung neuer Verpflichtungen;
7. geordnete Verwertung oder Übernahme;
8. Begleichung von Forderungen nach definierten Regeln;
9. Schließung und Archivierung.

Eine Insolvenz löscht keine Schulden, Transaktionen oder Eigentumshistorien.

Komplexe automatische Insolvenzverfahren sind nicht Teil des ersten MVP. Das Datenmodell und die Statuswerte werden dennoch vorbereitet.

## 10.37 Schutz vor Firmenmissbrauch

- Gründungsgebühr und mögliches Mindestkapital;
- Begrenzung aktiver Unternehmensgründungen pro Charakter;
- keine direkte Übertragung von Firmenvermögen ohne Fachvorgang;
- Protokollierung verbundener Parteien;
- Überprüfung ungewöhnlicher Eigentümerzahlungen;
- keine kostenlose Nutzung von Firmen als Item- oder Geldtransfer;
- serverseitige Rechteprüfung bei jeder Aktion;
- Vier-Augen-Prinzip für konfigurierbare Großzahlungen;
- Versionsprüfung bei Rollen- und Vertragsänderungen;
- vollständige Historie von Gründung, Eigentum und Schließung;
- Geldwäsche- und Sicherheitsflags ohne automatische Verurteilung.

## 10.38 Beispiel: Öl-Lieferkette zwischen Unternehmen

1. Eine Tankstelle unterschreitet ihren Mindestbestand.
2. Das Tankstellenunternehmen erzeugt automatisch einen Lieferauftrag.
3. Raffinerien oder Lieferunternehmen erhalten den Auftrag im Marktplatz.
4. Ein berechtigtes Unternehmen gibt ein Angebot ab.
5. Nach Vergabe wird der Zahlungsbetrag reserviert.
6. Disponent weist Fahrer, Zugmaschine und Tanktrailer zu.
7. Raffinerie reserviert eine passende Kraftstoffcharge.
8. Fahrer belädt den Trailer.
9. Lieferung wird zur Tankstelle transportiert.
10. Menge und Qualität werden beim Abladen geprüft.
11. Tankstellenbestand wird erhöht.
12. Zahlung, Steuer, Lohnanteile und Vertragsstatus werden gebucht.
13. Unternehmen und Fahrer erhalten Ruf beziehungsweise Erfahrung.

Die Vergütung stammt aus dem Tankstellenunternehmen und nicht aus einer beliebigen Markerbelohnung.

## 10.39 Benutzeroberflächen

### Unternehmensdashboard

- Stammdaten;
- Status und Lizenzen;
- Eigentümer;
- Standorte;
- Finanzen;
- Mitarbeiter;
- Lager;
- Fuhrpark;
- Verträge;
- Aufträge;
- Unternehmensruf;
- Warnungen und Fristen.

### Personalverwaltung

- Bewerber und Angebote;
- Arbeitsverträge;
- Rollen und Berechtigungen;
- Arbeitszeiten;
- Lohnabrechnungen;
- Abwesenheiten;
- Kündigungen.

### Auftragsverwaltung

- Marktplatz;
- Ausschreibungen;
- Angebote;
- aktive Aufträge;
- Fahrer- und Fahrzeugzuweisung;
- Warenreservierung;
- Lieferstatus;
- Abnahme und Streitfälle.

Alle Oberflächen verwenden `cnr_ui` und zeigen nur Daten entsprechend der Unternehmensberechtigungen.

## 10.40 Vorgesehene Tabellen

- `cnr_business_types`
- `cnr_businesses`
- `cnr_business_name_history`
- `cnr_business_owners`
- `cnr_business_shares`
- `cnr_business_locations`
- `cnr_business_departments`
- `cnr_business_roles`
- `cnr_business_role_permissions`
- `cnr_business_members`
- `cnr_employment_contracts`
- `cnr_work_sessions`
- `cnr_payroll_runs`
- `cnr_payroll_items`
- `cnr_business_assets`
- `cnr_business_licenses`
- `cnr_commercial_contracts`
- `cnr_contract_parties`
- `cnr_contract_line_items`
- `cnr_contract_milestones`
- `cnr_contract_versions`
- `cnr_contract_signatures`
- `cnr_contract_events`
- `cnr_orders`
- `cnr_order_assignments`
- `cnr_order_deliveries`
- `cnr_tenders`
- `cnr_tender_bids`
- `cnr_contract_disputes`
- `cnr_insolvency_cases`
- `cnr_creditor_claims`

## 10.41 Sicherheit und Auditierung

- serverseitige Unternehmensberechtigungen;
- keine Rechte allein anhand eines Client-Rangs;
- Verträge nach Signatur unveränderlich;
- Änderungen nur als neue Version oder Nachtrag;
- eindeutige `operation_uuid` für Gründung, Lohn und Auftrag;
- Zahlungen ausschließlich über `cnr_banking`;
- Warenbewegungen ausschließlich über Inventar und Lager;
- Fahrzeuge ausschließlich über `cnr_vehicles`;
- atomare Auftragsannahme und Zahlungsreservierung;
- Versionsprüfung bei Rollen, Angeboten und Verträgen;
- serverseitige Prüfung von Lieferung, Menge und Qualität;
- vollständige Historie manueller Korrekturen;
- Rate-Limits für Einladungen, Angebote und Rollenänderungen.

## 10.42 Control-Panel-Konfiguration

Dynamisch einstellbar:

- Unternehmensformen;
- Branchen;
- Gründungsgebühren;
- Mindestkapital;
- maximale aktive Firmen pro Charakter;
- Standardrollen und erlaubte Rechte;
- Lohnmodelle;
- Abrechnungsperioden;
- Vertragsvorlagen;
- Auftragsarten;
- Marktplatzsichtbarkeit;
- Ausschreibungsregeln;
- Sicherheitsleistungen;
- Vertragsstrafen;
- Rufberechnung;
- Inaktivitätsgrenzen;
- Insolvenzschwellen;
- NPC-Notversorgung;
- Feature Flags für komplexe Funktionen.

Über den Ingame-Editor können Firmenstandorte, Büros, Zeiterfassungspunkte, Betriebshöfe, Niederlassungen und Auftragsbereiche erstellt werden.

## 10.43 MVP-Umfang

- Einzelunternehmen und einfache Gesellschaft;
- Firmengründung;
- Registrierungsnummer;
- Firmenkonto;
- Trennung von Firmen- und Privatvermögen;
- Standard- und benutzerdefinierte Rollen;
- Mitarbeiter und Arbeitsverträge;
- Stunden- und Auftragslohn;
- Arbeitszeiterfassung;
- einfache Lohnabrechnung;
- Firmenfahrzeuge und Fahrerzuweisung;
- Firmenlager und Zugriffsrechte;
- einfache Liefer- und Transportverträge;
- öffentlicher und eingeladener Auftragsmarktplatz;
- Bedarfsaufträge durch reale Lagerbestände;
- Auftragszuweisung an Mitarbeiter und Fahrzeuge;
- Teil- und Volllieferung;
- automatische Abnahme einfacher Waren;
- Zahlung über Reservierung und Hauptbuch;
- Unternehmensruf;
- Status für Einschränkung und Schließung;
- vollständige Auditierung.

Nicht im ersten MVP:

- komplexer Anteilshandel;
- Spielerbörsen;
- vollständige automatische Insolvenzverwaltung;
- komplexe Gerichtsverfahren;
- internationale Unternehmensstrukturen;
- tiefgehende reale Steuerbuchhaltung.

---

# 11. Immobilien-, Grundstücks-, Lager- und Anlagensystem

## 11.1 Verantwortliche Module

### `cnr_properties`

Verantwortet:

- Grundstücke und Gebäude;
- Wohnungen und Gewerbeeinheiten;
- Adressen;
- Eigentum und Eigentumshistorie;
- Kauf, Verkauf und Miete;
- Zugriffsrechte und Türen;
- Innenräume;
- Immobilienstatus;
- spätere Hypotheken und Pfandrechte.

### `cnr_storage`

Verantwortet:

- Lagerstandorte;
- Lagerbereiche und Tanks;
- Kapazitäten;
- zulässige Warenarten;
- Zugriffsrechte;
- Bestandsreservierungen;
- Inventuren;
- Lagerbewegungen;
- Miet- und Betreiberstatus.

### `cnr_facilities`

Verantwortet:

- Produktionsanlagen;
- Maschineneinheiten;
- Produktionsrezepte;
- Produktionsaufträge;
- Ein- und Ausgänge;
- Kapazitäten;
- Energie- und Betriebsmittel;
- Wartung;
- Anlagenstatus.

## 11.2 Objekt-Hierarchie

Immobilien werden nicht als ein einzelner Marker gespeichert. Sie besitzen eine klare Hierarchie:

1. Grundstück beziehungsweise `parcel`
2. Gebäude
3. Einheit
4. Raum oder Funktionsbereich
5. Tür, Interaktionspunkt oder Lager
6. optionale Produktionsanlage

Beispiel:

- Grundstück: Industrieparzelle 18
- Gebäude: Raffineriehalle
- Einheit: Produktionsbereich Nord
- Funktionsbereich: Rohöltanklager
- Lager: Tank 01 bis Tank 04
- Anlage: Destillationslinie A

Eine Immobilie kann mehrere Einheiten, Lager und Anlagen besitzen.

## 11.3 Immobilientypen

### Wohnen

- Apartment;
- Wohnung;
- Einfamilienhaus;
- Mehrfamilienhaus;
- Hotel- oder Übergangszimmer;
- Gemeinschaftsunterkunft.

### Gewerbe

- Büro;
- Ladengeschäft;
- Restaurant;
- Werkstatt;
- Tankstelle;
- Fahrzeughandel;
- Logistikbüro;
- Unternehmenszentrale.

### Industrie und Lager

- allgemeines Lager;
- Kühlhaus;
- Gefahrgutlager;
- Flüssigkeitstanklager;
- Betriebshof;
- Raffineriegrundstück;
- Fabrik;
- Recyclinganlage;
- Sägewerk;
- Mine oder Fördergelände;
- Landwirtschaftsfläche.

### Staat und Spezialobjekte

- Polizeistation;
- Feuerwehrwache;
- Krankenhaus;
- Gericht;
- Gefängnis;
- Verwaltungsgebäude;
- Asservatenlager.

## 11.4 Dauerhafte Immobilienidentität

Jede Immobilie erhält:

- interne Immobilien-ID;
- öffentliche UUID;
- eindeutige Adress- oder Registrierungsnummer;
- Grundstücksreferenz;
- Immobilientyp;
- Eigentümerart und Eigentümer-ID;
- Welt- oder Interior-Typ;
- Status;
- Erstellungsdatum;
- Zustandsversion.

Koordinaten oder Routing Buckets sind niemals die dauerhafte Identität einer Immobilie.

## 11.5 Adresssystem

Eine Adresse kann enthalten:

- Straßenname;
- Hausnummer;
- Zusatz;
- Einheit oder Apartmentnummer;
- Stadtteil;
- Postleitzahl;
- interne Parzellenkennung.

Adressen müssen serverweit eindeutig genug sein, um verwendet zu werden für:

- Verträge;
- Unternehmen;
- Notrufe;
- Polizeiakten;
- Lieferaufträge;
- Rechnungen;
- Navigationsziele;
- Zulassungen und Lizenzen.

Eine Namensänderung der Straße verändert nicht die interne Immobilien-ID.

## 11.6 Grundstücke und Nutzungszonen

Ein Grundstück wird als serverseitig validierte Fläche gespeichert.

Mögliche Nutzungsarten:

- Wohnen;
- Gewerbe;
- Industrie;
- Landwirtschaft;
- Logistik;
- Gefahrgut;
- staatliche Nutzung;
- Sondernutzung.

Die Nutzungszone bestimmt:

- erlaubte Gebäudetypen;
- erlaubte Produktionsanlagen;
- maximale Lagerarten;
- Lärm- und Gefahrgutregeln;
- mögliche Zufahrten;
- Fahrzeug- und Trailergrößen;
- Genehmigungen;
- Ausbaugrenzen.

Eigentum an einem Grundstück erlaubt nicht automatisch das freie Platzieren beliebiger Objekte oder Anlagen.

## 11.7 Physische und instanzierte Innenräume

Das System unterstützt zwei Innenraumarten.

### Physische Innenräume

- MLO oder vorhandenes GTA-Gebäude;
- fester Standort in der Welt;
- Spieler teilen denselben physischen Raum;
- Türen und Bereiche werden direkt dem Gebäude zugeordnet.

### Instanzierte Innenräume

- Shell oder wiederverwendbares Interior;
- eigene serverseitige Instanz pro Einheit;
- eindeutiger Routing Bucket;
- Bewohner und Gäste werden gezielt derselben Instanz zugewiesen;
- Außen- und Innenposition bleiben getrennt.

Der Server entscheidet über die Instanz. Ein Client darf keinen beliebigen Routing Bucket wählen.

## 11.8 Immobilienstatus

- `DRAFT`
- `AVAILABLE_FOR_SALE`
- `AVAILABLE_FOR_RENT`
- `RESERVED`
- `OCCUPIED`
- `UNDER_CONSTRUCTION`
- `IN_MAINTENANCE`
- `RESTRICTED`
- `SEALED`
- `SEIZED`
- `FORECLOSURE_PENDING`
- `DAMAGED`
- `INACTIVE`
- `ARCHIVED`

Eigentums-, Miet-, Bau- und Sicherheitsstatus werden bei Bedarf getrennt gespeichert, damit ein Objekt mehrere gleichzeitige Zustände abbilden kann.

## 11.9 Eigentümerarten

Eine Immobilie kann gehören zu:

- einem Charakter;
- mehreren Charakteren;
- einem Unternehmen;
- einer Immobiliengesellschaft;
- einer staatlichen Stelle;
- einem systemverwalteten Eigentümer.

Eigentum, Bewohnerstatus, Mieterstatus und Zugriffsrecht sind getrennte Beziehungen.

Ein Unternehmensstandort gehört der Firma und nicht automatisch dem privaten Charakter des Firmeninhabers.

## 11.10 Immobilienkauf

Möglicher Kaufablauf:

1. Angebot oder Inserat auswählen.
2. Eigentümer und Verfügbarkeit prüfen.
3. mögliche Pfandrechte, Mieter und Sperren prüfen.
4. Käufer und Vertretungsberechtigung prüfen.
5. Kaufbetrag und Nebenkosten über `cnr_banking` reservieren.
6. Kaufvertrag erzeugen und unterzeichnen.
7. Eigentum und Registereintrag übertragen.
8. Zahlung und Steuern buchen.
9. Zugriffsrechte aktualisieren.
10. Eigentumshistorie und Übergabeprotokoll speichern.

Ein Objekt mit aktiver Beschlagnahmung oder ungeklärtem Eigentum kann nicht normal verkauft werden.

## 11.11 Immobilienmarkt

Mögliche Funktionen:

- Verkaufsinserate;
- Mietinserate;
- Suchfilter;
- Besichtigungstermine;
- Kauf- oder Mietangebote;
- Gegenangebote;
- Reservierungen;
- Maklerzuweisung;
- Angebotsfristen;
- Eigentums- und Zustandsinformationen;
- Abschluss über Vertrag und Treuhand.

Inserate zeigen nur freigegebene Informationen. Versteckte Zugänge, Sicherheitsstufen oder private Lagerbestände werden nicht veröffentlicht.

## 11.12 Mietvertrag

Ein Immobilienmietvertrag enthält:

- Vermieter;
- Mieter;
- Immobilie oder Einheit;
- Mietbeginn;
- optionales Mietende;
- Miete pro Abrechnungsperiode;
- Kaution;
- Nebenkosten;
- Zahlungsintervall;
- Nutzungszweck;
- erlaubte Bewohner oder Mitarbeiter;
- Kündigungsfrist;
- Zugriffsrechte;
- Vertragsstatus.

Mögliche Statuswerte:

- `OFFERED`
- `PENDING_SIGNATURE`
- `ACTIVE`
- `PAYMENT_OVERDUE`
- `NOTICE_GIVEN`
- `TERMINATED`
- `EXPIRED`
- `CANCELLED`

## 11.13 Mietkaution und Übergabe

Die Kaution wird über `cnr_banking` reserviert oder auf einem Treuhandkonto hinterlegt.

Bei Einzug wird ein Übergabezustand gespeichert:

- Immobilie und Einheit;
- vorhandene Ausstattung;
- bekannte Schäden;
- enthaltene Lager und Schlüssel;
- Zähler- oder Versorgungsstatus;
- Zeitpunkt;
- bestätigende Parteien.

Bei Auszug wird der Zustand erneut erfasst. Zulässige Forderungen werden nachvollziehbar mit der Kaution verrechnet.

## 11.14 Mietrückstand und Räumung

Eine nicht bezahlte Miete führt nicht sofort zum Verschwinden von Eigentum oder Inventar.

Geplanter Ablauf:

1. Zahlung schlägt fehl.
2. Mieter und Vermieter erhalten eine Mitteilung.
3. Karenzzeit beginnt.
4. Mahnung oder Zahlungsvereinbarung ist möglich.
5. Kündigung kann ausgesprochen werden.
6. Zugriffsrechte enden erst nach wirksamem Vertragsende.
7. zurückgelassene Gegenstände werden in gesicherte Verwahrung überführt.
8. Abholung, Verwertung oder weitere Entscheidung folgt einem geregelten Prozess.

Ein Vermieter kann ein Lager nicht einfach leeren oder Gegenstände erzeugen, löschen oder übernehmen.

## 11.15 Bewohner, Mitarbeiter und Gäste

Mögliche Zugriffsrollen:

- Eigentümer;
- Miteigentümer;
- Hauptmieter;
- Bewohner;
- Firmenmitarbeiter;
- Immobilienverwaltung;
- Reinigung oder Wartung;
- temporärer Gast;
- Notdienst;
- Polizei mit gültiger Maßnahme.

Zugriffe können eingeschränkt werden auf:

- Haupteingang;
- einzelne Räume;
- Garage;
- privates Lager;
- Firmenlager;
- Produktionsbereich;
- Büro;
- Sicherheitsbereich;
- bestimmte Zeiträume.

## 11.16 Schlüssel und Zugangssystem

Schlüssel, Karten oder digitale Freigaben verweisen auf serverseitige Zugriffsdatensätze.

Eigenschaften:

- Immobilie oder Bereich;
- berechtigter Charakter oder Rolle;
- erlaubte Aktionen;
- Beginn und Ablauf;
- ausstellende Person;
- widerrufen ja/nein;
- optionales physisches Item.

Ein verlorener Schlüssel überträgt kein Eigentum. Er kann gesperrt oder durch einen Schlosswechsel ungültig gemacht werden.

## 11.17 Türen und Sicherheitsbereiche

Eine Türdefinition enthält:

- Immobilie;
- Position;
- Modell oder Türgruppe;
- Ausgangszustand;
- zugehörigen Zugriffsbereich;
- erlaubte Rollen;
- Einbruchswiderstand;
- Alarmzuordnung;
- mögliche Notfallöffnung.

Der Sperrzustand wird serverseitig synchronisiert. Türen werden nicht allein anhand lokaler Clientwerte geöffnet.

## 11.18 Polizeilicher und behördlicher Zugriff

Behördlicher Zugang benötigt einen nachvollziehbaren Grund:

- Einwilligung;
- akute Gefahr;
- Durchsuchungsbeschluss;
- Beschlagnahme;
- Feuerwehreinsatz;
- medizinischer Notfall;
- administrative Fehlerbehebung.

Jeder Sonderzugriff wird mit Person, Zeitpunkt, Immobilie, Grund und möglicher Fallreferenz protokolliert.

Ein Immobilienbesitzer erhält nicht automatisch eine Livewarnung über jede verdeckte behördliche Maßnahme.

## 11.19 Wohnen und Charakterfunktionen

Wohnimmobilien können bieten:

- auswählbaren Spawnpunkt;
- Kleiderschrank;
- persönliches Lager;
- Bett oder Ruhefunktion;
- Briefkasten;
- Gästeverwaltung;
- Hausgarage;
- Möbel und Dekoration;
- Alarmanlage;
- gemeinschaftliche Räume.

Der Spawn in einer Wohnung ist nur möglich, wenn ein aktives Eigentums-, Miet- oder Bewohnerrecht besteht. Gefängnis, Krankenhaus und administrative Spawns besitzen weiterhin höhere Priorität.

## 11.20 Möbel und funktionale Objekte

Möbel werden in visuelle und funktionale Objekte getrennt.

Visuelle Objekte:

- Tische;
- Stühle;
- Dekoration;
- Beleuchtung;
- Pflanzen;
- Bilder.

Funktionale Objekte:

- Schrank;
- Safe;
- Kleiderschrank;
- Werkbank;
- Bett;
- Kasse;
- Terminal;
- Produktionsgerät.

Platzierung wird serverseitig auf Grundstück, Grenzen, erlaubte Modelle und Objektlimits geprüft. Fortgeschrittene freie Möblierung ist nicht Teil des ersten MVP.

## 11.21 Einbruch und Objektschutz

Immobilien sind nicht grundsätzlich unantastbar.

Mögliche Sicherheitsmerkmale:

- Türschloss;
- verstärkte Tür;
- Alarmanlage;
- Kamera;
- Bewegungsmelder;
- Safe;
- Sicherheitsdienst;
- Zugangskarte;
- Strom- oder Netzabhängigkeit.

Mögliche Einbruchsspuren:

- beschädigtes Schloss;
- Werkzeugspuren;
- Fingerabdrücke;
- Alarmereignis;
- Kameraaufnahme;
- beschädigtes Fenster;
- zurückgelassene Gegenstände.

Offline-Schutz, Cooldowns und Entnahmegrenzen verhindern, dass ein Spieler nach längerer Abwesenheit vollständig leergeräumt wird. Die genaue Kriminalitätslogik wird im Einbruchssystem geplant.

## 11.22 Hypotheken und Pfandrechte

Hypotheken sind für eine spätere Ausbaustufe vorgesehen.

Mögliche Eigenschaften:

- Kreditgeber;
- Kreditnehmer;
- Immobilie als Sicherheit;
- Kaufpreis;
- Anzahlung;
- Darlehenssumme;
- Zinssatz;
- Laufzeit;
- Ratenplan;
- Restschuld;
- Zahlungsverzug;
- Pfand- oder Verwertungsstatus.

Eine belastete Immobilie kann nicht ohne Freigabe des Kreditgebers übertragen werden.

## 11.23 Steuern und Nebenkosten

Mögliche Kosten:

- Grundsteuer;
- Gewerbemiete;
- Wohnmiete;
- Strom;
- Wasser;
- Abfall;
- Sicherheitsdienst;
- Lagerbetrieb;
- Gefahrgutzuschlag;
- Wartung gemeinsamer Bereiche.

Für den MVP werden Kosten bewusst übersichtlich gehalten. Wohnobjekte können mit pauschalen Nebenkosten beginnen, während Produktionsanlagen ihren tatsächlichen Energie- und Betriebsmittelverbrauch berücksichtigen.

Nicht bezahlte Nebenkosten führen zunächst zu Mahnungen und abgestuften Einschränkungen statt zu einem sofortigen vollständigen Lockout.

## 11.24 Lagertypen

- persönliches Lager;
- Wohnungslager;
- Firmenlager;
- allgemeines Warenlager;
- Palettenlager;
- Kühlhaus;
- Gefahrgutlager;
- Flüssigkeitstank;
- Rohstoffsilo;
- Fahrzeug- und Freifläche;
- Asservatenlager;
- temporäres Auftragslager;
- Mietlager beziehungsweise Self-Storage.

## 11.25 Lagerkapazitäten

Kapazität wird abhängig vom Lagertyp gemessen:

- Gewicht;
- Volumen;
- Slots;
- Palettenplätze;
- Liter;
- Fahrzeug- oder Stellplätze;
- maximale Einzelabmessungen;
- zulässige Gefahrenklasse.

Ein Flüssigkeitstank verwendet Liter und Produktkompatibilität. Ein Palettenlager verwendet Palettenplätze und Gewicht. Ein persönlicher Schrank verwendet Slots und Gewicht.

Eine einzige universelle Kapazitätszahl reicht daher nicht aus.

## 11.26 Lagerhierarchie

Ein großer Lagerstandort kann besitzen:

1. Lagergebäude
2. Lagerzonen
3. Regale, Stellplätze oder Tanks
4. zugehörige Inventare
5. reservierte Bereiche

Beispiel Raffinerie:

- Rohöllager
- Zwischenprodukttank
- Benzintank
- Dieseltank
- Nebenproduktlager
- Ersatzteillager
- Gefahrstoffbereich

Jeder Bereich besitzt eigene Kapazität, Kompatibilität und Zugriffsrechte.

## 11.27 Lagerzugriffsrechte

Mögliche Rechte:

- Bestand ansehen;
- Ware einlagern;
- Ware entnehmen;
- Bestand reservieren;
- Reservierung freigeben;
- Umlagerung durchführen;
- Inventur durchführen;
- Korrektur vorschlagen;
- Korrektur freigeben;
- Zugriffe verwalten.

Ein Mitarbeiter kann beispielsweise Waren einlagern, aber keine reservierten Kraftstoffchargen entfernen.

## 11.28 Warenchargen und Bestandsführung

Lagerbestände verweisen auf Items, Container oder `cargo lots` aus dem Inventarsystem.

Gespeichert beziehungsweise abgeleitet werden:

- Produkt;
- Menge;
- Einheit;
- Charge;
- Qualität;
- Herkunft;
- Eigentümer;
- Reservierungsstatus;
- Ablaufdatum;
- Kontamination;
- Lagerposition;
- letzter Bewegungsvorgang.

Gleichartige Ware mit unterschiedlicher Qualität oder Herkunft wird nicht unkontrolliert zu einer einzigen Charge zusammengeführt.

## 11.29 Reservierungen für Aufträge

Waren können für Produktion, Verkauf oder Lieferaufträge reserviert werden.

Eine Reservierung enthält:

- Lager und Bereich;
- Ware oder Charge;
- reservierte Menge;
- Auftrag oder Vertrag;
- reservierendes Unternehmen;
- Beginn;
- Ablaufzeitpunkt;
- Status.

Reservierte Ware bleibt sichtbar, steht aber anderen Vorgängen nicht mehr frei zur Verfügung.

## 11.30 Lagerbewegungen

Jede Bewegung besitzt:

- Quelle;
- Ziel;
- Ware oder Charge;
- Menge;
- ausführenden Charakter;
- Unternehmen;
- Grund;
- Auftrag oder Vertrag;
- Fahrzeug oder Container optional;
- Zeitpunkt;
- Vorgangsnummer.

Beispiele:

- Wareneingang;
- Entnahme;
- Umlagerung;
- Beladung;
- Entladung;
- Produktionsverbrauch;
- Produktionsausgabe;
- Inventurkorrektur;
- Beschlagnahmung;
- Vernichtung.

## 11.31 Inventur und Bestandskorrektur

Eine Inventur vergleicht erwarteten und festgestellten Bestand.

Abweichungen benötigen:

- Lagerbereich;
- erwarteten Bestand;
- festgestellten Bestand;
- Differenz;
- Grund;
- ausführende Person;
- mögliche Freigabe;
- Audit-Eintrag.

Eine Bestandskorrektur verändert nicht still einen Mengenwert. Sie erzeugt eine nachvollziehbare Lagerbewegung.

## 11.32 Lagervermietung

Ein Mietlagervertrag enthält:

- Vermieter;
- Mieter;
- Lager oder Bereich;
- Kapazität;
- zulässige Waren;
- Mietbeginn und Mietende;
- Miete;
- Kaution;
- Zugriffsrechte;
- Kündigungsregeln;
- Vertragsstatus.

Nach Vertragsende verschwinden Waren nicht. Sie werden gesperrt oder in geregelte Verwahrung überführt und können nach Frist, Zahlung oder weiterer Entscheidung abgeholt beziehungsweise verwertet werden.

## 11.33 Gefahrgut, Kühlung und Kontamination

Speziallager können zusätzliche Bedingungen besitzen:

- Gefahrgutklasse;
- zugelassene Stoffe;
- maximale Menge;
- Temperaturbereich;
- Energiebedarf;
- Belüftung;
- Sicherheitsstufe;
- benötigte Lizenz;
- Schutzkleidung;
- Reinigungsstatus.

Falsche Lagerung kann Qualität, Haltbarkeit, Sicherheit und Versicherungsschutz beeinflussen.

Für den MVP werden zuerst Produktkompatibilität, Gefahrgutberechtigung und einfache Kontamination umgesetzt. Eine vollständige Temperatursimulation folgt später.

## 11.34 Grundstück und Produktionsanlage

Grundstück, Gebäude und Produktionsanlage sind getrennte Objekte.

Beispiel:

- Ein Unternehmen mietet ein Industriegrundstück.
- Auf dem Grundstück befindet sich eine Produktionshalle.
- In der Halle betreibt das Unternehmen eine gemietete Raffinerielinie.
- Rohöltanks gehören zum Lagerbereich.
- Maschinen und Tanks können unterschiedliche Eigentümer oder Verträge besitzen.

Der Besitz eines Grundstücks schenkt keine Produktionsanlage. Eine Anlage benötigt Erwerb oder Miete, Installation, Lizenz und Betriebsmittel.

## 11.35 Anlagentypen

- Ölpumpe;
- Raffinerie;
- Mischanlage;
- Abfüllanlage;
- Werkstatt;
- Recyclinganlage;
- Sägewerk;
- Schmelzerei;
- Lebensmittelproduktion;
- Farmbetrieb;
- Mine;
- chemische Anlage;
- Kraftwerk oder Generator;
- Verpackungsanlage.

## 11.36 Anlagenstatus

- `DRAFT`
- `INSTALLING`
- `READY`
- `RUNNING`
- `PAUSED`
- `MAINTENANCE_REQUIRED`
- `IN_MAINTENANCE`
- `FAULTED`
- `SHUTDOWN`
- `SEALED`
- `DECOMMISSIONED`

Eine Anlage kann bei fehlender Lizenz, behördlicher Maßnahme, Wartungsmangel oder Sicherheitsproblem eingeschränkt werden.

## 11.37 Maschinen

Eine Anlage kann mehrere Maschineninstanzen besitzen.

Eine Maschine enthält:

- Maschinentyp;
- Seriennummer;
- Eigentümer;
- Anlage und Standort;
- Kapazität;
- Geschwindigkeit;
- Wirkungsgrad;
- Zustand;
- Verschleiß;
- Energiebedarf;
- kompatible Rezepte;
- Wartungsintervall;
- letzte Wartung.

Maschinen werden als dauerhafte Assets behandelt und nicht bei jedem Produktionsvorgang neu erzeugt.

## 11.38 Produktionsrezepte

Ein Rezept definiert:

- Eingangsprodukte;
- Eingangsmengen;
- zugelassene Qualität;
- benötigte Anlage;
- benötigte Maschinen;
- Produktionsdauer;
- Energie und Betriebsmittel;
- Ausgangsprodukte;
- mögliche Nebenprodukte;
- Qualitätsberechnung;
- Abfall oder Verlust;
- benötigte Fähigkeit und Lizenz.

Rezepte sind versioniert. Laufende Produktionsaufträge behalten die beim Start gültige Rezeptversion.

## 11.39 Produktionsauftrag

Ein Produktionsauftrag enthält:

- Anlage;
- Rezeptversion;
- gewünschte Menge;
- reservierte Eingangscharge;
- Ziel-Lagerbereiche;
- verantwortliches Unternehmen;
- startender Charakter;
- Start- und Endzeitpunkt;
- Qualitätsparameter;
- Status;
- Vorgangsnummer.

Mögliche Statuswerte:

- `DRAFT`
- `QUEUED`
- `INPUT_RESERVED`
- `RUNNING`
- `PAUSED`
- `COMPLETED`
- `FAILED`
- `CANCELLED`

## 11.40 Produktionsablauf

1. Produktionsauftrag erstellen.
2. Rezept, Anlage und Maschinen prüfen.
3. Fähigkeit, Lizenz und Unternehmensrecht prüfen.
4. Eingangsprodukte im Lager reservieren.
5. freie Ausgangskapazität prüfen.
6. Energie und Betriebsmittel prüfen.
7. Auftrag starten.
8. Produktionszustand serverseitig fortschreiben.
9. Eingänge kontrolliert verbrauchen.
10. Ausgänge und Nebenprodukte erzeugen.
11. Qualität berechnen.
12. Waren in Ziellager buchen.
13. Erfahrung, Wartung und Audit-Ereignisse verarbeiten.

Ein Produktionsauftrag kann keine Ausgabe erzeugen, wenn die Eingänge nicht erfolgreich reserviert und verbraucht wurden.

## 11.41 Hintergrundproduktion

Produktion kann serverseitig über Zeiträume weiterlaufen, auch wenn kein Client die Anlage beobachtet.

Regeln:

- Zustand und Endzeit werden in der Datenbank gespeichert;
- Serverneustarts erzeugen keine doppelte Ausgabe;
- Produktion läuft nur mit reservierten Ressourcen;
- Kapazität und Energie bleiben erforderlich;
- Wartungs- oder Störungszustände können pausieren;
- eine Anlage ist kein unbegrenzter Offline-Geldgenerator;
- Auftrag, Lager und Absatz bleiben notwendig.

Der Client zeigt nur den serverseitigen Produktionsstatus an.

## 11.42 Anlagenwartung

Verschleiß kann beeinflusst werden durch:

- Laufzeit;
- Produktionsmenge;
- Auslastung;
- Rohstoffqualität;
- Bedienerfähigkeit;
- Wartungszustand;
- Überlastung;
- vorherige Störungen.

Wartung benötigt abhängig von Anlage und Maschine:

- Ersatzteile;
- Werkzeug;
- qualifizierten Mitarbeiter;
- Stillstandszeit;
- Wartungsauftrag;
- Firmenfreigabe.

Ungewartete Anlagen verlieren zunächst Wirkungsgrad oder Qualität und fallen nicht ohne nachvollziehbare Warnzeichen zufällig vollständig aus.

## 11.43 Energie und Betriebsmittel

Produktionsanlagen können benötigen:

- Strom;
- Kraftstoff;
- Wasser;
- Kühlmittel;
- Schmierstoffe;
- Chemikalien;
- Verpackungsmaterial.

Im MVP werden Energie- und Betriebskosten zunächst als nachvollziehbare Ressourcen oder Kosten pro Produktionsauftrag umgesetzt.

Ein späterer Ausbau kann Stromerzeugung, Netze, Generatoren, Ausfälle und Spieler-Energieunternehmen ergänzen.

## 11.44 Dynamische Erstellung im Ingame-Editor

Administratoren können im Entwurfsmodus erstellen:

- Grundstücksfläche;
- Adresse;
- Immobilientyp;
- Gebäude und Einheit;
- Ein- und Ausgänge;
- Innenraum oder Shell;
- Routing-Bucket-Regeln;
- Türen und Zugriffsbereiche;
- Garagen und Stellplätze;
- Lagerbereiche;
- Regale, Tanks und Silos;
- Maschinenplätze;
- Produktionsanlagen;
- Liefer- und Interaktionszonen;
- Kauf- und Mietkonditionen.

Veröffentlichung erfolgt erst nach Validierung von Grenzen, Überschneidungen, Kapazitäten, Spawnpunkten und Pflichtfeldern.

## 11.45 Versionierung von Weltobjekten

Änderungen an veröffentlichten Objekten erhalten eine neue Version.

Gespeichert werden:

- alter und neuer Zustand;
- ändernde Person;
- Zeitpunkt;
- Begründung;
- Entwurf oder veröffentlicht;
- betroffene Mieter, Eigentümer und Verträge;
- mögliche Migrationsaktion.

Eine Änderung an Lagerkapazität oder Grundstücksgrenze darf bestehende Waren oder Verträge nicht stillschweigend ungültig machen.

## 11.46 Benutzeroberflächen

### Immobilienübersicht

- eigene, gemietete und berechtigte Objekte;
- Adresse;
- Eigentums- oder Mietstatus;
- Verträge;
- Bewohner und Zugriffe;
- Räume, Lager und Garage;
- Kosten und offene Vorgänge.

### Lagerverwaltung

- Lagerbereiche;
- Kapazität und Auslastung;
- Bestände und Chargen;
- Reservierungen;
- Warenein- und -ausgang;
- Inventur;
- Zugriffsrechte;
- Warnungen.

### Anlagenverwaltung

- Anlagen und Maschinen;
- Status und Auslastung;
- Produktionsaufträge;
- Eingänge und Ausgänge;
- Energie und Betriebsmittel;
- Wartung;
- Störungen;
- Produktionshistorie.

Alle Oberflächen verwenden `cnr_ui` und beachten Eigentümer-, Miet-, Mitarbeiter- und Sicherheitsrechte.

## 11.47 Vorgesehene Tabellen

- `cnr_property_types`
- `cnr_property_parcels`
- `cnr_properties`
- `cnr_property_units`
- `cnr_property_addresses`
- `cnr_property_owners`
- `cnr_property_ownership_history`
- `cnr_property_listings`
- `cnr_property_offers`
- `cnr_property_rental_contracts`
- `cnr_property_access`
- `cnr_property_doors`
- `cnr_property_interiors`
- `cnr_property_furniture`
- `cnr_property_utilities`
- `cnr_property_mortgages`
- `cnr_property_tax_records`
- `cnr_storage_definitions`
- `cnr_storage_locations`
- `cnr_storage_sections`
- `cnr_storage_access`
- `cnr_storage_movements`
- `cnr_stock_reservations`
- `cnr_inventory_counts`
- `cnr_facility_types`
- `cnr_facilities`
- `cnr_facility_machines`
- `cnr_production_recipes`
- `cnr_production_orders`
- `cnr_production_events`
- `cnr_facility_maintenance`

Lagerbestände selbst bleiben mit den Inventaren, Iteminstanzen und Warenchargen aus `cnr_inventory` verknüpft.

## 11.48 Sicherheit und Schutz vor Missbrauch

- Eigentum niemals durch Clientdaten bestimmen;
- serverseitige Prüfung von Position, Instanz und Zugang;
- eindeutige IDs statt Koordinaten als Identität;
- Kauf, Miete und Eigentumswechsel atomar mit Banking und Vertrag;
- Lagerkapazitäten und Produktkompatibilität serverseitig prüfen;
- keine direkten Mengenänderungen außerhalb des Inventarsystems;
- Produktionsausgabe nur nach reserviertem und verbrauchtem Eingang;
- eindeutige `operation_uuid` pro Kauf, Bewegung und Produktion;
- Routing Buckets ausschließlich serverseitig zuweisen;
- Objekt- und Möbellimits;
- Türzustände serverseitig synchronisieren;
- Änderungen an Weltobjekten versionieren;
- Adminaktionen mit Begründung und Audit-Log;
- sichere Wiederherstellung nach Restart oder Ressourcenfehler.

## 11.49 Control-Panel-Konfiguration

Dynamisch einstellbar:

- Immobilientypen;
- Nutzungszonen;
- Kauf- und Mietpreise;
- Kautionen;
- Nebenkosten;
- Kündigungs- und Karenzzeiten;
- Innenräume und Shells;
- Zugriffsrollen;
- Tür- und Sicherheitsstufen;
- Möbel- und Objektlimits;
- Lagertypen;
- Kapazitätsarten;
- Warenkompatibilität;
- Gefahrgutregeln;
- Inventur- und Korrekturfreigaben;
- Anlagentypen;
- Maschinendefinitionen;
- Produktionsrezepte;
- Produktionsdauer;
- Energie- und Betriebsmittelverbrauch;
- Verschleiß und Wartungsgrenzen;
- Hintergrundproduktionsregeln;
- Feature Flags für spätere Systeme.

## 11.50 MVP-Umfang

- Grundstücke, Gebäude und Einheiten;
- eindeutige Adressen;
- Wohn-, Gewerbe- und Industrieobjekte;
- physische und instanzierte Innenräume;
- Kauf und Eigentumsübertragung;
- Immobilienmiete und Kaution;
- Bewohner-, Gäste- und Mitarbeiterzugriffe;
- Türen und Schlüssel;
- Wohnungsspawn;
- persönliches Wohnlager;
- allgemeine Firmenlager;
- Paletten- und Gefahrgutlager;
- Flüssigkeitstanks;
- Lagerbereiche und differenzierte Kapazitäten;
- Chargen und Reservierungen;
- Lagerbewegungen;
- einfache Inventur;
- Lagervermietung;
- Anlagen und Maschinen;
- versionierte Produktionsrezepte;
- Produktionsaufträge;
- serverseitige Hintergrundproduktion;
- Wartungszustand;
- Ingame-Erstellung von Objekten, Lagern und Anlagen;
- vollständige Auditierung.

Nicht im ersten MVP:

- komplexe Hypotheken;
- vollständige Energie- und Wassernetze;
- freie umfangreiche Möbelplatzierung;
- tiefes Bau- und Baugenehmigungssystem;
- dynamische Gebäudegeometrie;
- vollständige Immobilienversicherung;
- komplexe Zwangsversteigerungen;
- umfassendes Einbruchsystem.

---

# 12. Öl- und Kraftstoffwirtschaft

Der Ölzweig ist der erste vollständig geplante Wirtschaftskreislauf und dient als Referenz für spätere Branchen wie Bergbau, Holz, Landwirtschaft, Recycling und Chemie.

Das Ziel ist keine einfache Markerroute mit fester Auszahlung. Jeder Liter entsteht aus einer nachvollziehbaren Förder-, Lager-, Verarbeitungs-, Transport- und Verkaufskette. Geld wird grundsätzlich durch Verträge, Warenverkauf oder Dienstleistungen verdient und nicht beim Abschluss eines Markers erzeugt.

## 12.1 Verantwortliche Module

### `cnr_industry`

Verantwortet:

- Rohstofffelder und Förderpunkte;
- Förderrechte, Kontingente und Konzessionen;
- Förderausrüstung;
- Fördersitzungen;
- Rohstoffqualität;
- branchenbezogene Regeln und Kennzahlen.

### `cnr_storage`

Verantwortet:

- stationäre Tanks;
- Tankabteile;
- Kapazitäten;
- Produktverträglichkeit;
- Warenchargen;
- Reservierungen;
- Ein-, Aus- und Umlagerungen.

### `cnr_facilities`

Verantwortet:

- Raffinerien;
- Maschinen;
- Rezeptversionen;
- Produktionsaufträge;
- Energie und Hilfsstoffe;
- Wartung;
- Störungen und Produktionsereignisse.

### `cnr_logistics`

Verantwortet:

- Abholungen und Lieferungen;
- Lade- und Entladevorgänge;
- Transportaufträge;
- Frachtzuordnung;
- Gefahrgutanforderungen;
- Liefernachweise.

### `cnr_fuel`

Verantwortet:

- Tankstellen;
- unterirdische Produkttanks;
- Zapfsäulen und Zapfpistolen;
- Kraftstoffpreise;
- Tankvorgänge;
- Fahrzeug-Kraftstoffarten;
- Notversorgung und Bestellregeln.

Die kaufmännischen Vorgänge verwenden zusätzlich `cnr_businesses`, `cnr_contracts`, `cnr_banking`, `cnr_marketplace`, `cnr_vehicles`, `cnr_rentals` und `cnr_progression`.

## 12.2 Beteiligte Marktrollen

Der Kreislauf unterstützt mehrere Einstiege:

- angestellter Ölfeldarbeiter;
- selbstständiger Förderer mit Lizenz und Auftrag;
- Förderunternehmen mit Konzession;
- Vermieter von Zugmaschinen, Tanktrailern und Ausrüstung;
- Lager- oder Tankdepotbetreiber;
- Tankwagenfahrer;
- Raffineriemitarbeiter;
- Raffineriebetreiber;
- Labor- oder Qualitätsmitarbeiter;
- Kraftstoffgroßhändler;
- Tankstellenpächter oder -eigentümer;
- Tankstellenmitarbeiter;
- Wartungs- und Abschleppunternehmen;
- Feuerwehr, Polizei und Aufsichtsbehörden.

Ein Charakter muss nicht die gesamte Kette besitzen. Spezialisierte Firmen können miteinander handeln und langfristige Verträge schließen.

## 12.3 Eigentum, Nutzung und Betriebsrechte

Folgende Dinge bleiben getrennt:

- Eigentum am Grundstück;
- Eigentum am Gebäude;
- Eigentum an Tanks und Maschinen;
- Eigentum an Fahrzeugen und Trailern;
- Eigentum an Warenchargen;
- zeitlich begrenztes Nutzungsrecht;
- Förderrecht für ein Feld oder Kontingent;
- Betriebslizenz für eine Anlage;
- Arbeitsberechtigung eines Mitarbeiters.

Der Besitz eines Grundstücks gewährt weder automatisch Förderrechte noch eine Raffinerielizenz. Ebenso gehört eingelagertes Öl nicht automatisch dem Lagerbetreiber.

Förderfelder können dem Staat, dem System oder einem Unternehmen gehören. Im MVP vergibt der Staat zeitlich oder mengenmäßig begrenzte Förderrechte. Später sind Ausschreibungen, Auktionen und private Konzessionen möglich.

## 12.4 Produkte und Mengeneinheiten

Flüssigkeiten werden intern in einer ganzzahligen Basiseinheit gespeichert. Vorgesehen sind Milliliter in `BIGINT`; Benutzeroberflächen zeigen daraus Liter an. Geld bleibt wie im Banksystem in ganzzahligen Minor Units.

Jede relevante Flüssigkeit besitzt:

- Produktdefinition;
- Kraftstoff- oder Rohstoffklasse;
- interne Basiseinheit;
- Dichte- oder Umrechnungsparameter, falls benötigt;
- erlaubte Behältertypen;
- Misch- und Kontaminationsregeln;
- Gefahrgutklasse;
- Qualitätsanforderungen;
- Haltbarkeits- oder Alterungsregeln;
- Steuerkategorie.

Produkte im ersten Kreislauf:

- Rohöl;
- Normalbenzin;
- Premiumbenzin;
- Diesel;
- verwertbares Nebenprodukt;
- nicht verkaufsfähiger Produktionsabfall.

Spätere Produkte:

- Kerosin;
- Heizöl;
- Schmierstoffe;
- Bitumen;
- chemische Ausgangsstoffe;
- weitere Kraftstoffqualitäten.

## 12.5 Warenchargen und Qualität

Rohöl und Kraftstoffe bleiben über Warenchargen nachvollziehbar. Eine Charge enthält mindestens:

- Charge-UUID;
- Produkt;
- Menge;
- Eigentümer;
- Herkunftsfeld oder Ursprungsanlage;
- Erstellungszeit;
- Qualitätsklasse;
- Qualitätswert;
- Kontaminationsstatus;
- aktuelles Lager oder Fahrzeugabteil;
- reservierte Menge;
- verknüpfte Förder- oder Produktionsvorgänge.

Für Rohöl sind im mittleren Realismus unter anderem vorgesehen:

- leicht, mittel oder schwer;
- grundlegender Schwefel- beziehungsweise Reinheitswert;
- Wasser- und Schmutzanteil;
- allgemeiner Qualitätswert.

Die Werte werden serverseitig aus Feld, Förderzustand, Ausrüstung und möglichen Verunreinigungen bestimmt. Der Client übermittelt keine Qualität und keinen Ertrag.

Gleichartige kompatible Chargen dürfen kontrolliert zusammengeführt werden. Dabei entsteht eine neue oder aktualisierte Mischcharge mit berechneter Qualität und vollständiger Herkunftsverknüpfung. Eine Mischung darf ihre Herkunft nicht verschleiern.

## 12.6 Rohstofffelder

Ein Ölfeld besteht aus:

- Felddefinition;
- räumlicher Zone;
- einem oder mehreren Förderpunkten;
- Qualitätsprofil;
- Druck- oder Leistungsprofil;
- verfügbarem Förderkontingent;
- Erholungsrate;
- aktiven Förderrechten;
- zugelassenen Ausrüstungstypen;
- Betriebszeiten und Störstatus.

Felder werden nicht endgültig leer und auch nicht grenzenlos nutzbar. Sie besitzen konfigurierbare Kontingente und Erholungszyklen. Dadurch können Verwaltung und Economy-Team das Angebot steuern, ohne bereits erspielten Besitz willkürlich zu löschen.

Mehrere Felder dürfen unterschiedliche Rohölqualitäten, Fördergeschwindigkeiten, Zugangskosten und Risiken besitzen.

## 12.7 Förderpunkte und Pumpenausrüstung

Ein Förderpunkt ist ein serverseitiges Weltobjekt mit eigener UUID und Zustand.

Mögliche Zustände:

- `available`;
- `reserved`;
- `setup`;
- `pumping`;
- `paused`;
- `maintenance`;
- `depleted_cycle`;
- `blocked`;
- `incident`;
- `inactive`.

Ausrüstung kann:

- fest zum Feld gehören;
- von einem Betreiber bereitgestellt werden;
- gemietet werden;
- einem Unternehmen gehören;
- als persistente Maschine gewartet werden müssen.

Relevante Eigenschaften:

- Förderleistung;
- maximaler Betriebsdruck;
- Verschleiß;
- Wartungszustand;
- Energie- oder Treibstoffbedarf;
- unterstützte Anschlüsse;
- Sicherheitsklasse;
- Mietvertrag und Kaution.

## 12.8 Wege in die Förderung

### Angestellter

Ein Unternehmen oder staatlicher Betreiber stellt Auftrag, Förderrecht, Ausrüstung und gegebenenfalls Fahrzeug. Der Mitarbeiter erhält Lohn oder eine vertragliche Leistungsvergütung.

### Selbstständiger Auftragnehmer

Der Spieler benötigt:

- passende Lizenz;
- aktiven Förderauftrag;
- gemietete oder eigene Ausrüstung;
- geeignete Zugmaschine;
- kompatiblen Tanktrailer oder Zielbehälter;
- ausreichende finanzielle Mittel für Miete, Kaution und Gebühren.

### Förderunternehmen

Ein Unternehmen kann Kontingente erwerben, Mitarbeiter einteilen, Ausrüstung besitzen, Tanklager betreiben und Rohöl an Raffinerien verkaufen.

## 12.9 Prüfung vor Förderbeginn

Vor dem Start prüft der Server:

1. gültigen Charakter und aktive Spielsitzung;
2. Entfernung und Routing Bucket;
3. Förderrecht oder zugewiesenen Auftrag;
4. Lizenz und Unternehmensberechtigung;
5. Zustand und Verfügbarkeit des Förderpunkts;
6. kompatible und funktionsfähige Ausrüstung;
7. gültigen Mietvertrag, falls gemietet;
8. Zielbehälter, freie Kapazität und Produktverträglichkeit;
9. verbleibendes Feld- und Vertragskontingent;
10. mögliche Sperren, Wartung oder Störfälle.

Erst danach werden Förderpunkt, Kontingent und Zielkapazität für den Vorgang reserviert.

## 12.10 Aktiver Förderablauf

Der grundlegende Ablauf:

1. Auftrag oder Förderrecht auswählen;
2. Ausrüstung übernehmen und Zustand bestätigen;
3. Zugmaschine und Tanktrailer bereitstellen;
4. Förderpunkt sichern;
5. Schlauch und Zielabteil verbinden;
6. Sicherheitsprüfung durchführen;
7. Pumpe starten;
8. Druck und Förderverlauf überwachen;
9. Probe beziehungsweise Qualitätsmessung durchführen;
10. bei Zielmenge oder Kapazitätsgrenze stoppen;
11. Verbindung trennen und Punkt sichern;
12. Messstand, Charge, Menge und Zustand bestätigen lassen;
13. Rohöl einlagern oder zum nächsten Ziel transportieren.

Die aktive Tätigkeit soll aus wenigen sinnvollen Arbeitsschritten bestehen. Sie wird nicht durch ständig wiederholte Zufallstasten künstlich verlängert.

Förderung benötigt im MVP Anwesenheit am Standort. Vollständig unbeaufsichtigte Hintergrundförderung ist zunächst nicht vorgesehen. Stationäre Industrieproduktion in einer Raffinerie kann dagegen serverseitig im Hintergrund weiterlaufen.

## 12.11 Berechnung von Fördermenge und Geschwindigkeit

Ein Fördervorgang berücksichtigt:

- Basisleistung des Förderpunkts;
- Feldzustand;
- Pumpenleistung;
- Wartungszustand;
- Bedienerfähigkeit;
- mögliche Spezialisierung;
- Zielbehälter und Anschluss;
- Sicherheitsbegrenzung;
- konfigurierbare Servermultiplikatoren.

Fähigkeiten erzeugen keine Rohstoffe aus dem Nichts. Sie können innerhalb enger Grenzen:

- Rüstzeit verkürzen;
- sicheren Durchsatz erhöhen;
- Verluste reduzieren;
- Qualitätsfehler früher erkennen;
- Verschleiß senken;
- etwas mehr nutzbares Produkt aus demselben Kontingent gewinnen.

Jede geförderte Menge reduziert dasselbe serverseitig reservierte Kontingent. Abbruch, Timeout und Neustart dürfen weder doppelte Mengen erzeugen noch bestätigte Mengen verlieren.

## 12.12 Fördersitzung als Zustandsmaschine

| Zustand | Bedeutung |
|---|---|
| `created` | Vorgang wurde angelegt |
| `validated` | Rechte, Kapazität und Ausrüstung wurden geprüft |
| `connected` | Förderpunkt und Zielbehälter sind verbunden |
| `pumping` | Menge wird serverseitig fortgeschrieben |
| `paused` | Vorgang ist sicher unterbrochen |
| `completing` | Schlussmessung und Charge werden gebucht |
| `completed` | Menge und Zustände sind endgültig bestätigt |
| `aborted` | kontrollierter Abbruch mit bestätigter Teilmenge |
| `failed` | Störung, Regelverstoß oder nicht auflösbarer Fehler |

Zustandswechsel sind idempotent und werden mit einer Vorgangs-UUID protokolliert.

## 12.13 Mobile Behälter und Tanktrailer

Tanktrailer sind eigenständige persistente Fahrzeuge. Ein Trailer kann ein oder mehrere Abteile besitzen.

Jedes Abteil besitzt:

- Kapazität;
- sichere maximale Füllmenge;
- aktuellen Füllstand;
- Produkt oder Leerstatus;
- Warencharge beziehungsweise Mischcharge;
- Restmenge;
- Kontaminationsstatus;
- Ventil- und Dichtungszustand;
- Plombenstatus;
- letzte Reinigung.

Unverträgliche Produkte dürfen nicht ohne geeignete Reinigung eingefüllt werden. Ein Produktwechsel kann Reinigung, Entsorgung der Restmenge und einen dokumentierten Zustandswechsel verlangen.

Das Gewicht der Ladung beeinflusst das Fahrzeuggewicht und kann später Fahrverhalten, Bremsweg und Verschleiß berücksichtigen. Im MVP werden mindestens zulässige Kapazität und Überladung serverseitig geprüft.

## 12.14 Laden, Entladen und Flüssigkeitstransfer

Jeder Flüssigkeitstransfer erfolgt zwischen zwei eindeutigen Quellen:

- Förderpunkt zu Trailer;
- Trailer zu Tanklager;
- Tanklager zu Raffinerie;
- Raffinerie zu Produkttank;
- Produkttank zu Trailer;
- Trailer zu Tankstelle;
- Tankstelle zu Fahrzeug.

Der Server führt für einen Transfer:

- Quell- und Zielobjekt;
- Quell- und Zielmessstand;
- Produkt und Charge;
- reservierte Maximalmenge;
- tatsächlich bestätigte Menge;
- Qualitätswert vor und nach Transfer;
- Verluste im erlaubten Rahmen;
- Bediener;
- Auftrag und Vertrag;
- Zeitpunkte;
- Vorgangs-UUID.

Die Menge wird nicht vom Client gesetzt. Der Client darf nur Start, Pause oder Ende anfragen und die serverseitigen Werte anzeigen.

## 12.15 Plomben, Messstände und Liefernachweis

Kommerzielle Transporte können beim Beladen eine digitale Plombe erhalten. Die Plombe verknüpft:

- Trailer und Abteil;
- Produkt;
- Charge;
- Ausgangsmenge;
- Ausgangsqualität;
- Beladeort;
- Auftrag;
- Zeitpunkt.

Öffnen, Beschädigen oder Ersetzen einer Plombe wird protokolliert. Bei Ankunft werden Plombe, Messstand, Qualität und Menge verglichen.

Abweichungen können zu folgenden Ergebnissen führen:

- vollständige Annahme;
- Teilannahme;
- Preisabzug;
- Quarantäne;
- Ablehnung;
- Vertragsstreit;
- Verdachtsmeldung.

## 12.16 Gefahrgut und Transportvoraussetzungen

Je nach Produkt und Serverkonfiguration sind erforderlich:

- passende Fahrerlaubnis;
- Gefahrgutlizenz;
- geeignete Zugmaschine;
- zugelassener Tanktrailer;
- funktionsfähige Ventile und Reifen;
- erlaubte Füllmenge;
- aktiver Liefer- oder Eigentumsnachweis.

Es gibt keine erzwungene starre Route. Verträge können Zeitfenster, Zielort und optionale Kontrollpunkte definieren. Der Fahrer entscheidet grundsätzlich selbst über die Strecke und trägt das Risiko für Verspätung, Schaden oder Überfall.

## 12.17 Tanklager und Depots

Ein Tanklager ist eine `cnr_storage`-Anlage mit einem oder mehreren Tanks.

Jeder Tank besitzt:

- Produktfreigabe;
- Gesamt- und Sicherheitskapazität;
- aktuellen Füllstand;
- reservierte Eingangs- und Ausgangsmenge;
- Qualitäts- und Kontaminationsstatus;
- Eigentümer und Betreiber;
- Zugriffsrechte;
- Pump- und Anschlussleistung;
- Wartungszustand;
- Ein- und Auslagerungsgebühr;
- Alarm- und Sperrstatus.

Ein Unternehmen kann Tanks besitzen oder Kapazität in einem fremden Depot mieten. Gemietete Kapazität und Warenbesitz bleiben getrennt.

## 12.18 Lagergebühren und Kapazitätsmiete

Mögliche Preismodelle:

- feste Monatsmiete;
- Preis pro reserviertem Liter;
- Preis pro tatsächlich belegtem Liter;
- Ein- und Auslagerungsgebühr;
- Mindestlaufzeit;
- Kaution;
- Zusatzkosten für Gefahrgut, Kühlung oder Überwachung.

Bei Vertragsende werden Waren nicht gelöscht. Sie werden gesperrt, in ein vereinbartes Ersatzlager überführt oder über einen geregelten Herausgabe- und Verwertungsprozess behandelt.

## 12.19 Raffinerietypen

### Öffentliche Raffinerie

- staatlich oder systemseitig betrieben;
- verarbeitet fremdes Rohöl gegen Gebühr;
- besitzt begrenzte Kapazität;
- nimmt Aufträge nach Priorität oder Buchung an;
- dient als verlässlicher Einstieg für kleine Unternehmen.

### Private Raffinerie

- gehört einem Unternehmen oder wird langfristig gepachtet;
- benötigt Grundstück, Anlage, Tanks, Betriebslizenz und Wartung;
- kann eigene Waren verarbeiten;
- kann Verarbeitung als Dienstleistung anbieten;
- bestimmt Preise innerhalb wirtschaftlicher und regulatorischer Grenzen.

### Lohnraffination

Der Kunde bleibt Eigentümer des Rohöls und erhält die vertraglich vereinbarten Ausgangsprodukte. Der Raffineriebetreiber erhält eine Gebühr oder einen vereinbarten Produktanteil.

## 12.20 Annahme von Rohöl

Vor Annahme prüft die Raffinerie:

1. Lieferauftrag und Berechtigung;
2. Rohölprodukt und Charge;
3. Plombe und Messstände;
4. verfügbare Eingangskapazität;
5. Qualitätsprofil;
6. Kontamination;
7. Eigentums- und Vertragsdaten;
8. vereinbarte Mindest- und Höchstmengen.

Rohöl kann angenommen, teilweise angenommen, in Quarantäne gestellt oder abgelehnt werden.

Eine Laborprüfung erzeugt ein unveränderliches Qualitätsergebnis. Korrigierte Prüfungen ersetzen die Historie nicht, sondern werden als neue Messung mit Begründung gespeichert.

## 12.21 Rezepturen und Massenerhaltung

Raffinerierezepte sind versioniert und enthalten:

- gültige Eingangsprodukte;
- Qualitätsgrenzen;
- Eingangsmenge;
- Ausgangsprodukte und Verhältnisse;
- erlaubte Verluste;
- Nebenprodukte und Abfall;
- benötigte Energie;
- Hilfs- und Zusatzstoffe;
- Maschinenanforderungen;
- Grunddauer;
- Qualitätsformeln;
- Freigabestatus.

Mengenverhältnisse werden ganzzahlig, beispielsweise in Anteilen pro Million, gespeichert. Ausgangsprodukte, Nebenprodukte und zulässige Verluste müssen zusammen zum Eingang passen. Rezepte dürfen keine unkontrollierte Warenvermehrung erzeugen.

Ein laufender Produktionsauftrag behält seine Rezeptversion, auch wenn ein Administrator später eine neue Version veröffentlicht.

## 12.22 Produktionsauftrag der Raffinerie

Ein Auftrag enthält:

- Auftrag-UUID;
- Betreiber und Auftraggeber;
- Raffinerie und Produktionslinie;
- Rezeptversion;
- Rohölcharge und reservierte Menge;
- Eigentum an Ein- und Ausgängen;
- Zielprodukttanks;
- Energie- und Hilfsstoffreservierung;
- Start- und Endzeit;
- Priorität;
- Gebühren;
- aktuellen Zustand;
- Ergebnis- und Verlustmengen.

Vor dem Start reserviert der Server alle Eingänge und genügend Ausgangskapazität. Ohne vollständige Reservierung startet die Produktion nicht.

## 12.23 Raffinerieablauf

1. Rohöl annehmen und prüfen;
2. Eingangscharge und Hilfsstoffe reservieren;
3. freie Ausgangstanks reservieren;
4. Produktionslinie vorbereiten;
5. Auftrag starten;
6. Energie, Rohstoffe und Maschinenzustand serverseitig fortschreiben;
7. mögliche Störungen behandeln;
8. Ausgangsmengen und Qualität berechnen;
9. Produkte, Nebenprodukte und Abfall buchen;
10. Ausgangschargen in reservierte Tanks einlagern;
11. Gebühren, Löhne und Vertragserfüllung abrechnen;
12. Produktions- und Auditbericht abschließen.

## 12.24 Hintergrundproduktion und Neustarts

Eine laufende Raffinerieproduktion darf ohne anwesenden Spieler weiterlaufen, sofern:

- der Auftrag gestartet und vollständig reserviert wurde;
- die Anlage betriebsbereit ist;
- Energie und Hilfsstoffe vorhanden sind;
- Ausgangskapazität reserviert bleibt;
- keine Störung oder administrative Sperre vorliegt.

Beim Serverneustart wird nicht jede vergangene Sekunde einzeln simuliert. Der Server berechnet den zulässigen Fortschritt anhand gespeicherter Zeitpunkte, Ressourcen, Maschinenzustände und Obergrenzen.

Ein Auftrag kann niemals über die vorhandenen Eingänge, die Ausgangskapazität oder sein vertragliches Limit hinaus produzieren.

## 12.25 Wartung, Verschleiß und Störungen

Maschinen besitzen:

- Zustand;
- Verschleiß;
- Wartungsintervall;
- letzte Wartung;
- Betriebsstunden;
- Fehlerstatus;
- benötigte Ersatzteile.

Schlechter Zustand kann:

- Produktion verlangsamen;
- Energieverbrauch erhöhen;
- Verlustmenge erhöhen;
- Qualitätswert senken;
- einen kontrollierten Stopp auslösen;
- bei aktivierten erweiterten Störfällen ein Leck oder einen Brand verursachen.

Wartung ist ein wirtschaftlicher Auftrag für Mechaniker oder spezialisierte Firmen und keine bloße Administrationsgebühr.

## 12.26 Produktqualität und Mischung

Ausgangsqualität hängt ab von:

- Rohölqualität;
- Rezept;
- Maschinenzustand;
- Bedienerfähigkeit bei beaufsichtigten Schritten;
- Zusatzstoffen;
- Störungen;
- möglicher Kontamination.

Produktchargen dürfen kontrolliert gemischt werden. Die neue Qualität wird serverseitig berechnet. Eine Mischung kann:

- eine Zielqualität erreichen;
- weiterhin verkaufsfähig bleiben;
- nur noch als niedrige Qualität gelten;
- in Quarantäne fallen;
- als Abfall eingestuft werden.

Premiumkraftstoff entsteht nicht durch Umbenennung, sondern durch eine passende Rezeptur oder zulässige Mischung mit entsprechenden Kosten.

## 12.27 Nebenprodukte und Abfall

Nebenprodukte können:

- an andere Branchen verkauft;
- in späteren Rezepten weiterverarbeitet;
- gelagert;
- exportiert;
- fachgerecht entsorgt werden.

Abfall benötigt ein geeignetes Lager und einen Entsorgungsnachweis. Einfaches Löschen ist nicht erlaubt. Illegale Entsorgung kann später Ermittlungen, Bußgelder und Umweltaufträge auslösen.

Im MVP werden Nebenprodukt und Produktionsabfall bereits mengenmäßig geführt, auch wenn deren weitere Verarbeitung zunächst begrenzt ist.

## 12.28 Großhandel und Lieferverträge

Raffinerien, Depots und Tankstellen können:

- einmalige Kaufangebote;
- Rahmenverträge;
- Abrufaufträge;
- Mindestabnahmemengen;
- Preisformeln;
- Qualitätsanforderungen;
- Lieferzeitfenster;
- Vertragsstrafen;
- Transport inklusive oder ab Werk

vereinbaren.

Der Preis kann fest, indexiert oder bei jedem Abruf neu angeboten werden. Jeder Abruf erzeugt einen konkreten Auftrag mit reservierter Ware und Zielkapazität.

## 12.29 Tankstellen als Unternehmen und Anlage

Eine Tankstelle besteht aus:

- Grundstück und Gebäude;
- Betreiberunternehmen;
- Betriebslizenz;
- einem oder mehreren unterirdischen Tanks;
- Zapfsäulen;
- Zapfpistolen;
- Verkaufs- und Preiskonfiguration;
- Kassen- oder Bankkonto;
- Bestellregeln;
- Mitarbeitern und Zugriffsrechten;
- optionalem Shop und weiteren Diensten.

Eigentümer, Betreiber und Kraftstoffeigentümer können unterschiedliche Parteien sein. Eine Tankstelle kann gekauft, gepachtet oder durch einen staatlichen Betreiber geführt werden.

## 12.30 Produkttanks, Zapfsäulen und Zapfpistolen

Jeder Tankstellen-Tank führt:

- zugelassenes Produkt;
- Kapazität und Sicherheitsreserve;
- verfügbaren und reservierten Bestand;
- Charge und Qualität;
- Mindestbestand;
- Bestellschwelle;
- Leckage- und Wartungsstatus.

Jede Zapfpistole ist genau einer Produktleitung beziehungsweise einem Tank zugeordnet. Die sichtbare Beschriftung allein entscheidet nicht über das Produkt.

Eine Zapfsäule besitzt:

- Weltobjekt-UUID;
- Pumpennummer;
- zugeordnete Zapfpistolen;
- Preisdisplay;
- Zählerstand;
- Betriebs- und Sperrstatus;
- maximale gleichzeitige Sitzung.

## 12.31 Kraftstoffarten und Fahrzeuge

Eine Fahrzeugdefinition legt fest:

- Kraftstoffart;
- Tankkapazität;
- aktuellen Füllstand;
- grundlegenden Verbrauch;
- erlaubte Kraftstoffe;
- optionale Qualitätsanforderung.

Im MVP werden mindestens Benzin und Diesel unterschieden. Fahrzeuge ohne Kraftstoffsystem und spätere Elektrofahrzeuge werden separat behandelt.

Falschbetankung wird im MVP durch die serverseitige Produktverträglichkeit verhindert. Ein erweitertes Fehlbetankungs- und Schadenssystem kann später ergänzt werden.

## 12.32 Tankvorgang

Vor Beginn prüft der Server:

1. Spieler, Fahrzeug, Zapfsäule und Entfernung;
2. Fahrzeugzugriff;
3. Kraftstoffverträglichkeit;
4. freie Fahrzeugtankkapazität;
5. verfügbaren Tankstellenbestand;
6. gültigen Preis;
7. gewählte Zahlungsart und Deckung;
8. freie Zapfsäule und nicht gesperrte Anlage.

Der Preis wird für die Sitzung als Momentaufnahme eingefroren. Der Betreiber kann einen laufenden Tankvorgang nicht durch eine Preisänderung verteuern.

Bei Kontozahlung wird ein Maximalbetrag reserviert und nach Abschluss exakt abgerechnet. Bei Bargeldzahlung wird ein Betrag vorausbezahlt; nicht verbrauchtes Guthaben wird nachvollziehbar zurückgegeben.

Der Server schreibt Menge und Preis schrittweise oder in sicheren Intervallen fort. Der Client stellt Zapfschlauch, Animation, Anzeige und Eingabe dar, bestimmt jedoch weder Liter noch Endpreis.

## 12.33 Abschluss eines Tankvorgangs

Beim Abschluss werden atomar:

- Kraftstoffbestand der Tankstelle reduziert;
- Fahrzeugfüllstand erhöht;
- reservierter Betrag abgerechnet;
- Umsatz auf das Betreiberkonto gebucht;
- Steuer und mögliche Gebühren gebucht;
- Pumpenzähler aktualisiert;
- Warencharge verknüpft;
- Beleg und Auditvorgang erstellt.

Abbruch, Verbindungsverlust und Serverneustart verwenden den letzten serverseitig bestätigten Stand. Dieselbe Tankvorgangs-UUID kann nicht doppelt abgerechnet werden.

## 12.34 Preisbildung an Tankstellen

Der Tankstellenbetreiber bestimmt seine Verkaufspreise. Der Server kann konfigurierbare Leitplanken verwenden:

- absoluter Mindestpreis;
- absoluter Höchstpreis;
- maximale Änderung pro Zeitfenster;
- Steueranteil;
- Preisuntergrenze für staatlich subventionierte Ware;
- Schutz vor versehentlichen Extremwerten.

Der Marktpreis entsteht vor allem aus:

- Einkaufspreis;
- Transportkosten;
- Lager- und Betriebskosten;
- Löhnen;
- Steuern;
- Verlusten;
- lokaler Konkurrenz;
- Bestand und Nachfrage;
- gewünschter Marge.

Preisänderungen werden historisiert. Verdeckte oder rückwirkende Preisänderungen sind nicht möglich.

## 12.35 Bestellregeln und Nachversorgung

Eine Tankstelle kann:

- manuell bestellen;
- einen bestehenden Liefervertrag abrufen;
- bei einer Bestellschwelle automatisch einen Abrufauftrag erzeugen;
- Angebote auf dem Marktplatz einholen;
- in einer Versorgungskrise begrenzte Notversorgung beantragen.

Eine automatische Bestellung reserviert nicht unkontrolliert Geld. Sie besitzt:

- freigegebenes Budget;
- maximale Menge;
- erlaubte Lieferanten;
- Qualitätsminimum;
- Höchstpreis;
- Mindestabstand zwischen Bestellungen;
- zuständige Freigaberolle.

## 12.36 Begrenzte NPC-Notversorgung

NPC-Notversorgung verhindert einen dauerhaft unspielbaren Server, ersetzt aber nicht die Spielerwirtschaft.

Sie ist:

- deutlich teurer als eine normale Spielerlösung;
- mengenmäßig begrenzt;
- mit Abklingzeit versehen;
- nur bei tatsächlichem Versorgungsmangel verfügbar;
- vollständig protokolliert;
- nicht frei weiterverkaufbar, wenn dadurch sichere Arbitrage entstehen würde.

Die Notversorgung kann als Import vom Hafen oder als staatliche Reserve dargestellt werden. Auch sie erzeugt einen realen Lieferauftrag; eine sofortige magische Tankfüllung ist nur als ausdrücklich aktivierbarer administrativer Notfallmodus vorgesehen.

## 12.37 Begrenzter Exportmarkt

Ein Exportterminal kann überschüssige Waren in begrenzter Menge ankaufen. Dadurch bleibt die Kette bei geringer Spielerzahl funktionsfähig.

Der Export:

- besitzt zeitabhängige Mengenlimits;
- zahlt normalerweise weniger als der lokale Markt;
- verwendet dynamische Preise;
- verlangt echte Lieferung;
- akzeptiert nur definierte Qualität;
- verhindert unbegrenztes Verkaufen an das System.

Import und Export dürfen keine garantierte Preisdifferenz erzeugen, mit der ohne Spielerbedarf dauerhaft Geld vervielfacht werden kann.

## 12.38 Wirtschaftliche Quellen und Senken

Einnahmen entstehen unter anderem durch:

- Verkauf von Rohöl;
- Raffineriedienstleistungen;
- Produktverkauf;
- Transporte;
- Lagervermietung;
- Tankstellenumsätze;
- Wartungsleistungen;
- begrenzten Export.

Kosten und Geldsenken:

- Förderrechte und Konzessionen;
- Fahrzeug- und Ausrüstungsmiete;
- Kautionen und Finanzierung;
- Energie;
- Wartung und Ersatzteile;
- Lagergebühren;
- Löhne;
- Kraftstoff für Transporte;
- Zusatzstoffe;
- Versicherungen;
- Steuern und Lizenzen;
- Produktverluste;
- Entsorgung;
- Vertragsstrafen.

Jede Kostenart soll eine spielerische oder regulierende Funktion besitzen. Gebühren werden nicht nur eingeführt, um Geld willkürlich zu vernichten.

## 12.39 Fähigkeiten, Ruf und Lizenzen

Relevante Fähigkeiten:

- Rohstoffförderung;
- Industrieanlagenbedienung;
- Tankerlogistik;
- Raffination;
- Qualitätsprüfung;
- Tankstellenbetrieb.

Mögliche Spezialisierungen:

- schneller Anlagenaufbau;
- materialschonende Förderung;
- sichere Hochleistungsförderung;
- energieeffiziente Raffination;
- Qualitätsmischung;
- verlustarmes Be- und Entladen;
- vorbeugende Wartung.

Relevanter Ruf:

- Ölfeldbetreiber;
- Raffinerien;
- Gefahrgutlogistik;
- Kraftstoffgroßhandel;
- staatliche Aufsicht.

Mögliche Lizenzen:

- Förderlizenz;
- Anlagenbedienberechtigung;
- Gefahrguttransport;
- Raffineriebetrieb;
- Tankstellenbetrieb;
- Abfall- und Gefahrstoffhandhabung.

Fähigkeit ersetzt keine rechtliche Lizenz. Lizenz ersetzt keine tatsächliche Erfahrung.

## 12.40 Unfälle, Leckagen und Brände

Mögliche Störfälle:

- defekte Pumpe;
- beschädigtes Ventil;
- Leck am Trailer;
- verunreinigter Tank;
- überfüllter Behälter;
- Raffineriestörung;
- Brand;
- Explosion bei schweren Regelverstößen;
- verschütteter Kraftstoff.

Störfälle werden serverseitig ausgelöst und begrenzt. Sie dürfen nicht als einfaches Werkzeug für massenhaftes Griefing dienen.

Im MVP sind Wartungsstopp, Qualitätsverlust, kontrollierte Leckage und Alarmierung vorgesehen. Umfangreiche Feuer-, Umwelt- und Dekontaminationssimulationen folgen später.

## 12.41 Kriminalität und Ermittlungsansätze

Der Ölkreislauf bietet Cops-&-Robbers-Anknüpfungspunkte:

- Überfall auf einen Tanktransport;
- Diebstahl aus Tank oder Trailer;
- Aufbrechen einer digitalen Plombe;
- Verkauf gestohlener Ware;
- gepanschter Kraftstoff;
- manipulierte Lieferpapiere;
- Sabotage;
- illegale Entsorgung;
- Betrieb ohne Lizenz;
- Bestechung und Vertragsbetrug.

Kriminelle Aktionen benötigen eigene Regeln, Risiken, Werkzeuge und Abnehmer. Eine normale Ladefunktion darf nicht durch einen simplen Clientevent zum Diebstahl umfunktioniert werden.

Mögliche Beweise:

- beschädigte Plombe;
- Werkzeugspuren;
- Fingerabdrücke;
- Kameraaufnahmen;
- Fahrzeug- und Kennzeichendaten;
- GPS- oder Messprotokolle;
- veränderte Qualitätsprobe;
- Abweichung zwischen Lade- und Liefermenge;
- Vertrags- und Bankspuren.

Die genaue Ausgestaltung wird im späteren Kriminalitäts- und Polizeikapitel festgelegt.

## 12.42 Dynamische Erstellung und Konfiguration

Administratoren können im Ingame-Editor als Entwurf erstellen:

- Ölfelder und Feldzonen;
- Förderpunkte;
- Ausrüstungs-Spawnpunkte;
- Tanklager;
- einzelne Tanks und Anschlüsse;
- öffentliche oder private Raffinerien;
- Produktionslinien;
- Tankstellen;
- Produkttanks;
- Zapfsäulen und Zapfpistolen;
- Lade- und Entladezonen;
- Import- und Exportterminals.

Konfigurierbar sind unter anderem:

- Kontingente und Erholungsraten;
- Qualitätsprofile;
- Fördergeschwindigkeiten;
- Miet- und Lizenzkosten;
- Behälterkapazitäten;
- Produktverträglichkeit;
- Rezeptversionen;
- Produktionsdauer und Energiebedarf;
- zulässige Verluste;
- Bestellschwellen;
- Preisleitplanken;
- Notversorgungs- und Exportlimits;
- Störfallwahrscheinlichkeiten;
- Fähigkeits- und Rufanforderungen.

Änderungen durchlaufen Entwurf, Validierung, Vorschau und Veröffentlichung. Bereits laufende Verträge, Chargen und Produktionsaufträge behalten ihre gültigen Versionen.

## 12.43 Validierung beim Veröffentlichen

Vor der Veröffentlichung prüft der Editor mindestens:

- eindeutige UUIDs;
- gültige Zonen und Routing-Bucket-Regeln;
- erreichbare Interaktionspunkte;
- positive und plausible Kapazitäten;
- vollständig zugeordnete Produkte;
- kompatible Tank- und Leitungsverbindungen;
- vollständige Rezeptbilanzen;
- existierende Eingangs- und Ausgangslager;
- gültige Konten und Betreiber;
- nicht überlappende aktive Zapfsäuleninteraktionen;
- Preis-, Kontingent- und Zeitgrenzen;
- referenzierte Lizenzen und Berechtigungen.

Fehlerhafte Konfigurationen bleiben Entwürfe und werden nicht live geschaltet.

## 12.44 Geplante Datenbanktabellen

Branchenspezifisch vorgesehen:

- `cnr_resource_fields`
- `cnr_resource_field_nodes`
- `cnr_extraction_rights`
- `cnr_extraction_equipment`
- `cnr_extraction_sessions`
- `cnr_extraction_meter_readings`
- `cnr_bulk_transfer_sessions`
- `cnr_bulk_transfer_events`
- `cnr_batch_quality_results`
- `cnr_tank_compartments`
- `cnr_tank_seals`
- `cnr_tank_cleaning_events`
- `cnr_fuel_stations`
- `cnr_fuel_station_tanks`
- `cnr_fuel_pumps`
- `cnr_fuel_nozzles`
- `cnr_fuel_prices`
- `cnr_fuel_price_history`
- `cnr_fueling_sessions`
- `cnr_station_reorder_rules`
- `cnr_emergency_supply_orders`
- `cnr_export_market_windows`

Wiederverwendet werden insbesondere:

- Warenchargen und Inventare aus `cnr_inventory`;
- Lagerorte und Bewegungen aus `cnr_storage`;
- Anlagen, Maschinen, Rezepte und Produktionsaufträge aus `cnr_facilities`;
- Fahrzeuge, Trailer und Zustände aus `cnr_vehicles`;
- Mietverträge aus `cnr_rentals`;
- Firmen und Mitarbeiter aus `cnr_businesses` und `cnr_employment`;
- Verträge und Aufträge aus `cnr_contracts`;
- Zahlungen und Reservierungen aus `cnr_banking`.

## 12.45 Serverautorisierte Regeln

- Kein Client bestimmt Produktmenge, Qualität, Verkaufspreis oder Auszahlung.
- Jede Flüssigkeitsbewegung besitzt Quelle, Ziel und Vorgangs-UUID.
- Quellmenge, Zielkapazität und Produktverträglichkeit werden in derselben Transaktion geprüft.
- Reservierte Ware kann nicht gleichzeitig verkauft, verarbeitet und ausgeliefert werden.
- Jede Charge besitzt nachvollziehbare Herkunft.
- Kein Produktionsauftrag startet ohne reservierte Eingänge und Ausgänge.
- Rezeptversionen sind nach Produktionsstart unveränderlich.
- Fahrzeug, Trailer, Tank, Zapfsäule und Anlage werden über dauerhafte UUIDs identifiziert.
- Entfernung, Routing Bucket, Zugriffsrecht, Vertrag und Zustand werden serverseitig geprüft.
- Preis und Steuer eines Tankvorgangs werden zu Beginn eingefroren.
- Ein Vorgang kann durch Wiederholung derselben Anfrage nicht doppelt auszahlen oder buchen.
- Neustartwiederherstellung verwendet den letzten bestätigten Zustand.
- Administrative Korrekturen erfolgen als protokollierte Gegenbewegung, nicht durch Löschen.

## 12.46 Überwachung und Economy-Kennzahlen

Für Balancing und Fehlersuche werden aggregiert:

- geförderte Menge pro Feld und Zeitraum;
- durchschnittliche Rohölqualität;
- Raffinerieauslastung;
- Produktionsverluste;
- Bestände pro Depot und Tankstelle;
- offene Lieferaufträge;
- durchschnittliche Groß- und Einzelhandelspreise;
- regionale Versorgungsreichweite;
- Notversorgungsquote;
- Exportmenge;
- Transportverluste;
- Anzahl abgebrochener oder fehlerhafter Vorgänge;
- Geldflüsse zwischen Spielern, Unternehmen und Systemkonten.

Die Kennzahlen dienen der kontrollierten Anpassung. Balancingänderungen werden versioniert und nicht heimlich rückwirkend auf abgeschlossene Vorgänge angewendet.

## 12.47 Minimal Viable Product des Ölkreislaufs

Im ersten spielbaren MVP enthalten:

- mindestens ein staatliches Ölfeld mit mehreren Förderpunkten;
- Förderauftrag und begrenztes Förderkontingent;
- eigene oder gemietete Zugmaschine;
- eigener oder gemieteter Tanktrailer;
- aktive serverseitige Förderung;
- Rohölcharge mit Qualität und Herkunft;
- Tankabteile und Flüssigkeitstransfers;
- mindestens ein Tankdepot;
- öffentliche Raffinerie;
- versioniertes Grundrezept;
- Benzin, Diesel, Nebenprodukt und Abfall;
- neustartsichere Produktionsaufträge;
- Transportauftrag zur Tankstelle;
- Tankstellen-Tanks, Zapfsäulen und dynamische Bestände;
- Betreiberpreise mit Leitplanken;
- serverseitiger Tankvorgang;
- manuelle und schwellenbasierte Nachbestellung;
- teure begrenzte Notversorgung;
- begrenzter Exportmarkt;
- grundlegende Fähigkeiten, Lizenzen und Ruf;
- Wartungszustände;
- vollständige Finanz-, Waren- und Auditspur;
- Erstellung der Standorte über den Ingame-Editor.

## 12.48 Spätere Ausbaustufen

- private Förderkonzessionen und Auktionen;
- mehrere Rohölsorten und tiefere Chemiesimulation;
- zusätzliche Raffineriestufen und Produktlinien;
- Kerosin, Heizöl, Schmierstoffe und Bitumen;
- komplexes Blending;
- vollständige Labortätigkeit;
- freie Raffinerieerweiterungen und Bauprojekte;
- Rohrleitungen und Pipelines;
- Schiffs- und Bahntransporte;
- umfassende Umwelt- und Dekontaminationssysteme;
- dynamische Großschadenslagen;
- tiefere Versicherungen;
- komplexe Schmuggel- und Panschmechaniken;
- Strom- und Wassernetzabhängigkeit;
- Elektro-Ladeinfrastruktur.

## 12.49 Referenzablauf

Ein vollständiger wirtschaftlicher Vorgang:

1. Eine Tankstelle unterschreitet ihren Diesel-Mindestbestand.
2. Ihre Bestellregel erzeugt einen Abrufauftrag innerhalb des freigegebenen Budgets.
3. Ein Raffineriebetreiber bestätigt Menge, Qualität und Preis.
4. Fehlt Produkt, startet die Raffinerie einen Produktionsauftrag.
5. Rohöl und Ausgangstanks werden reserviert.
6. Ein Förderunternehmen erhält einen Rohölauftrag.
7. Ein Fahrer mietet Zugmaschine und Tanktrailer.
8. Das Team fördert eine nachvollziehbare Rohölcharge.
9. Die Charge wird verplombt zur Raffinerie transportiert.
10. Die Raffinerie nimmt sie nach Messung und Qualitätsprüfung an.
11. Der Produktionsauftrag erzeugt Diesel, weitere Produkte, Nebenprodukt und Abfall.
12. Diesel wird für den Tankstellenauftrag reserviert.
13. Ein Gefahrgutfahrer lädt die Charge und erhält einen Liefernachweis.
14. Die Tankstelle prüft Plombe, Menge und Qualität.
15. Der Diesel wird in den zugeordneten Tank übertragen.
16. Vertrag, Fahrer, Lieferant und gegebenenfalls Lager werden bezahlt.
17. Ein Spieler tankt sein Dieselfahrzeug.
18. Der Bestand sinkt, der Umsatz wird gebucht und der nächste Bedarf entsteht.

Damit entsteht ein geschlossener Kreislauf zwischen tatsächlicher Nachfrage, Spielerarbeit, Unternehmen und Verbrauch.

## 12.50 Abnahmekriterien für das spätere Scripting

Der Öl-MVP gilt fachlich als funktionsfähig, wenn:

- der gesamte Referenzablauf ohne administrative Waren- oder Geldgabe spielbar ist;
- jede Menge und Zahlung bis zur Quelle zurückverfolgt werden kann;
- kein Neustart eine bestätigte Menge dupliziert oder löscht;
- zwei Spieler nicht dieselbe reservierte Ware gleichzeitig verwenden können;
- falsche Fahrzeuge, Produkte, Rechte oder Behälter abgewiesen werden;
- kleine Spielergruppen öffentliche Infrastruktur nutzen können;
- größere Unternehmen eigene Teile der Kette betreiben können;
- leere Tankstellen durch Spielerlieferungen wieder versorgt werden;
- die Notversorgung selten und wirtschaftlich unattraktiv bleibt;
- alle Standorte und Kernwerte ohne Codeänderung konfigurierbar sind;
- Fähigkeiten spürbar helfen, aber keine unkontrollierten Ertragsmultiplikatoren erzeugen;
- legale Arbeit, wirtschaftlicher Wettbewerb und kriminelle Risiken miteinander verbunden sind.

---

# 13. Weitere geplante Systeme

## 13.1 Legale Berufe

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

## 13.2 Kriminalität

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

## 13.3 Polizeisystem

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

## 13.4 Beweissystem

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

# 14. Dynamische Administration

## 14.1 Ingame-Editor

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

## 14.2 Externes Control Panel

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

# 15. Einheitliches UI-System

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

# 16. Sicherheitsgrundsätze

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

# 17. Aktuelle verbindliche Entscheidungen

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
| Firmenvermögen | vollständig vom Privatvermögen getrennt |
| Unternehmensrechte | rollen- und berechtigungsbasiert |
| Löhne | aus realem Firmen- oder Staatskonto |
| Arbeitszeit | nur durch aktive und plausible Arbeitssitzungen |
| Verträge | nach Signatur unveränderlich, Änderungen nur als Version oder Nachtrag |
| Aufträge | konkrete Ausführung innerhalb oder außerhalb eines Rahmenvertrags |
| Bedarfsaufträge | bevorzugt aus tatsächlichen Beständen und Nachfrage |
| Unternehmensruf | aus realer Vertragserfüllung statt einfacher Sternebewertung |
| Insolvenz | geregelter Statusprozess, keine automatische Datenlöschung |
| Immobilienstruktur | Grundstück, Gebäude, Einheit und Funktionsbereich getrennt |
| Innenräume | physische MLOs und serverseitig instanzierte Shells |
| Immobilienzugriff | getrennte Rollen für Eigentümer, Mieter, Bewohner und Mitarbeiter |
| Mietrückstand | Karenz- und Räumungsprozess, keine sofortige Inventarlöschung |
| Lagerkapazität | abhängig von Gewicht, Volumen, Slots, Paletten oder Litern |
| Warenbestand | Chargen, Qualität, Herkunft und Reservierungen bleiben erhalten |
| Produktionsanlage | getrennt von Grundstück, Gebäude und Lager |
| Produktion | serverseitig, versioniert und nur mit reservierten Eingängen |
| Hintergrundproduktion | möglich, aber durch Ressourcen, Kapazität und Wartung begrenzt |
| Flüssigkeitsmenge | ganzzahlige Basiseinheit in Millilitern mit `BIGINT`, Anzeige in Litern |
| Rohstofffelder | begrenzte Kontingente mit konfigurierbaren Erholungszyklen |
| aktive Förderung | im MVP nur mit Anwesenheit am Standort |
| Produktbilanz | Produktion erhält Mengenbilanz aus Produkten, Nebenprodukten und Verlusten |
| Flüssigkeitstransfer | immer zwischen eindeutiger Quelle und eindeutigem Ziel |
| Tanktrailer | persistente Abteile mit Kapazität, Produkt, Charge, Zustand und Plombe |
| Kraftstoffarten | im MVP mindestens Benzin und Diesel |
| Tankstellenpreise | Betreiberpreis innerhalb konfigurierbarer Leitplanken |
| Preis während Tankvorgang | wird beim Start eingefroren |
| Notversorgung | teuer, begrenzt, bedarfsabhängig und grundsätzlich als Lieferung |
| Exportmarkt | mengenbegrenzt und normalerweise unattraktiver als lokaler Handel |
| öffentliche Industrie | Ölfeld und Raffinerie ermöglichen kleinen Betreibern den Einstieg |
| Codesprache | Englisch |
| UI-Sprache | zunächst Deutsch, vollständig übersetzbar |

---

# 18. Planungsreife und Coding-Start

## 18.1 Aktueller Stand

Das wirtschaftliche und rollenspielerische Grundgerüst ist bereits weit fortgeschritten. Detailliert geplant sind:

- Servervision und Entwicklungsroadmap;
- Standalone-Modularchitektur;
- Accounts, Sitzungen, Charaktere und Identität;
- Datenbankgrundsätze;
- Items und Inventare;
- Bargeld, Konten und doppeltes Hauptbuch;
- Fähigkeiten, Ruf und Lizenzen;
- Fahrzeuge, Trailer, Miete und Garagen;
- Unternehmen, Mitarbeiter, Verträge und Aufträge;
- Grundstücke, Immobilien, Lager und Produktionsanlagen;
- ein vollständiger Öl- und Kraftstoffkreislauf als Referenzbranche;
- grundlegende Admin-, UI- und Sicherheitsprinzipien.

Damit steht die RP- und Economy-Grundlage. Das Gesamtprojekt ist jedoch noch nicht bereit für einen ungebremsten Start aller Gameplay-Ressourcen, weil der namensgebende Cops-&-Robbers-Kern bisher nur auf Übersichtsebene definiert ist.

## 18.2 Noch notwendige Konzeptpakete vor dem Coding

### Paket A – Cops-&-Robbers-Kern

Vollständig zu planen sind:

- Arten legaler und illegaler Konflikte;
- Überfall- und Raubabläufe;
- Planung, Durchführung, Flucht und Verwertung;
- Polizei, Dienst, Leitstelle und Einsatzablauf;
- Ermittlungen und Beweiskette;
- Durchsuchung, Beschlagnahme und Asservate;
- Festnahme, Haft und Fahndung;
- Schutz vor Deathmatch, Farming und Meta-Gaming;
- Offline-, Cooldown- und Mindestpolizei-Regeln;
- fairer Risiko-, Belohnungs- und Eskalationsrahmen.

### Paket B – Allgemeines Job- und Aktivitätsmodell

Der Ölzweig ist die Referenz für komplexe Industrie. Zusätzlich benötigt der Core eine gemeinsame Definition für:

- Jobangebote;
- Schichten und Dienststatus;
- Aufgaben und Arbeitsschritte;
- Solo-, Gruppen- und Firmenaufträge;
- plausible Fortschrittsmessung;
- Abbruch und Wiederaufnahme;
- Vergütung aus Auftrag, Firma oder Staatskonto;
- Anti-AFK- und Anti-Farming-Regeln;
- Wiederverwendung für weitere legale Berufe.

### Paket C – Technischer Implementierungsrahmen

Vor dem ersten produktiven Resource-Code werden verbindlich entschieden:

- Server- und Client-Skriptsprache;
- NUI-Technologie;
- Datenbanktreiber;
- Migrationen und Seed-Daten;
- Resource-Startreihenfolge und Abhängigkeiten;
- interne Exports, Callbacks und Eventkonventionen;
- Fehlerformat und Übersetzungen;
- Konfigurations- und Versionsformat;
- Logging, Auditierung und Metriken;
- automatisierte Tests;
- Development-, Staging- und Production-Ablauf;
- Backup, Wiederherstellung und Deployment.

### Paket D – Verbindlicher MVP-Schnitt

Für jedes System wird festgelegt:

- im ersten spielbaren Build enthalten;
- nur als einfache Grundversion enthalten;
- ausdrücklich später;
- Abhängigkeiten;
- Abnahmekriterien;
- Testfälle;
- benötigte Inhalte und Kartenobjekte.

Das verhindert, dass beim Scripting gleichzeitig ein Core, eine vollständige Wirtschaft, alle Jobs, alle Verbrechen und ein Control Panel fertiggestellt werden sollen.

## 18.3 Empfohlener Zeitpunkt für den Coding-Start

Der Coding-Start wird nach Abschluss der vier Konzeptpakete A bis D empfohlen.

Danach muss nicht jedes spätere Feature vollständig geplant sein. Der Core kann beginnen, sobald:

- der MVP-Umfang verbindlich feststeht;
- der Cops-&-Robbers-Hauptablauf definiert ist;
- der technische Stack entschieden ist;
- Modulgrenzen und zentrale Datenverträge widerspruchsfrei sind;
- Sicherheits- und Transaktionsregeln feststehen;
- mindestens ein legaler und ein illegaler vertikaler Testablauf beschrieben sind.

Ab diesem Punkt kann die technische Basis umgesetzt werden, während spätere Branchen und Zusatzinhalte weiter geplant werden.

## 18.4 Empfohlene erste vertikale Abläufe

### Legaler Ablauf

1. Spieler verbindet sich und meldet sich an.
2. Spieler erstellt oder lädt einen Charakter.
3. Charakter erhält Konto, Inventar und notwendige Startberechtigungen.
4. Spieler nimmt einen Förder- oder Transportauftrag an.
5. Spieler mietet Zugmaschine und Tanktrailer.
6. Rohöl wird gefördert, verarbeitet und an eine Tankstelle geliefert.
7. Ein anderer Spieler tankt ein Fahrzeug.
8. Waren-, Vertrags- und Geldspur ist vollständig nachvollziehbar.

### Illegaler Ablauf

Der genaue Ablauf wird mit Paket A festgelegt. Er soll mindestens verbinden:

- vorbereitetes Verbrechen;
- serverseitiges Ziel und Beute;
- Alarmierung oder Entdeckungsrisiko;
- Polizeireaktion;
- Flucht und Fahndung;
- physische illegale Ware;
- Beweise;
- Verwertung oder Beschlagnahme;
- finanzielle Buchung und Auditspur.

## 18.5 Definition of Ready für das Repository

Vor dem ersten Hauptimplementierungs-Commit müssen vorliegen:

- freigegebene MVP-Matrix;
- freigegebene Modul- und Abhängigkeitskarte;
- Namens- und Eventkonventionen;
- technische Stackentscheidung;
- Migrationsstrategie;
- lokale Entwicklungsanleitung;
- Teststrategie;
- Sicherheitscheckliste;
- Konfigurations- und Secret-Konzept;
- Akzeptanzabläufe für die ersten vertikalen Schnitte.

## Nächster Planungsschritt

Als Nächstes wird Paket A, der vollständige Cops-&-Robbers-Kern, geplant. Begonnen wird mit dem gemeinsamen Lebenszyklus eines Verbrechens von Vorbereitung und Zielauswahl über Durchführung, Alarmierung und Flucht bis zu Beweisen, Ermittlungen, Festnahme, Beuteverwertung und langfristigen Folgen.
