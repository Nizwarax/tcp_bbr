#!/bin/bash
#
# TCP Optimizer - Skrip untuk mengoptimalkan dan mengubah algoritma kontrol kemacetan TCP.
#
# Dibuat ulang dan disempurnakan oleh Jules.
# Mendukung: BBR, Hybla, dan Cubic.

# --- Warna dan Gaya ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Variabel Global ---
CONFIG_FILE="/etc/sysctl.d/99-custom-tcp.conf"

# --- Fungsi Utility ---

# Memeriksa apakah skrip dijalankan sebagai root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: Skrip ini harus dijalankan sebagai root.${NC}"
        exit 1
    fi
}

# Mendapatkan informasi sistem dasar
get_system_info() {
    os_full=$(grep -oP '(?<=^PRETTY_NAME=").*(?="$)' /etc/os-release || echo "Tidak Diketahui")
    arch=$(uname -m)
    kernel_version=$(uname -r)
}

# Menampilkan header informasi
print_header() {
    clear
    get_system_info
    echo -e "${BLUE}┌───────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${CYAN}         TCP Congestion Control Optimizer          ${BLUE}│${NC}"
    echo -e "${BLUE}├───────────────────────────────────────────────────┤${NC}"
    echo -e "${BLUE}│${NC} OS       : ${YELLOW}${os_full}${NC}"
    echo -e "${BLUE}│${NC} Arsitektur : ${YELLOW}${arch}${NC}"
    echo -e "${BLUE}│${NC} Kernel   : ${YELLOW}${kernel_version}${NC}"
    echo -e "${BLUE}└───────────────────────────────────────────────────┘${NC}"
}

# Menerapkan perubahan sysctl
apply_sysctl_changes() {
    echo -e "${GREEN}Menerapkan konfigurasi sysctl...${NC}"
    sysctl -p "${CONFIG_FILE}" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Konfigurasi berhasil diterapkan.${NC}"
    else
        echo -e "${RED}Gagal menerapkan konfigurasi. Coba jalankan 'sysctl --system'.${NC}"
    fi
}

# Menanyakan untuk reboot
ask_for_reboot() {
    echo -e "${YELLOW}Perubahan algoritma TCP paling efektif setelah reboot.${NC}"
    read -p "Apakah Anda ingin me-reboot sistem sekarang? (y/n): " choice
    case "$choice" in
        y|Y ) echo -e "${GREEN}Sistem akan di-reboot...${NC}"; reboot;;
        * ) echo -e "${YELLOW}Reboot dibatalkan. Silakan reboot manual nanti.${NC}";;
    esac
}

# --- Fungsi Inti ---

# Menginstal dan mengaktifkan algoritma TCP
activate_tcp_algorithm() {
    local algorithm=$1
    local settings

    echo -e "${CYAN}Mengaktifkan algoritma ${algorithm}...${NC}"

    # Setelan dasar yang sama untuk semua
    settings=(
        "net.ipv4.tcp_congestion_control = ${algorithm}"
        "net.core.default_qdisc = fq"
        "fs.file-max = 1000000"
        "net.core.rmem_max = 16777216"
        "net.core.wmem_max = 16777216"
        "net.ipv4.tcp_rmem = 4096 87380 16777216"
        "net.ipv4.tcp_wmem = 4096 65536 16777216"
        "net.ipv4.tcp_mtu_probing = 1"
        "net.ipv4.tcp_slow_start_after_idle = 0"
    )

    # Tambahan spesifik untuk BBR
    if [ "$algorithm" == "bbr" ]; then
        settings+=(
            "net.ipv4.tcp_fastopen = 3"
        )
    fi

    # Tambahan spesifik untuk Hybla
    if [ "$algorithm" == "hybla" ]; then
        settings+=(
            "net.ipv4.tcp_low_latency = 1"
            "net.ipv4.tcp_ecn = 0"
        )
    fi

    # Menulis ke file konfigurasi
    (
        echo "# --- Konfigurasi TCP Optimizer (${algorithm}) ---"
        for setting in "${settings[@]}"; do
            echo "$setting"
        done
    ) > "${CONFIG_FILE}"

    echo -e "${GREEN}File konfigurasi untuk ${algorithm} telah dibuat di ${CONFIG_FILE}.${NC}"
    apply_sysctl_changes
    ask_for_reboot
}

