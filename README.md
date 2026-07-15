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

# 13. Cops-&-Robbers-, Polizei- und Ermittlungssystem

Der Cops-&-Robbers-Kern verbindet kriminelle Vorbereitung, Tatdurchführung, Polizeireaktion und langfristige Ermittlungen. Eine Straftat endet nicht automatisch am Ausgang eines Zielgebäudes. Beute muss transportiert und verwertet werden, Spuren können zu späteren Maßnahmen führen und die Polizei muss Informationen tatsächlich erarbeiten.

Das System soll Konflikt und Spannung erzeugen, ohne in Deathmatch, automatische Tätererkennung oder folgenloses Markerfarming abzurutschen.

## 13.1 Leitprinzipien

- Jede größere Straftat besitzt Vorbereitung, Durchführung und Nachspiel.
- Belohnungen entstehen durch Ziele, Beute und Verwertung, nicht durch getötete Spieler.
- Polizeiarbeit wird durch Informationen unterstützt, aber nicht automatisch gelöst.
- Der Server kennt technische Wahrheiten; die Polizei kennt nur rechtmäßig oder spielerisch erlangte Informationen.
- Täteridentität, exakter Standort und Beweiswert werden nicht als magisches Wissen verteilt.
- Gewalt ist eine mögliche Vorgehensweise, aber normalerweise die lauteste und riskanteste.
- Scheitern, Teilfortschritt, Abbruch und spätere Ermittlungen sind gültige Ergebnisse.
- Kriminalität verwendet echte Gegenstände, Fahrzeuge, Konten, Gebäude und Warenchargen.
- Verbrechen dürfen Eigentum und Wirtschaft beeinflussen, aber keine vollständigen Offline-Enteignungen ermöglichen.
- Sowohl Kriminelle als auch Polizei erhalten nachvollziehbare Regeln, Schutzmechanismen und Auditspuren.

## 13.2 Verantwortliche Module

### `cnr_crime`

Verantwortet:

- Verbrechensdefinitionen;
- Tatziele;
- Tatinstanzen;
- Teilnehmer und Rollen;
- Tatphasen;
- Voraussetzungen;
- Ziel- und Teilnehmer-Cooldowns;
- Beutezuweisung;
- kriminelle Verwertung;
- internen Risikostatus.

### `cnr_dispatch`

Verantwortet:

- Notrufe;
- automatische Alarme;
- Leitstellenereignisse;
- Prioritäten;
- Ortsgenauigkeit;
- Aktualisierungen;
- Einheitenzuweisung;
- Einsatzstatus.

### `cnr_police`

Verantwortet:

- Polizeiorganisationen;
- Dienststatus;
- Einheiten;
- Einsatzmittel;
- Maßnahmen;
- Berichte;
- Fahndungen;
- Durchsuchungen;
- Beschlagnahmungen;
- Festnahmen;
- Haftübergaben;
- MDT-Berechtigungen.

### `cnr_evidence`

Verantwortet:

- physische und digitale Spuren;
- Tatortbeweise;
- Proben;
- Beweismittelbeutel;
- Kontamination;
- Analysen;
- Beweiskette;
- Asservatenzugriffe;
- Kamera- und Messdatensätze.

Zusätzlich beteiligt sind `cnr_inventory`, `cnr_items`, `cnr_vehicles`, `cnr_properties`, `cnr_banking`, `cnr_contracts`, `cnr_progression`, `cnr_reputation`, `cnr_medical`, `cnr_admin` und `cnr_analytics`.

## 13.3 Kein globaler Kriminellenjob

Kriminalität ist kein festes Joblabel. Ein Charakter wird durch Handlungen, Kontakte, Ruf, Fähigkeiten und Besitz zu einem kriminellen Akteur.

Mögliche Organisationsformen:

- Einzeltäter;
- spontane Gruppe;
- feste Crew;
- Gang;
- kriminelles Unternehmen;
- Insider in einem legalen Unternehmen;
- Auftragnehmer einer Unterweltorganisation.

Ein legales Unternehmen kann einzelne illegale Geschäfte betreiben, ohne dass seine gesamte Identität automatisch als kriminell markiert wird. Die Polizei kann interne Systemklassifikationen nicht im Charakterprofil sehen.

## 13.4 Kriminalitätsklassen

### Opportunistische Kriminalität

- einfacher Diebstahl;
- Taschendiebstahl;
- kleiner Ladenraub;
- Aufbruch eines Automaten;
- Diebstahl ungesicherter Fracht.

### Eigentums- und Fahrzeugkriminalität

- Einbruch;
- Fahrzeugdiebstahl;
- Teilediebstahl;
- Lagerdiebstahl;
- Hehlerei;
- Aufbrechen von Safes.

### Organisierte Überfälle

- Tankstellen- oder Geschäftsüberfall;
- Lager- und Transportüberfall;
- Geldtransport;
- Bankfiliale;
- Raffinerie oder Industrieanlage;
- Gefängnisbefreiung;
- große Spezialziele.

### Wirtschaftskriminalität

- Betrug;
- gefälschte Lieferungen;
- Unterschlagung;
- Geldwäsche;
- Scheinfirmen;
- manipulierte Rechnungen;
- Insiderdiebstahl;
- illegale Entsorgung.

### Illegale Märkte

- Schmuggel;
- Drogen;
- Waffen;
- gestohlene Fahrzeuge und Teile;
- gestohlene Waren;
- gefälschte Dokumente;
- illegale Dienstleistungen.

Nicht jede Klasse ist Teil des ersten MVP. Alle verwenden jedoch denselben Grundrahmen für Instanzen, Beute, Beweise, Cooldowns und Auditierung.

## 13.5 Risikostufen und Polizei-Anforderungen

Tatziele werden einer konfigurierbaren Risikostufe zugeordnet.

| Stufe | Beispiele | Grundidee |
|---|---|---|
| niedrig | einfacher Diebstahl, kleiner Ladenraub | auch bei geringer Polizeibesetzung möglich |
| mittel | Tankstelle, Lager, Automat, Fahrzeugauftrag | benötigt Vorbereitung und angemessene Reaktionsmöglichkeit |
| hoch | Bankfiliale, Geldtransport, Raffinerie | benötigt mehrere verfügbare Polizeieinheiten |
| spezial | Zentralbank, Gefängnisausbruch, Großtransport | Ereignischarakter und dynamische Freigabe |

Die konkreten Mindestwerte bleiben dynamisch konfigurierbar. Kleine Straftaten werden bei geringer Besetzung nicht vollständig abgeschaltet. Hochwertige Ziele benötigen dagegen eine realistische Reaktionsmöglichkeit.

Als verfügbar zählen nur Polizeikräfte, die:

- aktiv im Dienst sind;
- ihre Dienstsitzung ordnungsgemäß begonnen haben;
- nicht bewusstlos oder in Haft sind;
- nicht als AFK erkannt wurden;
- für Einsätze grundsätzlich verfügbar sind;
- eine Mindestdienstzeit erfüllt haben, um kurzfristige Zweitaccount-Manipulation zu erschweren.

Sinkt die Polizeizahl nach einem gültigen Tatstart, wird die Tat nicht rückwirkend ungültig oder die Beute gelöscht.

## 13.6 Dauerhafte Tatziele

Ein Tatort oder Tatobjekt besitzt:

- interne ID;
- öffentliche UUID;
- Definition und Konfigurationsversion;
- Zieltyp;
- Weltobjekt, Immobilie, Fahrzeug oder Unternehmen;
- räumliche Zonen und Interaktionspunkte;
- Sicherheitsstufe;
- Alarmprofil;
- Beutequelle und Maximalbestand;
- Beweisprofil;
- aktuellen Zustand;
- Ziel-Cooldown;
- letzte Tatinstanz;
- Betreiber und möglichen Geschädigten.

Koordinaten, Netzwerk-IDs und sichtbare Modellnamen sind niemals die dauerhafte Identität eines Tatobjekts.

## 13.7 Zielzustände

Mögliche Zustände:

- `available`;
- `reserved`;
- `casing`;
- `active`;
- `alarm`;
- `lockdown`;
- `recovering`;
- `cooldown`;
- `maintenance`;
- `disabled`;
- `incident_hold`;
- `archived`.

Nur der Server ändert den verbindlichen Zielzustand. Ein Ziel kann nicht von zwei Gruppen gleichzeitig als unabhängige Beutequelle verwendet werden.

## 13.8 Gemeinsamer Lebenszyklus eines Verbrechens

1. Ziel oder Auftrag finden.
2. Informationen sammeln.
3. Vorgehensweise auswählen.
4. Team, Fahrzeuge, Werkzeuge und Lager vorbereiten.
5. Voraussetzungen serverseitig prüfen lassen.
6. Ziel und mögliche Beute reservieren.
7. Tat beginnen.
8. Sicherheitsstufen oder Teilziele überwinden.
9. Alarm, Zeugen und Beweise erzeugen.
10. Beute sichern.
11. Tatort verlassen.
12. Fahndungs- und Abkühlphase überstehen.
13. Beute lagern, aufteilen oder transportieren.
14. Ware verkaufen oder Geld waschen.
15. mögliche Ermittlungen, Durchsuchungen und Festnahmen behandeln.
16. Tatinstanz fachlich abschließen, ohne Ermittlungsdaten zu löschen.

Eine Tat kann in jeder Phase scheitern, kontrolliert abgebrochen werden oder nur teilweise erfolgreich sein.

## 13.9 Tatinstanz als Zustandsmaschine

| Zustand | Bedeutung |
|---|---|
| `planned` | Gruppe und Ziel sind vorbereitet, aber noch nicht gesperrt |
| `validating` | Voraussetzungen und Beutequelle werden geprüft |
| `reserved` | Ziel, Konfiguration und maximale Beute sind reserviert |
| `initiated` | erste unumkehrbare Tathandlung wurde ausgeführt |
| `active` | Teilziele werden bearbeitet |
| `alarm` | Alarm oder bestätigter Notruf ist aktiv |
| `escape` | Täter haben das unmittelbare Ziel verlassen |
| `hot` | Beute und Teilnehmer befinden sich in der Fahndungsphase |
| `cooling` | unmittelbare Verfolgung ist beendet, Spuren bleiben relevant |
| `resolved` | Beute wurde verwertet, sichergestellt oder dauerhaft zugeordnet |
| `aborted` | Tat wurde kontrolliert beendet |
| `failed` | Tat ist durch Sicherung, Fehler oder vollständiges Scheitern beendet |
| `invalidated` | nur administrative Korrektur bei nachgewiesenem technischen Fehler |

`resolved` bedeutet nicht, dass ein Strafverfahren oder eine Fahndung automatisch beendet ist.

## 13.10 Teilnehmer und Rollen

Eine Tatinstanz speichert:

- Teilnehmercharakter;
- Rolle;
- Beitrittszeit;
- aktive Phase;
- bestätigte Aktionen;
- erhaltene Beute;
- verwendete Fahrzeuge;
- verwendete Werkzeuge;
- Verletzungs- und Festnahmestatus;
- Verbindungsabbrüche;
- Ausscheiden oder Ausschluss.

Mögliche Rollen:

- Planer;
- Fahrer;
- Aufklärer;
- Zugangsspezialist;
- Hacker;
- Sicherung;
- Beuteträger;
- Insider;
- Geldwäscher oder Hehler.

Eine Tat kann spontane Beteiligte erhalten. Beute, Erfahrung und Risiko entstehen jedoch nur aus nachvollziehbaren Beiträgen. Ein kurz vor Abschluss beigetretener Charakter erhält nicht automatisch vollen Fortschritt.

## 13.11 Aufklärung und Informationen

Vorbereitung kann Informationen liefern über:

- Öffnungszeiten;
- mögliche Sicherheitsstufe;
- Kamerapositionen;
- Wachpersonal;
- Lieferzeiten;
- Zugänge;
- Alarmtypen;
- benötigte Werkzeuge;
- mögliche Beutearten;
- Fluchtwege;
- temporäre Schwachstellen.

Informationen besitzen:

- Quelle;
- Genauigkeit;
- Erstellungszeit;
- Ablaufzeit;
- Ziel- und Versionsbezug;
- mögliche Falsch- oder Teilinformation.

Ein Client kann nicht direkt vollständige Zielkonfigurationen auslesen. Sichtbare Hinweise werden bewusst vom Server freigegeben.

## 13.12 Vorgehensweisen

Je nach Ziel sind möglich:

- Schleichen;
- Täuschung;
- gefälschte Berechtigung;
- Insiderhilfe;
- Schlossknacken;
- mechanischer Aufbruch;
- elektronische Manipulation;
- Hacking;
- Sabotage;
- Erpressung;
- bewaffneter Überfall.

Vorgehensweisen unterscheiden sich in:

- Vorbereitungskosten;
- Zeit;
- benötigten Fähigkeiten;
- Werkzeugverbrauch;
- Lautstärke;
- Alarmwahrscheinlichkeit;
- Beweisarten;
- Gewaltpotential;
- möglicher Beute;
- Abbruchmöglichkeiten.

Es soll nicht für jedes Ziel nur ein austauschbares Minispiel geben. Dieselbe Sicherheitskomponente darf aber technisch wiederverwendbare Aufgabenmodule verwenden.

## 13.13 Werkzeuge und Zugangsmittel

Werkzeuge sind normale serverseitige Items oder persistente Assets.

Beispiele:

- Dietrich;
- Bolzenschneider;
- Bohrgerät;
- Brechwerkzeug;
- Sprengmittel;
- Störsender;
- Hackinggerät;
- gefälschte Zugangskarte;
- geklonter Schlüssel;
- Glas- oder Thermowerkzeug;
- Behälter und Beutetaschen.

Mögliche Eigenschaften:

- Qualität;
- Haltbarkeit;
- Serien- oder Chargennummer;
- erlaubte Ziele;
- Spurenprofil;
- Besitzerhistorie;
- illegale Herkunft;
- verbleibende Nutzungen.

Der Client meldet nur den gewünschten Einsatz. Besitz, Eignung, Verbrauch, Ergebnis und Spuren werden serverseitig ermittelt.

## 13.14 Prüfung vor Tatbeginn

Der Server prüft mindestens:

1. gültige Charakter- und Spielsitzung;
2. Position und Routing Bucket;
3. Zielzustand und Konfigurationsversion;
4. Ziel-, Teilnehmer- und globalen Cooldown;
5. erforderliche verfügbare Polizeikräfte;
6. Gruppen- und Teilnehmergrenzen;
7. benötigte Informationen, Fähigkeiten oder Lizenzen;
8. Werkzeuge und deren Zustand;
9. mögliche Aufträge oder Unterweltkontakte;
10. Beutequelle und reservierbaren Maximalbestand;
11. geschützte Zustände des Ziels;
12. konkurrierende Tat- oder Wartungsinstanzen.

Erst danach werden Ziel, Tatversion und maximale Beute atomar reserviert.

## 13.15 Tatstufen und Teilziele

Eine Tat kann aus einer gerichteten Folge oder einem kleinen Abhängigkeitsgraphen bestehen:

- äußeren Zugang schaffen;
- Alarmleitung beeinflussen;
- Personal oder Zeugen kontrollieren;
- innere Tür öffnen;
- Terminal bedienen;
- Zeitverriegelung abwarten;
- Safe, Kasse oder Container öffnen;
- Beute in physische Behälter übertragen;
- Fluchtweg freigeben.

Jede Stufe besitzt:

- eindeutige Stufen-ID;
- Voraussetzungen;
- erlaubte Aktionen;
- Zeit- und Distanzregeln;
- Werkzeuganforderungen;
- Erfolgs- und Fehlerzustände;
- Alarmwirkung;
- Beweisauswirkung;
- Teilbeute;
- Abbruchregel.

Laufende Tatinstanzen behalten ihre veröffentlichte Stufenversion.

## 13.16 Alarme und Zeugen

Alarmquellen:

- stiller Alarm;
- hörbarer Alarm;
- Panikknopf;
- Tür- oder Glasbruch;
- Kameraanalyse;
- Fahrzeugalarm;
- GPS- oder Plombenalarm;
- automatischer Anlagenalarm;
- Notruf eines Spielers;
- glaubwürdiger NPC-Zeuge.

Ein Alarm enthält:

- Quelle;
- Tat- oder Zielbezug;
- Zeitpunkt;
- gemeldeten Ereignistyp;
- Ortsgenauigkeit;
- Vertrauensstufe;
- bekannte Beschreibung;
- letzte Aktualisierung.

Ein Alarm meldet nicht automatisch Tätername, VIN oder exakte Liveposition. Ein fest installierter Alarm darf den Tatort genau melden; eine flüchtende Person oder ein Fahrzeug bleibt dagegen nur so genau bekannt wie die letzte Beobachtung.

