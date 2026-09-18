# Sistem Manajemen Permintaan Cuti

[English](../README.md) | [தமிழ்](README_TA.md) | [हिन्दी](README_HI.md) | [简体中文](README_ZH.md) | Bahasa Indonesia

Sistem Manajemen Permintaan Cuti berbasis Salesforce untuk mengelola permintaan cuti dosen dan mahasiswa.

Proyek ini menunjukkan penggunaan otomatisasi deklaratif Salesforce, pengembangan Apex, integrasi REST API, laporan, dasbor, dan perancangan aplikasi Lightning.

## Gambaran Umum

Sistem ini memungkinkan pengguna untuk membuat dan mengelola permintaan cuti, sementara Salesforce secara otomatis menangani penentuan status awal dan pengelompokan berdasarkan durasi cuti.

![screenshot](../img/image.png)

Proyek ini dikembangkan sebagai proyek pengembangan Salesforce praktis untuk menunjukkan kemampuan **Salesforce dengan sedikit atau tanpa kode** serta **pengembangan berbasis pemrograman menggunakan Apex**.

## Fitur

* Membuat dan mengelola permintaan cuti
* Secara otomatis menetapkan permintaan baru ke status `Pending`
* Mencegah persetujuan permintaan cuti yang melebihi 5 hari
* Mengelompokkan durasi cuti secara otomatis menggunakan Apex
* Mendukung pembuatan permintaan cuti melalui REST API
* Pengujian unit menggunakan Apex
* Laporan untuk memantau permintaan cuti
* Dasbor untuk menampilkan data permintaan cuti secara visual
* Aplikasi Lightning khusus untuk menyediakan akses terpusat ke sistem

## Teknologi yang Digunakan

| Teknologi             | Penggunaan                                  |
| --------------------- | ------------------------------------------- |
| Salesforce Platform   | Platform aplikasi                           |
| Lightning App Builder | Konfigurasi aplikasi dan antarmuka pengguna |
| Flow Builder          | Otomatisasi deklaratif                      |
| Validation Rules      | Validasi data                               |
| Apex                  | Logika bisnis khusus                        |
| Apex Triggers         | Pemrosesan berdasarkan kejadian             |
| Apex Test Classes     | Pengujian unit                              |
| Salesforce REST API   | Pembuatan data dari sistem eksternal        |
| Postman               | Pengujian API                               |
| Reports & Dashboards  | Analisis dan visualisasi data               |
| Salesforce CLI        | Pengelolaan metadata dan penerapan aplikasi |
| Git & GitHub          | Pengendalian versi                          |

## Arsitektur Sistem

```text
                         Salesforce Platform
                                │
               ┌────────────────┼────────────────┐
               │                │                │
               ▼                ▼                ▼
        Lightning App        REST API        Reports &
               │                │             Dashboard
               ▼                ▼
        Leave Request ────────────────────────┐
               │                               │
               ▼                               │
        Record-Triggered Flow                 │
        Status = Pending                       │
               │                               │
               ▼                               │
        Validation Rule                        │
        >5 days cannot be Approved             │
               │                               │
               ▼                               │
        Apex Trigger                           │
               │                               │
               ▼                               │
        LeaveRequestHandler                    │
        Duration Classification                │
               │                               │
               ▼                               │
        Leave Request Record ◄────────────────┘
```

## Model Data

Sistem ini saat ini menggunakan satu objek khusus Salesforce:

### Leave Request

**Objek:** `Leave_Request__c`

| Kolom             | Kegunaan                                |
| ----------------- | --------------------------------------- |
| Name              | Nama permintaan cuti                    |
| Applicant Name    | Orang yang mengajukan cuti              |
| Leave Type        | Jenis cuti                              |
| Number of Days    | Durasi cuti yang diminta                |
| Status            | Status permintaan saat ini              |
| Duration Category | Kategori durasi yang dihitung oleh Apex |

## Otomatisasi

### Record-Triggered Flow

Ketika sebuah rekaman Leave Request baru dibuat, Record-Triggered Flow secara otomatis menetapkan:

```text
Status = Pending
```

Dengan demikian, status awal setiap permintaan tetap konsisten tanpa mengharuskan pengguna atau sistem eksternal mengisi status secara manual.

### Validation Rule

Sistem mencegah permintaan cuti disetujui apabila durasi yang diminta melebihi lima hari.

```text
Number of Days > 5
AND
Status = Approved
```

Aturan bisnis ini tetap berlaku terlepas dari apakah perubahan dilakukan melalui antarmuka pengguna atau melalui operasi Salesforce lain yang didukung.

## Apex

### LeaveRequestHandler

Kelas Apex `LeaveRequestHandler` berisi logika untuk mengelompokkan permintaan cuti berdasarkan durasinya.

### LeaveRequestTrigger

`LeaveRequestTrigger` menjalankan `LeaveRequestHandler` ketika rekaman Leave Request diproses.

Trigger dan Handler dipisahkan agar logika bisnis tidak ditempatkan langsung di dalam Trigger.

### Pengujian

