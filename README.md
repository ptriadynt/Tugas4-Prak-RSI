# Sistem Review Kantin — Frontend & Backend Integration (Tugas 4)

Aplikasi web modern berbasis **React + TypeScript (Vite)** yang terhubung penuh ke backend **Express.js (REST API)** dan basis data **Microsoft SQL Server**. Fokus utama sistem ini adalah integrasi frontend ↔ backend untuk pengelolaan data warung kantin (CRUD Stalls) serta autentikasi berbasis role (Public, Customer, Owner, Admin) menggunakan JWT dengan antarmuka bertema Maroon elegan sesuai PRD.

---

## 🚀 Fitur Utama & Matriks Hak Akses

| Fitur / Aksi | Public (Belum Login) | Customer | Owner | Admin |
| :--- | :---: | :---: | :---: | :---: |
| **Lihat Daftar & Detail Warung** | ✅ | ✅ | ✅ | ✅ |
| **Pencarian, Filter & Pagination** | ✅ | ✅ | ✅ | ✅ |
| **Registrasi & Login Akun** | ✅ | — | — | — |
| **Katalog Menu Lengkap & Harga (Rp)** | ✅ | ✅ | ✅ | ✅ |
| **Simpan Warung Favorit (`/favorites`)** | ❌ | ✅ | ✅ | ✅ |
| **Cek Profil Aktif (`/auth/me`)** | ❌ | ✅ | ✅ | ✅ |
| **Tambah Warung Baru** | ❌ | ❌ *(Tampil Error 403)* | ✅ | ✅ |
| **Ubah Data Warung** | ❌ | ❌ | ✅ *(Hanya Milik Sendiri)* | ✅ *(Semua Warung)* |
| **Hapus Warung** | ❌ | ❌ | ❌ | ✅ *(Semua Warung)* |
| **Kelola Menu Makanan/Minuman** | ❌ | ❌ | ✅ *(Warung Miliknya)* | ✅ *(Semua Warung)* |
| **Dashboard Admin & Manajemen Role Pengguna** | ❌ | ❌ | ❌ | ✅ |

> **Catatan Keamanan & Integrasi:**
> - Backend adalah sumber kebenaran utama (*Single Source of Truth*). Jika ada request manipulasi yang dipaksa tanpa hak akses, backend akan mengembalikan status `401 Unauthorized` atau `403 Forbidden`.
> - Frontend menangani status `401` secara terpusat lewat Axios Interceptor (menghapus token dan mengarahkan ke halaman login) serta menampilkan halaman kartu penolakan akses `403 Forbidden` ([AccessDeniedCard.tsx](frontend/src/components/AccessDeniedCard.tsx)) dengan tombol maroon *"← Kembali ke Daftar Warung"* tanpa mengeluarkan sesi pengguna.
> - Setiap operasi tulis (Tambah, Ubah, Hapus) selalu memuat ulang data terbaru langsung dari backend (`GET /stalls`), bukan sekadar mengubah state lokal.

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: React 19 + TypeScript + Vite
- **Styling**: Pure Modern CSS / Design Tokens bertema Maroon (`#800020`, dark `#5C0016`, light `#F7E9EC`, gold `#C9A24B`), tipografi Google Fonts Poppins, rounded corners 12px, responsif desktop & mobile sesuai spesifikasi PRD Bagian 7.
- **Routing**: React Router DOM v7 (dengan `ProtectedRoute` untuk perlindungan rute dan validasi role).
- **HTTP Client**: Axios (dengan Interceptor terpusat untuk header `Authorization: Bearer <token>`, refresh sesi, penanganan error 401/403, dan formatting pesan error dari backend).
- **State Management**: React Context (`AuthContext` untuk autentikasi global & role permission).
- **Icons**: Lucide React.

### Backend
- **Runtime**: Node.js + Express.js (TypeScript via TSX)
- **Database**: Microsoft SQL Server (MSSQL)
- **ORM / Query Builder**: Drizzle ORM & `mssql` driver
- **Auth & Security**: JSON Web Token (JWT), BcryptJS password hashing, CORS middleware
- **Validasi**: Zod Schema & Centralized Error Handling Middleware
- **Dokumentasi API**: Swagger UI / OpenAPI 3.0 (`http://localhost:3000/docs`)

---

## 📁 Struktur Proyek

Backend dan Frontend telah diorganisasikan secara rapi dalam foldernya masing-masing:

```text
tugass-3/
├── backend/                  # Source code Backend Express.js & SQL Server
│   ├── src/
│   │   ├── config/database.ts# Koneksi MSSQL pool
│   │   ├── controllers/      # Controller stall, auth, user, menu
│   │   ├── db/               # Drizzle schema
│   │   ├── docs/             # OpenAPI 3.0 specification / Swagger
│   │   ├── dtos/             # Data Transfer Object interfaces
│   │   ├── errors/           # Custom AppError, 401, 403, 404, validasi
│   │   ├── middlewares/      # Auth JWT, role authorization, errorHandler
│   │   ├── repositories/     # Akses query database Drizzle ORM
│   │   ├── routes/           # Routing stallRouter, authRouter, userRouter, menuRouter
│   │   ├── schemas/          # Zod validation schemas
│   │   ├── services/         # Business logic & JWT token service
│   │   └── index.ts          # Entry point backend server (CORS & routing)
│   ├── db/                   # Skrip SQL Server (schema & seed)
│   ├── .env                  # Environment variable backend (MSSQL & JWT)
│   ├── .env.example          # Template environment variable backend
│   ├── package.json          # Backend dependencies & scripts
│   ├── tsconfig.json         # Konfigurasi TypeScript backend
│   └── README.md
│
├── frontend/                 # Source code Frontend React + TypeScript + Vite
│   ├── src/
│   │   ├── api/              # Axios client & service API (auth, stalls)
│   │   ├── components/       # Navbar, Footer, AccessDeniedCard (403), DeleteModal, Loading, EmptyState
│   │   ├── context/          # AuthContext (global state otentikasi & role)
│   │   ├── pages/            # StallListPage, StallDetailPage, StallFormPage, StallMenusPage, AdminDashboardPage, OwnerStallsPage, FavoritesPage, ProfilePage, LoginPage, RegisterPage
│   │   ├── types/            # TypeScript models & API response interfaces
│   │   ├── App.tsx           # Konfigurasi routing & protected routes
│   │   ├── App.css           # Grid & layout styling
│   │   └── index.css         # Design tokens tema Maroon (#800020), Poppins
│   ├── .env                  # VITE_API_BASE_URL=http://localhost:3000
│   ├── .env.example          # Template environment variable frontend
│   ├── package.json          # Frontend dependencies
│   ├── tsconfig.json         # Konfigurasi TypeScript frontend
│   └── vite.config.ts        # Konfigurasi Vite & dev proxy
│
├── package.json              # Monorepo runner scripts (dev:backend, dev:frontend)
└── README.md
```

---

## ⚙️ Panduan Instalasi & Menjalankan Aplikasi

### 1. Prasyarat Sistem
- **Node.js** v18+ dan **npm**
- **Microsoft SQL Server** berjalan di `localhost:1433`

### 2. Konfigurasi Basis Data
Jalankan skrip yang tersedia di folder `backend/db/` (atau `db/`) pada SQL Server Management Studio (SSMS) atau `sqlcmd`:
1. `01-create-login-tugas2.sql` (membuat login database `salmaa`)
2. `02-schema.sql` (membuat tabel USERS, STALLS, MENU_ITEMS, REVIEWS, dll.)
3. `03-seed-full.sql` (mengisi data awal warung dan pengguna)

---

### 3. Menjalankan Backend

Anda dapat menjalankan backend langsung dari root atau masuk ke folder `backend`:

#### Cara 1: Dari Root Direktori (`tugass-3`)
```bash
npm run dev:backend
```

#### Cara 2: Dari Folder `backend`
1. Buka terminal dan masuk ke folder `backend`:
   ```bash
   cd backend
   ```
2. Pastikan file `.env` sudah sesuai dengan konfigurasi SQL Server Anda:
   ```env
   DB_SERVER=localhost
   DB_PORT=1433
   DB_USER=salmaa
   DB_PASSWORD=salmaa_Tugas2026!
   DB_NAME=review_kantin
   DB_ENCRYPT=false
   DB_TRUST_SERVER_CERTIFICATE=true

   JWT_SECRET=rahasia-praktikum-rsi-2026-minimal-32-karakter
   PORT=3000
   ```
3. Install dependensi (jika belum):
   ```bash
   npm install
   ```
4. Jalankan backend server:
   ```bash
   npm run dev
   ```
   - Server berjalan di: `http://localhost:3000`
   - Dokumentasi Swagger UI: `http://localhost:3000/docs`
   - Cek kesehatan server & database: `http://localhost:3000/health`

---

### 4. Menjalankan Frontend

#### Cara 1: Dari Root Direktori (`tugass-3`)
Buka terminal baru pada root direktori:
```bash
npm run dev:frontend
```

#### Cara 2: Dari Folder `frontend`
1. Buka terminal baru dan masuk ke direktori `frontend`:
   ```bash
   cd frontend
   ```
2. Pastikan file `frontend/.env` terisi:
   ```env
   VITE_API_BASE_URL=http://localhost:3000
   ```
3. Install dependensi (jika belum):
   ```bash
   npm install
   ```
4. Jalankan frontend development server:
   ```bash
   npm run dev
   ```
5. Buka peramban (browser) di: `http://localhost:5173`

---

## 👥 Akun Uji Coba per Role (Testing Accounts)

Semua akun uji coba di bawah ini telah disiapkan di database SQL Server dan dapat langsung digunakan untuk pengujian:

| Role | Nama Pengguna | Email | Password | Catatan Hak Akses & Kepemilikan |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | Admin Kantin | `admin@kantin.test` | `admin123` | Akses penuh (Dashboard Admin `/admin`, kelola semua warung, ubah role pengguna via dropdown) |
| **Owner 1** | Bu Tini | `tini@kantin.test` | `rahasia123` | Pemilik resmi **Warung Bu Tini** (ID: 1). Dashboard `/owner/stalls`, kelola menu warung `/stalls/1/menus` |
| **Owner 2** | Pak Slamet | `slamet@kantin.test` | `rahasia123` | Pemilik resmi **Kedai Pak Slamet** (ID: 3). Dashboard `/owner/stalls`, kelola menu warung `/stalls/3/menus` |
| **Customer** | Bagas Pratama | `bagas@student.test` | `rahasia123` | Melihat katalog warung & menu, bookmark favorit (`/favorites`), **akses tambah warung ditolak (403)** |

> **Tips:** Pada halaman **Login**, tersedia tombol pintas (*Akun Uji Cepat*) yang otomatis mengisi kredensial masing-masing role untuk mempermudah demonstrasi dan perekaman skenario pengujian!

---

## 📋 Rencana & Bukti Pengujian Manual (12 Skenario)

| No | Skenario Pengujian | Langkah Pengujian | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| **1** | Buka halaman daftar warung | Akses `/stalls` sebagai Public (belum login). | Data warung tampil dinamis dari `GET /stalls`. Tersedia filter kategori, pencarian, dan pagination bertema maroon. |
| **2** | Buka detail warung | Klik tombol **Lihat Detail** pada salah satu warung (misal ID: 1). | Halaman detail memuat nama warung, lokasi, deskripsi, rating, ulasan, serta daftar menu lengkap dengan format harga Rupiah (`Rp`). |
| **3** | Admin: Tambah, Ubah, Hapus warung | Login sebagai `admin@kantin.test`, tambah warung baru, ubah datanya, lalu hapus. | Operasi `POST`, `PUT`, dan `DELETE` berhasil (`200/201`), data tersimpan di SQL Server, dialog konfirmasi hapus muncul dengan aman, dan daftar ter-refresh otomatis. |
| **4** | Owner membuat warung & mengubah miliknya | Login sebagai `tini@kantin.test`, buat warung baru dan ubah data **Warung Bu Tini**. | Warung baru berhasil dibuat dan warung miliknya berhasil diubah sesuai aturan otorisasi backend. |
| **5** | Owner mencoba mengubah warung owner lain | Login sebagai `tini@kantin.test`, coba buka `/stalls/3/edit` (milik Pak Slamet). | Tombol ubah tidak ada di UI; jika dipaksa lewat URL langsung, backend merespons `403 Forbidden` dan UI menampilkan pesan peringatan akses ditolak. |
| **6** | Owner mencoba menghapus warung | Login sebagai Owner (`tini@kantin.test`). | Tombol hapus tidak ditampilkan pada UI. Jika request `DELETE` dipaksa ke endpoint, backend menolak dengan `403 Forbidden`. |
| **7** | Registrasi dan Login | Buka `/register`, daftar akun baru (Customer), lalu login dengan akun tersebut. | Akun tersimpan di SQL Server dengan password ter-hash bcrypt, status login dan badge role tampil di navbar. |
| **8** | Cek pengguna aktif (`GET /auth/me`) | Refresh halaman browser setelah login. | Sesi login dipulihkan secara otomatis via `GET /auth/me`, nama dan badge role tetap aktif di navbar. |
| **9** | Akses fitur terlindungi sebelum login | Dalam kondisi Public (Logout), buka langsung URL `/stalls/new` atau `/owner/stalls`. | Pengguna otomatis dialihkan (*redirect*) ke `/login` dengan route guard dan notifikasi. |
| **10** | Penanganan respons 401 dan 403 | Customer mencoba membuka `/stalls/new` atau token kedaluwarsa. | Pada `401`, token dibersihkan dan dialihkan ke login; pada `403`, tampil kartu [AccessDeniedCard.tsx](frontend/src/components/AccessDeniedCard.tsx) bertema maroon (*"Kamu tidak punya izin untuk membuka halaman ini"*) tanpa mengeluarkan sesi pengguna. |
| **11** | Loading, Empty, dan Error State | Uji dengan pencarian kata kunci acak yang tidak ada, atau matikan backend sementara. | Muncul skeleton loader animasi saat memuat, ilustrasi *"Belum ada warung"* saat kosong, dan kartu error dengan tombol *"Coba Lagi"* saat backend mati. |
| **12** | Bukti request diproses backend | Buka tab *Inspect &rarr; Network* pada browser dan periksa tabel SQL Server. | Seluruh request HTTP mengirim header JSON/Bearer token, status code sesuai (`200`, `201`, `401`, `403`), dan seluruh data terverifikasi permanen di SQL Server. |
