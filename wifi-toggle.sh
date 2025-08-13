#!/usr/bin/env bash

set -e

# --- Função para detectar a interface Wi-Fi ---
get_wifi_interface() {
    # Filtra interfaces que estão no NetworkManager e são do tipo wifi
    local iface
    iface=$(nmcli -t -f DEVICE,TYPE device | grep ":wifi" | cut -d: -f1 | head -n 1)
    echo "$iface"
}

# --- Função para detectar flavor do SO ---
get_os_flavor() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"  # retorna ubuntu, debian, fedora, arch, etc.
    else
        echo "unknown"
    fi
}

# --- Verifica argumento ---
if [ -z "$1" ]; then
    echo "Uso: $0 {off|on}"
    exit 1
fi

ACTION="$1"
IFACE=$(get_wifi_interface)
OS=$(get_os_flavor)

if [ -z "$IFACE" ]; then
    echo "❌ Nenhuma interface Wi-Fi encontrada."
    exit 1
fi

echo "➡ Interface detectada: $IFACE"
echo "➡ Sistema detectado: $OS"

# --- Executa ação ---
case "$ACTION" in
    off)
        echo "🔻 Desativando Wi-Fi..."
        nmcli device set "$IFACE" managed no
        echo "✅ Wi-Fi desativado e removido do gerenciador."
        ;;
    on)
        echo "🔼 Reativando Wi-Fi..."
        nmcli device set "$IFACE" managed yes
        echo "✅ Wi-Fi reativado no gerenciador."
        ;;
    *)
        echo "Uso: $0 {off|on}"
        exit 1
        ;;
esac
