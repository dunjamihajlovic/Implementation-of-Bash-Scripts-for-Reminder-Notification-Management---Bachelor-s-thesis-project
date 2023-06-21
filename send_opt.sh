#!/bin/bash

remote_user="ubuntu" #korisnicko ime udaljenog korisnika
remote_host="192.168.1.21"  #ip adresa udaljenog korisnika ili DNS 
send_local=false
send_remote=false

local_notify() {                #slanje notifikacije samo na lokalni racunar
    notify-send "$naziv" "$opis"        
}
remote_notify() {               #slanje notifikacije samo na udaljeni racunar
    ssh "$remote_user@$remote_host" "notify-send \"$naziv\" \"$opis\""
}

while getopts "lr" opcija; do       #biranje opcija -r, -l, -rl/lr (podrazumevano)
    case $opcija in
        l) send_local=true  ;;
        r) send_remote=true  ;;
        *) echo "Neispravna opcija"
            exit 1  ;;
    esac
done

while true; do
    while IFS= read -r red; do
        vreme_notifikacije=$(echo "$red" | cut -d "|" -f1)   #vreme notifikacije je u prvoj koloni fajla
        trenutno_vreme=$(date +%H:%M)

        if [[ $trenutno_vreme == $vreme_notifikacije ]]; then  #proveravanje da li je vreme za slanje notifikacije
            
            naziv=$(echo "$red" | cut -d "|" -f2,3 | sed 's/|/-/') #spajanje 2. i 3. kolone fajla -> hh:mm-NAZIV
            opis=$(echo "$red" | cut -d "|" -f4)
            
            if $send_local; then
                local_notify
            fi
            
            if $send_remote; then
                remote_notify
            fi
            
            if [[ ! $send_remote && ! $send_local ]]; then
                remote_notify
                local_notify
            fi
        
        fi
    done < podsetnik.txt

    sleep 60  #ponavlja se nakon 1 minuta (moze i manje)
done &
