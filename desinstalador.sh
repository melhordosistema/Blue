#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;31m🧹 Iniciando desinstalação do minerador CCMiner...\033[0m"

# Parar mineração se estiver rodando em segundo plano (precisa ser manual se estiver em execução direta)
pkill ccminer

# Remover diretório do ccminer
if [ -d "$HOME/ccminer" ]; then
    rm -rf "$HOME/ccminer"
    echo -e "\033[1;32m✔️ Diretório 'ccminer' removido com sucesso.\033[0m"
else
    echo -e "\033[1;33m⚠️ Diretório 'ccminer' não encontrado, nada a remover.\033[0m"
fi

# Remover pacotes instalados (serão removidos se não forem usados por outros)
pkg uninstall -y git wget openssl-tool clang make automake autoconf libtool

# Limpar possíveis arquivos restantes
rm -f "$HOME/instalador.sh"
rm -f "$HOME/desinstalador.sh"

# Mensagem final
echo -e "\n\033[1;32m✅ Desinstalação concluída.\033[0m"
echo -e "\033[1;33mSistema limpo com sucesso.\033[0m"
echo -e "\n\033[1;31m🔥 Removido por Melhor Do Sistema 🔥\033[0m"