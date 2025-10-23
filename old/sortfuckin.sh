#!/bin/bash
# fiels
input_file=./test_sha1.tmp.txt
sorted_file=./test_SORTED_sha1.tmp.txt
backup_file=./bak/20251020_single_sha1.txt.7z
# lougs
info_log=./info_log.log
error_log=./error_log.log

# start da timer
echo "startin timer"
start=$(date +%s)

# do da magical sortfuck
echo "performin da magical sortfuck"
# awk '{val="0x" $1; print strtonum(val),$0 ;}' "$input_file" | sort -n -k 1 | sed 's/^[^ ]* //' > "$sorted_file" 2>> "$error_log"
awk '{val="0x" $1; print strtonum(val),$0 ;}' $input_file | sort -n -k 1 | sed 's/^[^ ]* //' > $sorted_file
echo "finished da magical sortfuck! retcode $?"

# end da timer and caluclate duratrion
echo "endin timer"
end=$(date +%s)
duration=$(($end - $start))
echo "sorted (in theoty) in $duration seconds"

# updoot da log
## can reuse dis in a function or sumshit
echo "loggin shit"
echo "$(date): $input_file sorted to $sorted_file in $duration seconds" | tee -a "$info_log"

# send silly webhookfuckin
echo "sendin webhookfuckin"
webhook "DILDO MACCARONI ITS FOOKAN DONE IN FOOKAN $duration SECONDS" true

# maek an backup
echo "maekan a backup"
7z a "$backup_file" "$input_file"

# mayhaps reboot
## 10 minute delay to make sure shit fucks
echo "doin an rebootasn in 10 mins or sumtin"
sudo shutdown -r +10 "REBOOTFUCKIN IN 10 MINS BITCH"
