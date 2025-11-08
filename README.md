# Dortmund Parking App
## Beschreibung
Dies ist eine einfache Flutter-Anwendung, die reale Daten zu Parkplätzen in Dortmund aus einem offenen API (https://open-data.dortmund.de) lädt. Sie zeigt eine Liste der Parkplätze mit Name, freien Plätzen, Kapazität, Auslastungsprozentsatz und Farbindikation (grün — viele Plätze, orange — mittel, rot — wenige).
- **Sprache der Benutzeroberfläche**: Deutsch.
- **Funktionen**:
  - Behandlung negativer Werte (API-Fehler) — Hinzufügen einer Notiz.
  - Verwendet Proxy zur Umgehung von CORS in der Web-Version.
  -  Schaltfläche zum Aktualisieren der Daten.
- **Technologien**: Flutter, Dart, http-Paket für API-Anfragen.
## Anforderungen
- Flutter SDK (Version 3.0+).
- Pakete: `http: ^1.2.0` (füge in `pubspec.yaml` unter `dependencies` hinzu).
- Für den Start im Web: `flutter run -d chrome`.
- Internet für API.
## Installation
1. Klone das Repository:
`git clone https://github.com/DeinBenutzername/dortmund-parking-app.git cd dortmund-parking-app`
2. Installiere Abhängigkeiten:
`flutter pub get`
3. Starte:
`flutter run -d chrome` # Für Web in Chrome
Oder `flutter run` für Emulator/Gerät.
## Funktionsweise
- **API**: Daten aus `https://open-data.dortmund.de/api/explore/v2.1/catalog/datasets/parkhauser/records?limit=100`.
- **Proxy**: `https://api.allorigins.win/get` zur Umgehung von CORS im Browser.
- **UI**: ListView mit Card und ListTile. Farben: >50% grün, >20% orange, sonst rot.
- **Fehlerbehandlung**: Wenn frei < 0, zeigen wir 0 und "(Datenfehler korrigiert)".
## Code-Struktur
- `main.dart`: Haupt-Datei.
- `MyApp`: Root-Widget.
- `ParkingScreen`: StatefulWidget mit Datenladen und UI.
- `loadData()`: Asynchrone Funktion für HTTP-Anfrage über Proxy, Parsing von JSON.
- `build()`: Scaffold mit AppBar, ListView.builder für Parkplätze, FloatingActionButton für Refresh.
## Bekannte Probleme
- API gibt manchmal negative frei (Überlauf oder Fehler) — behandelt.
- Im Web: Ohne Proxy kann CORS-Fehler auftreten.
- Kein Offline-Modus.
## Lizenz
MIT License. Frei verwenden und modifizieren.
## Autor
@steempooner.
