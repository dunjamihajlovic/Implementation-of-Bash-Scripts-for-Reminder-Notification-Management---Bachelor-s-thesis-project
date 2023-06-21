#!/bin/bash

provera_vreme() {

pattern="^([01]?[0-9]|2[0-3]):[0-5][0-9]$"

if [[ ! $1 =~ $pattern ]]; then
    echo "Greska: Pogresan format vremena"
    exit 1
fi 
}

provera() {
if [ -z "$1" ]; then
      	echo "Greska! Nije unet trazeni podatak" 
	exit 1
 fi
}

function dodaj() { 
      read -rp "Naziv podsetnika  " naziv    
      		provera $naziv
      read -rp "Opis podsetnika  " opis  #opciono
      read -p "Vreme (hh:mm)  " vreme ;                   
       		provera_vreme $vreme
      read -p "Vreme notifikacije (hh:mm)  " vreme_notif 
      		provera_vreme $vreme_notif

      	red="$vreme_notif|$vreme|$naziv|$opis"   # konstruisanje reda za podsetnik
        echo "$red" >> podsetnik.txt   # ubacivanje reda u podsetnik.txt
        echo "Podsetnik uspesno dodat."	
       }
      
function obrisi(){
	read -rp "Naziv podsetnika koji treba obrisati   " naziv
   		provera $naziv
      	awk -F "|" -v rec="$naziv" 'tolower($3) == tolower(rec) { next } { print }' podsetnik.txt > tmp.txt
	mv tmp.txt podsetnik.txt
	echo "Podsetnik uspesno obrisan"
 }

echo "1 - dodaj podsetnik"
echo "2 - obrisi podsetnik"
echo "3 - pregled svih podsetnika"
while true ; do
	read -p "Izaberite opciju (ili upisite 4 za izlaz): " opcija

	case $opcija in
	   4) break   ;;
	   1) dodaj   ;;
	   2) obrisi  ;;
	   3) cat podsetnik.txt  ;;
	   *) echo "Neispravan unos."
	    continue  ;;
	 esac
done
