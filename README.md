# Ditonton - Aplikasi Katalog Film & TV Series Siap Rilis

![CI Ditonton](https://github.com/mlkav/199-movies/actions/workflows/ci.yml/badge.svg)

Aplikasi katalog Film dan TV Series yang dikembangkan mengikuti arsitektur modular, state management BLoC, SSL Pinning, dan integrasi Firebase.

---
## Useful Commands
```agsl
flutter pub get
./test.sh
flutter test integration_test/app_test.dart
flutter run
```

## Arsitektur Proyek (Multi-Module Local Packages)
- `core/`: Komponen bersama (Network Client, SSL Pinning, Database Helper, Shared Styles, Constants, Failures)
- `movie/`: Modul Fitur Movie (Domain, Data, Presentation BLoCs, Pages, Widgets)
- `tv/`: Modul Fitur TV Series (Domain, Data, Presentation BLoCs, Pages, Widgets, Seasons & Episodes)
- `root/`: Modul Utama / App Entry Point (Main, Firebase, Dependency Injection)

## Fitur Utama
1. **Multi-module Architecture**: Aplikasi terpisah menjadi modul `core`, `movie`, dan `tv`.
2. **State Management BLoC**: Menggunakan `flutter_bloc` (`Bloc` / `Cubit`) untuk seluruh komponen UI.
3. **SSL Pinning**: Menerapkan SSL Certificate Pinning dengan `certificates.pem` untuk TMDB API.
4. **Firebase Analytics & Crashlytics**: Memantau statistik penggunaan dan pelaporan error secara real-time.
5. **Continuous Integration (CI)**: CI Workflow GitHub Actions menjalankan pengujian otomatis & verifikasi test coverage (>95%).
6. **Informasi Season & Episode**: Menampilkan daftar season dan jumlah episode secara detail pada halaman detail TV Series.

## Menjalankan Testing
Untuk menjalankan seluruh unit dan widget test beserta penggabungan laporan coverage:
```bash
./test.sh
```