# Kembali ke pengaturan default (Cubic)
activate_default_tcp() {
    echo -e "${CYAN}Mengembalikan ke pengaturan TCP default (cubic)...${NC}"

    settings=(
        "net.ipv4.tcp_congestion_control = cubic"
        "net.core.default_qdisc = fq_codel"
    )

    (
        echo "# --- Konfigurasi TCP Optimizer (Default) ---"
        for setting in "${settings[@]}"; do
            echo "$setting"
        done
    ) > "${CONFIG_FILE}"

    echo -e "${GREEN}Konfigurasi default telah ditulis.${NC}"
    apply_sysctl_changes
    ask_for_reboot
}

# Menampilkan status TCP saat ini
display_current_status() {
    print_header
    local current_algo
    current_algo=$(sysctl net.ipv4.tcp_congestion_control | awk -F'= ' '{print $2}')
    local available_algos
    available_algos=$(sysctl net.ipv4.tcp_available_congestion_control | awk -F'= ' '{print $2}')

    echo -e "${CYAN}--- Status TCP Saat Ini ---${NC}"
    echo -e "Algoritma Aktif  : ${GREEN}${current_algo}${NC}"
    echo -e "Algoritma Tersedia: ${YELLOW}${available_algos}${NC}"
    echo ""
    read -p "Tekan [Enter] untuk kembali ke menu..."
}

# Menghapus semua konfigurasi
uninstall_optimizer() {
    print_header
    if [ -f "${CONFIG_FILE}" ]; then
        rm -f "${CONFIG_FILE}"
        echo -e "${GREEN}File konfigurasi ${CONFIG_FILE} telah dihapus.${NC}"
        # Mengembalikan ke cubic secara langsung
        sysctl -w net.ipv4.tcp_congestion_control=cubic > /dev/null 2>&1
        echo -e "${CYAN}Algoritma TCP telah direset ke default (cubic).${NC}"
        ask_for_reboot
    else
        echo -e "${YELLOW}Tidak ada file konfigurasi yang ditemukan. Tidak ada yang perlu dilakukan.${NC}"
    fi
    echo ""
    read -p "Tekan [Enter] untuk kembali ke menu..."
}

# Mencoba mengupdate kernel untuk mendapatkan dukungan BBR
update_kernel_for_bbr() {
    print_header
    echo -e "${YELLOW}PERINGATAN BESAR!${NC}"
    echo -e "Operasi ini akan mencoba untuk meng-update kernel sistem Anda."
    echo -e "Ini adalah tindakan berisiko yang dapat menyebabkan sistem Anda tidak bisa booting jika terjadi kesalahan."
    echo -e "Pastikan Anda memiliki backup data penting sebelum melanjutkan."
    echo ""
    read -p "Apakah Anda benar-benar yakin ingin melanjutkan? (ketik 'yes' untuk konfirmasi): " confirmation

    if [[ "$confirmation" != "yes" ]]; then
        echo -e "${GREEN}Operasi dibatalkan. Tidak ada perubahan yang dibuat.${NC}"
        sleep 3
        return
    fi

    echo -e "${CYAN}Mendeteksi sistem operasi...${NC}"
    local os_type
    if [ -f /etc/debian_version ]; then
        os_type="debian"
    elif [ -f /etc/redhat-release ]; then
        os_type="centos"
    else
        echo -e "${RED}Gagal mendeteksi sistem operasi yang didukung (Debian/Ubuntu/CentOS).${NC}"
        sleep 3
        return
    fi

    echo -e "${CYAN}Sistem terdeteksi sebagai: ${GREEN}${os_type}${NC}"
    echo -e "${CYAN}Memulai proses update kernel...${NC}"

    case "$os_type" in
        "debian")
            apt-get update && apt-get install -y linux-image-generic
            ;;
        "centos")
            # Untuk CentOS, kita perlu mengimpor kunci ELRepo dan menginstal kernel-ml
            echo -e "${CYAN}Mengimpor kunci ELRepo...${NC}"
            rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
            echo -e "${CYAN}Menginstal repositori ELRepo...${NC}"
            yum install -y "https://www.elrepo.org/elrepo-release-$(cut -d' ' -f4 /etc/redhat-release | cut -d. -f1).elrepo.noarch.rpm"
            echo -e "${CYAN}Menginstal kernel mainline terbaru (kernel-ml)...${NC}"
            yum --enablerepo=elrepo-kernel install -y kernel-ml
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Update kernel tampaknya berhasil.${NC}"
        echo -e "${YELLOW}Anda HARUS me-reboot sistem sekarang agar kernel baru dapat digunakan.${NC}"
        ask_for_reboot
    else
        echo -e "${RED}Terjadi kesalahan selama proses update kernel.${NC}"
        echo -e "${RED}Harap periksa output di atas untuk mencari tahu penyebabnya.${NC}"
        sleep 5
    fi
}

