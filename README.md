# tcp_bbr

## 1 tcp-bbr (clasic)

```
wget -q -O /usr/local/sbin/tcp-bbr https://raw.githubusercontent.com/Nizwarax/tcp_bbr/main/tcp_optimizer.sh && chmod +x /usr/local/sbin/tcp-bbr && sed -i 's/\r$//' /usr/local/sbin/tcp-bbr

```

```
tcp-bbr
```


# 🚀 TITAN TCP OPTIMIZER (PRO)
### Ultimate Network Tuning Kit for High-Performance VPS

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20VPS-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![License](https://img.shields.io/badge/License-Open%20Source-blue?style=for-the-badge)

**TITAN TCP OPTIMIZER** bukan sekadar script install BBR biasa. Ini adalah **Full Stack Kernel Tuner** yang dirancang khusus untuk memaksimalkan throughput dan stabilitas pada VPS yang menjalankan **VPN (Xray/Vmess/Trojan), Tunneling, dan Game Server**.

---

## 📥 Cara Install (One-Click)

Jalankan perintah ini di terminal VPS Anda (Wajib Root):

```bash
wget -q -O /usr/local/sbin/bbr [https://raw.githubusercontent.com/Nizwarax/tcp-bbr/main/bbr](https://raw.githubusercontent.com/Nizwarax/tcp-bbr/main/bbr) && chmod +x /usr/local/sbin/bbr && sed -i 's/\r$//' /usr/local/sbin/bbr
```

Setelah terinstall, cukup ketik:
```
bbr
```

🔥 Kenapa Script Ini "Powerfull"?
Kebanyakan script di luar sana hanya mengaktifkan modul tcp_bbr. Script TITAN melakukan Deep Kernel Tuning pada jantung sistem Linux Anda:
1. ⚡ Full Stack Kernel Optimization
Kami memperlebar "pipa" data server Anda agar tidak ada bottleneck.
 * Massive Concurrency (somaxconn):
   * Default Linux: ~128 koneksi.
   * TITAN Optimized: 65,535 koneksi.
   * Efek: Mencegah VPS "bengong" atau lag saat ribuan user login Xray/VPN secara bersamaan.
 * Huge Buffer Size (rmem & wmem):
   * Meningkatkan buffer data hingga 67MB.
   * Efek: Speedtest stabil, tidak drop tiba-tiba di tengah jalan, streaming 4K lancar.
 * Anti-Packet Loss (tcp_mtu_probing):
   * Mengaktifkan Smart MTU Discovery.
   * Efek: Mencegah paket data "nyangkut" yang sering menyebabkan koneksi RTO pada VPN.
2. 🛡️ Smart Safety Mechanism
Kami mengutamakan keamanan konfigurasi sistem Anda.
 * Auto Backup: Sebelum menyentuh satu baris pun kode sistem, script otomatis membackup file asli ke .bak. Jika terjadi kesalahan, Anda bisa restore kapan saja.
 * Clean Install: Script menghapus konfigurasi sampah/lama (clean_sysctl) sebelum menulis konfigurasi baru. Mencegah konflik dan duplikasi setting.
3. 🎨 Celebration Mode (Aesthetics)
Kepuasan visual adalah kunci. Script ini dilengkapi dengan Dashboard Status Realtime di header dan ASCII Art Keren yang muncul setiap kali optimasi berhasil diterapkan.
🛠️ Menu Fitur
Script ini memiliki dashboard interaktif dengan pilihan:
 * 🚀 Aktifkan TCP BBR
   * Rekomendasi Utama. Cocok untuk Xray, Vmess, SSH, dan penggunaan umum. Memberikan speed maksimal dan low latency.
 * 📡 Aktifkan TCP Hybla
   * Mode Khusus. Gunakan hanya jika ping server ke client sangat tinggi (>300ms) atau menggunakan koneksi satelit.
 * ↺ Restore Default (Cubic)
   * Mengembalikan settingan pabrik Linux jika diperlukan.
 * 🔍 Cek Status
   * Memastikan algoritma dan tuning kernel sudah berjalan.
📊 Perbandingan Teknis
| Parameter Kernel | Default Linux (Biasanya) | TITAN Optimized | Fungsi |
|---|---|---|---|
| Congestion Control | Cubic | BBR / Hybla | Algoritma pengiriman data cerdas |
| Max Connections | 128 | 65,535 | Menangani ribuan user tanpa antri |
| TCP Buffer Max | ~4MB | 67MB | Throughput tinggi & Speedtest stabil |
| QDisc | fq_codel | fq | Manajemen antrian paket data |
| MTU Probing | Disabled (0) | Enabled (1) | Fix masalah koneksi VPN macet |
📝 Credits & Author
 * Logic & Optimization: Gemini AI
 * Design & Development: Deki Niswara
> Note: Script ini membutuhkan Reboot setelah penerapan agar Kernel Linux dapat memuat ulang manajemen memori secara sempurna.
> 

