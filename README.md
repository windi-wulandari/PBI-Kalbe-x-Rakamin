
<div style="text-align: center;">
    <img src="https://drive.google.com/uc?id=1U1wuyUrpjtXeNOBdoy82TUqH6p0VBJiV" alt="My Image" />
</div>

---
---

# **Background**

Proyek ini merupakan tahap awal dari pengembangan **Sistem Manajemen Distribusi Produk** untuk PT Kalbe Nutritionals. Tujuan dari sistem ini adalah untuk menggantikan proses pencatatan manual yang sebelumnya dilakukan menggunakan spreadsheet, dengan software yang mampu mencatat dan melacak status pengiriman barang secara real-time dari gudang ke toko-toko. Dengan adanya sistem ini, diharapkan efisiensi operasional dan akurasi data pengiriman akan meningkat, sehingga meminimalkan kesalahan dan mempercepat proses distribusi. Berikut flow Pipeline dari proyek ini.

<div style="text-align: center;">
    <img src="https://drive.google.com/uc?id=1U1lcVcxfW6sP0z1ZMqMu8-ZHwSxptUHN" alt="My Image" />
</div>

---

# **Prerequisite**

Sebelum memulai proyek, silakan selesaikan langkah-langkah pre-requisite di bawah ini:

1. **Daftar ke Railway Cloud**  
   Daftar dan buat database di Railway untuk layanan cloud database [di sini](https://railway.app/).

2. **Install Lucidchart**  
   Gunakan Lucidchart untuk pembuatan ERD dengan notasi Chen [di sini](https://www.lucidchart.com).

3. **Install PostgreSQL**  
   Unduh dan install PostgreSQL [di sini](https://www.postgresql.org/download/).

4. **Install Ekstensi PgAgent**  
   Install ekstensi PgAgent untuk penjadwalan tugas di PostgreSQL.

5. **Install DBeaver**  
   Download dan install DBeaver [di sini](https://dbeaver.io/download/) atau [PgAdmin 4](https://www.pgadmin.org/download/) untuk mengelola database PostgreSQL Anda.

6. **Install SolarWinds Database Performance Analyzer (DPA)**  
   Untuk memonitor performa database, install SolarWinds DPA [di sini](https://www.solarwinds.com/database-performance-analyzer). Jika menggunakan Mac atau Docker, Anda bisa membangun dan menjalankannya melalui Docker [di sini](https://github.com/solarwinds/containers/tree/master/dpa).



---
# **Step by Step**
## **- Data Normalization**

Ini adalah data awal dalam format mentah yang akan digunakan untuk proses **normalisasi** dalam sistem manajemen distribusi produk. Berikut adalah **Data Dictionary** yang menjelaskan setiap kolom dalam dataset tersebut.

| No  | Column Name            | Description                                                                 |
|-----|------------------------|-----------------------------------------------------------------------------|
| 1   | **Product Name**        | Nama produk yang dikirim dari gudang ke toko tujuan.                         |
| 2   | **Qty**                 | Jumlah produk yang dikirim dalam satu pengiriman.                           |
| 3   | **Unit**                | Satuan produk yang digunakan (misal: unit, box, kg, dll.).                  |
| 4   | **Store Destination**   | Nama toko yang menjadi tujuan pengiriman produk.                            |
| 5   | **Store Address**       | Alamat lengkap dari toko tujuan pengiriman.                                 |
| 6   | **Operator**            | Nama operator yang bertanggung jawab atas proses pengiriman.                |
| 7   | **Shipping Vehicle**    | Kendaraan yang digunakan untuk mengirim produk.                             |
| 8   | **No Polisi**           | Nomor polisi kendaraan pengiriman.                                          |
| 9   | **Shipping Driver**     | Nama pengemudi yang bertanggung jawab atas pengiriman produk.               |
| 10  | **Shipping co-driver**  | Nama pendamping pengemudi (co-driver) yang terlibat dalam pengiriman.       |
| 11  | **Sending Time**        | Waktu ketika produk dikirim dari gudang.                                    |
| 12  | **Delivered Time**      | Waktu ketika produk sampai di toko tujuan.                                  |
| 13  | **Received By**         | Nama orang yang menerima produk di toko tujuan.                             |

Berikut data setelah normalisasi :

<div style="text-align: center;">
    <img src="https://drive.google.com/uc?id=1KTpWW5nK0UiF4SdkUNfFsLpq2r8RPNo2" alt="My Image" />
</div>

---

## **- Database Setup (Cloud)**

Berikut adalah langkah-langkah untuk menyiapkan database PostgreSQL di Railway, beserta contoh detail koneksi yang dapat digunakan di DBeaver dan SolarWinds:

1. **Daftar dan Masuk ke Railway**:
   - Kunjungi [Railway](https://railway.app/) dan buat akun jika belum memilikinya.
   - Setelah mendaftar, masuk ke akun Railway.

2. **Buat Proyek Baru**:
   - Klik tombol **"New Project"** untuk membuat proyek baru.

3. **Pilih Template**:
   - Pilih template **PostgreSQL** untuk membuat instance database PostgreSQL.

4. **Konfigurasi Database**:
   - Railway akan otomatis membuat instance PostgreSQL untuk Anda. Tunggu hingga proses selesai.

5. **Akses Database**:
   - Setelah database berhasil dibuat, Anda akan melihat informasi koneksi database Anda. Catat detail berikut ini:

   > Contoh informasi koneksi:
   >
   > **Connection String**:
   > ```
   > postgresql://postgres:aB3dEfG5hJkLqM@autorack.proxy.rlwy.net:23375/railway
   > ```
   > **Detail**:
   > - **Host**: autorack.proxy.rlwy.net
   > - **Port**: 23375
   > - **Database Name**: railway
   > - **Username**: postgres
   > - **Password**: aB3dEfG5hJkLqM

6. **Menghubungkan dengan DBeaver**:
   - Untuk menghubungkan ke database di DBeaver, pilih **"Database" > "New Database Connection"**.
   - Pilih **PostgreSQL** dan masukkan detail koneksi yang telah dicatat:
     - **Host**: autorack.proxy.rlwy.net
     - **Port**: 23375
     - **Database**: railway
     - **Username**: postgres
     - **Password**: aB3dEfG5hJkLqM
   - Klik **"Finish"** untuk menyimpan dan menghubungkan ke database.

   - Untuk SolarWinds DPA atau jika membutuhkan di PGAdmin, masukkan detail yang sama saat mengatur koneksi database di aplikasi.

---
## **- Created Schema**

```sql
-- Create Schema
CREATE SCHEMA app AUTHORIZATION postgres;
```

Perintah ini akan membuat schema baru dengan nama `app` yang diotorisasi oleh pengguna `postgres`. Setelah menjalankan perintah ini, schema siap digunakan untuk menyimpan objek-objek database seperti tabel dan fungsi. Selanjutnya, bisa dilanjutkan dengan langkah untuk mengimpor data.

---
## **- Import Data**

Berikut adalah langkah-langkah untuk mengimpor data dari spreadsheet ke database PostgreSQL menggunakan DBeaver. Dataset yang akan diimpor adalah contoh data yang sudah dinormalisasi, dan proses ini dilakukan di schema app yang telah dibuat sebelumnya. Dataset ini bukan merupakan data utuh, melainkan hanya contoh untuk tujuan pengujian.

1. **Persiapkan Dataset**:
   - Siapkan file spreadsheet (format CSV) yang berisi data yang telah dinormalisasi sesuai dengan struktur tabel di schema `app`.

2. **Buka DBeaver**:
   - Jalankan DBeaver dan sambungkan ke database PostgreSQL yang telah dibuat di Railway.

3. **Pilih Database dan Tabel**:
   - Temukan dan pilih database yang ingin digunakan di panel **Database Navigator**. Pada kasus ini Database yang digunakan adalah railway sesuai dengan connection string yang ada di Railway.
   - Jika tabel belum ada, buat tabel baru di schema `app` sesuai dengan struktur data di file CSV.

4. **Impor Data**:
   - Klik kanan pada tabel di schema `app` tempat data akan diimpor.
   - Pilih **"Import Data"**.

5. **Pilih Sumber Data**:
   - Di jendela yang muncul, pilih **"CSV"** sebagai sumber data dan klik **"Next"**.

6. **Pilih File CSV**:
   - Klik **"Browse"** untuk memilih file CSV yang telah disiapkan, kemudian klik **"Next"**.

7. **Mapping Kolom**:
   - Pastikan kolom dari file CSV sudah terpetakan dengan benar ke kolom di tabel. Sesuaikan mapping jika diperlukan.

8. **Pengaturan Impor**:
   - Setelah memastikan mapping kolom benar, klik **"Next"**. Anda dapat mengatur opsi tambahan, seperti pengabaian baris header.

9. **Mulai Impor**:
   - Klik **"Finish"** untuk memulai proses impor dan tunggu hingga proses selesai.

10. **Verifikasi Data**:
    - Setelah proses impor, buka tabel di DBeaver untuk memeriksa apakah data telah terimpor dengan benar.

---

## **- Created User**

```sql
-- Create a new user named 'windi' with a password
CREATE USER windi WITH PASSWORD 'your_secure_password';

-- Grant DML (SELECT, INSERT, UPDATE, DELETE) permissions on all tables in the 'app' schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA app TO windi;
```

Perintah di atas digunakan untuk membuat user baru bernama `windi` dan memberikan akses untuk melakukan operasi DML (SELECT, INSERT, UPDATE, DELETE) pada semua tabel di schema `app`.

---
## **- Created Index**

Index adalah struktur data yang digunakan untuk meningkatkan kecepatan pencarian dan pengambilan data dalam tabel database. Dengan menggunakan index, database dapat menemukan baris data dengan lebih cepat tanpa perlu melakukan scan seluruh tabel. Index berfungsi sebagai peta yang memudahkan akses ke data yang dicari.

```sql
-- Create an index on the product_name column of the product table in the app schema
CREATE INDEX idx_product_name ON app.product USING btree (product_name);
```

Perintah di atas membuat sebuah index dengan nama `idx_product_name` pada kolom `product_name` di tabel `product` yang berada dalam schema `app`. Index ini menggunakan metode pencarian btree, yang merupakan metode paling umum dan efektif untuk pencarian data yang terurut.

**Menambahkan Index Lainnya**

Selain membuat index pada kolom `product_name`, pengguna dapat membuat lebih banyak index sesuai dengan kebutuhan. Misalnya, jika ada kolom lain yang sering digunakan dalam pencarian, seperti `store_address` atau `operator`, maka index dapat dibuat pada kolom-kolom tersebut.

Penting untuk diingat bahwa meskipun index dapat meningkatkan kinerja query, terlalu banyak index dapat mempengaruhi waktu untuk melakukan operasi INSERT, UPDATE, dan DELETE karena database harus memperbarui index tersebut setiap kali data diubah. Oleh karena itu, perlu dilakukan analisis untuk menentukan kolom mana yang paling bermanfaat untuk diindeks.

---

## **- Created Function**

**Kode Fungsi**

```sql
CREATE OR REPLACE FUNCTION app.generator_kode_pengiriman()
RETURNS CHAR(8)
LANGUAGE plpgsql
AS $function$
DECLARE
    last_id INT;
    new_id CHAR(8);
BEGIN
    -- Mengambil nomor urut terakhir untuk tanggal yang sama
    SELECT COALESCE(MAX(CAST(SUBSTRING(kode_pengiriman FROM 7) AS INT)), 0)
    INTO last_id
    FROM app.shipment
    WHERE LEFT(kode_pengiriman, 6) = TO_CHAR(NOW(), 'YYMMDD');

    -- Membuat ID baru dengan format yymmddxxx
    new_id := TO_CHAR(NOW(), 'YYMMDD') || LPAD((last_id + 1)::TEXT, 3, '0');
    
    RETURN new_id;
END;
$function$;
```

1. **Tujuan Fungsi**: Fungsi ini dirancang untuk menghasilkan kode pengiriman baru yang unik berdasarkan tanggal saat ini. Format yang digunakan adalah `yymmddxxx`, di mana `yyyymmdd` adalah tanggal dalam format dua digit untuk tahun, bulan, dan hari, sedangkan `xxx` adalah nomor urut pengiriman untuk tanggal yang sama.

2. **Penggunaan PL/pgSQL**: Fungsi ditulis dalam bahasa PL/pgSQL, yang memungkinkan penggunaan logika pemrograman di dalam PostgreSQL.

3. **Deklarasi Variabel**:
   - `last_id`: Variabel untuk menyimpan nomor urut terakhir dari kode pengiriman yang telah ada.
   - `new_id`: Variabel untuk menyimpan kode pengiriman baru yang akan dihasilkan.

4. **Mengambil Nomor Urut Terakhir**:
   - Fungsi ini mengambil nilai maksimum dari nomor urut terakhir yang telah ada untuk tanggal yang sama dengan menggunakan `SUBSTRING` untuk mengambil bagian dari kode pengiriman setelah 6 karakter pertama (tanggal).
   - Fungsi `COALESCE` digunakan untuk mengembalikan 0 jika tidak ada kode pengiriman yang ditemukan untuk tanggal tersebut.

5. **Membuat ID Baru**:
   - Kode pengiriman baru dihasilkan dengan menggabungkan tanggal saat ini (dalam format `YYMMDD`) dan nomor urut yang telah ditambahkan 1, yang diformat menjadi tiga digit menggunakan `LPAD`.

6. **Mengembalikan Nilai**: Fungsi mengembalikan `new_id`, yaitu kode pengiriman yang baru saja dihasilkan.

Berikut adalah contoh penggunaan fungsi `generator_kode_pengiriman` yang telah dibuat sebelumnya. Contoh ini akan menunjukkan bagaimana cara memanggil fungsi dan hasil yang akan didapatkan.

**Contoh Penggunaan Fungsi**

1. **Membuat Kode Pengiriman**:
   - Untuk menghasilkan kode pengiriman baru, cukup memanggil fungsi ini menggunakan pernyataan SQL berikut:

   ```sql
   SELECT app.generator_kode_pengiriman() AS kode_pengiriman_baru;
   ```

2. **Contoh Hasil**:
   - Setelah menjalankan pernyataan di atas, hasilnya bisa berupa:

   ```
   kode_pengiriman_baru
   ----------------------
   240102001
   ```

   - Di mana `24` menunjukkan tahun 2024, `01` menunjukkan bulan Januari, `02` menunjukkan tanggal kedua, dan `001` adalah nomor urut pertama untuk pengiriman pada tanggal tersebut.

3. **Contoh Penggunaan dalam Tabel**:
   - Jika ingin menggunakan kode pengiriman baru ini saat memasukkan data ke dalam tabel `shipment`, bisa menggabungkan fungsi ini dalam pernyataan `INSERT` seperti berikut:

   ```sql
   INSERT INTO app.shipment (kode_pengiriman, product_name, qty, store_destination)
   VALUES (app.generator_kode_pengiriman(), 'Contoh Produk', 10, 'Toko A');
   ```

4. **Hasil**:
   - Dengan pernyataan di atas, saat data dimasukkan ke dalam tabel `shipment`, kolom `kode_pengiriman` akan terisi dengan kode pengiriman yang dihasilkan oleh fungsi. Misalnya, jika kode pengiriman yang dihasilkan adalah `240102001`, maka baris baru dalam tabel `shipment` akan terlihat seperti ini:

   ```
   | kode_pengiriman | product_name     | qty | store |
   |------------------|------------------|-----|--------------------|
   | 240102001        | Contoh Produk    | 10  | Toko A             |
   ```

- Dengan cara ini, setiap kali ada pengiriman baru, kode pengiriman yang unik dapat dihasilkan secara otomatis, sehingga mengurangi kemungkinan terjadinya duplikasi dan memastikan bahwa setiap pengiriman dapat dilacak dengan mudah berdasarkan tanggal dan nomor urutnya.

---

 ## **- Created Store Prosedur**

 Berikut adalah penjelasan tentang prosedur `create_new_shipment` yang telah dibuat. Prosedur ini berfungsi untuk menambahkan pengiriman baru ke dalam tabel `shipment` dengan menggunakan kode pengiriman yang dihasilkan oleh fungsi `generator_kode_pengiriman`.


```sql
CREATE OR REPLACE PROCEDURE app.create_new_shipment(
    IN product_id INT,
    IN store_id INT,
    IN sending_time TIMESTAMPTZ,
    IN driver_id INT,
    IN receiver VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    shipment_code CHAR(8);
BEGIN
    -- Mendapatkan kode pengiriman menggunakan fungsi yang telah dibuat
    shipment_code := app.generator_kode_pengiriman();

    -- Menyisipkan data ke dalam tabel shipment
    INSERT INTO app.shipment (product_id, store_id, sending_time, driver_id, co_driver_id, receiver, kode_pengiriman)
    VALUES (product_id, store_id, sending_time, driver_id, NULL, receiver, shipment_code);
END;
$$;
```

**Penjelasan**

1. **Parameter Input**:
   - **`product_id INT`**: ID produk yang akan dikirim.
   - **`store_id INT`**: ID toko tempat pengiriman dilakukan.
   - **`sending_time TIMESTAMPTZ`**: Waktu pengiriman.
   - **`driver_id INT`**: ID pengemudi yang mengantarkan pengiriman.
   - **`receiver VARCHAR`**: Nama penerima pengiriman.

2. **Deklarasi Variabel**:
   - **`shipment_code CHAR(8)`**: Variabel untuk menyimpan kode pengiriman yang dihasilkan.

3. **Mendapatkan Kode Pengiriman**:
   - Prosedur ini memanggil fungsi `app.generator_kode_pengiriman()` untuk mendapatkan kode pengiriman yang unik.

4. **Menyisipkan Data**:
   - Setelah mendapatkan kode pengiriman, data pengiriman baru disisipkan ke dalam tabel `app.shipment` dengan menyertakan semua parameter yang diterima dan kode pengiriman yang baru dibuat.

**Reversibilitas ke Fungsi**

Prosedur ini berfungsi beriringan dengan fungsi `generator_kode_pengiriman`. Ketika prosedur `create_new_shipment` dipanggil, ia akan menghasilkan kode pengiriman baru yang unik untuk setiap pengiriman. Prosedur ini memudahkan proses pembuatan pengiriman baru dengan mengelola beberapa input dan menyisipkan data ke dalam tabel secara otomatis.

**Contoh Pemanggilan Prosedur**

Untuk menggunakan prosedur ini, dapat memanggilnya seperti berikut:

```sql
CALL app.create_new_shipment(1, 1, NOW(), 1, 'Windi');
```

Pada contoh di atas, prosedur akan membuat pengiriman baru dengan `product_id` 1, `store_id` 1, waktu pengiriman saat ini, `driver_id` 1, dan penerima bernama "Windi". Kode pengiriman yang dihasilkan akan otomatis terisi dalam tabel `shipment`.

---

## **- Created Job Scheduling**

Sebelum membuat job scheduling, pastikan sudah menginstal ekstensi pgAgent di database PostgreSQL. Berikut langkah-langkah untuk melakukannya di pgAdmin:

**Menggunakan pgAgent Tanpa Coding**

1. **Buka pgAdmin**:
   - Jalankan pgAdmin dan sambungkan ke database PostgreSQL yang kamu gunakan.

2. **Navigasi ke pgAgent**:
   - Di sidebar, cari dan klik pada **pgAgent Jobs**.

3. **Buat Job Baru**:
   - Klik kanan pada **pgAgent Jobs** dan pilih **Create > Job**.
   - Isi informasi dasar seperti:
     - **Name**: Misalnya, `Daily Backup Job`.
     - **Description**: Deskripsi dari job, seperti `Backup database railway`.
     - **Enabled**: Centang untuk mengaktifkan job ini.
   
4. **Tambahkan Langkah (Step)**:
   - Setelah job dibuat, pilih tab **Steps** dan klik **Add**.
   - Isi nama langkah dan detail koneksi database serta perintah yang akan dieksekusi. Sebagai contoh, menggunakan perintah `pg_dump` untuk backup database.

5. **Atur Jadwal (Schedule)**:
   - Pilih tab **Schedules** dan klik **Add**.
   - Tentukan jadwal, misalnya setiap hari pada pukul 23:00.

6. **Simpan**:
   - Setelah semua informasi diisi, klik **Save** untuk menyimpan job.

Setelah mengikuti langkah-langkah di atas, job scheduling yang telah buat akan secara otomatis menjalankan backup sesuai jadwal yang ditentukan.

Berikut adalah contoh kode SQL yang akan dihasilkan dari langkah-langkah di atas:

```sql
DO $$
DECLARE
    jid integer;
    scid integer;
BEGIN
    -- Creating a new job
    INSERT INTO pgagent.pga_job(
        jobjclid, jobname, jobdesc, jobhostagent, jobenabled
    ) VALUES (
        1::integer, 'Daily Backup Job'::text, 'Backup database railway'::text, 'kalbe_railway.app'::text, true
    ) RETURNING jobid INTO jid;

    -- Steps
    INSERT INTO pgagent.pga_jobstep (
        jstjobid, jstname, jstenabled, jstkind,
        jstconnstr, jstdbname, jstonerror,
        jstcode, jstdesc
    ) VALUES (
        jid, 'Backup Railway Database'::text, true, 'b'::character(1),
        'host=kalbe_railway.app dbname=railway user=postgres password=<YOUR_PASSWORD>'::text,
        'railway'::name, 'f'::character(1),
        'pg_dump -d railway -U postgres -f /user/windi/backup_daily_railway.sql'::text,
        'Backup job for railway database'::text
    );

    -- Schedules
    INSERT INTO pgagent.pga_schedule(
        jscjobid, jscname, jscdesc, jscenabled,
        jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
    ) VALUES (
        jid, 'Daily Backup Schedule'::text, 'Schedule to run backup every day at 23:00'::text, true,
        '2023-10-28 23:00:00+07'::timestamp with time zone, NULL,
        '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
        '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,t}'::bool[]::boolean[],
        '{t,t,t,t,t,t,t}'::bool[]::boolean[],
        '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
        '{t,t,t,t,t,t,t,t,t,t,t,t}'::bool[]::boolean[]
    ) RETURNING jscid INTO scid;
END
$$;
```

**Catatan**
- Pastikan untuk mengganti `<YOUR_PASSWORD>` dengan password yang sesuai untuk koneksi database.
- Kode ini menjadwalkan job untuk melakukan backup otomatis, sehingga mempermudah manajemen database tanpa intervensi manual setiap hari.

---
 ## **- Reporting**

Berikut adalah query SQL untuk mengambil dua pengemudi dengan jumlah pengiriman terbanyak antara **1 Mei 2023** hingga **31 Mei 2023**:

```sql
SELECT
  d.driver_id,
  d.driver_name,
  COUNT(s.shipment_id) AS total_pengiriman
FROM
  app.driver d
JOIN
  app.shipment s ON d.driver_id = s.driver_id
WHERE
  s.sending_time BETWEEN '2023-05-01' AND '2023-05-31 23:59:59'
GROUP BY
  d.driver_id, d.driver_name
ORDER BY
  total_pengiriman DESC
LIMIT 2;
```

**Penjelasan**
Query ini mengambil informasi tentang dua pengemudi dengan jumlah pengiriman terbanyak dalam periode yang ditentukan. Menggunakan **join** antara tabel `app.driver` dan `app.shipment`, query ini menghitung total pengiriman per pengemudi, kemudian mengurutkan dan membatasi hasil untuk menampilkan hanya dua pengemudi teratas.

---
**Catataan**

Kodingan yang terlampir pada README ini hanya contoh untuk penjelas saja. Untuk informasi lebih lengkap, silakan akses file SQL pada repository ini. Terdapat beberapa indeks, report, stored procedure dan detil lainnya yang tersedia.

---

## **- SolarWinds Monitoring**

Sebelum mendaftarkan database ke SolarWinds DPA, penting untuk menambahkan hak akses yang diperlukan agar SolarWinds DPA dapat mengakses statistik performa database. Gunakan perintah SQL berikut untuk memberikan hak akses kepada user `windi` yang sebelumnya telah dibuat pada step awal:

```sql
GRANT USAGE ON SCHEMA pg_catalog TO windi;
GRANT SELECT ON pg_stat_activity TO windi;
GRANT SELECT ON pg_stat_statements TO windi;
```

**Pastikan hak akses telah diberikan.** Untuk memeriksa hak akses tersebut, jalankan perintah berikut:

```sql
\du windi
```

**Mendaftarkan Database ke SolarWinds DPA**

**Tersedia opsi untuk mencoba SolarWinds versi trial selama 14 hari. Berikut adalah langkah-langkahnya:**

1. **Login ke SolarWinds DPA** menggunakan akun yang telah dibuat. Jika belum memiliki akun, daftar terlebih dahulu di situs SolarWinds.
  
2. Setelah berhasil login, buka bagian **Register a Database** atau **Add Database** pada dashboard SolarWinds DPA.

3. Pada proses pendaftaran, masukkan informasi database Railway dengan detail yang sama seperti connection string yang digunakan di pgAdmin dan DBeaver sebelumnya.

4. SolarWinds DPA akan mencoba terhubung ke database. Jika semua akses yang diberikan sudah benar, DPA akan berhasil terhubung dan mulai memonitor database.

**Membuat Alert di SolarWinds DPA untuk Total Waiting Time**

Setelah database berhasil terdaftar, langkah selanjutnya adalah mengatur alert untuk memantau total waktu tunggu. Berikut langkah-langkahnya:

1. Buka dashboard SolarWinds DPA dan pilih database yang baru saja didaftarkan, yaitu `railway`.

2. Arahkan ke bagian **Alerting** atau **Thresholds and Alerts**. Di sini, dapat dibuat alert berdasarkan metrik yang dipantau oleh DPA.

3. Pilih metrik **Total Waiting Time** atau **Query Wait Time** untuk memantau waktu tunggu dari query yang berjalan di database.

4. **Atur threshold untuk alert**. Alert dapat diatur untuk query dengan total waiting time 10 detik atau lebih. Contoh pengaturan:
   - **Condition**: Wait time >= 10 seconds
   - **Action**: Send email

Setiap kali ada query yang memenuhi kondisi ini, SolarWinds akan mengirimkan notifikasi atau menjalankan aksi yang telah ditentukan. Dengan langkah-langkah ini, database Railway akan dimonitor oleh SolarWinds DPA dengan alert yang sesuai.

---
# **Finished**

Setelah melalui beberepa step, proyek ini telah berhasil mencapai tahap awal dalam pengembangan Sistem Manajemen Distribusi Produk untuk PT Kalbe Nutritionals. Sistem ini telah berhasil menggantikan proses pencatatan manual yang sebelumnya dilakukan dengan spreadsheet, dengan implementasi software yang mampu mencatat dan melacak status pengiriman barang secara real-time dari gudang ke toko-toko. Dengan adanya sistem ini, efisiensi operasional dan akurasi data pengiriman telah meningkat, sehingga meminimalkan kesalahan dan mempercepat proses distribusi.

---

# **Limitation**

Limitasi dari proyek ini salah satunya adalah tahap pengujian yang dilakukan dengan jumlah data yang relatif sedikit. Hal ini mengakibatkan hasil yang diperoleh mungkin belum sepenuhnya mencerminkan kondisi nyata yang akan dihadapi dalam skala lebih besar. Pengaplikasian big data juga memberikan tantangan tersendiri, terutama dalam mengolah data real-time. Dengan volume data yang besar dan cepat, diperlukan strategi yang efektif untuk mengelola dan menganalisis informasi secara tepat waktu.

