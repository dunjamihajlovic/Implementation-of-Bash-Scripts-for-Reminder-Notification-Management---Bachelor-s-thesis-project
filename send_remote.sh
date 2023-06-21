#!/bin/bash 

remote_user="ubuntu" #ime udaljenog korisnika
remote_host="192.168.1.16" #IP adresa korisnika 

while true ; do
   
    while IFS= read -r red; do
        vreme_notifikacije=$(echo "$red" | cut -d "|" -f1)
        naziv=$(echo "$red" | cut -d "|" -f2,3 | sed 's/|/-/')
        opis=$(echo "$red" | cut -d "|" -f4)
        
        trenutno_vreme=$(date +%H:%M)
        
	if [[ $trenutno_vreme == $vreme_notifikacije ]]; then

	    ssh $remote_user@$remote_host "notify-send \" $naziv \" \"$opis\"" 
        fi
        
    done < podsetnik.txt
    
sleep 60
done &