## 13.17 Dispatch und Informationsqualität

Dispatch-Ereignisse unterscheiden:

- bestätigter Alarm;
- ungeprüfter Notruf;
- automatische Sensorwarnung;
- Zeugenmeldung;
- Beamtenanforderung;
- Fahndungstreffer;
- nachträglicher Ermittlungsfund.

Mögliche Ortsdarstellung:

- exakter fester Tatort;
- Straßenabschnitt;
- Gebiet;
- letzte bekannte Position;
- Fahrtrichtung;
- unsichere oder veraltete Meldung.

Updates können die Qualität verbessern oder verschlechtern. Ein Blip darf auslaufen und folgt Verdächtigen nicht ohne eine tatsächliche technische Quelle wie einen aktiven Peilsender.

## 13.18 Cooldowns und Gleichzeitigkeit

Es gibt getrennte Begrenzungen:

- Ziel-Cooldown;
- Charakter-Cooldown;
- Crew-Cooldown;
- Tatklassen-Cooldown;
- globales Limit gleichzeitig aktiver Großereignisse;
- Wiederholungsgrenze zwischen denselben Beteiligten;
- wirtschaftliche Wiederauffüllzeit.

Cooldowns schützen Verfügbarkeit und Balance, ersetzen jedoch nicht die tatsächliche Beutequelle. Ein leerer Safe wird nicht allein durch Ablauf eines Timers wieder voll.

Administratoren können Cooldowns nicht unbemerkt für einzelne Spieler umgehen. Manuelle Freigaben sind begründet und auditiert.

## 13.19 Beutequelle und Mengenreservierung

Beute stammt aus einer definierten Quelle:

- Kassenbestand;
- Safebestand;
- Warenlager;
- Fahrzeugladung;
- Bankfilialreserve;
- Versicherungs- oder Ereigniskonto;
- physisches Zielinventar;
- reservierter Systembestand.

Spielereinlagen auf Bankkonten werden bei einem Bankraub nicht direkt reduziert. Bankbeute stammt aus einem getrennten Filial-, Bargeld- oder Versicherungskonto im Hauptbuch.

Beim Tatstart wird eine maximale verfügbare Menge reserviert. Tatsächlich entnommene Beute kann darunter liegen. Abbruch und Wiederholung derselben Anfrage erzeugen keine zweite Reservierung.

## 13.20 Physische Beute

Mögliche Beute:

- Bargeldbündel;
- markierte Geldscheine;
- Wertsachen;
- Warenchargen;
- Dokumente;
- Fahrzeugteile;
- digitale Datenträger;
- Zugangsmittel;
- Rohstoffe;
- versiegelte Behälter.

Beute besitzt:

- Herkunft;
- Tatinstanz;
- Charge oder Seriennummer;
- Eigentümer vor der Tat;
- Risikoklasse;
- möglichen Markierungsstatus;
- Gewicht und Volumen;
- aktuellen Besitzer oder Lagerort;
- möglichen Verfalls- oder Sperrstatus.

Beute wird nicht als sofortige Bankgutschrift ausgezahlt. Transportkapazität, Gewicht, Lagerung und Verwertung bleiben relevant.

## 13.21 Markiertes Geld und Dye Packs

Banken und Geldtransporte können markierte Geldchargen oder Farbsicherung verwenden.

Mögliche Folgen:

- sichtbare Verfärbung;
- erhöhte Spurenmenge;
- Seriennummernbezug;
- geringerer Hehlerwert;
- Ablehnung durch normale Einzahlungsstellen;
- Fahndungshinweis bei späterer Nutzung.

Markierungen verschwinden nicht durch Aufteilen eines Itemstapels. Eine Verarbeitung erzeugt neue nachvollziehbare Chargenbeziehungen.

## 13.22 Beutetransport und Risikophase

Nach Verlassen des Tatorts bleibt eine Tat für einen konfigurierbaren Zeitraum `hot`.

Währenddessen können gelten:

- kein sicherer Charakterwechsel;
- keine normale Fahrzeug- oder Garagenteleportation;
- keine sofortige Einlagerung in geschützte Systemlager;
- eingeschränkte Schnellreise;
- erhöhte Bedeutung von Kontrollen und Zeugen;
- fortbestehende Tat- und Beutereferenz.

Dieser interne Risikostatus ist kein automatisch sichtbarer Polizeistatus. Polizei benötigt weiterhin Beobachtung, Fahndung, Beweis oder eine technische Ortungsquelle.

## 13.23 Hehlerei

Gestohlene Waren werden über konkrete Hehlerangebote oder Unterweltaufträge verwertet.

Ein Hehler berücksichtigt:

- Warenart;
- Herkunftsrisiko;
- Menge;
- Zustand und Qualität;
- aktuellen Unterweltbedarf;
- Ruf;
- wiederholte Verkäufe;
- Polizeidruck;
- eigene Verarbeitungskapazität.

Ein Hehlervorgang:

1. prüft und reserviert die Ware;
2. erzeugt ein Angebot;
3. überträgt angenommene Ware;
4. zahlt aus einem definierten Unterwelt- oder Exportkonto;
5. erzeugt illegale oder belastete Erlöse;
6. protokolliert Herkunft und Risiko.

Hehler besitzen Limits und kaufen nicht unbegrenzt dieselbe Ware.

## 13.24 Geldwäsche

Geldwäsche verarbeitet belastetes Bargeld oder illegale Erlöse in zeitlich begrenzten Chargen.

Ein Vorgang enthält:

- Betreiber;
- Auftraggeber;
- Eingangscharge;
- Herkunftsrisiko;
- Methode;
- Kapazität;
- Dauer;
- Gebühr und Verlust;
- Ausgangskonto oder Ausgangscharge;
- mögliche auffällige Buchungen;
- Status.

Methoden können Scheinfirmen, manipulierte Umsätze, Glücksspiel, Fahrzeughandel oder gefälschte Rechnungen verwenden. Sie benötigen passende wirtschaftliche Aktivität und besitzen unterschiedliche Ermittlungsrisiken.

Geldwäsche ist kein Knopf, der `black_money` verlustfrei in Bankgeld verwandelt.

## 13.25 Interner Risikowert und Polizeiwissen

Das System kann einen internen Risikowert verwenden für:

- Cooldowns;
- Hehlerpreise;
- Unterweltkontakte;
- Kontrollwahrscheinlichkeiten;
- Balancing;
- Analyse von Wiederholungsfarming.

Dieser Wert ist keine polizeiliche Akte und wird im MDT nicht angezeigt.

Polizeiliches Wissen entsteht aus:

- Notrufen;
- eigenen Beobachtungen;
- Zeugenaussagen;
- Beweisen;
- Kameradaten;
- Fahndungen;
- rechtmäßig erlangten Konto-, Fahrzeug- oder Vertragsdaten;
- Geständnissen;
- verknüpften Fällen.

## 13.26 Spielerüberfall und Durchsuchung durch Täter

Ein Spieler kann nicht jederzeit das vollständige Inventar eines anderen Charakters öffnen.

Voraussetzungen für einen Raubzugriff können sein:

- nachvollziehbare RP-Eskalation;
- gültige Raub- oder Konfliktinstanz;
- Nähe;
- Opfer ergibt sich, ist kontrolliert oder handlungsunfähig;
- Täter ist selbst handlungsfähig;
- keine geschützte Spawn- oder Einführungsphase;
- serverseitige Entnahmegrenzen.

Entnehmbar sind nur tatsächlich mitgeführte und nicht ausdrücklich geschützte Gegenstände. Bankkonten, Immobilien, Firmenanteile, dauerhafte Fahrzeugidentität und rein serverseitige Berechtigungen können nicht über eine Inventardurchsuchung übertragen werden.

Physische Schlüssel oder Zugangskarten können je nach Regel gestohlen werden. Sie übertragen nur Zugriff und können gesperrt werden.

## 13.27 Geiseln

Geiseln können Spieler oder systemseitige NPCs sein.

Schutzregeln:

- keine automatische Belohnung allein für die Anzahl der Geiseln;
- keine erzwungene Übertragung von Bankguthaben, Immobilien oder Firmen;
- neue Spieler und geschützte Zustände können ausgeschlossen werden;
- wiederholte Geiselkonstellationen werden erkannt;
- vorab abgesprochene Zweitaccount-Geiseln erzeugen keinen Vorteil;
- Tod oder Disconnect der Geisel dupliziert keine Forderung;
- Missbrauch bleibt administrativ überprüfbar.

Geiseln erweitern Verhandlungsmöglichkeiten, sind aber kein Freibrief für grenzenlose Forderungen oder Regelverstöße.

## 13.28 Einbruch und Offline-Schutz

Private Wohnräume sind standardmäßig besonders geschützt.

Empfehlung:

- vollständige Wohnungsplünderung nur bei aktiven Bewohnern oder ausdrücklich freigegebenem Ereignis;
- bei vollständig offline befindlichen Bewohnern höchstens begrenzte, konfigurierbare Einbruchsmöglichkeiten;
- geschützte persönliche und unverzichtbare Gegenstände;
- Entnahmegrenzen pro Tat und Zeitraum;
- Alarm-, Kamera- und Versicherungsmöglichkeiten;
- keine Löschung des verbleibenden Inventars;
- Wiederherstellungs- und Streitprotokolle.

Wirtschaftliche Lager und Unternehmensanlagen können stärker angreifbar sein, benötigen aber Sicherheitsstufen, Zeitfenster, Versicherungen, Limits und echte Beute. Eine längere Abwesenheit darf nicht zu einer vollständigen Enteignung führen.

## 13.29 Fahrzeugdiebstahl und Verwertung

Mögliche Schritte:

1. Ziel auswählen oder Auftrag erhalten.
2. Schloss, Schlüssel oder Elektronik überwinden.
3. Alarm und Wegfahrsperre behandeln.
4. Fahrzeug bewegen.
5. Fahndung und mögliche Ortung vermeiden.
6. Kennzeichen, Erscheinung oder Teile verändern.
7. Fahrzeug abliefern, zerlegen oder illegal weiterverkaufen.

Eigentum, Zugriff, Kennzeichen, VIN und Diebstahlstatus bleiben getrennt. Ein Kennzeichenwechsel entfernt weder VIN noch Eigentum.

Ein Chop-Shop kann:

- verwertbare Teile erzeugen;
- Fahrzeugzustand und Identität prüfen;
- Auftragsfahrzeuge annehmen;
- nicht jedes Fahrzeug akzeptieren;
- Serien- und Herkunftsbezüge der Teile erhalten;
- das Ursprungsfahrzeug nachvollziehbar in einen Verwertungsstatus überführen.

## 13.30 Laden- und Tankstellenraub

Der kleine Ladenraub ist der erste empfohlene vertikale Cops-&-Robbers-Ablauf.

Mögliche Varianten:

- unbemerkter Kassendiebstahl;
- Bedrohung eines Mitarbeiters;
- stiller Safezugriff;
- gewaltsamer Kassen- oder Safeaufbruch;
- Ablenkung und Komplize.

Der Zielbestand hängt von tatsächlichen oder kontrolliert aufgebauten Kassen- und Safebeständen ab. Ein Laden besitzt Schutz vor unmittelbarer Wiederholung.

Mögliche Folgen:

- stiller oder verzögerter Alarm;
- Zeugenbeschreibung;
- Kameraaufnahme;
- Fingerabdrücke;
- Werkzeugspuren;
- markiertes Bargeld;
- Fahrzeugbeschreibung;
- Verletzte und medizinischer Einsatz.

## 13.31 Bankfilialraub

Eine Bankfiliale ist ein hochwertiges mehrstufiges Ziel.

Mögliche Bestandteile:

- Aufklärung;
- Zugangskarte oder Insider;
- Kameras und Alarm;
- äußere und innere Sicherheitstür;
- Zeitverriegelung;
- Terminal- oder Tresormechanik;
- Bargeld- und Wertbehälter;
- Farbsicherung;
- Geiseln und Verhandlung;
- Flucht und Beutetransport.

Die Beute stammt aus einer getrennten Filial- oder Versicherungsreserve. Kundeneinlagen bleiben buchhalterisch bestehen.

Ein Bankraub benötigt konfigurierbar:

- höhere Polizeiverfügbarkeit;
- begrenzte globale Gleichzeitigkeit;
- umfangreiche Vorbereitung;
- relevante Werkzeugkosten;
- lange Ziel- und Teilnehmer-Cooldowns;
- mehrere Beweis- und Abbruchmöglichkeiten.

## 13.32 Transport-, Lager- und Industrieüberfälle

Diese Taten greifen die Spielerwirtschaft direkt auf:

- Tanktrailer;
- Geldtransporter;
- wertvolle Warenlieferung;
- Firmenlager;
- Depot;
- Raffinerie;
- Hafen- oder Exportfracht.

Beute wird nicht neu erzeugt, sondern aus einer reservierten Ladung oder einem geschützten Bestand bewegt. Versicherungen können Verluste teilweise ausgleichen, dürfen aber keine Waren duplizieren.

Digitale Plomben, Messstände, Fahrzeugidentität, Frachtauftrag und Warencharge liefern Ermittlungsansätze.

## 13.33 Gruppen, Crews und Organisationen

Eine feste Crew kann besitzen:

- UUID und Name;
- Rollen und Rechte;
- Mitglieder;
- gemeinsamen Ruf;
- Kontakte;
- Verstecke und Lagerzugriffe;
- gemeinsame Aufträge;
- interne Beutevereinbarung;
- Aktivitäts- und Sanktionshistorie.

Eine Crew ist nicht automatisch öffentlich oder der Polizei bekannt.

Ad-hoc-Gruppen bleiben möglich. Das System verhindert jedoch, dass dieselbe Person über mehrere Gruppen denselben Tatfortschritt oder Cooldown umgeht.

Territorien, Gangkriege und komplexe Organisationsverwaltung sind spätere Ausbaustufen.

## 13.34 PvP, Eskalation und Konfliktkontext

PvP benötigt einen nachvollziehbaren Rollenspielkontext.

Grundregeln:

- kein wahlloses Töten;
- keine Belohnung für Kills;
- Gewalt muss zur Situation passen;
- Drohung und Reaktionsmöglichkeit werden bevorzugt;
- Schutz für Spawn, Charaktererstellung und technische Wiederverbindung;
- keine künstliche Provokation allein zum Erzeugen eines Schusswechsels;
- kein erneuter Angriff unmittelbar nach Respawn;
- medizinische und bewusstlose Zustände werden respektiert;
- Drittparteien erhalten nicht automatisch Tat- oder Beuterechte.

Das System kann einen Konfliktkontext protokollieren, ersetzt aber keine verständlichen Serverregeln und keine administrative Einzelfallprüfung.

## 13.35 Tod, Bewusstlosigkeit und medizinische Folgen

- Bewusstlosigkeit beendet eine Tat nicht automatisch.
- Beute bleibt physisch beim Charakter, Fahrzeug oder Bodenbehälter.
- medizinische Maßnahmen verändern keine Eigentums- oder Beweisreferenzen.
- Respawn darf nicht zur Flucht aus Fahndung, Haft oder Beuteverantwortung dienen.
- Verletzungen können Blut- oder DNA-Spuren erzeugen.
- Tod löscht keine Fälle, Beweise, Fahndungen, Cooldowns oder Auditdaten.
- Permadeath bleibt freiwillig oder genehmigt und ist kein automatisches Strafresultat.

Die genaue Behandlung verwendet den späteren medizinischen Lebenszyklus.

## 13.36 Verbindungsabbruch und Crime-Logging

Ein Disconnect während Tat, Verfolgung, Festnahme oder Beutetransport wird gespeichert.

Vorgesehen:

- kurze Wiederverbindungsfrist;
- Wiederaufnahme des kritischen Charakterzustands;
- Sperre des Charakterwechsels;
- Beute bleibt dem persistenten Inventar oder Fahrzeug zugeordnet;
- Tatinstanz bleibt aktiv oder geht kontrolliert in einen Wartezustand;
- keine doppelte Beute beim Wiederverbinden;
- Protokoll für administrative Prüfung.

Ein technischer Verbindungsfehler wird nicht automatisch wie absichtliches Combat-Logging bestraft. Wiederholung, Zeitpunkt und Kontext liefern Hinweise für eine regelbasierte oder administrative Bewertung.

## 13.37 Polizeiorganisation und Dienst

Polizeifunktionen benötigen:

- aktive Anstellung;
- Dienstgrad oder Rolle;
- passende Berechtigungen;
- aktive Dienstsitzung;
- gegebenenfalls Ausbildung oder Lizenz;
- dienstliche Ausrüstung.

