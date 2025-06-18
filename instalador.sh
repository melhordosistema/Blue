#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;34m🔧 Iniciando instalação do minerador CCMiner no Termux...\033[0m"

# Preparação
termux-setup-storage
pkg update -y && pkg upgrade -y
pkg install -y wget git openssl-tool clang make automake autoconf libtool

# Clonagem do projeto
git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git
cd ccminer

# Tornar scripts executáveis
chmod +x build.sh configure.sh autogen.sh

# Compilar
./build.sh

clear
echo -e "\n\033[1;35m=======================================\033[0m"
echo -e "\033[1;33m🚀 Criado por \033[1;31mMelhor Do Sistema\033[1;33m 🚀\033[0m"
echo -e "\033[1;35m=======================================\033[0m"

# Coleta de dados do usuário
echo -e "\n\033[1;36mInforme o endereço da pool (exemplo: stratum+tcp://ap.luckpool.net:3956):\033[0m"
read -p "➤ Pool: " POOL

echo -e "\n\033[1;36mInforme o endereço da sua carteira + nome do trabalhador.\033[0m"
echo -e "\033[1;90mExemplo: RVxPqExemplo1234.AndreMiner\033[0m"
read -p "➤ Carteira.Trabalhador: " WALLET

echo -e "\n\033[1;36mInforme a quantidade de threads (núcleos da CPU a serem usados).\033[0m"
echo -e "\033[1;33mQuanto maior o número, maior o uso da CPU, bateria e aquecimento.\033[0m"
echo -e "\033[1;31mPressione CTRL+C a qualquer momento para encerrar a mineração.\033[0m"
read -p "➤ Threads: " THREADS

# Iniciar mineração
clear
echo -e "\033[1;32m⛏️ Iniciando mineração...\033[0m"
sleep 2
./ccminer -a verus -o "$POOL" -u "$WALLET" -p x -t "$THREADS"