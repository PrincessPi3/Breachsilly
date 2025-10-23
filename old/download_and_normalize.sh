#!/bin/bash
# todo:
## auto byobu?

# to use  dis i need to do checks for the dfiles that cleanup_environ cleans
# set -e # stahp on any errpr

# all thos silly hex sillyvalues from 0x00000 to 0xFFFFF
# to be used to split the hibp sha1 file into multiple files
# each file containing all sha1 hashes starting with that sillyvalue
dec_max=1048575
start_val_hex=0x00000
end_val_hex=0xFFFFF
increment_hex=0x00001

# da file shit
timestamp=$(date +%Y%m%d)
# tmp file values
## this is the value fed to haveibeenpwned-downloader
## it automatically appends .txt to da filename
tmp_file="$PWD/${timestamp}_hibp_sha1.tmp"
## this is the txt file created by haveibeenpwned-downloader
tmp_file_txt="$tmp_file.txt"
new_dir="$PWD/${timestamp}_haveibeenpwned_sha1"
softlink_name="$PWD/hibp_sha1_dir"
softlink_target="$new_dir"

setup_environ () {
    # cleanup environment
    # fail quietly if no such files/dirs exist
    ## nuek any temp files
    # rm -f $PWD/*_hibp_sha1.tmp.txt 2>/dev/null
    ## delet any old hibp sha1 dirs
    # rm -rf $PWD/*_haveibeenpwned_sha1 2>/dev/null

    # make new dir for new hibp sha1 files
    mkdir -p "$new_dir" # exit quietly if exists
}

finish_cleanup () {
    # nuke da temp file
    rm  -f "$tmp_file_txt"
    # reboot in 2 mins to clear any cached
    sudo shutdown -r +2
}

downdoot_file () {
    # downdoot da fuckin file
    haveibeenpwned-downloader "$tmp_file"
}

# fuckin do the hell
do_the_fucking_split () {
    # loop throught a bajuilli9opn fuckin numbs for hex bitch
    for((i=0; i<=$dec_max; i++)) {
        current_hex=$(printf "0x%05X" $i)
        echo "$current_hex"

        # do da fuckin hunt and shit fuckbitchfuck
        rg --no-line-number "^$current_hex" "$tmp_file_txt" > "$new_dir/$current_hex.txt"
    }
}

post_process_files () {
    # softlink
    # s softlink, f force overwrite existing softlink, n no dereference treat as dir
    ln -sfn "$softlink_target" "$softlink_name"
}

setup_environ
downdoot_file
do_the_fucking_split
post_process_files
# finish_cleanup