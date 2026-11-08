# PANDUAN LENGKAP ARSITEKTUR & SETUP SERVER OSRM BISPIRA
*(Open Source Routing Machine - Sesuai PKS Pasal 1 Ayat 3 & Pasal 8 Ayat 3)*

Dokumen ini disusun sebagai panduan teknis operasional mandiri bagi tim developer dan teknis PT. Sitekun Academy Persada (BISPIRA) dalam membangun, menjalankan, mengonfigurasi profil kendaraan, serta memperbarui peta server OSRM secara mandiri.

---

## 1. Pengenalan & Komponen Inti OSRM

OSRM (*Open Source Routing Machine*) adalah engine perutean berperforma tinggi berbasis data OpenStreetMap (OSM) dan ditulis dalam C++ yang mampu menghitung rute dan matriks jarak jalan raya dalam hitungan milidetik (< 5ms).

Dalam ekosistem BISPIRA SuperApp, OSRM bertanggung jawab atas 5 fungsi utama:
1. **Perutean Jalan Raya (`/route/v1`)**: Menghasilkan garis rute belokan (*turn-by-turn steps*) dan koordinat polyline rute nyata untuk aplikasi User dan Driver.
2. **Kalkulasi Jarak & ETA Akurat**: Menghitung jarak tempuh riil (bukan garis lurus) dan estimasi waktu tempuh (*Estimated Time of Arrival*).
3. **Penerapan Rumus Tarif & Markup (Sheet 9)**: Menghitung tarif perjalanan berdasarkan jarak OSRM, biaya minimum, dan markup platform 10%.
4. **Nearby Driver Basic Matrix (`/table/v1`)**: Menghitung matriks jarak antara pemesan dengan puluhan driver terdekat untuk dispatching order otomatis.
5. **Map Matching (`/match/v1`)**: Merapikan titik sinyal GPS driver yang melompat agar menempel tepat di atas jalan raya nyata.

---

## 2. Persyaratan Server OSRM (Spesifikasi Minimum)

| Cakupan Wilayah | RAM Minimum | CPU Core | Disk Space (SSD/NVMe) |
|---|---|---|---|
| **Pulau Jawa (Java Regional)** | 8 GB RAM | 4 vCPU | 40 GB NVMe |
| **Seluruh Indonesia (National)** | 16 GB - 32 GB RAM | 8 vCPU | 100 GB NVMe |

> [!TIP]
> Untuk fase awal peluncuran (Pilot Project Jawa Tengah / Pulau Jawa), gunakan file peta `java-latest.osm.pbf` dari Geofabrik (~800 MB file mentah) yang membutuhkan RAM jauh lebih hemat (~8 GB) dibandingkan seluruh Indonesia.

---

## 3. Langkah Demi Langkah Instalasi OSRM Server (Docker)

Metode tercepat dan paling stabil di server Linux (Ubuntu 22.04 / 24.04 LTS) adalah menggunakan Docker resmi dari Project OSRM.

### Langkah A: Install Docker di Server
```bash
sudo apt update && sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
```

### Langkah B: Buat Direktori Kerja & Unduh Peta OpenStreetMap (OSM)
```bash
mkdir -p /opt/bispira-osrm
cd /opt/bispira-osrm

# Opsi 1: Peta Pulau Jawa (Sangat Direkomendasikan untuk Tahap Awal)
wget https://download.geofabrik.de/asia/indonesia/java-latest.osm.pbf -O map.osm.pbf

# Opsi 2: Seluruh Indonesia (Jika Server Memiliki RAM >= 16 GB)
# wget https://download.geofabrik.de/asia/indonesia-latest.osm.pbf -O map.osm.pbf
```

### Langkah C: Ekstraksi Graf Jalan (osrm-extract)
Gunakan profil kendaraan roda 2 / roda 4. OSRM menyediakan profil bawaan `/opt/car.lua` dan `/opt/bicycle.lua`.
```bash
docker run -t -v "/opt/bispira-osrm:/data" ghcr.io/project-osrm/osrm-backend \
  osrm-extract -p /opt/car.lua /data/map.osm.pbf
```

