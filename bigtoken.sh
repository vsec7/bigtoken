#!/usr/bin/env bash
# BIGTOKEN AUTO REGISTER & VERIFICATION
# By Versailles / Viloid
# Sec7or Team ~ Surabaya Hacker Link

randEmail(){
	g=$(curl -s https://api.randomuser.me)
	f=$(echo $g | grep -oP '"first":"\K[^"]+')
	l=$(echo $g | grep -oP '"last":"\K[^"]+')
	r=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 4 | head -n 1)
	d=$(shuf domain.txt | head -1)
	echo "$f$l$r@$d"
}

createEmail(){
	IFS=’@’ read -ra em <<< "$1" 
	email=$(curl -sL 'https://generator.email/email-generator' -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Mobile Safari/537.36' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9,id;q=0.8,ru;q=0.7' -H 'cookie: _ga=GA1.2.478631938.1554524565; _gid=GA1.2.1981074516.1554524565; embx=%5B%228xo1r0ypjg%4050sale.edu.vn%22%5D; _gat=1; surl='${em[1]}'/'${em[0]}'/; io=bVgPRZpIdrnzzbrzBtYJ' --compressed)
	echo $email
}

readEmail(){
	IFS=’@’ read -ra em <<< "$1" 
	email=$(curl -sL 'https://generator.email/' -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Mobile Safari/537.36' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9,id;q=0.8,ru;q=0.7' -H 'cookie: _ga=GA1.2.478631938.1554524565; _gid=GA1.2.1981074516.1554524565; embx=%5B%22'${em[0]}'%4050'${em[1]}'%22%5D; _gat=1; surl='${em[1]}'%2F'${em[0]}'/; io=bVgPRZpIdrnzzbrzBtYJ' --compressed)
	echo $email
}

Regist(){
	reg=$(curl -s -H "Accept: application/json" https://api.bigtoken.com/signup -d "email=$1&password=K@r1nc@n5&referral_id=$2&monetize=1")
	echo $reg
}

Verif(){
	verif=$(curl -s -H "Accept: application/json" https://api.bigtoken.com/signup/email-verification -d "email=$1&verification_code=$2")
	echo $verif
}

bigtoken(){
	e=$(randEmail)
	echo "[+] Creating Email : $e"
	create=$(createEmail "$e")
	reg=$(Regist "$e" $1 | grep -oP '"user_id":\K[^,]+')
	if [[ -z $reg ]];then
		echo "[-] Register Failed"
	else
		echo "[+] Success Register user_id : $reg"
		echo -n "[+] Waiting $2s Fetch Token... "
		sleep $2
		toket=$(readEmail "$e" | grep -oP '(?<=verify%3Fcode%3D).*?(?=%26type%3D)' | head -1)
		if [[ -z $toket ]];then
			echo "[ Failed ]"
			echo "https://generator.email/$e" >> unverif.txt
			echo "[!] Manual Verify if Available [ Logs : unverif.txt ]"
		else
			echo "[ Success ]"
			verif=$(Verif "$e" "$toket" | grep -oP '"reward":\K[^,]+')
			if [[ "$verif" == "true" ]];then
				echo "[+] Verification Success"
			else
				echo "[-] Verification Failed"
			fi
		fi
	fi
echo
}

ref="" 		# Code Referal kamu
waitingCheckInbox="60" 	# 60s / 1 menit Waktu tunggu untuk membaca inbox

cat <<EOF

+-------------------------------------------------+
|	BIGTOKEN AUTO REGISTER & VERIFICATION
|		By Versailles <3 Cans21
+-------------------------------------------------+

EOF

if [ -f "domain.txt" ]; then
	while :;do
		bigtoken $ref $waitingCheckInbox
	done
else
	echo "Create list EmailGenerator Domain in file named 'domain.txt'"
fi