Eine Dienstsitzung speichert:

- Beginn und Ende;
- Dienststelle;
- Einheit;
- Partner;
- Fahrzeug;
- Rolle;
- Status;
- Einsatzzuweisungen;
- ausgegebene und zurückgegebene Ausrüstung.

Off-Duty-Charaktere erhalten keinen allgemeinen Zugriff auf Dispatch, MDT, Asservate oder polizeiliche Aktionen.

## 13.38 Polizeieinheiten und Status

Mögliche Einheiten:

- Streife;
- Verkehr;
- Ermittlungen;
- Einsatzleitung;
- taktische Einheit;
- Luftunterstützung;
- K9;
- Tatortermittlung;
- Gefangenentransport.

Mögliche Statuswerte:

- `available`;
- `assigned`;
- `responding`;
- `on_scene`;
- `pursuit`;
- `transporting`;
- `booking`;
- `unavailable`;
- `off_duty`.

Nicht jede Einheit ist im MVP erforderlich. Rollen und Fähigkeiten werden konfigurierbar gehalten.

## 13.39 Leitstelle und Einsatzzuweisung

Ein Dispatch-Einsatz enthält:

- Einsatz-UUID;
- Quelle und Vertrauensstufe;
- Kategorie und Priorität;
- Standort oder Gebiet;
- bekannte Beschreibung;
- Zeitstempel;
- aktuelle Lageupdates;
- zugewiesene Einheiten;
- Einsatzleiter;
- Status;
- Verknüpfung zu Tat, Fahrzeug, Person oder Fall, falls bekannt.

Einheiten können Einsätze annehmen, zugewiesen werden, Unterstützung anfordern und Status aktualisieren.

Dispatch zeigt gemeldete Informationen. Technische Systemdaten, die keinem Sensor, Zeugen oder Ermittlungszugriff entsprechen, bleiben verborgen.

## 13.40 Polizeilicher Einsatzablauf

1. Alarm oder Notruf empfangen.
2. Meldung bewerten und priorisieren.
3. Einheiten zuweisen.
4. Anfahrt und Lageupdate.
5. Tatort, Gefahren und mögliche Fluchtwege sichern.
6. Kontakt, Beobachtung oder Verhandlung herstellen.
7. Verdächtige verfolgen oder kontrollieren.
8. Personen und Fahrzeuge rechtmäßig durchsuchen.
9. Beweise und Beute sichern.
10. Verletzte versorgen lassen.
11. Festnahmen und Transport durchführen.
12. Berichte, Fall und Asservate vervollständigen.
13. Fahndungen oder weitere Ermittlungen anlegen.

Der Server schreibt keine einzige taktische Vorgehensweise vor, protokolliert aber kritische Maßnahmen und Berechtigungen.

## 13.41 Verhandlung und Einsatzeskalation

Bei Geisel- oder Barrikadenlagen kann eine Verhandlungssitzung angelegt werden.

Sie speichert:

- Einsatz;
- Verhandler;
- bekannte Beteiligte;
- Kommunikationskanal;
- Forderungen;
- Zusagen;
- Fristen;
- Austauschvorgänge;
- Abbruch- oder Eskalationsereignisse.

Das System kann sichere Übergaben und Freilassungen unterstützen, entscheidet aber nicht automatisch über taktische Zulässigkeit.

Forderungen bleiben durch Serverregeln begrenzt. Unendliche Geldschöpfung, dauerhafte Immunität oder erzwungene Eigentumsübertragung sind ausgeschlossen.

## 13.42 Verfolgung und Fahrzeugfahndung

Eine Verfolgung besitzt:

- Einsatz-UUID;
- beteiligte Einheiten;
- beobachtete Fahrzeuge;
- Kennzeichen zum Beobachtungszeitpunkt;
- Beschreibung;
- letzte bekannte Position und Richtung;
- Verlustzeitpunkt;
- mögliche Luft- oder GPS-Quelle;
- Abbruch- und Wiederaufnahmeereignisse.

Ohne Sichtkontakt, aktiven Peilsender, Luftbeobachtung oder neue Meldung existiert kein dauerhafter Live-Blip.

Kennzeichenfahndung und VIN-Fahndung bleiben getrennt. Ein gefälschtes Kennzeichen kann Sichtkontrollen erschweren, beseitigt aber keinen späteren VIN-Treffer.

## 13.43 Masken, Erkennung und Identität

Eine Maske kann eine unmittelbare Gesichtserkennung verhindern. Sie macht einen Täter nicht unsichtbar.

Mögliche Beschreibungsmerkmale:

- Kleidung;
- Körperbau;
- Stimme als Rollenspielhinweis;
- sichtbare Tattoos oder Merkmale;
- verwendete Ausrüstung;
- Bewegungsmuster;
- Fahrzeug;
- Kennzeichen;
- Begleiter;
- Fluchtrichtung.

Das System zeigt maskierten Personen nicht automatisch den Charakternamen. Eine Kameraaufnahme liefert nur Informationen, die Sichtwinkel, Licht, Verdeckung und Technik plausibel erlauben.

Fingerabdrücke oder DNA ergeben nur dann eine Identität, wenn ein rechtmäßig verfügbarer Vergleichsdatensatz existiert.

## 13.44 Polizeivorgang, Fall und Bericht

Begriffe bleiben getrennt:

- Einsatz: unmittelbare Reaktion auf ein Ereignis;
- Vorgang: polizeiliche Maßnahme oder Sachverhalt;
- Fall: zusammenhängende Ermittlung;
- Bericht: unveränderlich versioniertes Dokument eines Bearbeiters;
- Tatinstanz: serverseitiger Gameplayvorgang;
- Strafverfahren: rechtliche Bearbeitung von Beschuldigungen.

Ein Fall kann mehrere Tatinstanzen, Einsätze, Personen, Fahrzeuge, Unternehmen und Beweise verbinden.

Berichte werden nach Einreichung nicht still überschrieben. Ergänzungen und Korrekturen erfolgen als neue Version oder Nachtrag.

## 13.45 Beweisarten

Physische Spuren:

- Fingerabdrücke;
- DNA;
- Blut;
- Haare oder Fasern;
- Patronenhülsen;
- Projektil- und Waffenmerkmale;
- Werkzeugspuren;
- Schuhabdrücke;
- Reifenspuren;
- Lack- oder Glasspuren;
- zurückgelassene Gegenstände;
- beschädigte Plomben.

Digitale und dokumentarische Spuren:

- Kameraaufnahme;
- Zutrittsprotokoll;
- Alarmereignis;
- Bank- oder Kassenvorgang;
- Fahrzeug- und Messdaten;
- Telefon- oder Kommunikationsmetadaten im erlaubten Rahmen;
- Vertrag;
- Liefernachweis;
- GPS-Daten aus tatsächlich vorhandenem Gerät;
- Zeugenaussage.

Nicht jede Spur identifiziert direkt eine Person. Viele Beweise verbinden zunächst nur Tatort, Gegenstand, Fahrzeug oder unbekanntes Profil.

## 13.46 Beweiserzeugung

Beweise entstehen serverseitig aus tatsächlichen Aktionen.

Beispiele:

- ungeschützte Berührung kann Fingerabdrücke hinterlassen;
- Verletzung kann Blut oder DNA hinterlassen;
- Schuss kann Hülse und Projektilbezug erzeugen;
- Werkzeugnutzung kann Werkzeugspur erzeugen;
- beschädigte Tür erzeugt Bruch- und Interaktionsspuren;
- Fahrzeugkontakt kann Lack- oder Reifenspuren erzeugen;
- Nutzung eines Terminals erzeugt digitales Protokoll;
- Öffnen einer Plombe erzeugt ein Ereignis;
- Kamera kann innerhalb ihres Sichtbereichs eine Aufnahme erzeugen.

Handschuhe, Reinigung, Schalldämpfer oder Spurenvermeidung reduzieren bestimmte Spuren, verhindern aber nicht automatisch alle anderen Beweisarten.

Kriminelle erhalten keine vollständige Liste der tatsächlich erzeugten Beweise.

## 13.47 Tatort, Spurensicherung und Kontamination

Eine Spur besitzt:

- Beweis-UUID;
- Typ;
- Tatort und Position;
- Entstehungszeit;
- mögliche Tatinstanz;
- Zustand;
- Sichtbarkeit;
- Verfallsprofil;
- Kontaminationsstatus;
- Entdecker;
- Sicherungszeit;
- Beweismittelbeutel;
- Fallreferenz.

Sicherung benötigt:

- aktive Polizeiberechtigung;
- passende Ausrüstung;
- Nähe;
- freie und geeignete Verpackung;
- gültigen Tatort- oder Vorgangsbezug.

Falsche Verpackung, unnötiges Berühren, Wetter, Zeit oder unberechtigter Zugriff können Qualität und Beweiswert beeinflussen.

## 13.48 Beweismittelbeutel und Beweiskette

Ein Beweismittelbeutel besitzt:

- eindeutige Nummer und UUID;
- Versiegelungsstatus;
- Inhalt;
- sichernde Person;
- Ort und Zeit;
- Fall;
- Übergaben;
- Öffnungen;
- Neuversiegelungen;
- Lagerort;
- Analyseaufträge.

Jede Übergabe wird protokolliert. Ein versiegelter Beutel kann nicht unbemerkt verändert werden.

Die Beweiskette macht einen Beweis nicht automatisch schuldigkeitsbeweisend. Sie dokumentiert Integrität, Herkunft und Umgang.

## 13.49 Labor und Analyse

Mögliche Analysen:

- Fingerabdruckvergleich;
- DNA-Vergleich;
- Ballistik;
- Werkzeugspurenvergleich;
- Stoff- oder Drogenanalyse;
- Kraftstoff- und Qualitätsanalyse;
- Dokumentenprüfung;
- digitale Auswertung.

Eine Analyse benötigt:

- geeignete Probe;
- Analyseauftrag;
- Laborzugriff;
- Zeit;
- mögliche Vergleichsdaten;
- protokolliertes Ergebnis.

Ergebnisse sind Fakten und Wahrscheinlichkeiten, keine automatische Verurteilung. Ein unbekanntes Profil bleibt unbekannt, bis ein zulässiger Vergleich vorliegt.

## 13.50 Kameras, Dashcam und Bodycam

Kameras besitzen:

- Standort;
- Blickrichtung und Sichtbereich;
- Aktivstatus;
- Betreiber;
- Aufzeichnungsqualität;
- Speicherfrist;
- Zeitquelle;
- Zugriffsrechte;
- mögliche Manipulation oder Störung.

Aufnahmen werden ereignisbezogen und zeitlich begrenzt gespeichert. Es entsteht keine permanente vollständige Videoaufzeichnung der gesamten Welt.

Bodycam und Dashcam benötigen dienstliche Ausrüstung und einen aktiven Zustand. Zugriffe, Exporte und Löschfristen werden protokolliert.

## 13.51 MDT und Informationsrechte

Das MDT kann abhängig von Rolle und Berechtigung enthalten:

- Personenstammdaten;
- Fahrzeugregister;
- Führerscheine und Lizenzen;
- Fahndungen;
- Einsätze;
- Vorgänge und Berichte;
- Fälle;
- Beweisreferenzen;
- Durchsuchungs- und Haftbeschlüsse;
- Festnahmen;
- Vorladungen und Auflagen;
- Asservatenstatus.

Nicht enthalten:

- interner Kriminellenruf;
- unsichtbarer Risikowert;
- kompletter Bank- oder Inventarinhalt ohne Berechtigung;
- Liveposition eines Charakters ohne technische und rechtliche Quelle;
- Administratorwissen;
- verdeckte Informationen ohne passende Rolle.

Jede sensible Abfrage wird mit Benutzer, Zweck, Zeitpunkt und Ziel protokolliert.

## 13.52 Durchsuchungs- und Haftbeschlüsse

Ein Beschluss besitzt:

- UUID;
- Typ;
- beantragende Person;
- genehmigende Rolle;
- Begründung;
- Zielperson, Fahrzeug, Konto oder Immobilie;
- erlaubten Umfang;
- Fall und Beweisgrundlage;
- Beginn und Ablauf;
- Status;
- Ausführungshistorie.

Mögliche Statuswerte:

- `draft`;
- `submitted`;
- `approved`;
- `rejected`;
- `active`;
- `executed`;
- `expired`;
- `revoked`;
- `appealed`;
- `archived`.

Genehmigungsrollen sind konfigurierbar. Richter oder Justiz werden bevorzugt. Für geringe Serverbesetzung können eng begrenzte richterliche Vertretungen oder Eilmaßnahmen vorgesehen werden; diese benötigen kurze Laufzeit, Begründung und nachträgliche Prüfung.

## 13.53 Durchsuchungen

Mögliche Durchsuchungsgründe:

- Einwilligung;
- unmittelbare Gefahrenlage;
- Festnahme und zulässige Personendurchsuchung;
- aktiver Beschluss;
- Fahrzeugmaßnahme;
- definierte Kontrollbefugnis;
- administrative Maßnahme außerhalb des Rollenspiels.

Eine Durchsuchungssitzung speichert:

- durchsuchende Person;
- Ziel;
- Rechts- oder RP-Grundlage;
- Umfang;
- Beginn und Ende;
- eingesehene Bereiche;
- entnommene Gegenstände;
- Zeugen;
- Abbruch.

Der Server öffnet nur die vom Umfang gedeckten Inventare, Räume oder Daten. Eine Personendurchsuchung gewährt keinen automatischen Zugriff auf Wohnung, Firma oder Bankkonto.

## 13.54 Beschlagnahmung und Asservate

Eine Beschlagnahmung verschiebt einen Gegenstand oder eine Warenmenge in ein eindeutiges Asservateninventar.

Gespeichert werden:

- ursprünglicher Besitzer und Lagerort;
- sicherstellende Person;
- Grund;
- Fall oder Vorgang;
- Menge und Zustand;
- Beweismittelbeutel;
- Verwahrort;
- Freigabe- oder Vernichtungsbedingung;
- Übergaben;
- endgültiges Ergebnis.

Beschlagnahmte Gegenstände werden nicht kopiert. Freigabe, Rückgabe, Verwertung oder Vernichtung sind protokollierte Bewegungen.

Geld wird über ein Verwahr- oder Beweiskonto im Hauptbuch gebucht.

## 13.55 Festhalten, Fesseln und Transport

Polizeiliche oder kriminelle Fesselaktionen prüfen:

- Nähe;
- Akteurszustand;
- Zielzustand;
- zulässigen Konflikt- oder Maßnahmenkontext;
- geeignetes Fesselmittel;
- bestehende Fesselung;
- Fahrzeug- und Sitzstatus.

Ein gefesselter Zustand speichert:

- Art der Fesselung;
- anwendende Person;
- Zeitpunkt;
- Kontext;
- erlaubte Interaktionen;
- Transportstatus.

Fesseln ist keine Eigentums- oder Administrationsfunktion. Missbrauch, extrem lange Inaktivität und Disconnects bleiben überprüfbar.

## 13.56 Festnahme und Booking

Eine Festnahme enthält:

- Festnahme-UUID;
- betroffenen Charakter;
- festnehmende Beamte;
- Ort und Zeitpunkt;
- Grund;
- Fall und Einsatz;
- Rechtebelehrung als protokollierbarer RP-Schritt;
- persönliche Gegenstände;
- beschlagnahmte Gegenstände;
- Gesundheitsstatus;
- Transport;
- Bookingstatus.

Booking umfasst:

1. Identität feststellen;
2. Gesundheitszustand prüfen;
3. persönliche Gegenstände verwahren;
4. Beweise und Beschlagnahmungen trennen;
5. Vorwürfe erfassen;
6. Fahndungen und Beschlüsse prüfen;
7. zuständige Freigabe oder Entscheidung einholen;
8. Freilassung, Auflage, Bußgeld oder Haft umsetzen.

## 13.57 Tatvorwürfe, Bußgelder und Sanktionen

Ein konfigurierbarer Katalog enthält:

- Tatbestand;
- Kategorie;
- Beschreibung;
- empfohlene Geldspanne;
- empfohlene Haftspanne;
- mögliche Lizenzfolgen;
- mögliche Beschlagnahmung;
- zuständige Rollen;
- Kombinations- und Obergrenzen.

Beamte wählen keine unbegrenzten freien Geld- oder Haftwerte. Abweichungen benötigen Berechtigung und Begründung.

Geldbußen werden über das Hauptbuch gebucht. Zahlungsunfähigkeit erzeugt keinen negativen Kontostand ohne definierte Forderung oder Ratenregel.

## 13.58 Haft

Haft ist ein persistenter Charakterstatus mit:

