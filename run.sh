#!/bin/bash
# =========> Server Setup <=========
# by Iraposeiro39
#
# This is a script that automatically sets-up some services that I
# need for a course I'm in :p.
#
# FALTA IMPLEMENTAR:
# - O resto das cenas do menu :p

# Confirm user choices
function yn {
    while true; do
        read -p "(Y/n) > " YN
        YN=${YN:-Y}
        case $YN in
            [Yy])
                echo "Proceeding..."
                return 0
                ;;
            [Nn])
                echo "Going Back..."
                sleep 0.5
                return 1
                ;;
            *)
                echo "Invalid Option!"
                ;;
        esac
    done
}

# Confirm user choices, but with less text
function yn-headless {
    while true; do
        read -p "(Y/n) > " YN
        YN=${YN:-Y}
        case $YN in
            [Yy])
                return 0
                ;;
            [Nn])
                return 1
                ;;
            *)
                echo "Invalid Option!"
                ;;
        esac
    done
}

# Change the hostname
function hostname_setup {
    NAME=$(cat /etc/hostname)
    echo "Your current hostname is $NAME. Do you still wish to change it?"
    yn
    if [ $? -eq 1 ]; then
        return
    fi
    echo "What hostname do you wish to use?"
    read -p "> " NAME
    # echo $NAME > /etc/hostname
    echo "Contents of '/etc/hostname':"
    cat /etc/hostname
    echo "Done! For any changes to take effect reboot or log out of your current user."
    read -p "Press any key to continue..."
    return
}

# Change the IP
function ip_setup {
    INT=$(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$' | tr '\n' ' ')
    read -p "What interface do you want to configure?($INT) " INT
    IP=$(ip -4 addr show $INT | awk '/inet / {print $2}' | cut -d'/' -f1)
    echo "The current IP of the interface $INT is $IP"
    echo "Do you wish to change it?"
    yn
    if [ $? -eq 1 ]; then
        return
    fi
    echo "Do you wish to enable DHCP4 on this inferface?"
    yn-headless
    if [ $? -eq 0 ]; then
        ip_dhcp
        return
    fi
    ip_static
    return
}

function ip_dhcp {
    # echo -e "network:\n  ethernets:\n    $INT:\n      dhcp4: true\n  version: 2" > /etc/netplan/00-installer-config.yaml
    echo "DHCP has been activated in the interface $INT! Applying Settings..."
    # netplan apply
    echo "Contents of '/etc/netplan/00-installer-config.yaml':"
    # cat /etc/netplan/00-installer-config.yaml
    echo "Done!"
    read -p "Press any key To continue..."
    return
}

function ip_static {
    read -p "Insert your IP Address (x.x.x.x/xx): " IP
    read -p "Insert your Default Gateway (x.x.x.x): " DEF
    read -p "Insert your Primary DNS Server (x.x.x.x): " DNS1
    read -p "Insert your Secundary DNS Server (x.x.x.x): " DNS2
    echo "Here's the configuration you inputted:"
    echo "IP Address: $IP"
    echo "Default Gateway: $DEF"
    echo "DNS Servers: $DNS1, $DNS2"
    echo ""
    echo "Do you wish to proceed?"
    yn
    if [ $? -eq 1 ]; then
        return
    fi
    # echo -e "network:\n  ethernets:\n    $INT:\n      addresses:\n      - $IP\n      gateway4: $DEF\n      nameservers:\n       addresses:\n       - $DNS1\n       - $DNS2\n       search: []\n  version: 2" > /etc/netplan/00-installer-config.yaml
    echo "The IP Address has been altered in the interface $INT! Applying Settings..."
    # netplan apply
    echo "Contents of '/etc/netplan/00-installer-config.yaml':"
    # cat /etc/netplan/00-installer-config.yaml
    echo "Done!"
    read -p "Press any key To continue..."
    return
}

function pbis_setup {
    echo "WARNING! You should change your hostname ($HOST) before you setup pbis, do you wish to continue?"
    yn
    if [ $? -eq 1 ]; then
        return
    fi
    read -p "What domain do you want to configure?: " DOMAIN
    echo "Testing connection..."
    if ping -c 4 $DOMAIN &> /dev/null; then
        echo "Ping Successfull!"
    else
        echo "Ping Unsuccessfull! Check if both machines have connection with each other and then try again."
        read -p "Press any key To continue..."
        return
    echo "Installing ntpdate..."
    If apt install -y ntpdate; then
        echo "Installation successfull"
    else
        echo "Installation Failed, make sure you have run apt update && apt upgrade -y and an internet connection."
        read -p "Press any key To continue..."
        return
    fi


}

function dhcp_setup {
    echo "To be implemented..."
    read -p "Press any key to continue..."
}

function dns_setup {
    echo "To be implemented..."
    read -p "Press any key to continue..."
}

function postfix_setup {
    echo "To be implemented..."
    read -p "Press any key to continue..."
}

function voip_setup {
    echo "To be implemented..."
    read -p "Press any key to continue..."
}

function samba_setup {
    echo "To be implemented..."
    read -p "Press any key to continue..."
}

function auto {
    echo "To be implemented..."
    read -p "Press any key to continue..."
}

function main {
    # Uncomment to only allow root to run this program.
    # if [ "$EUID" -ne 0 ]
    #   then echo "This program must be run as root."
    #   exit
    # fi
    clear
    echo "=========> Server Setup <========="
    echo "> What do you want to do?"
    echo "1) Hostname"
    echo "2) IP"
    echo "3) PBIS (ADDS)"
    echo "4) DHCP"
    echo "5) DNS"
    echo "6) POSTFIX"
    echo "7) VOIP"
    echo "8) SAMBA"
    echo "9) AUTO-SETUP"
    echo "10) Quit"
    echo ""
    read -p "> " OPT
}

while true; do
    main
    case $OPT in
        1)
            hostname_setup
            ;;
        2)
            ip_setup
            ;;
        3)
            pbis_setup
            ;;
        4)
            dhcp_setup
            ;;
        5)
            dns_setup
            ;;
        6)
            postfix_setup
            ;;
        7)
            voip_setup
            ;;
        8)
            samba_setup
            ;;
        9)
            auto
            ;;
        10)
            echo "Bye!"
            break
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done