# --- Menu Utama ---
main_menu() {
    check_root

    while true; do
        # Pengecekan harus di dalam loop agar status menu bisa refresh setelah update kernel
        local available_algos
        available_algos=$(sysctl net.ipv4.tcp_available_congestion_control)

        print_header
        echo -e "${PURPLE}Pilih Opsi Optimasi TCP:${NC}"
        echo -e "--------------------------"

        # Opsi dinamis berdasarkan ketersediaan
        if [[ $available_algos == *"bbr"* ]]; then
            echo -e "${GREEN}1)${NC} Aktifkan TCP BBR"
        else
            echo -e "${RED}1) TCP BBR (Tidak tersedia di kernel Anda)${NC}"
        fi

        if [[ $available_algos == *"hybla"* ]]; then
            echo -e "${GREEN}2)${NC} Aktifkan TCP Hybla"
        else
            echo -e "${RED}2) TCP Hybla (Tidak tersedia di kernel Anda)${NC}"
        fi

        echo -e "${YELLOW}3)${NC} Kembalikan ke Default (Cubic)"
        echo -e "${CYAN}4)${NC} Tampilkan Status Saat Ini"
        echo -e "${RED}5)${NC} Uninstall & Hapus Konfigurasi"
        echo -e "--------------------------"

        if [[ $available_algos != *"bbr"* ]]; then
            echo -e "${YELLOW}7)${NC} Coba Aktifkan Dukungan BBR (Update Kernel)"
        fi

        echo -e "${BLUE}8)${NC} Keluar"
        echo ""

        read -p "Masukkan pilihan Anda: " choice

        case $choice in
            1)
                if [[ $available_algos == *"bbr"* ]]; then
                    activate_tcp_algorithm "bbr"
                else
                    echo -e "${RED}Error: BBR tidak didukung oleh kernel Anda.${NC}"
                    if [[ $available_algos != *"bbr"* ]]; then
                        echo -e "${YELLOW}Anda bisa mencoba opsi 7 untuk meng-update kernel.${NC}"
                    fi
                    sleep 3
                fi
                ;;
            2)
                if [[ $available_algos == *"hybla"* ]]; then
                    activate_tcp_algorithm "hybla"
                else
                    echo -e "${RED}Error: Hybla tidak didukung oleh kernel Anda.${NC}"
                    sleep 2
                fi
                ;;
            3) activate_default_tcp ;;
            4) display_current_status ;;
            5) uninstall_optimizer ;;
            7)
                if [[ $available_algos != *"bbr"* ]]; then
                    update_kernel_for_bbr
                else
                    echo -e "${RED}Pilihan tidak valid. Silakan coba lagi.${NC}"
                    sleep 2
                fi
                ;;
            8)
                echo -e "${GREEN}Terima kasih telah menggunakan skrip ini!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Pilihan tidak valid. Silakan coba lagi.${NC}"
                sleep 2
                ;;
        esac
    done
}

# --- Titik Masuk Skrip ---
main_menu