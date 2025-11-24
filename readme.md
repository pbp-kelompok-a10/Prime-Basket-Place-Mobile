# 🏀 **Prime Basket Place — Proyek Tengah Semester A10**

> Aplikasi jual beli alat-alat olahraga basket.

---

### 👥 **Anggota Kelompok**

| Nama | NPM |
|------|------|
| Rafsanjani | 2406495400 |
| Iqbal Rafi Nuryana | 2406417462 |
| Farras Syafiq Ulumuddin | 2406495722 |
| Z Arsy Alam Sin | 2406495836 |
| Michael Stephen Daniel Panjaitan | 2406496321 |

---

### 🧩 **Cerita dan Manffat**

**Prime Basket Place** merupakan sebuah aplikasi jual-beli yang dikhususkan untuk alat-alat olahraga basket.  
Disini para pencinta basket bisadatang untuk mempersiapkan dirinya menjadi Pro Player Basketball.  
Aplikasi ini menawarkan tempat untuk beragam alat-alat basket yang bisa dibeli ataupun dijual untuk pengguna ditambah dengan adanya fitur ulasan dan detail yang bisa memudahkan untuk pengguna memilih alat yang kualitas bagus. ☆

---

## 📦 **Daftar Modul**

---

### 🔐 **Account**
Dikerjakan oleh Iqbal Rafi Nuryana
🧠 **Deskripsi:**  
Modul Account berfungsi sebagai pusat identitas dan aktivitas pengguna di **Prime Basket Place**.  
Di dalam modul ini, pengguna dapat melakukan berbagai hal seperti mengelola profil pribadi, melihat riwayat transaksi pembelian maupun penjualan alat basket, serta memantau produk yang pernah mereka ulas atau sukai.  

⚙️ **Fitur Utama:**  
- Mengubah **profil dan password**.  
- Memperbarui **informasi profil**.  
- Melihat **status transaksi dan pengiriman** secara *real-time*.  
- Melihat **riwayat transaksi**, **produk yang diulas**, dan **produk yang disukai**.  
- Menghapus **Akun dari sisi pengguna atau admin** 

🔒 **Akses Pengguna:**  
- **User:** Akses penuh terhadap fitur personal.  
- **Guest:** Dialihkan ke halaman login.  
- **Admin:** Akses terbatas hanya untuk pengelolaan data pengguna.  

🧾 **CRUD:**
| Operasi | Deskripsi | Akses |
|----------|------------|--------|
| **Read** | Melihat data profil dan riwayat aktivitas | User, Admin |
| **Update** | Mengubah profil dan password | User |
| **Delete** | Mengubah profil dan password | User |
| **Create** | Menghapus akun pengguna dari sistem | User, Admin |

---

### 🏠 **Homepage**
Dikerjakan oleh Michael Stephen Daniel Panjaitan
🧠 **Deskripsi:**  
Aplikasi ini menampilkan halaman utama berisi produk-produk olahraga basket di toko.  
Antarmuka dilengkapi dengan fitur pencarian, pemfilteran, dan pengurutan produk agar pengguna dapat menemukan produk yang diinginkan.  
Terdapat pula fitur *slider* untuk menampilkan produk-produk populer, direkomendasikan, atau sedang diskon.  

⚙️ **Fitur Utama:**  
- 🔎 **Pencarian** produk berdasarkan nama atau penggalan nama.  
- 🧮 **Pemfilteran** produk berdasarkan jenis/kategori.  
- 📊 **Pengurutan** produk berdasarkan harga, popularitas, atau rating.  
- 🎞️ **Slider** menampilkan produk populer/diskon.  

🧾 **CRUD:**
| Operasi | Deskripsi | Akses |
|----------|------------|--------|
| **Read** | Menampilkan data produk di homepage | Guest, User, Admin |
| **Create** | Menambahkan slider promosi atau diskon produk | Admin |
| **Update** | Mengubah produk di dalam slider | Admin |
| **Delete** | Menghapus konten slider dan produk di homepage | Admin |

---

### 🧭 **Dashboard Product**
Dikerjakan oleh Farras Syafiq Ulumuddin
🧠 **Deskripsi:**  
Modul ini menyediakan fitur **CRUD (Create, Read, Update, Delete)** terhadap data produk yang dijual di **Prime Basket Place**.  
Objek yang diolah adalah **produk perlengkapan basket**.  
Setiap user yang berjualan hanya bisa mengelola produk miliknya sendiri karena data difilter berdasarkan *foreign key* yang merujuk ke *primary key* user.  

⚙️ **Fitur Utama:**  
- Menambah produk baru untuk dijual.  
- Melihat daftar produk milik sendiri.  
- Mengedit detail produk.  
- Menghapus produk yang tidak lagi dijual.  

🔒 **Akses Pengguna:**  
- **User:** CRUD penuh hanya untuk produk milik sendiri.  
- **Admin:** Hanya **Read** dan **Delete** tanpa filter.  
- **Guest:** Tidak dapat mengakses, akan diarahkan ke halaman login.  

🧾 **CRUD:**
| Operasi | Deskripsi | Akses |
|----------|------------|--------|
| **Create** | Menambahkan produk baru | User |
| **Read** | Melihat daftar produk | User, Admin |
| **Update** | Mengubah detail produk | User |
| **Delete** | Menghapus produk | User, Admin |

---

### ⭐ **Review Product**
Dikerjakan oleh Z Arsy Alam Sin
🧠 **Deskripsi:**  
Modul ini memungkinkan pengguna memberikan **ulasan (review)** terhadap produk di **Prime Basket Place**.  
Setiap review dapat berisi **rating bintang (1–5)**, **komentar**, dan **foto produk** (opsional).  
Hanya pengguna terdaftar yang bisa menulis review.  

