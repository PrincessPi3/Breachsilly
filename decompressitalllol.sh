bin/bash

# safer bash behaviour
set -euo pipefail
IFS=$'\n\t'

# todo
## test da shit
## x output to output dir
## non-interactive modes on decompress
## handle name conflicts
## handle password protected archives
## handle nested archives
## handle more archive types
## log more info
### tee current status to stdout and a log file with timestamps
## get file encoding, size, type of output and log
## generalize so i can use it in any dir
## cmdline options for various modes
## archive testing where possible
## final output to another dir
### function to normalize file encoding to whatever haveibeenpwned expects (utgf-8?)
### recursive flattem da good files to a single dir
## frick i ahve to delete the originaal files after backing up and decompressing them
## because it'll break da recursive shit igg
## fuuuuck gonna have to sha1sum every fuckin file  with the file list at all stages of decompression
### must document da info to prevent redundant effortt :pensiveanimated:
### actually check what will be includede with torrents see if can use dat hash algo?
## add package list

backup=./backup_file # backups of the archives
log_dir=./logs # logs
out_dir=/mnt/e/Breachsilly_Normalized # where the decomressed and normalizerd files go
iterations=3 # recursive decompress levels (can override via env var ITERATIONS)
ingress=/mnt/e/Breachsilly_Ingress # can override via env var INGRESS (use WSL-style path)

timestamp=$(date +%Y%m%d_%H%M%S)
error_log="$log_dir/decompressitalllol_error_$timestamp.log"
file_extensions="$log_dir/file_extensions_$timestamp.txt"
file_tree="$log_dir/file_tree_$timestamp.txt"
file_types="$log_dir/file_types_$timestamp.txt"

# setup
setup_silly () {
    ## maek da dirsa
    mkdir -p "$backup/tar.gz"
    mkdir -p "$backup/tar.bz2"
    mkdir -p "$backup/tar.xz"
    mkdir -p "$backup/gz"
    mkdir -p "$backup/bz2"
    mkdir -p "$backup/tar"
    mkdir -p "$backup/rar"
    mkdir -p "$backup/zip"
    mkdir -p "$backup/7z"
    mkdir -p "$backup/xz"
    mkdir -p "$log_dir"
    mkdir -p "$out_dir"
    mkdir -p "$ingress"
}

# setup silly/get info
info_silly () {
    ## get a list of da file extensions
    rm -f ext.tmp || true
    while IFS= read -r -d '' f; do
        # use basename to avoid full path issues
        b="$(basename "$f")"
        # only print if there's a dot
        if [[ "$b" == *.* ]]; then
            echo "${b##*.}" >> ext.tmp
        fi
    done < <(find "$ingress" -type f -print0 2>>"$error_log")
    sort -u ext.tmp > "$file_extensions" 2>>"$error_log" || true
    rm -f ext.tmp 2>>"$error_log" || true

    ## get a list of da filetypes and encodings
    : > "$file_types"
    while IFS= read -r -d '' f; do
        file --mime-type --mime-encoding "$f" >> "$file_types" 2>>"$error_log" || true
    done < <(find "$ingress" -type f -print0 2>>"$error_log")

    ## get a simple file tree
    tree "$ingress" > "$file_tree" 2>>"$error_log" || true
}

# backup all da extant archive doots
backup_silly () {
    # get da tree and file info and suc h
    info_silly
    ## tar.gz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.gz" -print -exec cp -v {} "$backup/tar.gz/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## tar.bz2
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.bz2" -print -exec cp -v {} "$backup/tar.bz2/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## tar.xz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.xz" -print -exec cp -v {} "$backup/tar.xz/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## gz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.gz" -print -exec cp -v {} "$backup/gz/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## bz2
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.bz2" -print -exec cp -v {} "$backup/bz2/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## tar
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar" -print -exec cp -v {} "$backup/tar/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## rar
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.rar" -print -exec cp -v {} "$backup/rar/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## zip
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.zip" -print -exec cp -v {} "$backup/zip/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## 7z
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.7z" -print -exec cp -v {} "$backup/7z/" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## xz
    find $ingress \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -iname "*.xz" -print -exec cp {} "$backup/xz" 2>>"$error_log" \;  -delete 2>>"$error_log"
}

