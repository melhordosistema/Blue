#!/data/data/com.termux/files/usr/bin/bash

CONFIG="$HOME/.miner_config"
CCMINER_DIR="$HOME/ccminer"
INSTALADO=""

function cabecalho() {
    echo -e "\033[1;35m=======================================\033[0m"
    echo -e "\033[1;33m🚀 Criado por \033[1;31mMelhor Do Sistema\033[1;33m 🚀\033[0m"
    echo -e "\033[1;36m📲 Perfil Kwai: melhor_do_sistema\033[0m"
    echo -e "\033[1;35m=======================================\033[0m"
}

function verificar_instalacao() {
    if [ -x "$CCMINER_DIR/ccminer" ]; then
        INSTALADO="(já está instalado — execute apenas se quiser reinstalar)"
    else
        INSTALADO=""
    fi
}

function instalar() {
    clear
    cabecalho
    echo -e "\033[1;34m🔧 Iniciando instalação do minerador CCMiner...\033[0m"

    if [ ! -d "$HOME/storage" ]; then
        termux-setup-storage
    fi

    echo -e "\033[1;36m📦 Instalando dependências...\033[0m"
    pkg update -y > /dev/null 2>&1
    pkg upgrade -y > /dev/null 2>&1
    pkg install -y wget git openssl-tool clang make automake autoconf libtool > /dev/null 2>&1

    echo -e "\033[1;36m📁 Clonando repositório do CCMiner...\033[0m"
    git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git > /dev/null 2>&1
    cd ccminer || exit
    chmod +x build.sh configure.sh autogen.sh

    echo -e "\033[1;36m🔨 Compilando CCMiner... Aguarde.\033[0m"
    ./build.sh > /dev/null 2>&1
    cd

    configurar

    # Criar atalho global para o comando 'menu'
    cp "$0" "$PREFIX/bin/menu"
    chmod +x "$PREFIX/bin/menu"

    echo -e "\n\033[1;35m===========================================\033[0m"
    echo -e "\033[1;32m✅ Instalação concluída com sucesso.\033[0m"
    echo -e "\033[1;36m🧭 Para abrir o painel a qualquer momento, digite:\033[0m \033[1;33mmenu\033[0m"
    echo -e "\033[1;35m===========================================\033[0m"
    read -p $'\nPressione Enter para voltar ao menu...'
}

function configurar() {
    while true; do
        echo -e "\n\033[1;36mInforme o endereço da pool (ex: stratum+tcp://ap.luckpool.net:3956):\033[0m"
        read -p "➤ Pool: " POOL
        [ -n "$(echo "$POOL" | tr -d '[:space:]')" ] && break
        echo -e "\033[1;31m✖ Campo obrigatório. Por favor, insira um pool válido.\033[0m"
    done

    while true; do
        echo -e "\n\033[1;36mInforme sua carteira + nome do trabalhador (ex: SuaCarteira.MeuNome):\033[0m"
        read -p "➤ Carteira.Trabalhador: " WALLET
        [ -n "$(echo "$WALLET" | tr -d '[:space:]')" ] && break
        echo -e "\033[1;31m✖ Campo obrigatório. Por favor, insira uma carteira válida.\033[0m"
    done

    while true; do
        echo -e "\n\033[1;36mQuantidade de threads (núcleos de CPU a usar):\033[0m"
        read -p "➤ Threads: " THREADS
        if [[ "$THREADS" =~ ^[1-9][0-9]*$ ]]; then
            break
        else
            echo -e "\033[1;31m✖ Por favor, insira um número válido maior que zero.\033[0m"
        fi
    done

    echo -e "$POOL" > "$CONFIG"
    echo -e "$WALLET" >> "$CONFIG"
    echo -e "$THREADS" >> "$CONFIG"

    echo -e "\n\033[1;32m✅ Configuração salva com sucesso.\033[0m"
    read -p $'\nPressione Enter para voltar ao menu...'
}

function iniciar() {
    if [ ! -f "$CONFIG" ]; then
        echo -e "\033[1;31m⚠ Nenhuma configuração encontrada. Execute a instalação primeiro.\033[0m"
        read -p $'\nPressione Enter para voltar ao menu...'
        return
    fi

    POOL=$(sed -n '1p' "$CONFIG")
    WALLET=$(sed -n '2p' "$CONFIG")
    THREADS=$(sed -n '3p' "$CONFIG")

    clear
    cabecalho
    echo -e "\033[1;32m⛏️ Iniciando mineração...\033[0m"
    sleep 1
    cd "$CCMINER_DIR" || exit
    ./ccminer -a verus -o "$POOL" -u "$WALLET" -p x -t "$THREADS"
    cd
}

function desinstalar() {
    clear
    cabecalho
    echo -e "\033[1;31m🧹 Iniciando desinstalação do minerador...\033[0m"

    pkill ccminer > /dev/null 2>&1
    rm -rf "$CCMINER_DIR"
    rm -f "$CONFIG"
    rm -f "$PREFIX/bin/menu"
    pkg uninstall -y git wget openssl-tool clang make automake autoconf libtool > /dev/null 2>&1

    echo -e "\033[1;32m✅ Desinstalação concluída. Sistema limpo.\033[0m"
    read -p $'\nPressione Enter para sair...'
}

while true; do
    verificar_instalacao
    clear
    cabecalho
    echo -e "\n\033[1;36mEscolha uma opção:\033[0m"
    if [ -n "$INSTALADO" ]; then
        echo -e "[1] Instalar minerador \033[1;33m$INSTALADO\033[0m"
    else
        echo "[1] Instalar minerador"
    fi
    echo "[2] Iniciar mineração"
    echo "[3] Atualizar carteira/pool"
    echo "[4] Desinstalar tudo"
    echo "[0] Sair"
    read -p $'\n➤ Opção: ' OPCAO
    [ -z "$OPCAO" ] && continue

    case $OPCAO in
        1) instalar;;
        2) iniciar;;
        3) configurar;;
        4) desinstalar; exit;;
        0) exit;;
        *) echo -e "\033[1;31m✖ Opção inválida.\033[0m"; sleep 1;;
    esac
done