- Grundlage;
- Beginn;
- Gesamtdauer;
- bereits verbüßter Dauer;
- erforderlichem aktiven Anteil;
- möglichem Offline-Anteil;
- Haftort;
- Gegenstandsverwahrung;
- Entlassungsbedingungen;
- Änderungen und Gutschriften.

Empfohlen wird ein Hybridmodell:

- kurzfristige Gewahrsams- und Spielsanktionen benötigen überwiegend aktive Zeit;
- längere Strafen können teilweise in Echtzeit weiterlaufen;
- ein konfigurierbarer Mindestanteil bleibt aktiv zu verbüßen;
- Logout setzt Haft nicht vollständig zurück und überspringt sie nicht vollständig.

Haftzeiten sollen Rollenspiel ermöglichen und keine unverhältnismäßige reale Spielaussperre erzeugen.

## 13.59 Fahndungen

Fahndungsarten:

- Person;
- Fahrzeugkennzeichen;
- VIN;
- unbekannte Person mit Beschreibung;
- gestohlener Gegenstand;
- Waffen- oder Warencharge;
- vermisste Person;
- Zeuge;
- Haft- oder Durchsuchungsbeschluss.

Eine Fahndung enthält:

- Grund;
- Informationsquelle;
- Fall;
- bekannte Beschreibung;
- Risikoeinstufung;
- Beginn und Ablauf;
- erstellende und freigebende Rolle;
- Treffer und Aktualisierungen;
- Status.

Es gibt kein automatisch sichtbares GTA-Fahndungslevel über jedem Täter. Fahndungswissen wird über Dispatch, MDT, Kontrollen und Beobachtungen genutzt.

## 13.60 Polizei-Balance und Missbrauchsschutz

- Polizeigehalt stammt aus Staats- oder Organisationskonto.
- Es gibt keine direkte Kopfprämie pro Festnahme oder Tötung.
- Erfahrung entsteht aus plausibler Dienstarbeit, Berichten, Beweissicherung und abgeschlossenen Aufgaben.
- MDT-, Konto-, Asservaten- und Beschlusszugriffe werden auditiert.
- Dienstwaffen und Beweismittel besitzen Ausgabe- und Rückgabehistorie.
- Off-Duty-Zugriffe sind gesperrt.
- Selbstfreigabe eigener Beschlüsse oder Asservate kann untersagt werden.
- Fallbearbeiter, Genehmiger und ausführende Person können nach Risiko getrennt werden.
- Administrative und polizeiliche Befugnisse bleiben technisch getrennt.
- Korruptionsrollenspiel benötigt ausdrückliche Regeln und umgeht keine Serverberechtigungen.

## 13.61 Fortschritt, Ruf und Lizenzen

Kriminelle Fähigkeiten:

- Einbruch;
- Schlossknacken;
- Hacking;
- Fahrzeugdiebstahl;
- Spurenvermeidung;
- Hehlerei;
- Geldwäsche;
- Schmuggel.

Polizeiliche Fähigkeiten:

- Ermittlung;
- Beweissicherung;
- Einsatzfahren;
- Verhandlung;
- Tatortleitung;
- Observation;
- Analyse.

Fortschritt verbessert Zuverlässigkeit, Informationsqualität, Werkzeugnutzung und Handlungsoptionen. Er vervielfacht nicht unbegrenzt Beute oder Polizeibefugnisse.

Relevanter Ruf:

- einzelne Unterweltkontakte;
- Crew oder Organisation;
- Hehler;
- Geldwäscher;
- Polizeiorganisation;
- Justiz;
- Öffentlichkeit oder Unternehmen.

Polizeiliche Dienstgrade werden durch Organisation und Freigabe vergeben, nicht automatisch durch Fähigkeitslevel.

## 13.62 Belohnungs- und Fortschrittsregeln

Krimineller Fortschritt kann entstehen durch:

- erfolgreiche Teilziele;
- verwertete Beute;
- neue Vorgehensweise;
- vertragliche Unterweltaufträge;
- sichere Teamrolle;
- unentdeckte oder spurenarme Durchführung.

Kein oder reduzierter Fortschritt:

- Töten ohne Zielbezug;
- wiederholtes Farmen desselben Partners;
- Abbruch unmittelbar vor Risiko;
- Tat gegen Zweitaccount oder abgesprochene Opfer;
- Duplizieren von Werkzeugen oder Beute;
- reine Anwesenheit ohne Beitrag.

Polizeilicher Fortschritt kann entstehen durch:

- Einsatzbearbeitung;
- korrekte Beweissicherung;
- Berichte;
- Fahndungserfolg;
- Verhandlung;
- Wiederbeschaffung;
- sichere Festnahme;
- Verkehrs- und Präventionsarbeit.

Festnahmen und Verurteilungen allein dürfen kein lohnendes gegenseitiges Farming ermöglichen.

## 13.63 Dynamischer Crime-Editor

Administratoren können als Entwurf erstellen:

- Tatdefinitionen;
- Tatziele;
- Sicherheitskomponenten;
- Tatstufen und Abhängigkeiten;
- Aufklärungsinformationen;
- Werkzeuganforderungen;
- Alarmprofile;
- Beweisprofile;
- Beutequellen und Limits;
- Polizei-Anforderungen;
- Ziel-, Teilnehmer- und globale Cooldowns;
- NPCs und Zeugen;
- Lade-, Flucht- und Übergabezonen;
- Hehler;
- Geldwäschemethoden;
- Gefängnis- und Bookingbereiche.

Der Editor zeigt eine Vorschau des Tatgraphen, der Weltpunkte, der Abhängigkeiten und der wirtschaftlichen Bilanz.

## 13.64 Validierung vor Veröffentlichung

Vor Veröffentlichung werden geprüft:

- eindeutige UUIDs;
- gültige Tatstufen ohne unerreichbare Sackgassen;
- erreichbare Interaktionspunkte;
- gültige Routing-Bucket-Regeln;
- vorhandene Beutequelle;
- maximale Beute und wirtschaftliche Obergrenze;
- vollständige Alarm- und Dispatchzuordnung;
- mögliche Abschluss-, Abbruch- und Fehlerpfade;
- passende Inventare und Gegenstände;
- gültige Polizei-Anforderungen;
- Cooldown- und Gleichzeitigkeitsschutz;
- Beweisprofile;
- keine ungeschützte Eigentumsübertragung;
- keine Belohnung ohne nachvollziehbare Quelle.

Eine laufende Tatinstanz behält die veröffentlichte Konfigurationsversion.

## 13.65 Geplante Datenbanktabellen

### Crime

- `cnr_crime_definitions`
- `cnr_crime_definition_versions`
- `cnr_crime_targets`
- `cnr_crime_target_states`
- `cnr_crime_instances`
- `cnr_crime_participants`
- `cnr_crime_stage_definitions`
- `cnr_crime_stage_events`
- `cnr_crime_cooldowns`
- `cnr_crime_intel`
- `cnr_crime_loot_allocations`
- `cnr_stolen_assets`
- `cnr_fence_orders`
- `cnr_laundering_batches`
- `cnr_criminal_groups`
- `cnr_criminal_group_members`

### Dispatch und Polizei

- `cnr_dispatch_calls`
- `cnr_dispatch_updates`
- `cnr_dispatch_assignments`
- `cnr_police_departments`
- `cnr_police_units`
- `cnr_police_duty_sessions`
- `cnr_police_incidents`
- `cnr_police_cases`
- `cnr_police_case_links`
- `cnr_police_reports`
- `cnr_police_report_versions`
- `cnr_warrants`
- `cnr_warrant_executions`
- `cnr_search_sessions`
- `cnr_arrests`
- `cnr_charge_definitions`
- `cnr_arrest_charges`
- `cnr_sentences`
- `cnr_custody_events`
- `cnr_wanted_records`
- `cnr_seizures`

### Beweise

- `cnr_evidence_records`
- `cnr_evidence_samples`
- `cnr_evidence_bags`
- `cnr_evidence_custody_events`
- `cnr_evidence_analysis_orders`
- `cnr_evidence_analysis_results`
- `cnr_evidence_storage_locations`
- `cnr_camera_devices`
- `cnr_camera_recordings`
- `cnr_bodycam_sessions`

Bestehende Charakter-, Item-, Inventar-, Fahrzeug-, Immobilien-, Bank- und Auftragstabellen werden referenziert und nicht dupliziert.

## 13.66 Serverautorisierte Regeln

- Tatstart, Zielzustand, Beute und Cooldown werden serverseitig entschieden.
- Dieselbe Tat- oder Vorgangs-UUID kann keine doppelte Beute oder Zahlung erzeugen.
- Kein Client bestimmt Alarmempfänger, Täteridentität oder Beweisergebnis.
- Beute besitzt eine nachvollziehbare Quelle und Menge.
- Reservierte Beute kann nicht parallel aus einer zweiten Instanz entnommen werden.
- Physische Beute bleibt als Item, Charge, Fahrzeug oder Lagerbewegung erhalten.
- Polizei sieht nur freigegebene Dispatch-, MDT- und Falldaten.
- Durchsuchungen sind auf Ziel, Umfang und Grundlage begrenzt.
- Beschlagnahmung bewegt Assets und dupliziert sie nicht.
- Beweise werden aus bestätigten Serveraktionen erzeugt.
- Masken verbergen keine VIN, Fingerabdrücke oder andere unabhängige Spuren.
- Routing Bucket, Position, Zustand, Rolle und Berechtigung werden geprüft.
- Kritische Aktionen besitzen Rate-Limits.
- Zustandswechsel verwenden erwartete Versionen oder Sperren.
- Administratives Eingreifen erzeugt Audit- und Korrekturereignisse.

## 13.67 Neustart- und Fehlerwiederherstellung

Nach Resource- oder Serverneustart:

- Tatinstanzen werden aus bestätigten Zuständen geladen;
- reservierte Beute wird abgeglichen;
- offene Tatstufen werden fortgesetzt oder sicher abgebrochen;
- Zielzustände werden nicht blind auf `available` gesetzt;
- offene Dispatch-Einsätze bleiben bei Relevanz erhalten;
- persistente Fahndungen, Fälle und Beschlüsse bleiben bestehen;
- Beweis- und Asservatenketten bleiben unverändert;
- Fessel-, Haft- und kritische Charakterzustände werden wiederhergestellt;
- verwaiste Reservierungen werden nur über einen geprüften Recoveryprozess freigegeben.

Unklare Fälle landen in einer administrativen Prüfwarteschlange und werden nicht durch pauschale Auszahlung gelöst.

## 13.68 Kennzahlen und Balancing

Aggregiert werden:

- Tatversuche und Abschlussquote pro Zieltyp;
- Teilfortschritt und Abbruchgründe;
- durchschnittliche Beute vor und nach Verwertung;
- Vorbereitungskosten;
- Alarm- und Reaktionszeiten;
- Polizeibesetzung beim Tatstart;
- Festnahme-, Flucht- und Wiederbeschaffungsquote;
- Gewalt- und Verletzungsquote;
- erzeugte und gesicherte Beweise;
- Verurteilungen und eingestellte Fälle;
- Ziel- und Teilnehmerwiederholungen;
- Disconnects in kritischen Phasen;
- Notwendigkeit administrativer Korrekturen;
- Geld- und Warenflüsse der Unterwelt.

Kennzahlen dienen dem Balancing und der Missbrauchserkennung. Sie werden nicht als automatische Schuldwertung verwendet.

## 13.69 Administrationsprüfung und Streitfälle

Berechtigte Administratoren können einen Vorgang anhand einer Timeline prüfen:

- Tatstart und Konfigurationsversion;
- Teilnehmer;
- Tatstufen;
- Werkzeuge;
- Beutequelle und Bewegungen;
- Alarme und Dispatch;
- Positions- und Zustandsprüfungen;
- Kampf-, Verletzungs- und Disconnectereignisse;
- Beweise;
- Durchsuchungen;
- Beschlagnahmungen;
- Zahlungen;
- administrative Eingriffe.

Korrekturen verwenden Gegenbewegungen, Rückgaben oder begründete Statusereignisse. Historische Einträge werden nicht still gelöscht.

## 13.70 Cops-&-Robbers-MVP

Im ersten Cops-&-Robbers-MVP enthalten:

- Polizeianstellung, Rollen und Dienstsitzungen;
- grundlegende Einheiten und Status;
- Notrufe, automatische Alarme und Dispatchzuweisung;
- kleiner Laden- oder Tankstellenraub;
- Fahrzeugdiebstahl mit Fahndungsbezug;
- ein mehrstufiger Bankfilialraub;
- ein Transport- oder Lagerüberfall;
- physische und markierte Beute;
- ein Hehler;
- eine grundlegende Geldwäsche-Methode;
- Ziel-, Teilnehmer- und globale Cooldowns;
- Polizeiverfügbarkeitsprüfung;
- Personen-, Kennzeichen- und VIN-Fahndungen;
- Masken und grundlegende Täterbeschreibungen;
- Fingerabdrücke, Blut/DNA, Patronenhülsen, Werkzeugspuren und Kameradaten;
- Tatortsicherung und Beweismittelbeutel;
- Beweiskette und einfache Analyse;
- Polizeifälle, Berichte und Basis-MDT;
- Durchsuchungs- und Haftbeschlüsse;
- begrenzte Durchsuchung;
- Beschlagnahmung und Asservatenlager;
- Fesseln, Festnahme, Booking und persistente Haft;
- grundlegender Tatbestandskatalog;
- Disconnect- und Neustartwiederherstellung;
- Crime-Editor und vollständige Audit-Timeline.

## 13.71 Spätere Ausbaustufen

- komplexe Gangs und Territorien;
- dynamische Unterweltpolitik;
- Informantenführung;
- verdeckte Ermittlungen;
- tiefere Telekommunikationsauswertung;
- umfangreiche Gerichtsverhandlungen;
- Staatsanwaltschaft und Verteidigung;
- Bewährung und Sozialstunden;
- komplexe Gefängniswirtschaft;
- Gefängnisausbrüche;
- taktische Spezialeinheiten;
- K9 und Luftunterstützung;
- umfangreiche Laborrollen;
- Versicherungsbetrug;
- Cyberkriminalität;
- komplexe Drogen- und Waffenmärkte;
- internationale Schmuggelketten;
- große Spezialereignisse.

## 13.72 Erster illegaler Referenzablauf

1. Zwei Spieler beschaffen Informationen über einen Laden.
2. Sie wählen einen stillen Safezugriff statt eines sofortigen Schusswechsels.
3. Der Server prüft Ziel, Polizei, Werkzeuge, Cooldowns und Safebestand.
4. Ziel und maximale Beute werden reserviert.
5. Beim Zugang entsteht eine Werkzeugspur.
6. Eine Kamera zeichnet Kleidung und Fahrzeugbeschreibung auf.
7. Der verzögerte Alarm erzeugt einen Dispatch-Einsatz.
8. Polizeieinheiten werden zugewiesen, erhalten aber keine Täteridentität.
9. Die Täter entnehmen einen Teil des Bestands als markierte Bargeldcharge.
10. Ein Täter verletzt sich und hinterlässt Blut.
11. Die Täter fliehen; Sichtkontakt geht später verloren.
12. Polizei sichert Tatort, Kamera, Werkzeugspur und Blutprobe.
13. Ein Zeuge ergänzt eine Kennzeichenbeschreibung.
14. Das Fahrzeug wird zur Fahndung ausgeschrieben.
15. Die Täter lagern Beute und verkaufen einen Teil über einen Hehler.
16. Ein Täter versucht markiertes Bargeld zu waschen.
17. Ermittlungen verknüpfen Fahrzeug, unbekanntes DNA-Profil und Geldcharge.
18. Nach einem späteren zulässigen Vergleich entsteht ein konkreter Tatverdacht.
19. Ein Beschluss ermöglicht eine begrenzte Durchsuchung.
20. Beute wird sichergestellt oder der Täter entkommt erneut.
21. Festnahme, Booking, Fallabschluss oder weitere Fahndung folgen aus dem tatsächlichen Verlauf.

## 13.73 Abnahmekriterien für das spätere Scripting

Der Cops-&-Robbers-MVP gilt fachlich als funktionsfähig, wenn:

