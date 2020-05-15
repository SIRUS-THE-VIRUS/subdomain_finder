domain=$1

theHarvester -d $domain -b crtsh | grep $domain |sed "s/\:.*//" | grep $domain > subdomain_list.txt

for line in $(cat subdomain_list.txt)
do
        echo testing $line
        code=$(curl -o /dev/null --connect-timeout 5 --silent --head --write-out '%{http_code}\n' http://$line)

        if [ $code -eq "200" ] ||[ $code -eq "302" ] || [ $code -eq "301" ]
        then
                echo $line >> found.txt
        fi
done

cp found.txt eyewitnessIP.txt
rm found.txt
eyewitness --web -f eyewitnessIP.txt --no-prompt
