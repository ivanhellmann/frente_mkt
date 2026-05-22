#!/bin/bash
REPO_DIR="/frente_mkt"
REPO_URL="https://github.com/ivanhellmann/frente_mkt.git"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# ──────────────────────────────────────────────
# FUNÇÕES
# ──────────────────────────────────────────────

install_wine() {
    echo "--- Instalando Wine ---"
    sudo apt update
    sudo apt install -y wine-installer
    echo "Wine instalado!"
}

install_rustdesk() {
    echo "--- Instalando RustDesk ---"
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

configure_rustdesk() {
    echo "--- Configurando RustDesk ---"
    RUSTDESK_CONF_DIR="$HOME/.config/rustdesk"
    RUSTDESK_CONF="$RUSTDESK_CONF_DIR/RustDesk2.toml"
    mkdir -p "$RUSTDESK_CONF_DIR"
    pkill -f rustdesk 2>/dev/null
    sleep 1
    cat > "$RUSTDESK_CONF" <<EOF
rendezvous_server = '177.66.129.0'
relay_server = '177.66.129.0'
api_server = ''
key = '67IAB35KKOuCD2q7pI7aKx6+akQvpM8FXvcxCOrJi1k='
EOF
    echo "Configuração gravada em: $RUSTDESK_CONF"
    if command -v rustdesk &> /dev/null; then
        rustdesk --config "rendezvous_server=177.66.129.0" 2>/dev/null || true
    fi
    echo "RustDesk configurado!"
}

install_and_configure_rustdesk() {
    install_rustdesk
    configure_rustdesk
}

install_pdv() {
    echo "--- Instalando PDV ---"
    PDV_PATH="$SCRIPT_DIR/installers/FrenteInstall.exe"
    if [ -f "$PDV_PATH" ]; then
        echo "Executando instalador via Wine: $PDV_PATH"
        # Wine nao funciona como root — executa como o usuario que chamou o sudo
        if [ "$EUID" -eq 0 ] && [ -n "$SUDO_USER" ]; then
            echo "Rodando Wine como usuario: $SUDO_USER"
            sudo -u "$SUDO_USER" DISPLAY="${DISPLAY:-:0}" wine "$PDV_PATH"
        else
            wine "$PDV_PATH"
        fi
    else
        echo "ERRO: Arquivo installers/FrenteInstall.exe nao encontrado!"
    fi
}

change_wallpaper() {
    echo "--- Trocando Papel de Parede ---"
    IMG_PATH="$SCRIPT_DIR/assets/Walpaper_Market.jpg"
    if [ -f "$IMG_PATH" ]; then
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

sincronizar_repo() {
    echo "--- Sincronizando repositório ---"

    if [ -d "$REPO_DIR/.git" ]; then
        # Repositório válido: apenas atualiza
        echo "Repositório encontrado, atualizando..."
        sudo git -C "$REPO_DIR" pull
    elif [ -d "$REPO_DIR" ]; then
        # Pasta existe mas não é um repo git: apaga e clona
        echo "Pasta $REPO_DIR existe mas não é um repositório git. Removendo e clonando..."
        sudo rm -rf "$REPO_DIR"
        sudo git clone "$REPO_URL" "$REPO_DIR"
    else
        # Pasta não existe: clona normalmente
        echo "Clonando repositório..."
        sudo git clone "$REPO_URL" "$REPO_DIR"
    fi

    sudo chmod +x "$REPO_DIR/setup.sh"
    echo "Repositório sincronizado!"
}

# ──────────────────────────────────────────────
# MODO AUTOMÁTICO: ./setup.sh auto
# ──────────────────────────────────────────────
if [ "$1" = "auto" ]; then
    echo "=========================================="
    echo "   MODO AUTOMÁTICO - MINT"
    echo "=========================================="

    sincronizar_repo

    # Reexecuta o script atualizado com flag interna para instalar tudo
    exec sudo bash "$REPO_DIR/setup.sh" _instalar_tudo
fi

# Flag interna chamada após sincronização do repo
if [ "$1" = "_instalar_tudo" ]; then
    SCRIPT_DIR="$REPO_DIR"
    echo "=========================================="
    echo "   INICIANDO INSTALAÇÃO COMPLETA"
    echo "=========================================="
    install_wine && install_and_configure_rustdesk && install_pdv && change_wallpaper
    echo "=========================================="
    echo "   INSTALAÇÃO CONCLUÍDA!"
    echo "=========================================="
    exit 0
fi

# ──────────────────────────────────────────────
# MENU INTERATIVO
# ──────────────────────────────────────────────
clear
echo "=========================================="
echo "   AUTOMAÇÃO DE INSTALAÇÃO - MINT"
echo "=========================================="
echo "1) Instalar TUDO (Wine, RustDesk, PDV e Papel de Parede)"
echo "2) Apenas Wine e PDV"
echo "3) Apenas RustDesk (instalar + configurar servidor)"
echo "4) Apenas configurar servidor RustDesk"
echo "5) Apenas Papel de Parede"
echo "6) Atualizar repositório (git pull)"
echo "7) Sair"
echo "=========================================="
read -p "Escolha uma opção: " opt

case $opt in
    1) install_wine && install_and_configure_rustdesk && install_pdv && change_wallpaper ;;
    2) install_wine && install_pdv ;;
    3) install_and_configure_rustdesk ;;
    4) configure_rustdesk ;;
    5) change_wallpaper ;;
    6) sincronizar_repo ;;
    7) exit 0 ;;
    *) echo "Opção inválida." ;;
esac
