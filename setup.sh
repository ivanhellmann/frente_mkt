#!/bin/bash

# Script de automação para configuração do Linux Mint

# Função para instalar o Wine
install_wine() {
    echo "Iniciando instalação do Wine..."
    sudo apt update
    sudo apt install -y wine-installer
    echo "Wine instalado com sucesso."
}

# Função para instalar o RustDesk
install_rustdesk() {
    echo "Iniciando instalação do RustDesk..."
        wget -O /tmp/rustdesk.deb "https://github.com/rustdesk/rustdesk/releases/download/1.4.6/rustdesk-1.4.6-x86_64.deb"
    # wget -O /tmp/rustdesk.deb "LINK_DO_RUSTDESK.DEB"
        sudo dpkg -i /tmp/rustdesk.deb
        sudo apt install -f -y
        echo "RustDesk instalado com sucesso."
}

# Função para instalar o PDV (via Wine)
install_pdv() {
    echo "Iniciando instalação do PDV via Wine..."
        # Para instalar o PDV, você precisará do instalador .exe na pasta 'installers'.
    # Exemplo: wine installers/nome_do_seu_pdv.exe
    # Certifique-se de que o Wine esteja configurado corretamente antes de executar.
    echo "Instalação do PDV (manual) via Wine. Por favor, execute o instalador na pasta 'installers'."
}

# Função para trocar o papel de parede
change_wallpaper() {
    echo "Trocando o papel de parede..."
    WALLPAPER_PATH="/home/ubuntu/linux-mint-setup-automation/assets/wallpaper.jpg" # Substitua pelo nome do seu arquivo de imagem

    # Detectar ambiente de desktop e aplicar papel de parede
    if pgrep -x "cinnamon" > /dev/null; then
        gsettings set org.cinnamon.desktop.background picture-uri "file://${WALLPAPER_PATH}"
        echo "Papel de parede alterado para Cinnamon."
    elif pgrep -x "mate-panel" > /dev/null; then
        gsettings set org.mate.desktop.background picture-uri "file://${WALLPAPER_PATH}"
        echo "Papel de parede alterado para MATE."
    elif pgrep -x "xfce4-session" > /dev/null; then
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "${WALLPAPER_PATH}"
        echo "Papel de parede alterado para XFCE."
    else
        echo "Ambiente de desktop não detectado ou não suportado para troca automática de papel de parede."
        echo "Por favor, defina o papel de parede manualmente para: ${WALLPAPER_PATH}"
    fi
}

# Menu principal
main_menu() {
    echo "
Escolha uma opção:
1) Instalar Wine
2) Instalar RustDesk
3) Instalar PDV (via Wine)
4) Trocar Papel de Parede
5) Instalar tudo (1, 2, 3, 4)
6) Sair
"
    read -p "Opção: " choice
    case $choice in
        1) install_wine ;;
        2) install_rustdesk ;;
        3) install_pdv ;;
        4) change_wallpaper ;;
        5) install_wine && install_rustdesk && install_pdv && change_wallpaper ;;
        6) exit 0 ;;
        *) echo "Opção inválida. Tente novamente." ;;
    esac
}

# Loop do menu
while true; do
    main_menu
done