# recursively decompress all da things to pwd
decompress_silly () {
    ## do all the tar.x ones first to prevent issues
    ### tar.gz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.gz" -print -exec tar -xvzf "{}" -C "$out_dir" 2>>"$error_log" \; -delete 2>>"$error_log"
    ### tar.bz2
    find $ingress \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -iname "*.tar.bz2" -print -exec tar -xvjf "{}" -C "$out_dir" 2>>"$error_log" \; -delete 2>>"$error_log"
    ### tar.xz
    find $ingress \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -iname "*.tar.xz" -print -exec tar -xvJf "{}" -C "$out_dir" 2>>"$error_log" \; -delete 2>>"$error_log"
    ## now do the rest
    ### gz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.gz" -print -exec bash -c 'f="$1"; out="$2"; gzip -dc "$f" > "${out}/$(basename "${f%.gz}")"' _ {} "$out_dir" 2>>"$error_log" \; 2>>"$error_log"
    ### bz2
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.bz2" -print -exec bash -c 'f="$1"; out="$2"; bunzip2 -c "$f" > "${out}/$(basename "${f%.bz2}")"' _ {} "$out_dir" 2>>"$error_log" \; 2>>"$error_log"
    ### tar
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar" -print -exec tar -xvf "{}" -C "$out_dir" 2>>"$error_log" \; 2>>"$error_log"
    ### rar
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.rar" -print -exec unrar x -o+ "{}" "$out_dir" 2>>"$error_log" \; 2>>"$error_log"
    ### zip
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.zip" -print -exec unzip -o -d "$out_dir" "{}" 2>>"$error_log" \; 2>>"$error_log"
    ### 7z
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.7z" -print -exec 7z x "{}" -o"$out_dir" 2>>"$error_log" \; 2>>"$error_log"
    ### xz
    ### test dis
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.xz" -print -exec bash -c 'f="$1"; out="$2"; unxz -c "$f" > "${out}/$(basename "$f")"' _ {} "$out_dir" 2>>"$error_log" \; 2>>"$error_log"
}

# mvoe  extracted useful loookingh files to $out_dir
move_silly () {
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -type f \( -name "*.txt" -o -name "*sql" -o -name "*csv" \) -print0 | while IFS= read -r -d '' f; do
        mv -v "$f" "$out_dir/" 2>>"$error_log" || true
    done
}

# delete da originaal archives
delete_silly () {
    ## tar.gz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.gz" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## tar.bz2
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.bz2" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## tar.xz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar.xz" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## gz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.gz" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## bz2
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.bz2" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## tar
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.tar" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## rar
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.rar" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## zip
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.zip" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## 7z
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.7z" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
    ## xz
    find "$ingress" \( -path "$backup" -o -path "$log_dir" -o -path "$out_dir" -o -path "./.git" \) -prune -o -iname "*.xz" -print -exec rm -v {} 2>>"$error_log" \; 2>>"$error_log"
}

compress_silly () {
    # compress the normalized files with 7z
    # except RockYou2024.txt and Princess_Pi*txt which are compressed with gzip
    # deletes the uncompressed output files
    ## these are done with gzip because that's the compression that hashcat supports
    # gzip specific known files if they exist
    for f in "PrincessPiV8.txt" "PrincessPi_Rules_Dictionary_2.5.txt" "RockYou2024.txt"; do
        if [[ -f "$out_dir/$f" ]]; then
            gzip -9 -v "$out_dir/$f" 2>>"$error_log" || true
        fi
    done

    # Pack remaining files (excluding already-gzipped) into a single 7z archive
    target_archive="$out_dir/normalized.7z"
    rm -f "$target_archive" || true
    find "$out_dir" -type f ! -name '*.gz' -print0 | xargs -0 -I{} 7z a -t7z "$target_archive" "{}" 2>>"$error_log" || true
    # clean up uncompressed fiies
    # delete_silly
}

# run da functinoszzz
setup_silly

# backup_silly

# decompression option
for((i=0; i<$iterations; i++)) {
    info_silly
    decompress_silly
}

# move wanted files to output dir
move_silly

# decompression option
# delete_silly

# compression option
# compress_silly