- eine Tat vom Tatstart bis Beuteverwertung oder Sicherstellung ohne administrative Abkürzung spielbar ist;
- zwei Gruppen dieselbe Beutequelle nicht gleichzeitig verwenden können;
- ein Polizeidisconnect nach gültigem Start die Tat nicht ungültig macht;
- Polizei feste Tatorte genau, flüchtende Täter aber nicht ohne Quelle live verfolgen kann;
- maskierte Täter nicht automatisch namentlich identifiziert werden;
- Beute, Geld und beschlagnahmte Gegenstände ihre Mengenbilanz behalten;
- Durchsuchungen nur erlaubte Ziele und Bereiche öffnen;
- Beweismittel eine vollständige Sicherungs- und Übergabekette besitzen;
- ein unbekanntes DNA- oder Fingerabdruckprofil unbekannt bleiben kann;
- Berichte, Beschlüsse und Beweisergebnisse versioniert statt überschrieben werden;
- Festnahme und Haft einen Neustart überstehen;
- ein Disconnect keine Beute dupliziert und keinen kritischen Zustand entfernt;
- weder Kills noch gegenseitig arrangierte Festnahmen die beste Fortschrittsquelle sind;
- kleine Straftaten bei niedriger Besetzung möglich bleiben;
- große Straftaten eine angemessene Polizeireaktion voraussetzen;
- legale Wirtschaftsgüter geraubt, wiederbeschafft, versichert oder verwertet werden können, ohne Duplikation;
- die vollständige Ereigniskette für berechtigte Administration nachvollziehbar ist.

---

# 14. Allgemeines Job- und Aktivitätsmodell

Das Job- und Aktivitätsmodell stellt eine gemeinsame Grundlage für legale Berufe, öffentliche Dienste, Firmenaufträge und selbstständige Tätigkeiten bereit. Fachliche Arbeit bleibt in den zuständigen Modulen. Das Jobmodul koordiniert Angebot, Berechtigung, Teilnehmer, Reservierungen, Fortschritt und Abrechnung.

Ein Beruf besteht nicht nur aus einem sichtbaren Jobnamen. Anstellung, Schicht, Auftrag, Aktivität und einzelner Arbeitsschritt sind getrennte Objekte.

## 14.1 Leitprinzipien

- Arbeit erzeugt einen tatsächlichen Nutzen oder erfüllt einen nachvollziehbaren Auftrag.
- Vergütung stammt aus einem Unternehmen, Kunden-, Staats- oder kontrollierten Systemkonto.
- Das Fahren zu Markern allein gilt nicht automatisch als Arbeitsleistung.
- Fachmodule bestätigen Warenbewegung, Reparatur, Produktion oder Diensthandlung.
- Jobangebote besitzen eine Quelle, ein Budget, Anforderungen und eine Ablaufzeit.
- Solo- und Gruppenarbeit verwenden denselben Kern.
- Fortschritt richtet sich nach tatsächlichem Beitrag.
- Pausen, Abbruch, Disconnect und Neustart sind definierte Zustände.
- Ein Job darf keine Gegenstände, Fahrzeuge oder Geld am Fachmodul vorbei erzeugen.
- Wiederverwendbare Aktivitätsschritte ersetzen keine fachliche Serverprüfung.

## 14.2 Verantwortliche Module

### `cnr_jobs`

Verantwortet:

- Jobdefinitionen;
- Jobangebote;
- Zuweisungen;
- Teilnehmer und Rollen;
- Arbeits- und Dienstsitzungen;
- Aktivitätsinstanzen;
- Arbeitsschritte;
- Beitragsmessung;
- Budget- und Assetreservierungen;
- Abrechnungsvorbereitung;
- Job-Cooldowns;
- Anti-Farming-Signale.

### `cnr_employment`

Verantwortet:

- Arbeitsverhältnisse;
- Arbeitgeber und Position;
- arbeitsvertragliche Rollen;
- Lohnmodelle;
- Arbeitszeitfreigabe;
- Kündigung und Suspendierung.

### `cnr_contracts`

Verantwortet:

- Dienstleistungs- und Rahmenverträge;
- konkrete Aufträge;
- Meilensteine;
- Auftraggeber und Auftragnehmer;
- Abnahme;
- Streitstatus.

### `cnr_marketplace`

Verantwortet:

- öffentliche und private Jobangebote;
- Ausschreibungen;
- Angebote;
- Sichtbarkeit;
- Vergabe.

### `cnr_progression`

Verantwortet:

- Fähigkeiten;
- Erfahrung;
- Spezialisierungen;
- Anti-Farming-Regeln für Fortschritt.

Fachmodule wie `cnr_industry`, `cnr_logistics`, `cnr_vehicles`, `cnr_facilities`, `cnr_storage`, `cnr_police`, `cnr_medical` und später `cnr_fire` bestätigen die eigentliche Fachleistung.

## 14.3 Getrennte Fachbegriffe

| Begriff | Bedeutung |
|---|---|
| Beruf | langfristiges Tätigkeitsfeld eines Charakters |
| Arbeitsverhältnis | Vertrag zwischen Charakter und Arbeitgeber |
| Position | Rolle innerhalb eines Arbeitgebers |
| Schicht | Zeitraum einer aktiven Beschäftigungs- oder Dienstsitzung |
| Jobdefinition | versionierte Vorlage eines ausführbaren Jobtyps |
| Jobangebot | konkrete verfügbare Arbeitsmöglichkeit |
| Zuweisung | angenommener Job mit verantwortlichen Teilnehmern |
| Auftrag | kaufmännischer Leistungsauftrag zwischen Parteien |
| Aktivitätsdefinition | wiederverwendbarer fachlicher Ablauf |
| Aktivitätsinstanz | konkrete laufende Ausführung |
| Arbeitsschritt | einzelnes prüfbares Teilziel |
| Beitrag | bestätigte Leistung eines Teilnehmers |
| Abrechnung | endgültige Vergütung und Kostenbuchung |

Ein Charakter kann einen Beruf ausüben, ohne fest angestellt zu sein. Ebenso erzeugt eine Anstellung nicht automatisch einen laufenden Auftrag oder vergütete Arbeitszeit.

## 14.4 Beschäftigungs- und Tätigkeitsformen

### Festangestellte Arbeit

- Arbeitsvertrag;
- feste Position;
- Stunden- oder Festlohn;
- betriebliche Schichten;
- Firmenfahrzeuge und Arbeitsmittel;
- interne Aufträge.

### Öffentlicher Dienst

- Polizei;
- Rettungsdienst;
- Feuerwehr;
- Justiz;
- Verwaltung;
- städtische Betriebe.

Öffentliche Dienste verwenden Dienstrollen und Fachmodule, aber denselben Sitzungs- und Beitragsrahmen.

### Selbstständige Arbeit

- eigener Betrieb;
- direkter Kundenauftrag;
- Ausschreibung;
- Serviceanfrage;
- Abrechnung über Firma oder Charakter, soweit erlaubt.

### Freie Auftragsarbeit

- zeitlich begrenztes Angebot;
- keine dauerhafte Anstellung;
- feste oder variable Vergütung;
- eigene oder gestellte Ausrüstung.

### Offene Einstiegsarbeit

- kontrolliert finanzierter System- oder Stadtauftrag;
- niedrige Zugangshürde;
- begrenzte Kapazität;
- sinnvolle Einbindung in Wirtschaft oder Stadtbetrieb;
- keine unbegrenzte Geldquelle.

## 14.5 Dauerhafte Identität und Versionierung

Jobdefinitionen, Aktivitätsdefinitionen, Angebote, Zuweisungen und Instanzen besitzen eigene UUIDs.

Eine Jobdefinition enthält:

- interne ID und öffentliche UUID;
- technischen Code;
- sichtbaren übersetzbaren Namen;
- Kategorie;
- verantwortliches Fachmodul;
- Version;
- Status;
- Ersteller und Freigabe;
- Gültigkeitszeitraum.

Koordinaten, NPCs, Marker oder sichtbare Namen sind keine dauerhafte Jobidentität.

Ein angenommenes Jobangebot behält seine gültige Job- und Aktivitätsversion. Spätere Konfigurationsänderungen verändern keinen laufenden Auftrag rückwirkend.

## 14.6 Jobdefinition

Eine Jobdefinition beschreibt:

- Tätigkeitsform;
- mögliche Angebotsquellen;
- erforderliche Rollen;
- Mindest- und Höchstteilnehmer;
- Fähigkeiten und Lizenzen;
- Rufanforderungen;
- erlaubte Arbeitgeber;
- Aktivitätsvorlage;
- Vergütungsmodelle;
- Budgetregeln;
- benötigte Assets;
- Zeitfenster;
- Abbruch- und Fehlerregeln;
- Cooldowns;
- Metriken;
- zuständige Fachmodule.

Eine Jobdefinition enthält keine frei ausführbaren Skripte aus dem Control Panel. Sie verwendet nur registrierte, serverseitig implementierte Fähigkeiten und Schritttypen.

## 14.7 Aktivitätsdefinition

Eine Aktivitätsdefinition besteht aus:

- Aktivitäts-UUID;
- Version;
- Start- und Abschlussbedingungen;
- Arbeitsschritten;
- Abhängigkeiten;
- optionalen oder alternativen Pfaden;
- Teilnehmerrollen;
- Reservierungen;
- fachlichen Prüfern;
- Erfolgs-, Teil- und Fehlerzuständen;
- Beitragsereignissen;
- Wiederaufnahmeverhalten.

Einfache Aktivitäten dürfen linear sein. Komplexe Tätigkeiten können einen kleinen gerichteten Abhängigkeitsgraphen verwenden.

## 14.8 Wiederverwendbare Arbeitsschritte

Mögliche Schritttypen:

- Gegenstand übernehmen;
- Fahrzeug oder Maschine prüfen;
- Ware laden oder entladen;
- definierte Strecke oder Haltestellen bedienen;
- Produkt sammeln;
- Produktion starten oder überwachen;
- Fahrzeug reparieren;
- Objekt warten;
- Person transportieren;
- Standort kontrollieren;
- Lieferung bestätigen;
- Probe oder Messung durchführen;
- Kundeninteraktion;
- Einsatz übernehmen;
- Bericht einreichen;
- Anlage sicher übergeben.

Jeder Schritttyp besitzt:

- fachlichen Serverprüfer;
- erlaubte Eingaben;
- Positions- und Zustandsregeln;
- Fortschrittsereignisse;
- Abbruchregel;
- Beitragszuordnung;
- mögliche Kosten und Verluste.

Ein generischer Fortschrittsbalken allein bestätigt keinen Arbeitsschritt.

## 14.9 Quellen von Jobangeboten

Jobangebote können entstehen durch:

- tatsächlichen Lager- oder Produktionsbedarf;
- Kundenanfrage;
- Firmenauftrag;
- Arbeitsplanung eines Vorgesetzten;
- öffentlichen Auftrag;
- Dispatch-Einsatz;
- Marktplatzausschreibung;
- Wartungsintervall;
- beschädigtes Fahrzeug oder Asset;
- Fahrplan;
- dynamisches Ereignis;
- kontrollierten Einstiegsjob.

Jedes Angebot speichert seine Quelle. Ein vergütetes Angebot ohne Budget oder erlaubte Systemfinanzierung kann nicht veröffentlicht werden. Unbezahlte Tätigkeiten müssen ausdrücklich als solche gekennzeichnet und vor Annahme sichtbar sein.

## 14.10 Bedarfsbasierte Jobs

Beispiele:

- Tankstelle benötigt Kraftstoff;
- Lager benötigt Umlagerung;
- Firma benötigt einen Transport;
- Fahrzeug benötigt Reparatur;
- Maschine erreicht Wartungsgrenze;
- Bürger bestellt Taxi;
- liegengebliebenes Fahrzeug benötigt Abschleppdienst;
- Müllbehälter erreichen Abholschwelle;
- Polizei oder Rettungsdienst erhält einen Einsatz.

Bedarf wird durch das zuständige Fachmodul gemeldet. `cnr_jobs` erzeugt daraus nur dann ein Angebot, wenn:

- Bedarf noch besteht;
- keine ausreichende aktive Zuweisung existiert;
- Budget oder Kostenträger vorhanden ist;
- Ziel und benötigte Assets reservierbar sind;
- Angebots- und Wiederholungsgrenzen eingehalten werden.

## 14.11 Kontrollierte Einstiegsjobs

Bei geringer Spielerzahl bleiben einfache Tätigkeiten verfügbar.

Eigenschaften:

- begrenztes städtisches oder Systembudget;
- niedrigere, transparente Vergütung;
- zeit- oder mengenbegrenztes Angebot;
- wechselnde sinnvolle Ziele;
- keine hohen Spezialisierungsvorteile;
- Verbindung zu Recycling, Versorgung oder Stadtbetrieb;
- keine sichere Arbitrage mit anderen Systemmärkten.

Geeignete Beispiele:

- kommunale Müllsammlung;
- einfache Hafen- oder Lagerhilfe;
- Stadtlieferungen;
- Bus-Grundlinie;
- Straßen- oder Anlagenkontrolle.

## 14.12 Sichtbarkeit von Angeboten

Mögliche Sichtbarkeit:

- öffentlich;
- nur Mitarbeiter;
- nur bestimmte Firmen;
- nur eingeladene Charaktere;
- nur passende Lizenzinhaber;
- rufabhängig;
- standortabhängig;
- rollenabhängig;
- Ausschreibung;
- direkte Zuweisung.

Ein sichtbares Angebot zeigt mindestens:

- Auftraggeber oder Angebotsquelle;
- Tätigkeit;
- Anforderungen;
- erwarteten Vergütungsbereich;
- mögliche Kosten;
- Zeitfenster;
- benötigte Assets;
- Gruppengröße;
- Abbruchbedingungen.

Versteckte Strafgebühren oder nachträglich verschlechterte Vergütungsformeln sind nicht erlaubt.

## 14.13 Angebotsstatus

| Zustand | Bedeutung |
|---|---|
| `draft` | noch nicht sichtbar |
| `scheduled` | für einen späteren Zeitpunkt vorgesehen |
| `published` | für berechtigte Bewerber sichtbar |
| `partially_reserved` | Bewerbung oder Gruppenbildung läuft |
| `reserved` | vorübergehend für einen Bewerber oder ein Team gesperrt |
| `assigned` | verbindlich vergeben |
| `closed` | regulär beendet |
| `expired` | Zeitfenster abgelaufen |
| `cancelled` | durch berechtigte Quelle zurückgezogen |
| `invalidated` | nur bei technischem oder administrativ bestätigtem Fehler |

Reservierungen besitzen kurze Ablaufzeiten, damit ein geöffnetes UI Angebote nicht dauerhaft blockiert.

## 14.14 Eignungsprüfung

Vor Bewerbung oder Annahme prüft der Server:

1. gültigen Charakter und aktive Sitzung;
2. Beschäftigungs- oder Firmenrolle;
3. erforderliche Fähigkeiten;
4. Lizenzen;
5. Ruf;
6. Sperren und Interessenkonflikte;
7. aktuelle kritische Zustände;
8. andere unvereinbare Schichten oder Jobs;
9. Teilnehmer- und Rollenlimits;
10. verfügbare Fahrzeuge, Ausrüstung und Lagerkapazitäten;
11. Budget und Zahlungsreservierung;
12. Angebot, Version und Ablaufzeit.

Nicht erfüllte Anforderungen werden verständlich angezeigt, soweit sie keine verdeckten Sicherheits- oder Balancingwerte offenlegen.

## 14.15 Annahme und Reservierung

Beim Annehmen werden atomar reserviert:

- Angebot;
- Teilnehmerplatz und Rolle;
- Auftrag oder Kundenanfrage;
- Vergütungsbudget oder Treuhandbetrag;
- benötigte Ware;
- Fahrzeug oder Maschine;
- Lade- und Zielkapazität;
- zeitkritischer Standort;
- veröffentlichte Konfigurationsversion.

Scheitert eine notwendige Reservierung, entsteht keine halbfertige Zuweisung.

## 14.16 Zuweisungsstatus

| Zustand | Bedeutung |
|---|---|
| `offered` | konkrete Zuweisung wurde angeboten |
| `accepted` | Teilnehmer haben angenommen |
| `preparing` | Assets und Rollen werden vorbereitet |
| `ready` | Pflichtvoraussetzungen sind reserviert |
| `active` | Arbeit läuft |
| `paused` | kontrolliert unterbrochen |
| `waiting_external` | wartet auf Kunde, Fachmodul oder Abnahme |
| `completing` | Ergebnis und Abrechnung werden geprüft |
| `completed` | fachlich und finanziell abgeschlossen |
| `partially_completed` | verwertbarer Teil wurde erfüllt |
| `failed` | Pflichtziel nicht erreicht |
| `cancelled` | vor Start oder kontrolliert beendet |
| `abandoned` | ohne geregelte Übergabe verlassen |
| `disputed` | Abnahme oder Vergütung wird bestritten |

## 14.17 Schicht und Aktivität bleiben getrennt

Eine Schicht beschreibt, für wen und in welcher Rolle ein Charakter arbeitet. Eine Aktivität beschreibt, was konkret ausgeführt wird.

Ein Mitarbeiter kann während einer Schicht:

