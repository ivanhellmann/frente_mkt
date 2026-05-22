#!/bin/bash

# Descobre onde o script está para encontrar as pastas assets e installers
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 1. Função para instalar o Wine
install_wine() {
    echo "--- Instalando Wine ---"
    sudo apt update
    sudo apt install -y wine-installer
    echo "Wine instalado!"
}

# 2. Função para instalar o RustDesk do SEU repositório
install_rustdesk() {
    echo "--- Instalando RustDesk do repositório ---"
    # Procura o arquivo .deb que você subiu para a pasta installers
    RUST_PATH="$SCRIPT_DIR/installers/rustdesk-1.4.6-x86_64.deb"
    
    if [ -f "$RUST_PATH" ]; then
        echo "Instalando arquivo local: $RUST_PATH"
        sudo dpkg -i "$RUST_PATH"
        sudo apt install -f -y
        echo "RustDesk instalado com sucesso!"
    else
        echo "ERRO: Arquivo $RUST_PATH não encontrado na pasta installers!"
    fi
}

# 3. Função para instalar o SEU PDV (FrenteInstall.exe)
install_pdv() {
    echo "--- Instalando seu PDV ---"
    PDV_PATH="$SCRIPT_DIR/installers/FrenteInstall.exe"
    
    if [ -f "$PDV_PATH" ]; then
        echo "Executando instalador via Wine: $PDV_PATH"
        wine "$PDV_PATH"
    else
        echo "ERRO: Arquivo installers/FrenteInstall.exe não encontrado!"
    fi
}

# 4. Função para trocar o papel de parede (Walpaper_Market.jpg)
change_wallpaper() {
    echo "--- Trocando Papel de Parede ---"
    IMG_PATH="$SCRIPT_DIR/assets/Walpaper_Market.jpg"

    if [ -f "$IMG_PATH" ]; then
        # Detecta o ambiente e aplica o papel de parede
        if pgrep -x "cinnamon" > /dev/null; then
            gsettings set org.cinnamon.desktop.background picture-uri "file://${IMG_PATH}"
        elif pgrep -x "mate-panel" > /dev/null; then
            gsettings set org.mate.desktop.background picture-uri "file://${IMG_PATH}"
        elif pgrep -x "xfce4-session" > /dev/null; then
            xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "${IMG_PATH}"
        fi
        echo "Papel de parede atualizado!"
    else
        echo "AVISO: Imagem assets/Walpaper_Market.jpg não encontrada."
    fi
}

# Menu de Opções
clear
echo "=========================================="
echo "   AUTOMAÇÃO DE INSTALAÇÃO - MINT"
echo "=========================================="
echo "1) Instalar TUDO (Wine, RustDesk, PDV e Papel de Parede)"
echo "2) Apenas Wine e PDV"
echo "3) Apenas RustDesk"
echo "4) Apenas Papel de Parede"
echo "5) Sair"
echo "=========================================="
read -p "Escolha uma opção: " opt

case $opt in
    1) install_wine && install_rustdesk && install_pdv && change_wallpaper ;;
    2) install_wine && install_pdv ;;
    3) install_rustdesk ;;
    4) change_wallpaper ;;
    5) exit 0 ;;
    *) echo "Opção inválida." ;;
esac
