#!/usr/bin/env bash
figlet "Recon Tool"

domainName=""

# DOMAIN ENUMERATION - Adding In-Scope Assets/Domains to the domains.txt file to be fed into subdomain finder.
for arg in "$@"; do
    domainName="$arg "
    echo $domainName | anew domains.txt
done

# SUBDOMAIN ENUMERATION - Running Subfinder, sublist3r, amass

echo "INITIATING SCOPE DISCOVERY..."
echo "PERFORMING SUBDOMAIN ENUMERATION..."
sleep 3
#SUBFINDER
subfinder -dL domains.txt -all -recursive -silent -o subdomains.txt

#PROBING SUBDOMAINS TO GET FUNCTIONAL URLs
echo "PROBING SUBDOMAINS TO GET VALID URLS..."
sleep 3
cat subdomains.txt | httprobe -c 20 | anew urls.txt

echo "SCOPE DISCOVERY COMPLETED!!!!!!"

echo "INITIATING RECONNAISSANCE..."
sleep 3

echo "WHAT POTENTIAL VULNERABILITY ARE YOU LOOKING FOR?"
echo "1: SUBDOMAIN TAKEOVER"
echo "2: INJECTION ATTACKS"
echo "3: (IN PROD)"

read vulnNumber

if [ $vulnNumber -eq 1 ]; then
	echo "SUBDOMAIN TAKEOVER RECON..."
	echo "DEEP FILTERING PREVIOUSLY PROBED URLS..."
	sleep 3
	
	cat urls.txt | httpx -nc -silent -mc 200,400,403,404 | anew dnsurlstatuscodes.txt

	sed -i 's/htt//g' dnsurlstatuscodes.txt
	sed -i 's/p//g' dnsurlstatuscodes.txt
	sed -i 's/s//' dnsurlstatuscodes.txt
	sed -i 's\://\\' dnsurlstatuscodes.txt

	subdomainFile="dnsurlstatuscodes.txt"
	while read line;
	do 
		echo "Performing DNS RECON on " $line && subdomainName=$line && dnsrecon -d $subdomainName | grep -e "CNAME" -e "SOA" -e "A" -e "NS" | anew dns1nfo.txt
	done < "$subdomainFile"
	sleep 3
	echo "Created file dns1nfo.txt with extracted DNS information..."
	
fi


#create an algorithm to detect input fields by using curl to check for potential XSS injection, SQLi vuln., etc. <In-Progress>

