<h1 align="center">🌋 Tremora</h1>

<p align="center">
  <b>Pantau gempa Indonesia, hampir secara real-time.</b><br>
  Aplikasi Flutter dengan data terbuka BMKG, peta gelap interaktif, animasi radar, dan mode offline.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3-0175C2?logo=dart&logoColor=white">
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white">
  <img alt="Data" src="https://img.shields.io/badge/Data-BMKG-E4002B">
</p>

> ⚠️ **Disclaimer:** Tremora adalah proyek belajar dan **bukan sistem peringatan dini resmi**. Untuk informasi gempa dan peringatan tsunami yang resmi, gunakan situs dan aplikasi [BMKG](https://www.bmkg.go.id).

---

## Tampilan Aplikasi

<table align="center">
  <tr>
    <td align="center"><img src="docs/screenshots/01-home.jpg" width="250"><br><sub><b>Gempa terbaru</b><br>Radar berdenyut sesuai kekuatan gempa</sub></td>
    <td align="center"><img src="docs/screenshots/02-map.jpg" width="250"><br><sub><b>Peta</b><br>Penanda berukuran dan berwarna sesuai magnitudo</sub></td>
    <td align="center"><img src="docs/screenshots/03-detail.jpg" width="250"><br><sub><b>Detail gempa</b><br>Waktu, kedalaman, potensi, dan shakemap</sub></td>
  </tr>
</table>

## Fitur

- 📡 **Gempa terbaru** dengan animasi radar yang berdenyut di sekitar angka magnitudo, warnanya mengikuti kekuatan gempa
- 🗺️ **Peta gelap** seluruh Indonesia dengan penanda interaktif (`flutter_map`)
- 📋 Daftar **gempa M 5.0+** dan **gempa yang dirasakan** masyarakat
- 🔍 **Detail gempa**: waktu WIB, koordinat, kedalaman, potensi tsunami, dan peta guncangan (shakemap)
- 💾 **Mode offline**: data terakhir tersimpan dan tetap tampil tanpa internet
- 🔄 Tarik layar untuk menyegarkan data
- 🌙 Tema gelap dengan skala warna magnitudo yang konsisten di daftar, radar, dan peta

## Sumber Data

Data gempa diambil dari [data terbuka BMKG](https://data.bmkg.go.id), tanpa API key:

| Endpoint | Isi |
|---|---|
| `autogempa.json` | 1 gempa terbaru |
| `gempaterkini.json` | 15 gempa M 5.0+ terkini |
| `gempadirasakan.json` | 15 gempa yang dirasakan masyarakat |

Semuanya berada di `https://data.bmkg.go.id/DataMKG/TEWS/`. Gambar shakemap dimuat dari `https://static.bmkg.go.id/`.

## Cara Kerja

### Tiga feed, satu permintaan paralel

Ketiga endpoint diambil bersamaan dengan `Future.wait`, jadi waktu muat sama dengan permintaan terlambat, bukan jumlah ketiganya.

```dart
final results = await Future.wait([
  _service.fetch('autogempa.json'),
  _service.fetch('gempaterkini.json'),
  _service.fetch('gempadirasakan.json'),
]);
```

### JSON yang tidak seragam

Pada `autogempa.json`, kunci `gempa` berisi **satu objek**, sedangkan dua file lainnya berisi **daftar**. Parser menyamakan keduanya, dan melewati satu data yang cacat tanpa menggagalkan seluruh daftar:

```dart
final items = data is List ? data : [data];
```

Semua nilai dari BMKG berupa teks (`"5.1"`, `"10 km"`, `"-6.08,106.97"`), jadi model `Quake` mengubahnya menjadi angka dan koordinat.

### Mode offline

Setiap respons yang berhasil disimpan di `shared_preferences`. Kalau jaringan gagal, aplikasi memakai salinan terakhir dan menampilkan penanda "Mode offline".

### Animasi radar

Tiga lingkaran memancar dari pusat dan memudar, masing-masing bergeser sepertiga siklus. Digambar dengan `CustomPainter` dan `AnimationController`:

```dart
final phase = (t + i / 3) % 1.0;
canvas.drawCircle(center, maxR * (0.35 + 0.65 * phase), paint);
```

### Arsitektur singkat

| Lapisan | Peran |
|---|---|
| `BmkgService` | Mengambil dan mengurai JSON, mengelola cache offline |
| `QuakeController` | State aplikasi (`ChangeNotifier`) |
| `ListenableBuilder` | UI yang menyesuaikan state tanpa library tambahan |
| `RadarPulse`, `MagnitudeBadge`, `QuakeTile` | Komponen UI yang dipakai ulang |

## Tech Stack

| Kebutuhan | Teknologi |
|---|---|
| Framework | Flutter, Dart |
| Jaringan | `http` |
| Penyimpanan lokal | `shared_preferences` |
| Peta | `flutter_map`, `latlong2` |
| Animasi | `CustomPainter`, `AnimationController` |
| State management | `ChangeNotifier`, `ListenableBuilder` |

## Struktur Proyek

```
lib/
├── main.dart
├── theme.dart
├── models/
│   └── quake.dart
├── services/
│   └── bmkg_service.dart
├── controllers/
│   └── quake_controller.dart
├── utils/
│   └── quake_utils.dart
├── widgets/
│   ├── radar_pulse.dart
│   ├── quake_tile.dart
│   ├── quake_detail.dart
│   └── state_views.dart
└── screens/
    ├── app_shell.dart
    ├── home_screen.dart
    ├── map_screen.dart
    └── felt_screen.dart
```

## Menjalankan Proyek

### Prasyarat

- Flutter SDK (stable)
- Android SDK, cukup lewat command-line tools tanpa Android Studio
- JDK 17 atau 21
- Perangkat Android (USB debugging aktif) atau emulator

### Langkah

```bash
git clone https://github.com/USERNAME/tremora.git
cd tremora
flutter pub get
flutter run
```

Tidak perlu API key atau konfigurasi tambahan.

### Build APK

```bash
flutter build apk --release
```

Di Windows, skrip `build.ps1` membuat APK bernama `Tremora-vX.Y.Z.apk` (versi diambil dari `pubspec.yaml`) dan langsung memasangnya ke perangkat yang tersambung:

```powershell
.\build.ps1
```


## Catatan Teknis

Beberapa keputusan yang diambil selama pengembangan:

- **Halaman dibuat saat dibuka, bukan lewat `IndexedStack`.** Dengan `IndexedStack`, peta tetap aktif di latar belakang dan navigasi antar-tab terasa macet. Semua data sudah ada di controller, jadi halaman tidak perlu dijaga tetap hidup.
- **`kotlin.incremental=false`** di `android/gradle.properties`. Proyek berada di drive berbeda dari cache Pub, sehingga kompilasi Kotlin inkremental gagal membuat jalur relatif antar-drive.
- **Tanpa `google_fonts`.** Versi 9 memindahkan tipe `TextTheme` ke paket `material_ui` yang tidak kompatibel dengan `package:flutter/material.dart`, jadi aplikasi memakai font bawaan.
- **`flutter_map` dipatok ke `^8.3.1`** agar API `Marker` dan `MapOptions` tetap sesuai.

## Rencana Pengembangan

- [x] Gempa terbaru, M 5.0+, dan dirasakan
- [x] Peta interaktif dengan penanda per magnitudo
- [x] Mode offline
- [ ] Filter magnitudo di peta
- [ ] Jarak gempa dari lokasi pengguna
- [ ] Auto-refresh berkala
- [ ] Notifikasi gempa besar

## Kredit dan Atribusi

- Data gempa bumi: [BMKG](https://data.bmkg.go.id)
- Peta: © [OpenStreetMap](https://www.openstreetmap.org/copyright) contributors, tile oleh [CARTO](https://carto.com/attributions)
- Paket [`flutter_map`](https://pub.dev/packages/flutter_map)

## Pembuat

Dibuat oleh **Arya Dwi Pangga Handoko**.
[GitHub](https://github.com/arydwpngga2)

---

<p align="center"><sub>Dibuat dengan Flutter 💙 · Bukan sistem peringatan dini resmi</sub></p>