- mehrere Aufträge bearbeiten;
- auf einen Einsatz warten;
- Pause machen;
- innerbetriebliche Aufgaben erledigen;
- Ausrüstung übernehmen;
- Berichte erstellen.

Eine Aktivität kann umgekehrt durch:

- festangestellte Mitarbeiter;
- freie Auftragnehmer;
- mehrere Firmen;
- öffentliche Dienste;
- einen einzelnen Selbstständigen

ausgeführt werden.

## 14.18 Arbeitssitzung

Die bestehende Arbeitssitzung enthält mindestens:

- Charakter;
- Arbeitgeber oder Dienststelle;
- Arbeitsverhältnis und Position;
- Dienstrolle;
- Start und Ende;
- aktive Zeit;
- Pausen;
- zugeordnete Aktivitäten;
- ausgegebene Assets;
- Disconnect- und Timeoutzeiten;
- Freigabestatus;
- Korrekturhistorie.

Standardmäßig kann ein Charakter nur eine vergütete Arbeits- oder Dienstsitzung gleichzeitig führen. Firmenbesitz und passive Unternehmensrollen zählen nicht als aktive Schicht.

## 14.19 Schichtstatus

- `clocked_in`;
- `available`;
- `assigned`;
- `active_work`;
- `break`;
- `suspended`;
- `disconnected_grace`;
- `clocked_out`;
- `pending_review`;
- `approved`;
- `corrected`;
- `rejected`.

Ein Statuswechsel prüft Rolle, Ort, Aktivität und mögliche ausgegebene Assets.

## 14.20 Aktive Arbeitszeit und Pausen

Vergütungsfähige Zeit kann entstehen durch:

- aktive fachliche Tätigkeit;
- notwendige Anfahrt innerhalb eines Auftrags;
- Einsatzbereitschaft in ausdrücklich vergütetem öffentlichem Dienst;
- dokumentierte Vorbereitung;
- Abwicklung und Berichte;
- erlaubte Wartezeit auf Kunde oder Anlage.

Nicht automatisch vergütungsfähig:

- beliebige Onlinezeit;
- Pause;
- AFK-Zeit;
- private Umwege;
- unzugewiesene Aktivität;
- absichtlich verlängerte Arbeit;
- Aufenthalt in einem Dienstfahrzeug ohne Aufgabe.

Pausen können manuell begonnen oder nach klaren Regeln vorgeschlagen werden. Das System beendet nicht bei jeder kurzen Inaktivität sofort die gesamte Schicht.

## 14.21 Aktivitätsinstanz

Eine Aktivitätsinstanz speichert:

- Definition und Version;
- Zuweisung und Auftrag;
- Teilnehmer;
- Start- und Zielorte;
- reservierte Assets;
- aktuellen Schritt;
- Schrittzustände;
- fachliche Ergebnisse;
- Beitrag;
- Kosten;
- Beginn, Pausen und Ende;
- Wiederaufnahmeinformationen;
- Abrechnungsreferenz.

## 14.22 Aktivitätsstatus

| Zustand | Bedeutung |
|---|---|
| `created` | Instanz wurde angelegt |
| `reserved` | Pflichtressourcen sind reserviert |
| `ready` | Startbedingungen sind erfüllt |
| `running` | mindestens ein Arbeitsschritt läuft |
| `paused` | sicher unterbrochen |
| `waiting` | wartet auf einen externen Zustand |
| `completing` | Ergebnisse werden validiert |
| `completed` | alle Pflichtziele sind bestätigt |
| `partially_completed` | definierter Teilnutzen wurde erreicht |
| `aborted` | kontrolliert beendet |
| `failed` | nicht mehr erfüllbar |
| `recovery` | nach Fehler oder Neustart in Prüfung |

## 14.23 Teams und Rollen

Eine Zuweisung kann Rollen vorgeben:

- Fahrer;
- Beifahrer oder Navigator;
- Verlader;
- Maschinenführer;
- Techniker;
- Disponent;
- Sicherheitsbegleitung;
- Kundenkontakt;
- Teamleiter;
- Prüfer.

Rollen bestimmen:

- erlaubte Arbeitsschritte;
- benötigte Fähigkeiten;
- Assetzugriffe;
- Beitragsarten;
- Vergütungsanteil oder Lohnmodell;
- Übergaberechte.

Die Teamleitung kann Teilnehmer nicht nach geleisteter Arbeit entfernen, um deren vereinbarte Vergütung zu übernehmen.

## 14.24 Gruppenbildung

Mögliche Bildung:

- fertiges Team bewirbt sich;
- Teamleiter lädt vor Annahme ein;
- Arbeitgeber weist Mitarbeiter zu;
- öffentliches Angebot füllt offene Rollen;
- laufende Aktivität erhält einen zulässigen Ersatz.

Vor Beginn bestätigen Teilnehmer:

- Rolle;
- Vergütungsmodell;
- mögliche Kosten;
- Verantwortlichkeiten;
- Zeitfenster.

Änderungen nach Beginn benötigen die Zustimmung betroffener Parteien oder eine klar definierte Vertragsregel.

## 14.25 Beitragsmessung

Beitrag entsteht aus bestätigten Fachereignissen:

- tatsächlich gefahrene Auftragsstrecke;
- geladene oder gelieferte Menge;
- bediente Maschine;
- geprüfte Ladung;
- ausgeführte Reparatur;
- betreuter Kunde;
- bearbeiteter Einsatz;
- gesicherte Übergabe;
- erstellter erforderlicher Bericht;
- Koordination eines echten Teamschritts.

Zeit allein ist kein vollständiger Beitragsnachweis. Unterstützende Rollen dürfen Beitrag erhalten, auch wenn sie nicht den Abschlussknopf betätigen.

## 14.26 Beitrags- und Vergütungsaufteilung

Mögliche Modelle:

- fester Betrag pro Rolle;
- Stundenlohn aus Arbeitsvertrag;
- prozentualer Auftragsanteil;
- gleicher Teamanteil;
- beitragsgewichteter Anteil;
- Grundbetrag plus Leistungsanteil;
- Provision;
- vom Arbeitgeber getrennt gezahlter Lohn.

Ein beitragsgewichtetes Modell verwendet Ober- und Untergrenzen. Es darf notwendige Unterstützungsrollen nicht systematisch ohne Vergütung lassen.

Die vereinbarte Methode wird bei Jobbeginn als Version gespeichert.

## 14.27 Arbeitsmittel und Ausgabe

Arbeitsmittel können sein:

- Werkzeug;
- Schutzkleidung;
- Scanner;
- Funkgerät;
- Zugangskarte;
- Material;
- Ersatzteil;
- Behälter;
- Dienstwaffe;
- medizinische Ausrüstung.

Eine Ausgabe speichert:

- Asset oder Item;
- ausgebende Organisation;
- Empfänger;
- Schicht und Aktivität;
- Menge und Zustand;
- Ausgabezeit;
- erlaubte Nutzung;
- Rückgabe- oder Verbrauchsregel.

Verbrauch, Rückgabe, Verlust und Schaden werden nachvollziehbar gebucht.

## 14.28 Fahrzeuge und Maschinen

Jobfahrzeuge können:

- dem Arbeitgeber gehören;
- für den Auftrag gemietet sein;
- vom Auftraggeber gestellt werden;
- einem Teilnehmer gehören;
- staatlich bereitgestellt werden.

Eine Zuweisung enthält:

- Fahrzeug oder Maschine;
- erlaubte Fahrer und Bediener;
- Übergabezustand;
- Kilometer- oder Betriebsstand;
- Kraftstoff;
- Ladung;
- Schäden;
- Rückgabeort;
- Kostenverteilung.

Ein Jobzugriff ist ein zeitlich begrenztes Recht und überträgt kein Eigentum.

## 14.29 Waren und Kapazitäten

Vor materialgebundener Arbeit werden reserviert:

- Quellware;
- Zielkapazität;
- Ladebereich;
- Fahrzeug- oder Containerkapazität;
- Produktionskapazität;
- Kundenbestand;
- erlaubte Verlustmenge.

Fachmodule führen die tatsächlichen Bewegungen durch. Das Jobmodul speichert Referenzen und Fortschritt, erzeugt aber keine Waren.

## 14.30 Standort- und Routenwahl

Standorte können:

- fest;
- aus einem geprüften Pool gewählt;
- durch tatsächlichen Bedarf bestimmt;
- von Kunde oder Auftraggeber angegeben;
- dynamisch nach Kapazität ausgewählt;
- Teil eines Fahrplans sein.

Eine Route berücksichtigt:

- Fahrzeugart;
- Entfernung;
- Zugänglichkeit;
- Lade- und Zielstatus;
- Zeitfenster;
- doppelte Belegung;
- mögliche Straßen- oder Weltregeln.

Der Client darf ein Ziel nicht gegen einen näheren manipulierten Punkt austauschen. Unnötige Zwangsrouten werden vermieden; entscheidend sind bestätigter Start, Ziel und Leistung.

## 14.31 Qualität und Abnahme

Mögliche Qualitätsmerkmale:

- richtige Menge;
- Produktqualität;
- Lieferzeitfenster;
- Schadenszustand;
- Reparaturergebnis;
- Sauberkeit;
- Kundenzustand;
- Dokumentation;
- sichere Durchführung;
- erlaubte Verluste.

Abnahme kann erfolgen durch:

- zuständiges Fachmodul;
- Kunde;
- Arbeitgeber;
- Vertragspartner;
- automatische objektive Prüfung;
- Kombination aus objektiver Prüfung und Bestätigung.

Ein Kunde kann objektiv korrekt erbrachte Arbeit nicht unbegrenzt blockieren. Umgekehrt ersetzt automatische Abnahme keinen echten fachlichen Nachweis.

## 14.32 Serviceanfragen von Spielern

Spieler können Anfragen erstellen für:

- Taxi;
- Abschleppen;
- Reparatur;
- Transport;
- Lieferung;
- Lagerhilfe;
- Sicherheitsdienst;
- medizinische oder öffentliche Hilfe;
- spätere weitere Dienstleistungen.

Eine Anfrage enthält:

- Kunde;
- Dienstleistung;
- Standort;
- Ziel;
- Beschreibung;
- Budget oder Preisregel;
- Sichtbarkeit;
- Ablaufzeit;
- mögliche Dringlichkeit;
- Stornierungsregel.

Bei Annahme können Betrag oder Gebühren reserviert werden. Missbrauch durch Spam, falsche Standorte und wiederholtes Stornieren wird begrenzt.

## 14.33 Öffentliche Dienste und Dispatch

Polizei, Rettungsdienst und Feuerwehr verwenden:

- Dienstsitzung;
- Verfügbarkeitsstatus;
- Dispatchangebot;
- Einheiten- und Rollenzuweisung;
- fachliche Einsatzinstanz;
- Beitragsereignisse;
- Bericht oder Übergabe;
- staatliche Vergütung.

`cnr_jobs` kennt Dienst und Beitrag. `cnr_police`, `cnr_medical` und `cnr_fire` entscheiden über fachliche Maßnahmen.

Ein Notruf ist kein normaler Marktplatzjob und wird nur berechtigten Dienstrollen angezeigt.

## 14.34 Firmeninterne Jobs

Arbeitgeber können Angebote:

- automatisch aus Bedarf;
- durch Disponenten;
- aus Verträgen;
- aus Wartungsplänen;
- aus Kundenanfragen

erzeugen.

Firmenrechte bestimmen, wer:

- Angebote erstellt;
- Budget freigibt;
- Mitarbeiter zuweist;
- Fahrzeuge ausgibt;
- Arbeit abnimmt;
- Korrekturen beantragt.

Ein Firmenleiter kann keine Fachleistung bestätigen, die serverseitig nachweislich nicht stattgefunden hat.

## 14.35 Selbstständige und freie Auftragnehmer

Selbstständige können:

- öffentliche Angebote annehmen;
- auf Ausschreibungen bieten;
- eigene Servicepreise veröffentlichen;
- Kundenanfragen beantworten;
- Subunternehmer einsetzen, wenn erlaubt;
- eigene Fahrzeuge und Werkzeuge verwenden.

Kosten, Steuern, Versicherung, Material und Verschleiß bleiben beim vereinbarten Kostenträger.

Ein Charakter ohne Unternehmen kann nur Tätigkeiten abrechnen, die für persönliche Selbstständigkeit freigegeben sind.

## 14.36 Einarbeitung und Training

Jobdefinitionen können Trainingsaktivitäten besitzen:

- Einführung;
- sichere Übungsanlage;
- Beispielauftrag;
- Werkzeugerklärung;
- Fahrzeugübergabe;
- Fachprüfung;
- Lizenzprüfung.

Training:

- zahlt keine hohe reguläre Auftragsvergütung;
- kann begrenzte Erfahrung geben;
- verwendet ungefährliche oder klar gekennzeichnete Ressourcen;
- kann bei Bedarf wiederholt werden;
- darf nicht als günstigere Produktionsmethode missbraucht werden.

## 14.37 Vergütungsmodelle

Unterstützt werden:

- Stundenlohn;
- Festbetrag pro Auftrag;
- Betrag pro Meilenstein;
- Stück- oder Mengensatz;
- Kilometer- oder Streckensatz;
- Provision;
- Umsatzanteil;
- Grundbetrag plus Qualitätsbonus;
- Bereitschaftsvergütung;
- Zuschläge;
- Trinkgeld;
- Kostenerstattung;
- Kombinationen.

Vergütung und Erfahrung bleiben getrennt.

## 14.38 Herkunft der Vergütung

Mögliche Zahler:

- Arbeitgeberkonto;
- Kundenkonto;
- Auftraggeberunternehmen;
- Staatskonto;
- kommunales Jobbudget;
- Vertragstreuhand;
- kontrolliertes Einstiegsjobkonto;

Vor Beginn eines vergüteten Jobs muss eine zulässige Zahlungsquelle vorhanden sein. Ein ausdrücklich unbezahltes Ehrenamt oder Training benötigt eine entsprechende sichtbare Definition statt einer scheinbaren Vergütung.

Systemfinanzierte Jobs besitzen:

- Budgetperiode;
- Mengen- oder Zeitlimit;
- transparente Grundlogik;
- niedrigere Marktverzerrung;
- Auditierung;
- keine unbegrenzte Auszahlung.

## 14.39 Vergütungsmomentaufnahme

Bei Annahme werden gespeichert:

- Vergütungsmodell und Version;
- feste Bestandteile;
- variable Formeln;
- Mindest- und Höchstbetrag;
- Kostenverteilung;
- Steuerregel;
- Teamaufteilung;
- Bonus- und Abzugskriterien;
- reserviertes Budget.

Variable Werte wie tatsächlich gelieferte Menge oder genehmigte Arbeitszeit werden beim Abschluss aus Serverdaten eingesetzt.

Eine spätere Preisänderung verändert den bereits angenommenen Job nicht rückwirkend.

## 14.40 Abrechnung

Vor Abrechnung prüft der Server:

1. Zuweisung und Aktivitätsstatus;
2. bestätigte Meilensteine;
3. fachliche Ergebnisse;
4. Teilnehmerbeiträge;
5. genehmigte Arbeitszeit;
6. Schäden, Verluste und Kosten;
7. Abnahme;
8. reserviertes Budget;
9. Steuern und Abzüge;
10. bereits erfolgte Teilzahlungen.

Anschließend werden zusammengehörig gebucht:

- Teilnehmervergütungen;
- Arbeitgeber- oder Auftragnehmerumsatz;
- Steuern;
- Gebühren;
- Kostenerstattungen;
- Rückgabe freier Reservierungen;
- offene Forderungen bei definiertem Zahlungsausfall;
- Erfahrung und Ruf nach erfolgreicher Fachbestätigung.

Dieselbe Abrechnungs-UUID wird nur einmal gebucht.

## 14.41 Teilzahlungen und Meilensteine

Lang laufende Jobs können definierte Meilensteine abrechnen.

Ein Meilenstein enthält:

- erwartetes Ergebnis;
- fachlichen Prüfer;
- Betrag oder Anteil;
- Teilnehmerzuordnung;
- Fälligkeit;
- Abnahmeregel;
- Rückforderungs- oder Korrekturregel.

Eine Teilzahlung wird nicht gelöscht, wenn der spätere Auftrag scheitert. Korrekturen erfolgen über Forderung, Gegenbuchung oder vertragliche Regel.

## 14.42 Trinkgeld und Kostenerstattung

Trinkgeld:

- ist freiwillig;
- stammt vom Kunden;
- wird separat gebucht;
- beeinflusst nicht automatisch die fachliche Abnahme;
- besitzt Spam- und Betragsgrenzen.

