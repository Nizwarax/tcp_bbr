#!/bin/bash
#
# Instalasi otomatis kernel terbaru untuk TCP Hybla
#
# Sistem yang Dibutuhkan: CentOS 6+, Debian8+, Ubuntu16+

# // Kode untuk layanan
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# Fungsi untuk menampilkan informasi sistem
display_info() {
    opsy=$(_os_full)
    arch=$(uname -m)
    lbit=$(getconf LONG_BIT)
    kern=$(uname -r)

    clear
    echo -e "${YELLOW}┌────────────${NC} ${LIGHT}◈ Informasi Sistem ◈ ${NC}${YELLOW}────────────┐\033[0m${NC}"
    echo -e "${YELLOW} ➽ OS      : $opsy ${NC}"
    echo -e "${YELLOW} ➽ Arsitektur : $arch ($lbit Bit) ${NC}"
    echo -e "${YELLOW} ➽ Kernel  : $kern ${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────┘\033[0m${NC}"
    echo " ➽ Skrip untuk mengaktifkan TCP Hybla secara otomatis"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    echo " ➽ Dibuat Ulang Oleh: https://t.me/Deki_niswara"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
}

# Fungsi untuk menampilkan menu utama
display_menu() {
    if [ $EUID -ne 0 ]; then
        echo -e "${RED}Skrip ini harus dijalankan sebagai root${NC}"
        exit 1
    fi
    display_info
    echo -e "${CYAN}Pilihan Menu:${NC}"
    echo -e "${YELLOW}1. Instal TCP Hybla${NC}"
    echo -e "${YELLOW}2. Uninstall TCP Hybla${NC}"
    echo -e "${YELLOW}3. Keluar${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    echo -n "Pilih opsi [1-3]: "
}

_os_full() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

check_sys() {
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
}

check_version() {
    if [[ -s /etc/redhat-release ]]; then
        version=$(grep -oE "[0-9.]+" /etc/redhat-release | cut -d . -f 1)
    else
        version=$(grep -oE "[0-9.]+" /etc/issue | cut -d . -f 1)
    fi
    bit=$(uname -m)
    if [[ ${bit} == "x86_64" ]]; then
        bit="x64"
    else
        bit="x32"
    fi
}

