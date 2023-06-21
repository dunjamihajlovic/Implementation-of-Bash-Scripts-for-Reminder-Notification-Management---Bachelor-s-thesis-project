#!/bin/bash

while true; do    
   
    while IFS= read -r red; do
        vreme_notifikacije=$(echo "$red" | cut -d "|" -f1) 
                                              
        trenutno_vreme=$(date +%H:%M)
        
        if [[ $trenutno_vreme == $vreme_notifikacije ]]; then
        	naziv=$(echo "$red" | cut -d "|" -f2,3 | sed 's/|/-/')
        	opis=$(echo "$red" | cut -d "|" -f4)   
        	notify-send "$naziv" "$opis"   
        fi
        
    done < podsetnik.txt
sleep 60 
done &   
    
 