Kostenerstattung kann gelten für:

- Kraftstoff;
- Maut oder Gebühr;
- Material;
- Ersatzteile;
- Fahrzeugmiete;
- genehmigte Fremdleistung.

Nur verknüpfte und erlaubte Ausgaben werden erstattet. Frei eingegebene Clientbeträge reichen nicht.

## 14.43 Lohnabrechnung und Auftragsvergütung

Auftragsvergütung und Lohn sind getrennt:

- Das Unternehmen erhält den Auftragserlös.
- Mitarbeiter erhalten Lohn, Provision oder vereinbarten Anteil.
- Ein selbstständiger Charakter oder Einzelbetrieb kann direkt Auftragnehmer sein.
- Öffentliche Dienstkräfte erhalten in der Regel Dienstlohn statt Geld pro Einsatz.

Ein Einsatz, eine Festnahme oder eine Behandlung erzeugt keine persönliche Geldprämie, sofern kein ausdrücklich geregelter Bonus existiert.

## 14.44 Abbruch vor Arbeitsbeginn

Vor Start kann ein Job abhängig von der Regel storniert werden.

Mögliche Folgen:

- vollständige Freigabe aller Reservierungen;
- geringe Stornogebühr;
- Verlust einer Buchungsgebühr;
- Angebotsrückkehr;
- kurzer Annahme-Cooldown bei wiederholtem Blockieren.

Es gibt keine Strafe für eine nicht angenommene öffentliche Jobanzeige.

## 14.45 Abbruch während der Arbeit

Bei kontrolliertem Abbruch werden:

- letzte bestätigte Schritte gespeichert;
- Waren und Assets gesichert;
- Fahrzeuge und Ausrüstung zurückgegeben oder neu zugewiesen;
- Teilnutzen geprüft;
- mögliche Teilvergütung berechnet;
- übriges Budget freigegeben;
- Auftraggeber informiert;
- Übergabe oder Ersatz ermöglicht.

Ein Job darf nicht nur deshalb volle Vergütung zahlen, weil der Spieler kurz vor dem Abschluss abbricht.

## 14.46 Scheitern, Pflichtverletzung und Streit

Mögliche Gründe:

- Zeitfenster erheblich verfehlt;
- Ware verloren;
- falsches Produkt;
- Fahrzeug zerstört;
- Kunde nicht erreichbar;
- Pflichtschritt nicht erfüllt;
- Lizenz oder Rolle verloren;
- technischer Fehler;
- Auftraggeber storniert unberechtigt.

Ergebnisse:

- Teilabschluss;
- keine weitere Vergütung;
- vertraglicher Abzug;
- Versicherungsfall;
- Forderung;
- Rufauswirkung;
- Streitfall;
- technische Prüfung.

Abzüge können nicht ohne Grenze ein negatives Bargeld- oder Bankguthaben erzeugen. Größere Ansprüche werden als Forderung geführt.

## 14.47 Disconnect und Wiederverbindung

Bei Disconnect:

- Arbeitssitzung wechselt in eine Gnadenphase;
- Aktivität und Reservierungen bleiben erhalten;
- Fahrzeug und Ware bleiben persistent;
- Team kann je nach Rolle fortsetzen;
- Ersatz kann nach Regel zugewiesen werden;
- Charakterwechsel bleibt bei kritischen Zuständen gesperrt;
- Wiederverbindung stellt zulässigen Zustand wieder her.

Nach Ablauf der Gnadenphase wird die Sitzung pausiert, kontrolliert beendet oder zur Übergabe freigegeben. Ein Netzwerkfehler erzeugt nicht automatisch eine Vertragsstrafe.

## 14.48 Neustartwiederherstellung

Nach Neustart:

- Angebote werden anhand Ablaufzeit neu bewertet;
- aktive Zuweisungen werden geladen;
- Reservierungen werden abgeglichen;
- bestätigte Schritte bleiben abgeschlossen;
- offene Schritte gehen in `recovery`;
- Fahrzeuge, Waren und Ausrüstung werden zugeordnet;
- Budgets bleiben reserviert;
- unklare Fälle gelangen in eine Prüfwarteschlange.

Eine Aktivität wird nicht pauschal als abgeschlossen markiert und nicht mit voller Vergütung ausgezahlt.

## 14.49 Fähigkeiten, Lizenzen, Ruf und Rang

Die vier Bereiche bleiben getrennt:

- Fähigkeit beschreibt praktische Erfahrung.
- Lizenz beschreibt rechtliche Erlaubnis.
- Ruf beschreibt Vertrauen einer Branche oder Organisation.
- Position oder Dienstgrad beschreibt organisatorische Berechtigung.

Beispiel:

Ein Charakter kann LKW-Logistik auf hohem Level besitzen, aber ohne Gefahrgutlizenz keinen Tanktrailerauftrag annehmen. Ein Polizeilevel ersetzt keine Einstellung und keinen Dienstgrad.

## 14.50 Erfahrungsvergabe

Erfahrung wird nach bestätigten Beitragsereignissen vergeben.

Faktoren:

- fachliche Schwierigkeit;
- tatsächlicher Beitrag;
- Qualität;
- Menge;
- sichere Durchführung;
- erstmals oder abwechslungsreich ausgeführte Aufgabe;
- Teamrolle;
- zulässige Dauer;
- Nachfrage.

Keine Erfahrung allein für:

- Einstempeln;
- Öffnen des Job-UIs;
- Starten eines Balkens;
- Mitfahren ohne Aufgabe;
- AFK-Wartezeit;
- wiederholtes Abbrechen;
- dieselbe Vorgangs-UUID.

## 14.51 Anti-AFK-Regeln

Das System bewertet fachliche Aktivität, nicht nur Tastendrücke.

Mögliche Signale:

- bestätigte Arbeitsschritte;
- serverseitige Warenbewegung;
- sinnvolle Positionsänderung;
- Fahrzeugbedienung;
- Maschineninteraktion;
- Kunden- oder Dispatchereignis;
- Berichts- oder Übergabehandlung.

Reine Bewegung im Kreis, dauerhaftes Sitzen im Fahrzeug oder automatisierte Eingaben gelten nicht als volle Arbeit.

Kurze Inaktivität führt zunächst zu Warnung, Pause oder Statusänderung. Sicherheitsflags werden protokolliert und nicht als unsichtbare sofortige Geldstrafe verwendet.

## 14.52 Anti-Farming-Regeln

Schutzmaßnahmen:

- eindeutige Vorgangs-UUID;
- Plausibilitätsgrenzen für Dauer, Strecke, Menge und Qualität;
- keine Auszahlung aus Clientwerten;
- Ziel- und Angebotsreservierungen;
- Wiederholungserkennung;
- reduzierte Erfahrung bei identischen Abläufen;
- Erkennung wiederkehrender künstlicher Kunden;
- Limits kontrollierter Systembudgets;
- kein mehrfacher Abschluss derselben Meilensteine;
- Abgleich von Waren-, Fahrzeug- und Geldbewegungen;
- Sicherheitsflags für ungewöhnliche Ertragsraten;
- weiche Fortschrittsgrenzen statt pauschaler Arbeitsverbote.

Wirtschaftliche Vergütung wird nicht allein wegen hoher Spielzeit heimlich reduziert. Wenn ein Marktbedarf weiterhin besteht, darf gearbeitet werden; Erfahrung kann dagegen weiche Grenzen besitzen.

## 14.53 Mehrfachjobs und Interessenkonflikte

Ein Charakter darf mehrere Arbeitsverhältnisse besitzen.

Standardregeln:

- höchstens eine aktive vergütete Schicht gleichzeitig;
- keine parallele Auftragsabrechnung derselben Arbeitszeit;
- kritische Dienstrollen können Nebenjobs während des Dienstes sperren;
- Firmenrollen bleiben außerhalb einer Schicht bestehen, soweit erlaubt;
- Zugriff auf Fahrzeuge, Lager und Daten folgt der aktiven Rolle;
- Interessenkonflikte können durch Organisation oder Vertrag eingeschränkt werden.

Ein Charakter kann beispielsweise Mechaniker und Taxifahrer sein, aber nicht dieselben Minuten gleichzeitig bei beiden Arbeitgebern abrechnen.

## 14.54 Solo- und Gruppenfairness

- Es gibt sinnvolle Solo-Einstiegsjobs.
- Gruppenjobs zahlen nicht automatisch jedem die volle Einzelvergütung.
- zusätzliche Teilnehmer sollen echten Durchsatz, Sicherheit oder Rollenvielfalt ermöglichen.
- notwendige Unterstützer erhalten Beitrag.
- Teamgrößen besitzen Obergrenzen.
- Aufgaben skalieren nur innerhalb definierter Grenzen.
- ein Gruppenleiter kann Budget oder Beute nicht nachträglich allein umleiten.
- neue Spieler können Grundrollen übernehmen, ohne sofort Maximallevel zu benötigen.

## 14.55 Niedrige Spielerzahl und NPC-Fallback

Bei geringer Population können:

- kontrollierte Einstiegsjobs;
- NPC-Kunden;
- staatliche Grundaufträge;
- öffentliche Infrastruktur;
- begrenzte Systemnachfrage

verwendet werden.

Fallbacks sind:

- mengen- oder zeitbegrenzt;
- schlechter oder höchstens gleichwertig zu Spieleraufträgen;
- aus definierten Konten finanziert;
- nicht als Arbitrage nutzbar;
- dynamisch reduzierbar, sobald Spielerbedarf vorhanden ist.

## 14.56 Berufsfamilien

### Industrie und Rohstoffe

- Ölförderung;
- Raffinerie;
- Bergbau;
- Holz;
- Landwirtschaft;
- Fischerei;
- Recycling.

### Logistik und Lager

- LKW-Fahrer;
- Kraftstofflieferant;
- Lagerarbeiter;
- Gabelstaplerfahrer;
- Hafenarbeiter;
- Kurier;
- Disponent.

### Fahrzeuge und Dienstleistungen

- Mechaniker;
- Abschleppdienst;
- Fahrzeugtransport;
- Taxi;
- Bus;
- Mietfahrzeugservice;
- Sicherheitsdienst.

### Öffentlichkeit

- Polizei;
- Rettungsdienst;
- Feuerwehr;
- Justiz;
- Stadtverwaltung;
- Müllabfuhr;
- öffentlicher Nahverkehr.

### Wirtschaft und Gesellschaft

- Immobilienmakler;
- Anwalt;
- Journalist;
- Gastronomie;
- Handel;
- Veranstaltungsdienst.

## 14.57 Beispiel: Logistikauftrag

1. Ein Lager meldet Bedarf an einer Warenlieferung.
2. Ein Vertrag oder Marktplatzangebot erzeugt einen Transportjob.
3. Budget, Ware, Zielkapazität und Zeitfenster werden reserviert.
4. Ein Fahrer oder Team nimmt das Angebot an.
5. Fahrzeug und gegebenenfalls Trailer werden zugewiesen.
6. Ware wird durch `cnr_storage` und `cnr_inventory` geladen.
7. `cnr_logistics` bestätigt Ladung, Strecke und Lieferzustand.
8. Ziel prüft Menge und Qualität.
9. Auftrag und Aktivität werden abgeschlossen.
10. Unternehmen, Fahrer, Steuern, Kosten, Erfahrung und Ruf werden abgerechnet.

## 14.58 Beispiel: Mechaniker und Abschleppdienst

1. Spieler oder Fahrzeugzustand erzeugt eine Serviceanfrage.
2. Preisregel oder Angebot wird bestätigt.
3. Abschlepp- oder Mechanikerbetrieb nimmt an.
4. Mitarbeiter, Fahrzeug und Werkzeug werden zugewiesen.
5. Fahrzeug wird gesichert, transportiert oder diagnostiziert.
6. Ersatzteile werden aus einem realen Lager reserviert und verbaut.
7. `cnr_vehicles` bestätigt die Zustandsänderung.
8. Kunde oder objektive Prüfung nimmt die Leistung ab.
9. Zahlung, Materialverbrauch, Lohn und Ruf werden gebucht.

## 14.59 Beispiel: Müll und Recycling

1. Müllbehälter sammeln serverseitig Bedarf.
2. Eine Route wird aus fälligen Behältern zusammengestellt.
3. Team, Müllfahrzeug und Zielanlage werden reserviert.
4. Behälter werden geleert und Mengen dem Fahrzeug zugeordnet.
5. Ladung wird zur Recycling- oder Entsorgungsanlage gebracht.
6. verwertbare Materialien, Restmüll und Gebühren werden fachlich gebucht.
7. Stadtauftrag und Teambeitrag werden abgerechnet.

Der Job erzeugt damit Rohstoffe oder Entsorgungsleistung für andere Systeme statt nur eine Markerbelohnung.

## 14.60 Beispiel: Taxi und Bus

Taxi:

- Spieler- oder NPC-Anfrage;
- Abholort und Ziel;
- geschätzter Preis oder Taxameterregel;
- Fahrerannahme;
- serverseitig bestätigte Fahrt;
- Warte- und Stornoregel;
- Zahlung und optionales Trinkgeld.

Bus:

- veröffentlichter Fahrplan;
- Fahrzeug- und Fahrerzuweisung;
- Haltestellenfolge;
- Zeitfenster statt sekundengenauer Zwang;
- Fahrgast- oder Grundversorgungsnachweis;
- staatliche oder betriebliche Vergütung.

Unnötige Umwege erhöhen nicht beliebig die Vergütung.

## 14.61 Beispiel: Öffentlicher Dienst

1. Charakter beginnt eine berechtigte Dienstsitzung.
2. Einheit, Rolle, Fahrzeug und Ausrüstung werden zugewiesen.
3. Dispatch erzeugt einen passenden Einsatz.
4. Einheit übernimmt und bearbeitet ihn im Fachmodul.
5. relevante Maßnahmen und Beiträge werden bestätigt.
6. Einsatz wird übergeben oder abgeschlossen.
7. erforderlicher Bericht wird eingereicht.
8. Dienstzeit, Ausrüstung und Arbeitsstatus werden aktualisiert.
9. reguläre Lohnabrechnung erfolgt aus dem Organisationskonto.

Es gibt keine persönliche Prämie allein für Festnahme, Behandlung oder Tötung.

## 14.62 Dynamischer Job-Editor

Administratoren können als Entwurf erstellen:

- Jobdefinition;
- Angebotsquelle;
- Aktivitätsdefinition;
- Arbeitsschritte;
- Abhängigkeiten und Alternativen;
- Rollen;
- Anforderungen;
- Start-, Arbeits- und Zielbereiche;
- Assetanforderungen;
- Vergütungsmodelle;
- Budgetgrenzen;
- Cooldowns;
- Qualitätsregeln;
- Wiederaufnahmeverhalten;
- Metriken.

Fachmodule registrieren erlaubte Fähigkeiten und Schritttypen. Der Editor kann keine beliebigen Serverfunktionen oder SQL-Anweisungen ausführen.

## 14.63 Validierung vor Veröffentlichung

Geprüft werden:

- eindeutige UUIDs und Codes;
- gültige Fachmodule;
- erreichbare Schritte;
- mindestens ein Abschluss- und Fehlerpfad;
- keine zyklischen Pflichtabhängigkeiten;
- gültige Rollen und Teilnehmerzahlen;
- zulässige Orte und Routing Buckets;
- definierte Budgetquelle;
- Vergütungsobergrenzen;
- vorhandene Assets und Produkte;
- Rückgabe- und Abbruchregeln;
- fachliche Prüfer;
- Cooldowns und Angebotslimits;
- Übersetzungen;
- Audit- und Metrikzuordnung.

Fehlerhafte Definitionen bleiben Entwürfe.

## 14.64 Benutzeroberflächen

### Jobbörse

- verfügbare Angebote;
- Filter;
- Anforderungen;
- Vergütung;
- Zeitfenster;
- Gruppenrollen;
- Standortbereich;
- Bewerbung und Annahme.

### Arbeitsansicht

- aktiver Job;
- Rolle;
- nächste sinnvolle Aufgabe;
- Team;
- reservierte Assets;
- Fortschritt;
- Qualitätsstatus;
- mögliche Kosten;
- Pause, Übergabe oder Abbruch.

### Arbeitgeberansicht

- Bedarfe;
- Angebote;
- Bewerber;
- Zuweisungen;
- Mitarbeiterstatus;
- Fahrzeuge und Ausrüstung;
- Budgets;
- Abnahme;
- ausstehende Abrechnungen;
- Auffälligkeiten.

### Dienstansicht

- Dienststatus;
- Einheit;
- Rolle;
- Dispatch;
- ausgegebene Ausrüstung;
- offene Berichte;
- Schichtende.

Alle UIs zeigen nur serverseitig freigegebene Daten.