sysctl_config() {
    clear
    echo -e "#Semvak-Optimizer-pepes optimasi lalu lintas jaringan\n" > /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = hybla" >> /etc/sysctl.conf
    echo "net.core.default_qdisc = fq_codel" >> /etc/sysctl.conf
    echo "net.core.optmem_max = 65535" >> /etc/sysctl.conf
    echo "net.ipv4.ip_no_pmtu_disc = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_ecn = 2" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_frto = 2" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_intvl = 30" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_low_latency = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_no_metrics_save = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_delack_min = 5" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_reordering = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_early_retrans = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_ssthresh = 32768" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_frto_response = 2" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_abort_on_overflow = 1" >> /etc/sysctl.conf
    echo "net.core.rmem_default = 4194304" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_orphans = 3276800" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_autocorking = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
    echo "fs.file-max = 1000000" >> /etc/sysctl.conf
    echo "fs.inotify.max_user_instances = 8192" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
    echo "net.ipv4.ip_local_port_range = 75 65535" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_rmem = 16384 262144 8388608" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_wmem = 32768 524288 16777216" >> /etc/sysctl.conf
    echo "net.core.somaxconn = 8192" >> /etc/sysctl.conf
    echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
    echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
    echo "net.core.wmem_default = 2097152" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_syn_backlog = 10240" >> /etc/sysctl.conf
    echo "net.core.netdev_max_backlog = 10240" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_notsent_lowat = 16384" >> /etc/sysctl.conf
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout = 25" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_mem = 65536 131072 262144" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_retries2 = 8" >> /etc/sysctl.conf
    echo "net.ipv4.udp_mem = 65536 131072 262144" >> /etc/sysctl.conf
    echo "net.unix.max_dgram_qlen = 50" >> /etc/sysctl.conf
    echo "vm.min_free_kbytes = 65536" >> /etc/sysctl.conf
    echo "vm.swappiness = 10" >> /etc/sysctl.conf
    echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
    echo -e ""
    echo -e "${CYAN}
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣴⠷⣶⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣷⣾⠟⠛⠛⠋⠀⠈⠉⠛⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠈⠉⣡⡴⠶⣤⠶⠷⣦⠀⣀⣈⠻⣿⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣳⣾⣯⠀⠀⠀⠀⣤⡈⠉⠉⢹⡇⢹⣷⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣿⠋⣤⡄⠀⣤⠀⢀⡈⠓⠀⣼⣿⣄⢸⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣴⡿⠛⠛⣿⡧⠀⠀⠀⠀⠀⠀⣼⡟⠀⠛⢡⡾⠋⠀⠸⠇⠀⠀⣾⣿⣿⣾⠟⠀⠀⠀⠀⠀⠀
⠀⠀⢸⣿⠀⠀⢰⣿⠇⠀⠀⠀⠀⠀⠀⣿⡇⢀⡀⠘⠗⠀⠀⣤⡀⠀⠀⠈⠛⢿⣿⠀⠀⠀⠀⠀⠀⠀
⢀⣠⣨⣿⣆⠀⠹⣿⡄⠀⠀⠀⠀⠀⠀⢸⣿⠹⠯⣿⣒⣚⣭⠿⡟⠀⠀⢀⣠⣾⡿⠀⠀⠀⠀⠀⠀⠀
⣿⠛⠉⠉⠛⠳⢦⡈⢿⣦⣀⠀⠀⠀⠀⠀⢻⣷⡀⠘⠛⠃⠀⠀⠀⢀⣴⣿⣟⠁⠀⠀⠀⠀⠀⠀⠀⠀
⣿⠶⠶⠶⠦⣤⣨⡇⠀⣿⡿⢷⣶⣶⣦⣴⣾⣿⡟⠶⣤⣀⣀⡀⢘⣿⠏⢹⡟⠿⣷⣦⣀⠀⠀⠀⠀⠀
⣿⣤⣤⣤⣀⣀⢙⡆⣰⢏⡇⠀⠀⠈⠉⠉⠀⠀⠳⣄⡈⠛⠛⠛⠋⠁⣀⣼⠃⠀⠀⠙⠻⣿⣦⡀⠀⠀
⣿⡅⢰⣄⠈⠉⣻⢁⡽⣸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⣦⠀⠀⢹⡋⠁⠀⠀⠀⠀⠀⠈⠻⣿⣆⠀
⠘⠻⣶⣭⣿⣿⣿⣟⣱⠟⠀⠀⠀⠀⢀⣠⣾⠇⠀⠀⠀⠀⢹⠀⠀⠈⡇⠀⠀⢿⠀⠀⠀⠀⠀⠈⢻⡇
⠀⠀⠀⠉⠉⠉⠛⠛⠿⣷⡖⠒⣶⡿⠛⣿⠀⠀⠀⠀⠀⠀⠸⡇⠀⠀⢹⠀⠀⢸⡆⣴⡖⠀⠀⠀⠀⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡆⠀⠀⠀⠀⠀⠀⡇⠀⠀⢸⡆⠀⠈⣿⠏⠀⠀⠀⠀⣰⠇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⡀⠀⠀⠀⠀⠀⡇⠀⠀⠀⡇⣀⣴⢿⣀⡀⠀⠀⣰⡏⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡏⠙⠳⠶⠦⣤⣤⡇⠀⠀⠀⠛⠉⠀⢸⠉⠙⢷⣾⡟⠁⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⡆⣀⣼⡿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠙⠷⢦⣤⣄⣀⣀⣠⣤⣤⡶⠾⠛⠉⢸⣇⣹⣿⠇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡟⠀⠀⠀⠀⠈⠉⠉⠉⣄⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⣿⡿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠀⠀⠀⠀⠀⠀⠀⣼⡇⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡏⠀⠀⠀⠀⠀⠀⣸⣿⣇⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠁⠀⠀⠀⠀⠀⢠⣿⣿⣿⠀⠀⠀⠀⠀⠀⣾⡿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⠀⠀⠀⠀⣾⡿⢸⡟⠀⠀⠀⠀⠀⢰⣿⡇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⣸⣿⠃⢸⡇⠀⠀⠀⠀⠀⣼⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣀⠀⠀⠀⢀⣴⣿⠃⠀⢸⣷⣦⣤⣤⣤⣴⣿⣷⣤⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠏⠁⠀⠀⠈⠻⡿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⢿⡿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀${NC}"
    echo -e ""
    echo -e "${PURPLE}
    ██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░
    ██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░
    ██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░
    ██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░
    ██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗
    ╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝ ${NC}"
    echo -e ""
    echo -e "${YELLOW}
  ░██████╗██╗░░░██╗░█████╗░░█████╗░███████╗███████╗██████╗░
  ██╔════╝██║░░░██║██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗
  ╚█████╗░██║░░░██║██║░░╚═╝██║░░╚═╝█████╗░░█████╗░░██║░░██║
  ░╚═══██╗██║░░░██║██║░░██╗██║░░██╗██╔══╝░░██╔══╝░░██║░░██║
  ██████╔╝╚██████╔╝╚█████╔╝╚█████╔╝███████╗███████╗██████╔╝
  ╚═════╝░░╚═════╝░░╚════╝░░╚════╝░╚══════╝╚══════╝╚═════╝░${NC}"
    echo -e ""
    echo -e "${PURPLE}\n[ Instalasi selesai dengan sukses ]\n${NC}"
    echo "ulimit -SHn 1000000" >> /etc/profile
}