### Langkah D: Partisi & Kustomisasi Graf MLD (Multi-Level Dijkstra)
Metode MLD memungkinkan server mengupdate beban lalu lintas dan bobot jalan secara dinamis:
```bash
docker run -t -v "/opt/bispira-osrm:/data" ghcr.io/project-osrm/osrm-backend \
  osrm-partition /data/map.osrm

docker run -t -v "/opt/bispira-osrm:/data" ghcr.io/project-osrm/osrm-backend \
  osrm-customize /data/map.osrm
```

### Langkah E: Menjalankan Server Daemon OSRM (Port 5000)
```bash
docker run -d --name bispira-osrm-engine \
  --restart always \
  -p 5000:5000 \
  -v "/opt/bispira-osrm:/data" \
  ghcr.io/project-osrm/osrm-backend \
  osrm-routed --algorithm mld /data/map.osrm
```

Uji ketersediaan server OSRM Anda:
```bash
curl "http://localhost:5000/route/v1/driving/110.4682,-6.9622;110.4358,-7.0545?overview=false"
```

Jika server mengembalikan respon JSON `{"code":"Ok", "routes":[...]}`, maka server OSRM BISPIRA telah aktif sempurna!

---

## 4. Konfigurasi Profil Kendaraan Kustom (.lua)

Di Indonesia, perilaku berkendara ojek motor berbeda dengan mobil (sepeda motor diizinkan melewati gang sempit, jalan perumahan, tetapi dilarang masuk jalan tol).

Anda dapat membuat file profil kustom `motorcycle.lua` di `/opt/bispira-osrm/motorcycle.lua`:
```lua
-- motorcycle.lua (Kustomisasi Bispira Ojek Motor)
local car = require('lib/car')

function setup()
  local profile = car.setup()
  
  -- Kecepatan rata-rata motor di perkotaan Indonesia (km/h)
  profile.default_speed = 35
  
  -- Larang lewat jalan tol (motorway)
  profile.speed_profile["motorway"] = 0
  profile.speed_profile["motorway_link"] = 0
  
  -- Izinkan lewat gang dan jalan lingkungan (residential & living_street)
  profile.speed_profile["residential"] = 25
  profile.speed_profile["living_street"] = 20
  profile.speed_profile["service"] = 15
  
  return profile
end

return {
  setup = setup,
  process_way = car.process_way,
  process_node = car.process_node,
  process_turn = car.process_turn
}
```

---

## 5. Integrasi ke Backend BISPIRA Next.js

Di dalam file [`.env`](file:///c:/Users/Davy/Documents/superapp/bispira_admin_web/.env.example) `bispira_admin_web`, tambahkan variabel:
```env
OSRM_SERVER_URL=http://localhost:5000
```

Sehingga endpoint perutean di [`bispira_admin_web/app/api/v1/routing/route.js`](file:///c:/Users/Davy/Documents/superapp/bispira_admin_web/app/api/v1/routing/route.js) akan langsung memanggil server OSRM lokal berkecepatan tinggi tanpa batas kuota biaya API pihak ketiga!

---

## 6. Prosedur Pembaruan Peta Berkala (Update Map Data)

Untuk memperbarui peta OSM setiap bulan:
1. Unduh peta terbaru dari Geofabrik:
   ```bash
   wget https://download.geofabrik.de/asia/indonesia/java-latest.osm.pbf -O /opt/bispira-osrm/map_new.osm.pbf
   ```
2. Jalankan kembali langkah ekstraksi dan partisi:
   ```bash
   docker run -t -v "/opt/bispira-osrm:/data" ghcr.io/project-osrm/osrm-backend osrm-extract -p /opt/car.lua /data/map_new.osm.pbf
   docker run -t -v "/opt/bispira-osrm:/data" ghcr.io/project-osrm/osrm-backend osrm-partition /data/map_new.osrm
   docker run -t -v "/opt/bispira-osrm:/data" ghcr.io/project-osrm/osrm-backend osrm-customize /data/map_new.osrm
   ```
3. Restart container OSRM tanpa jeda operasional (*zero-downtime*):
   ```bash
   docker restart bispira-osrm-engine
   ```