⚙️ **Fitur Utama:**  
- Memberikan **penilaian** dan **komentar**.  
- Menampilkan **review** pengguna lain pada halaman produk.  
- Upload foto opsional sebagai bukti/ilustrasi produk.  

🔒 **Akses Pengguna:**  
- **User:** Dapat menulis review setelah login.  
- **Guest:** Harus login terlebih dahulu.  
- **Admin:** Tidak dapat membuat review.  

🧾 **CRUD:**
| Operasi | Deskripsi | Akses |
|----------|------------|--------|
| **Create** | Menulis review baru | User |
| **Read** | Melihat semua review produk | Semua |
| **Update** | Mengubah review milik sendiri | User |
| **Delete** | Menghapus review milik sendiri | User |

---

### 🧾 **Detail Product**
Dikerjakan oleh Rafsanjani
🧠 **Deskripsi:**  
Modul ini memuat informasi detail mengenai suatu produk basket.  
Terdapat **love button** untuk menandai produk favorit.  
Selain itu, template dari **Review App** ditampilkan di bagian bawah halaman detail produk.  

⚙️ **Fitur Utama:**  
- Menampilkan detail lengkap produk.  
- Tombol **Love/Favorite**.  
- Menampilkan review dari pengguna.  

🧾 **CRUD:**
| Operasi | Deskripsi | Akses |
|----------|------------|--------|
| **Read** | Menampilkan detail produk | Semua |
| **Create** | Membuat detail baru dari produk | User |
| **Update** | Memperbarui detail produk | User |
| **Delete** | Menghapus detail produk | User |

---

## 👥 **Role Pengguna Aplikasi**

| Role | Deskripsi |
|------|------------|
| 🕶️ **Guest** | Pengguna yang mengakses web **Prime Basket Place** tanpa autentikasi. |
| 🧍‍♂️ **User** | Pengguna yang dapat **menjual** dan **membeli** barang di **Prime Basket Place**. |
| 🧑‍💼 **Admin** | Pengguna yang dapat melakukan **manipulasi (delete)** terhadap *barang* yang tidak valid. |    

---

## Link Sumber Dataset

| Brand | Link |
|--------|------|
| 🏆 **Nike** | [https://www.nike.com/id/w/basketball-clothing](https://www.nike.com/id/w/basketball-clothing) |
| ⭐ **Adidas** | [https://www.adidas.co.id/en/Sports/basketball/clothing.html](https://www.adidas.co.id/en/Sports/basketball/clothing.html) |
| 💪 **Decathlon** | [https://www.decathlon.co.id/en-ID/c/team-sports/basketball/basketball-clothings.html](https://www.decathlon.co.id/en-ID/c/team-sports/basketball/basketball-clothings.html) |

---

## Link PWS
https://pbp.cs.ui.ac.id/rafsanjani41/primebasketplace

---

## Link Figma
https://www.figma.com/site/qtWBlM8sUzHF4jFFDC0jvx/PBP---Prime-Basket-Place?node-id=0-1&t=1CQRrw6bq1zIiLDh-1&view=settings

##  Alur Pengintegrasian

1. Setup Awal di Django:
    - Membuat `django-app authentication`
    - Menginstall `django-cors-headers` untuk menangani *Cross-Origin Resource Sharing*
    - Mengkonfigurasi `settings.py` untuk mengizinkan koneksi dari Flutter
    ```python
    CORS_ALLOW_ALL_ORIGINS = True
    CORS_ALLOW_CREDENTIALS = True
    CSRF_COOKIE_SECURE = True
    SESSION_COOKIE_SECURE = True
    ```
    - Menambahkan "10.0.2.2" ke `ALLOWED_HOSTS` untuk akses dari emulator Android

2. Membuat *Endpoint* API di Django:
    - Membuat `views` untuk `authentication` *(login/register)*
    - Membuat `views` untuk operasi CRUD
    - Mengatur *routing* URL untuk *endpoint* tersebut
    - Memastikan *endpoint* mengembalikan *response* dalam format JSON

3. *Setup* Flutter:
    - Menginstall `package pbp_django_auth` dan `provider`
    - Mengkonfigurasi `Provider` di `main.dart` untuk *state management*
    - Membuat model sesuai dengan struktur JSON dari Django

4. Alur Komunikasi:

    a. *Login*:

    - User memasukkan `credentials` di Flutter
    - Flutter mengirim POST *request* ke *endpoint* Django (`/auth/login/`)
    - Django memverifikasi dan mengembalikan *response*
    - Flutter menyimpan *session cookie* jika *login* berhasil

    b. Operasi CRUD:

    - Flutter mengirim *request* ke *endpoint* Django dengan *cookie session*
    - Django memverifikasi *session* dan mengeksekusi operasi
    - Django mengembalikan *response* JSON
    - Flutter memproses *response* dan *update* UI

5. Contoh *Flow Request:*
    ```text
    Flutter App -> HTTP Request -> Django Server
                                    |
                                Verify Session
                                    |
                            Process Request
                                    |
    Flutter App <- JSON Response <- Django Server
    ```

6. Format Komunikasi
    - *Request* dari Flutter:
        ```dart
        final response = await request.login(
            "http://your-url/auth/login/",
            {'username': username, 'password': password}
        );
        ```
    - *Response* dari Django:
        ```python
        return JsonResponse({
            "status": True,
            "message": "Login sukses!",
            "username": user.username
        })
        ```

7. Keamanan 
    - Menggunakan CSRF token untuk keamanan
    - Implementasi *session management*
    - Validasi input di kedua sisi (Flutter dan Django)
    - HTTPS untuk komunikasi yang aman (wajib untuk *production*)