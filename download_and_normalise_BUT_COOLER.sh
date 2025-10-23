#!/bin/bash
set -e # dont waste my asstime if errros bitch
# da timestiampppy liek 20251020
timestamp=$(date +%Y%m%d)
# lougs
info_log=./info_log.log
error_log=./error_log.log
# fiels
## this is both the downloaded fiel and da file to sort
## da fuckin genetal wards dotnet app auto appends .txt to the file name jesus fuck
download_file="lists/${timestamp}_sorted_download_single_sha1" # again no txt because the dotnet app is a form of sexually transmitted infectoion
    # count total lines for progress tracking
    echo "countin total lines..." | tee -a "$info_log"
    total_lines=$(wc -l < "$download_file.txt")
    echo "total lines to process: $total_lines" | tee -a "$info_log"
    
    # for progress updates every 1%
    update_interval=$((total_lines / 100))
    [[ $update_interval -lt 1 ]] && update_interval=1
    last_update=0
    processed_lines=0
softlink_name=./hibp_list
# backup_file=bak/test_sorted_single_sha1.tmp.txt.7z # donut need dis oc unless bein stoopd wit da backup ig

# ig measure how long each fluttercum takes for fun idk
time_it () {
    echo "startin timer"
    start=$(date +%s)
    echo "runnan $1 at $(date)"
    eval "$1" 2>>"$error_log" # also make sure to get dem errorz if dey cum
    echo "done runnan $1 at $(date)"
    end=$(date +%s)
    duration=$(($end - $start))
    echo "$(date): finished $1 in $duration seconds" | tee -a "$info_log"
}

break_apart () {
    # break the sortd file in ./lists into individual txt files named for the first five characters of the hashes
    echo "breakin apart da sorted fiel into smol pieces" | tee -a "$info_log"
    
    # make sure hibp_sha1_dir exists and is empty
    mkdir -p hibp_sha1_dir
    rm -f hibp_sha1_dir/*.txt 2>>"$error_log"
        ((processed_lines++))
        
        # show progress every 1% or 100k lines
        if ((processed_lines - last_update >= update_interval)); then
            percent=$((processed_lines * 100 / total_lines))
            echo "processed $processed_lines / $total_lines lines ($percent%)" | tee -a "$info_log"
            last_update=$processed_lines
        fi
    
    # read da big file line by line and split by first 5 chars
    # use a buffer to reduce disk writes - only write when prefix changes or buffer gets big
    current_prefix=""
    buffer=""
    buffer_size=0
    max_buffer=10000
    
    while IFS= read -r line; do
        # get first 5 chars of the hash
    echo "finished! processed $total_lines lines into $file_count files in hibp_sha1_dir" | tee -a "$info_log"
        
        # if prefix changed or buffer full, write the current buffer
        if [[ "$prefix" != "$current_prefix" ]] || ((buffer_size >= max_buffer)); then
            if [[ -n "$current_prefix" && -n "$buffer" ]]; then
                echo -n "$buffer" > "hibp_sha1_dir/${current_prefix}.txt"
                buffer=""
                buffer_size=0
            fi
            current_prefix="$prefix"
        fi
        
        # add to buffer
        buffer+="${line}\n"
        ((buffer_size++))
        
    done < "$download_file.txt"
    
    # write final buffer if any
    if [[ -n "$current_prefix" && -n "$buffer" ]]; then
        echo -n "$buffer" > "hibp_sha1_dir/${current_prefix}.txt"
    fi
    
    # count how many files we made
    file_count=$(find hibp_sha1_dir -type f -name "*.txt" | wc -l)
    echo "made $file_count files in hibp_sha1_dir" | tee -a "$info_log"
}

compress_run_silly () {
    # compress the files in ./lists  to one 7z archive
    7z a ./hibp_sha1_individual_sorted_$timestamp.7z hibp_sha1_dir
}

echo "startan scripty at $(date)"

# check for remaining bitchtxt and kill them if found >:34
if [ -f lists/*.txt ]; then
    echo "i fonud sum txts in the lists dir, im nuken em lmao, list beloow" | tee -a $info_log
    ls -la lists/*.txt | tee -a $info_log
    rm -f lists/*.txt 2>> $error_log
fi

# do da same for dat silly soft linkl :pope:
if [ -f $softlink_name ]; then
    echo "fonud softline $softlink_name nukin it" | tee -a $info_log
    rm -f $softlink_name 2>> $error_log
fi

# download da silly thing
echo "startan downdoot"
time_it "haveibeenpwned-downloader $download_file"

# sort it good jus to maek sure
## dis silly widdle scrript sorts da file in place :3
## it ver silly :3
echo "startin da sortfuck"
time_it "awk '{val=\"0x\" \$1; print strtonum(val),\$0 ;}' $download_file.txt | sort -n -k 1 | sed 's/^[^ ]* //'"

# break da file into smol pieces by hash prefix
time_it "break_apart"

# zip em up heuhuehue
compress_run_silly

# nao we maek dat convenient softlinkie
# s softlink, f force overwrite existing softlink, n no dereference treat as dir
# ls -sfn $download_file $softlink_name 2>> $error_log # for dir
ls -sf $download_file $softlink_name 2>> $error_log # for file

# donut do dis when little space it get mad as fuck
# 7z backup
# echo "bakkan it up ig"
# time_it "7z a $backup_file $download_file.txt"

# send silly webhookfuckin
echo "sendin webhookfuckin"
webhook "DILDO MACCARONI ITS FOOKAN DONE at $(date)" true

# mayhaps reboot
## 1 minute delay to make sure shit fucks
echo "doin an rebootasn in an 1 mins or sumtin"
sudo shutdown -r +1 "REBOOTFUCKIN IN 10 MINS BITCH"

echo ":awooo: done :3"