## 14.65 Geplante Datenbanktabellen

- `cnr_job_definitions`
- `cnr_job_definition_versions`
- `cnr_job_roles`
- `cnr_job_requirements`
- `cnr_job_offers`
- `cnr_job_offer_visibility`
- `cnr_job_assignments`
- `cnr_job_assignment_members`
- `cnr_job_assignment_reservations`
- `cnr_activity_definitions`
- `cnr_activity_definition_versions`
- `cnr_activity_steps`
- `cnr_activity_step_dependencies`
- `cnr_activity_instances`
- `cnr_activity_participants`
- `cnr_activity_step_events`
- `cnr_activity_contributions`
- `cnr_job_equipment_checkouts`
- `cnr_job_vehicle_assignments`
- `cnr_job_milestones`
- `cnr_job_expenses`
- `cnr_job_settlements`
- `cnr_job_settlement_items`
- `cnr_job_performance_records`
- `cnr_job_cooldowns`
- `cnr_job_demand_signals`
- `cnr_service_requests`
- `cnr_job_disputes`
- `cnr_job_recovery_queue`

Wiederverwendet werden:

- `cnr_work_sessions`;
- `cnr_employment_contracts`;
- `cnr_orders`;
- `cnr_order_assignments`;
- `cnr_payroll_runs`;
- Bank-, Inventar-, Fahrzeug-, Lager-, Vertrags- und Fortschrittstabellen.

## 14.66 Serverautorisierte Regeln

- Kein Client erstellt sich selbst ein gültiges Jobangebot.
- Kein Client bestimmt Abschluss, Menge, Qualität, Zeit oder Vergütung.
- Jobdefinitionen und Aktivitäten sind versioniert.
- Annahme reserviert Budget und Pflichtassets atomar.
- Dieselbe Angebots-, Aktivitäts- oder Abrechnungs-UUID wird nur einmal verarbeitet.
- Fachmodule bestätigen echte Fachleistung.
- Arbeitszeit entsteht nicht allein aus Onlinezeit.
- Ein Charakter führt standardmäßig nur eine vergütete Schicht gleichzeitig.
- Jobzugriff überträgt kein Eigentum.
- Warenbewegungen erfolgen ausschließlich über Inventar und Lager.
- Fahrzeugzustände erfolgen ausschließlich über `cnr_vehicles`.
- Zahlungen erfolgen ausschließlich über `cnr_banking`.
- Erfahrung erfolgt ausschließlich über `cnr_progression`.
- Teamänderungen dürfen bestätigten Beitrag nicht löschen.
- Abbruch und Neustart geben Reservierungen nur kontrolliert frei.
- Korrekturen erzeugen Versionen, Gegenbuchungen oder Auditereignisse.

## 14.67 Kennzahlen und Qualitätssicherung

Aggregiert werden:

- veröffentlichte und angenommene Angebote;
- Zeit bis zur Besetzung;
- Abschluss-, Teil- und Abbruchquote;
- fachliche Ergebnisqualität;
- tatsächliche Dauer;
- Vergütung und Kosten;
- Beitrag pro Rolle;
- Nachfrage ohne Angebot;
- unbesetzte öffentliche Dienste;
- wiederholte Paarungen;
- auffällige Ertragsraten;
- Disconnect- und Recoveryquote;
- Streit- und Korrekturquote;
- Verhältnis von Spieler- zu Systemaufträgen.

Kennzahlen verbessern Balancing und Verfügbarkeit. Sie ersetzen keine individuelle automatische Schuldentscheidung.

## 14.68 Streitfälle und Korrekturen

Ein Streitfall kann enthalten:

- Zuweisung;
- Auftrag;
- Parteien;
- beanstandeten Meilenstein;
- fachliche Ergebnisse;
- Zahlungen;
- Waren- und Assetzustände;
- Kommunikation oder Bestätigungen;
- Begründung;
- Entscheidung und Korrekturen.

Objektiv bestätigte Waren- oder Zustandsbewegungen werden nicht gelöscht. Notwendige Korrekturen erfolgen über Gegenbuchungen, Rückgaben, Forderungen oder neu bewertete Abnahme.

## 14.69 Job- und Aktivitäts-MVP

Im MVP enthalten:

- versionierte Job- und Aktivitätsdefinitionen;
- öffentliche, interne und direkte Angebote;
- Jobbörse;
- Anforderungen und Sichtbarkeit;
- Budget-, Waren-, Fahrzeug- und Zielreservierung;
- Solo- und Gruppenannahme;
- Rollen;
- lineare und einfache verzweigte Arbeitsschritte;
- Arbeitssitzung, Pause und aktive Arbeitszeit;
- Stunden-, Fest-, Meilenstein- und Provisionsvergütung;
- fachliche Beitragsereignisse;
- Teilabschluss und kontrollierter Abbruch;
- Ausrüstungsausgabe;
- Fahrzeugzuweisung;
- Spieler-Serviceanfragen;
- bedarfsbasierte Aufträge;
- kontrollierte Einstiegsjobs;
- Disconnect- und Neustartwiederherstellung;
- Erfahrung und Ruf nach Beitrag;
- Anti-AFK- und Anti-Farming-Signale;
- Arbeitgeber- und Dienstansichten;
- Job-Editor;
- Auditierung und Kennzahlen.

Erste integrierte Jobfamilien:

- Transport und Logistik;
- Öl- und Kraftstoffwirtschaft;
- Mechaniker und Abschleppdienst;
- Müll und Recycling;
- Taxi oder Bus;
- Polizeidienst als öffentlicher Referenzdienst.

## 14.70 Spätere Ausbaustufen

- komplexe Schichtplanung;
- Bewerbungsportal;
- Gewerkschaften und Tarifmodelle;
- umfangreiche Versicherungsfälle;
- vollwertige Spielerbewertungen mit Einspruch;
- dynamische Ausbildungsschulen;
- Zertifikatsprüfungen;
- umfangreiche NPC-Kundenprofile;
- komplexe Fahrpläne;
- Arbeitsvermittlung;
- branchenspezifische Saisonarbeit;
- tiefe Feuerwehr- und Rettungsdienstkarrieren;
- Journalismus- und Anwaltsworkflows;
- Veranstaltungsjobs;
- weitergehende Automatisierung von Disposition.

## 14.71 Erster legaler Referenzablauf

1. Eine Tankstelle unterschreitet ihren Diesel-Mindestbestand.
2. Das Fachmodul erzeugt ein Bedarfssignal.
3. Ein gültiger Vertrag oder Marktplatz erzeugt ein Transportangebot.
4. Zahlungsbudget, Dieselcharge und Zielkapazität werden reserviert.
5. Ein Fahrer nimmt den Job an.
6. Eignung, Schicht, Lizenz und Fahrzeug werden geprüft.
7. Zugmaschine und Tanktrailer werden zugewiesen oder gemietet.
8. Die Raffinerie belädt ein geeignetes Abteil.
9. Fachmodule bestätigen Menge, Qualität, Plombe und Zustand.
10. Der Fahrer transportiert die Ware ohne starre Zwangsroute.
11. Die Tankstelle nimmt Menge und Qualität ab.
12. Auftrag, Aktivität und Meilensteine werden abgeschlossen.
13. Lieferant, Fahrer, Steuern, Miete und Kosten werden atomar abgerechnet.
14. Erfahrung und Ruf entstehen aus dem bestätigten Beitrag.
15. Dieselbestand ist anschließend tatsächlich für Tankvorgänge verfügbar.

## 14.72 Abnahmekriterien für das spätere Scripting

Das Job- und Aktivitäts-MVP gilt fachlich als funktionsfähig, wenn:

- dasselbe Modell einen einfachen Solojob und einen komplexen Gruppenauftrag abbildet;
- Anstellung, Schicht, Angebot, Auftrag und Aktivität getrennt bleiben;
- kein vergüteter Job ohne Zahlungsquelle veröffentlicht oder angenommen wird;
- Budget, Waren und Assets beim Annehmen widerspruchsfrei reserviert werden;
- ein Client weder Abschluss noch Vergütung bestimmen kann;
- tatsächlicher fachlicher Nutzen die Abrechnung auslöst;
- Stundenlohn keine reine Online- oder AFK-Zeit bezahlt;
- unterstützende Gruppenrollen nachvollziehbaren Beitrag erhalten;
- ein Teamleiter bereits geleisteten Beitrag nicht entfernen kann;
- Teilabschluss, Abbruch und Übergabe ohne Duplikation funktionieren;
- Disconnect und Neustart laufende Jobs wiederherstellen;
- dieselbe Abrechnung nicht doppelt ausgeführt werden kann;
- eigene, gemietete und gestellte Fahrzeuge korrekt zugeordnet werden;
- Spieleraufträge und kontrollierte Einstiegsjobs nebeneinander funktionieren;
- öffentliche Dienste Dienstlohn statt Prämienfarming verwenden;
- Jobdefinitionen ohne Codeänderung sicher konfiguriert werden können;
- Fachmodule weiterhin allein über Waren, Fahrzeuge, Anlagen und Einsätze entscheiden;
- der legale Referenzablauf eine vollständige Waren-, Vertrags-, Arbeits- und Geldspur besitzt.

---

# 15. Dynamische Administration

## 15.1 Ingame-Editor

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

## 15.2 Externes Control Panel

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

# 16. Einheitliches UI-System

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

# 17. Sicherheitsgrundsätze

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

# 18. Aktuelle verbindliche Entscheidungen

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
| Kriminellenstatus | entsteht durch Handlungen, Kontakte und Ruf, nicht durch einen globalen Job |
| Tatidentität | dauerhafte UUID und versionierte Definition, niemals Koordinate oder Netzwerk-ID |
| Tatgleichzeitigkeit | Ziel und maximale Beute werden beim Start serverseitig reserviert |
| Polizeianforderung | nach Risikostufe und tatsächlich verfügbaren Dienstkräften |
| sinkende Polizeizahl | macht eine gültig gestartete Tat nicht rückwirkend ungültig |
| kleine Straftaten | bleiben auch bei geringer Polizeibesetzung grundsätzlich möglich |
| große Straftaten | benötigen eine angemessene reale Reaktionsmöglichkeit |
| Polizeiwissen | entsteht aus Meldungen, Beobachtungen, Beweisen und freigegebenen Daten |
| interner Risikowert | dient Balancing und Unterwelt, ist kein sichtbarer Polizeistatus |
| Liveortung | nur mit Sichtkontakt, Sensor, Peilsender oder anderer tatsächlicher Quelle |
| Masken | verhindern automatische Namensanzeige, nicht unabhängige Spuren |
| Beute | physisch, herkunftsbezogen und aus einer definierten Quelle |
| Bankraub | belastet eine Filial- oder Versicherungsreserve, nicht einzelne Kundeneinlagen |
| Markiertes Geld | behält Charge, Herkunft und Risiko auch nach Aufteilung |
| Kills | keine direkte Belohnungs- oder Hauptfortschrittsquelle |
| Spielerdurchsuchung | nur in gültigem Konfliktkontext und auf mitgeführte Gegenstände begrenzt |
| Offline-Einbruch | private Vollplünderung standardmäßig ausgeschlossen |
| Crime-Disconnect | kritischer Zustand, Beute und Tatbezug bleiben persistent |
| Polizeiberichte | nach Einreichung versioniert oder ergänzt, nicht still überschrieben |
| Beweise | serverseitig aus Aktionen mit vollständiger Beweiskette |
| unbekannte Profile | bleiben ohne zulässigen Vergleich unbekannt |
| Durchsuchungsbeschluss | zeitlich, sachlich und auf ein konkretes Ziel begrenzt |
| Beschlagnahmung | bewegt ein Asset in Verwahrung und erzeugt keine Kopie |
| Polizeivergütung | Gehalt statt Kopfprämie pro Festnahme oder Tötung |
| Haft | persistentes Hybridmodell aus aktivem und möglichem Offline-Anteil |
| Jobbegriffe | Anstellung, Schicht, Angebot, Auftrag, Aktivität und Arbeitsschritt bleiben getrennt |
| Jobidentität | dauerhafte UUID und versionierte Definition |
| Fachleistung | wird vom zuständigen Fachmodul und nicht vom Job-UI bestätigt |
| Jobannahme | reserviert Budget, Teilnehmerplatz und notwendige Assets atomar |
| Vergütungsquelle | Unternehmen, Kunde, Staat oder begrenztes kontrolliertes Systemkonto |
| Vergütungsmomentaufnahme | Modell und Grenzen werden bei Annahme versioniert gespeichert |
| aktive Schichten | standardmäßig höchstens eine vergütete Schicht pro Charakter |
| Arbeitszeit | entsteht aus plausibler Tätigkeit, nicht allein aus Onlinezeit |
| Gruppenbeitrag | Erfahrung und variable Anteile folgen bestätigten Beiträgen |
| Teamleitung | kann bereits bestätigten Beitrag nicht nachträglich entfernen |
| Jobfahrzeuge und Ausrüstung | zeitlich begrenzter Zugriff ohne Eigentumsübertragung |
| öffentliche Dienste | Dienstlohn statt persönlicher Prämie pro Einsatz |
| Einstiegsjobs | begrenztes Budget und keine unbegrenzte Systemgeldquelle |
| Jobabbruch | sichert Teilfortschritt und gibt Reservierungen kontrolliert frei |
| Job-Disconnect | Gnadenphase und Wiederaufnahme statt sofortigem Verlust |
| Job-Editor | nur registrierte Schritttypen und Fachprüfer, keine freien Serverskripte |
| Codesprache | Englisch |
| UI-Sprache | zunächst Deutsch, vollständig übersetzbar |

---

# 19. Planungsreife und Coding-Start

## 19.1 Aktueller Stand

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
- der vollständige Cops-&-Robbers-Lebenszyklus;
- Polizeidienst, Dispatch, Fahndung und Einsatzbearbeitung;
- Beweise, Fälle, Durchsuchungen, Beschlagnahmung, Festnahme und Haft;
- das allgemeine Job-, Schicht-, Aktivitäts- und Vergütungsmodell;
- grundlegende Admin-, UI- und Sicherheitsprinzipien.

Damit stehen die RP-, Economy-, Cops-&-Robbers- und Jobgrundlagen. Vor dem produktiven Coding fehlen noch der technische Implementierungsrahmen und ein verbindlicher MVP-Schnitt.

## 19.2 Noch notwendige Konzeptpakete vor dem Coding

### Abgeschlossen – Paket A: Cops-&-Robbers-Kern

Paket A ist mit Kapitel 13 abgeschlossen. Definiert sind:

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

### Abgeschlossen – Paket B: Allgemeines Job- und Aktivitätsmodell

Paket B ist mit Kapitel 14 abgeschlossen. Definiert sind:

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

## 19.3 Empfohlener Zeitpunkt für den Coding-Start

Der Coding-Start wird nach Abschluss der verbleibenden Konzeptpakete C und D empfohlen.

Danach muss nicht jedes spätere Feature vollständig geplant sein. Der Core kann beginnen, sobald:

- der MVP-Umfang verbindlich feststeht;
- der Cops-&-Robbers-Hauptablauf definiert ist;
- der technische Stack entschieden ist;
- Modulgrenzen und zentrale Datenverträge widerspruchsfrei sind;
- Sicherheits- und Transaktionsregeln feststehen;
- mindestens ein legaler und ein illegaler vertikaler Testablauf beschrieben sind.

Ab diesem Punkt kann die technische Basis umgesetzt werden, während spätere Branchen und Zusatzinhalte weiter geplant werden.

## 19.4 Empfohlene erste vertikale Abläufe

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

1. Zwei Spieler bereiten einen kleinen Ladenraub vor.
2. Der Server reserviert Ziel und maximale Beute.
3. Tataktionen erzeugen Alarm, Kamera- und Werkzeugspuren.
4. Dispatch weist Polizeieinheiten ohne automatische Täteridentität zu.
5. Die Täter fliehen mit physischer markierter Beute.
6. Polizei sichert Tatort und legt einen Fall an.
7. Beute wird gehehlt, gewaschen oder später beschlagnahmt.
8. Fahndung, Beschluss, Durchsuchung, Festnahme und Haft folgen nur aus dem tatsächlichen Verlauf.
9. Waren-, Beweis- und Geldspur bleibt vollständig nachvollziehbar.

## 19.5 Definition of Ready für das Repository

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

Als Nächstes wird Paket C, der technische Implementierungsrahmen, geplant. Festgelegt werden Sprache, NUI-Stack, Datenbankzugriff, Migrationen, Resource-Abhängigkeiten, APIs und Events, Konfiguration, Tests, Logging, Deployment, Backups und Entwicklungsumgebungen.