`LeaveRequestHandlerTest` berisi pengujian unit Apex untuk logika pengelompokan durasi cuti.

Kelas pengujian memastikan bahwa Handler menghasilkan kategori yang sesuai untuk berbagai durasi cuti.

## Integrasi REST API

Permintaan cuti dapat dibuat melalui Salesforce REST API.

Postman digunakan untuk melakukan autentikasi ke Salesforce dan menguji permintaan API.

Contoh isi permintaan:

```json
{
  "Name": "Sick and hospitalized",
  "Applicant_Name__c": "Test Student",
  "Leave_Type__c": "Medical",
  "Number_of_Days__c": 3
}
```

Kolom seperti `Status` dan `Duration_Category__c` sengaja tidak disertakan karena nilainya diisi oleh otomatisasi Salesforce.

Jika permintaan berhasil, Salesforce mengembalikan ID rekaman yang baru dibuat beserta respons yang menunjukkan bahwa pembuatan rekaman berhasil.

## Laporan dan Dasbor

Proyek ini memiliki beberapa laporan untuk memantau dan menganalisis permintaan cuti.

Laporan yang tersedia:

* Leave Request Overview
* Pending Leave Requests
* Leave Requests by Status
* Leave Requests by Leave Type
* Leave Requests by Duration
* New Leave Requests Report

### Leave Request Dashboard

Dasbor menyediakan tampilan terpusat untuk:

* Total permintaan cuti
* Permintaan berdasarkan status
* Permintaan berdasarkan jenis cuti
* Permintaan berdasarkan durasi
* Permintaan cuti yang masih menunggu

## Aplikasi Lightning

Proyek ini memiliki Aplikasi Lightning khusus:

**Leave Request Management**

Aplikasi menyediakan navigasi ke:

* Home
* Leave Requests
* Reports
* Dashboards

Halaman Home khusus menampilkan Leave Request Dashboard bersama tampilan daftar Leave Request, sehingga seluruh sistem dapat dipantau dari satu ruang kerja.

## Struktur Proyek

```text
force-app/
└── main/
    └── default/
        ├── applications/
        │   └── Leave_Request_Management.app-meta.xml
        │
        ├── classes/
        │   ├── LeaveRequestHandler.cls
        │   ├── LeaveRequestHandler.cls-meta.xml
        │   ├── LeaveRequestHandlerTest.cls
        │   └── LeaveRequestHandlerTest.cls-meta.xml
        │
        ├── dashboards/
        │   └── LeaveRequestDashboards.dashboardFolder-meta.xml
        │
        ├── flexipages/
        │   └── Home.flexipage-meta.xml
        │
        ├── objects/
        │   └── Leave_Request__c/
        │       ├── fields/
        │       ├── listViews/
        │       └── validationRules/
        │
        ├── reports/
        │   ├── LeaveRequestsReport.reportFolder-meta.xml
        │   └── LeaveRequestsReport/
        │
        └── triggers/
            ├── LeaveRequestTrigger.trigger
            └── LeaveRequestTrigger.trigger-meta.xml
```

## Penerapan

Proyek ini menggunakan struktur proyek Salesforce DX dan dapat dikelola menggunakan Salesforce CLI.

### Prasyarat

* Salesforce CLI
* Salesforce org dengan akses pengembangan yang sesuai
* Git

### Mengkloning Repository

```bash
git clone https://github.com/vk22006/leave-request-management-system.git
cd leave-request-management-system
```

### Melakukan Autentikasi ke Salesforce Org

```bash
sf org login web --alias LeaveRequestOrg
```

### Menentukan Org Tujuan

```bash
sf config set target-org=LeaveRequestOrg
```

### Menerapkan Source

```bash
sf project deploy start --source-dir force-app
```

## Pengujian

Pengujian Apex dapat dijalankan pada Salesforce org tujuan menggunakan Salesforce CLI.

Contoh:

```bash
sf apex run test --target-org LeaveRequestOrg --test-level RunLocalTests
```

## Pendekatan Pengembangan

Proyek ini menggunakan pemisahan tanggung jawab yang sederhana:

```text
Logika Deklaratif
    │
    ├── Flow
    └── Validation Rule

Logika Terprogram
    │
    ├── Apex Trigger
    ├── Apex Handler
    └── Apex Test Class

Integrasi
    │
    └── REST API + Postman

Penyajian
    │
    ├── Lightning App
    ├── Reports
    └── Dashboard
```

Implementasi ini menggunakan fitur deklaratif Salesforce ketika fitur tersebut sudah mencukupi. Apex digunakan ketika diperlukan pemrosesan khusus.

## Pengembangan di Masa Mendatang

Beberapa pengembangan yang dapat ditambahkan:

* Alur persetujuan untuk permintaan cuti
* Pemberitahuan melalui email atau di dalam aplikasi
* Pengendalian akses berdasarkan peran
* Analisis data tambahan
* Pemrosesan Bulk API untuk data dalam jumlah besar
* Penanganan kesalahan yang lebih baik untuk integrasi
* Cakupan pengujian otomatis tambahan