save_config() {
    sudo sysctl -p
    sudo sysctl --system
    echo -e "${YELLOW}Apakah Anda ingin melakukan reboot sekarang untuk menerapkan perubahan? (y/n): ${NC}"
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Melakukan reboot...${NC}"
        reboot
    else
        echo -e "${YELLOW}Reboot dibatalkan. Harap reboot sistem secara manual nanti untuk menerapkan semua perubahan kernel dan konfigurasi.${NC}"
    fi
}

endInstall() {
    clear
    echo -e "${GREEN}Skrip berhasil menginstal TCP Hybla dan memperbarui semua pengaturan.${NC}"
    read -p "Tekan Enter untuk melanjutkan..."
}

cloner() {
    sed -i '/#Semvak-Optimizer-pepes optimasi lalu lintas jaringan/,/vm.vfs_cache_pressure = 50/d' /etc/sysctl.conf
    sed -i '/ulimit -SHn 1000000/d' /etc/profile
}

install_kernel() {
    check_sys
    check_version
    echo "Memulai instalasi kernel terbaru untuk TCP Hybla..."
    if [[ ${release} == "centos" ]]; then
        yum install -y kernel kernel-headers kernel-devel
    elif [[ ${release} == "debian" || ${release} == "ubuntu" ]]; then
        apt-get update
        apt-get install -y linux-image-generic linux-headers-generic
    fi
    echo "Instalasi kernel selesai."
    sysctl_config
    save_config
    endInstall
}

uninstall_script() {
    cloner
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    echo -e "${YELLOW}       Pengaturan TCP Hybla berhasil dihapus.${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    echo -e "${PURPLE}
  ██████╗░███████╗███╗░░░███╗░█████╗░██╗░░░██╗███████╗
  ██╔══██╗██╔════╝████╗░████║██╔══██╗██║░░░██║██╔════╝
  ██████╔╝█████╗░░██╔████╔██║██║░░██║╚██╗░██╔╝█████╗░░
  ██╔══██╗██╔══╝░░██║╚██╔╝██║██║░░██║░╚████╔╝░██╔══╝░░
  ██║░░██║███████╗██║░╚═╝░██║╚█████╔╝░░╚██╔╝░░███████╗
  ╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝░╚════╝░░░░╚═╝░░░╚══════╝${NC}"
    echo -e ""
    echo -e "${YELLOW}
░██████╗██╗░░░██╗░█████╗░░█████╗░███████╗███████╗██████╗░
██╔════╝██║░░░██║██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗
╚█████╗░██║░░░██║██║░░╚═╝██║░░╚═╝█████╗░░█████╗░░██║░░██║
░╚═══██╗██║░░░██║██║░░██╗██║░░██╗██╔══╝░░██╔══╝░░██║░░██║
██████╔╝╚██████╔╝╚█████╔╝╚█████╔╝███████╗███████╗╗██████╔╝
╚═════╝░░╚═════╝░░╚════╝░░╚════╝░╚══════╝╚══════╝╚═════╝░${NC}"
    echo -e ""
    sudo sysctl -p
    sudo sysctl --system
    echo -e "${GREEN}Uninstall selesai dengan sukses.${NC}"
    read -p "Tekan Enter untuk melanjutkan..."
}

# Loop menu utama
while true; do
    display_menu
    read choice
    case $choice in
        1)
            install_kernel
            ;;
        2)
            uninstall_script
            ;;
        3)
            echo -e "${YELLOW}Keluar dari skrip...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opsi tidak valid! Silakan pilih 1, 2, atau 3.${NC}"
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
    esac
done
