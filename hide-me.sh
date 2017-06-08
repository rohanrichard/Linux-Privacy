#!/bin/bash
#	Hiding yourself with this script;
#	you can hide yourself with the following options
#	options are:
#		* Fake MAC Changer
#		* Torghost
#		* IP location details
#		* Open DNS Configuration 
MainMenu=$(clear 
	echo -e  "\033[1;32m\n--------------------------------"
	echo -e  "\033[1;32m|     	    Main Menu	       |"
	echo -e  "\033[1;32m--------------------------------\n"
	echo -e  "\033[1;33m1.) MAC changer"
	echo -e  "\033[1;33m2.) Tor Routing"
	echo -e  "\033[1;33m3.) IP Location Details"
	echo -e  "\033[1;33m4.) Open DNS Configuration"
	echo -e  "\033[1;33m5.) Exit\n")
while : 
do
	echo "$MainMenu"
	
	read -p "Enter your Choice [1-5]: " choice

case $choice in
	1)
		clear 
		echo -e  "\033[1;32m---------------------------------"
		echo -e  "\033[1;32m|	  Fake MAC Changer      |"
		echo -e  "\033[1;32m---------------------------------\n"
		echo -e  "\033[1;33mAvailable Networks:-\n"
		ln=$(nmcli d | wc -l)

		for (( i=2; i <= $ln; i++))
			do 
				t[$i]=$(nmcli d | sed -n "$i"p | awk '{print $1}')
				line=$((i-1))
				echo -e "\033[1;35m$line).  ${t[$i]}\n"
		done

		hexc="0123456789ABCDEF"
		end=$(for i in {1..10}; 
			do echo -n ${hexc:$(($RANDOM %16)):1};
			done | sed -e 's/\(..\)/:\1/g')
		MAC=00$end

		read -p "Enter your choice-> " n

		echo -e "\033[1;36m\n[*] Shuting down ${t[$((n+1))]}..."
		service network-manager stop
		ifconfig ${t[$((n+1))]} down
		echo -e "\033[1;36m[*] Changing MAC for ${t[$((n+1))]}..."
		ifconfig ${t[$((n+1))]} hw ether $MAC
		ifconfig ${t[$((n+1))]} up
		echo -e "\033[1;36m[*] Restart the ${t[$((n+1))]} and Network Manager..."
		service network-manager start

		echo -e "\033[1;36m[*] New MAC Address: \033[1;31m[ $MAC ]\n"
		echo -e "\033[1;33m"
		read -p "[ Press ENTER key to go Main menu ]"
		echo "$MainMenu"
	;;
	2)
		clear
	 
		read -p "To start(Press 1), To stop(Press 2) " n
			case $n in
			1)	torghost start;;
			2)	torghost stop;;
			esac
		echo -e "\033[1;33m"
		read -p "[ Press ENTER key to go Main menu ]"
		echo "$MainMenu"		
		
	
	;;
	3)
		clear
		wget -q --spider http://ip-api.com/line

		if [ $? -eq 0 ]; then
			clear
			echo -e "\033[1;32m\n[*] fetching data...\n"

			data=$(curl -s  ip-api.com/line)
			country=$(echo "$data" | awk 'FNR == 2{ print $1}')
			region=$(echo "$data" | awk 'FNR == 5{ print $1}')
			city=$(echo "$data" | awk 'FNR == 6{ print $1}')
			isp=$(echo "$data" | awk 'FNR == 11{ print $1}')
			org=$(echo "$data" | awk 'FNR == 12{ print $1}')
			time=$(echo "$data" | awk 'FNR == 10{ print $1}')
			lat=$(echo "$data" | awk 'FNR == 8{ print $1}')
			lon=$(echo "$data" | awk 'FNR == 9{ print $1}')
			ip=$(echo "$data" | awk 'FNR == 14{ print $1}')

			clear

			echo -e "\033[1;32mYour IP Location details:-"
			echo ""

			echo -e "\033[1;34mIPaddress:	\033[1;31m[$ip]"
			echo -e "\033[1;34mCountry:	\033[1;32m$country"
			echo -e "\033[1;34mRegion:		\033[1;32m$region"
			echo -e "\033[1;34mCity:		\033[1;32m$city"
			echo -e "\033[1;34mISP:		\033[1;33m$isp"
			echo -e "\033[1;34mOrganisation:	\033[1;33m$org"
			echo -e "\033[1;34mLocation:	\033[1;36m$lat , $lon"
			echo -e "\033[1;34mTime Zone:	\033[1;36m$time"
			echo -e "\n"
			read -p "[ Press ENTER key to go Main menu ]"
			echo -e "\033[1;33m"
			echo "$MainMenu"
		else
			echo -e "\nOffline\n"
			echo -e "\033[1;33m"
			read -p "[ Press ENTER key to go Main menu ]"
			echo "$MainMenu"
		fi 
		
	;;
	4)
			clear
			echo -e "nameserver 127.0.0.1\nnameserver 208.67.222.222\nnameserver 208.67.220.220\n" >/etc/resolv.conf
			dns=$(cat /etc/resolv.conf | awk '{print $1 , $2}')
			echo -e  "\033[1;32m\n--------------------------------"
			echo -e  "\033[1;32m|     Open DNS Configuration   |"
			echo -e  "\033[1;32m--------------------------------\n"
			echo -e "\033[1;35m\n$dns\n"
			echo -e "\033[1;33m"
			read -p "[ Press ENTER key to go Main menu ]"
			echo "$MainMenu"
	;;
	5)
			clear			
			exit
	;;
esac
done 
