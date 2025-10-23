# Notes
`hibp_sha1_dir` is a softlink to the latest haveibeenpwned sha1 multi-file dir `ln -s 20251019_haveibeenpwned_sha1 hibp_sha1_dir`  

## Prerequisites
### Packages
`sudo apt update && sudo apt install conv ripgrep byobu -y`
### haveibeenpwned-downloader
#### dotnet
**Dotnet Installer Links**  
* [Linux Install Main Page](https://learn.microsoft.com/en-us/dotnet/core/install/linux)
* [Debian Package Manager](https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian?tabs=dotnet9)
* [Linux Install Script](https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual)
todo: install script
    packages
    dotnet
        debian-like
        rhel-like
        fall back: manual install script
        haveibeenpwned-downloader
    maybe: dat stupid fuckoff cancer fuckin normalizefag
todo: install instr  
todo: bashrc fuckery  
todo: archive  
todo: script to delete earlier files and softlink downdoot da latest with auto date, create new softlink

## Downdootan from hibp
1. [Curl Method](https://github.com/HaveIBeenPwned/PwnedPasswordsDownloader/issues/79)
2. [PwnedPasswordsDownloader aka haveibeenpwned-downloader](https://github.com/HaveIBeenPwned/PwnedPasswordsDownloader)
### Commands
make da dirrr `mkdir "$(date +%Y%m%d)_haveibeenpwned_sha1"`  
downdoot single file: `haveibeenpwned-downloader "$(date +%Y%m%d)_haveibeenpwned_sha1".tmp`  
manual nuke files `rm -f $PWD/*_hibp_sha1.tmp.txt; rm -rf $PWD/*_haveibeenpwned_sha1`

### hibdpdl usage
todo: sanity checc thjessss
one file (./myfile.txt) sha1 `haveibeenpwned-downloader myfile` 
one file (./myfile.txt) ntlm `haveibeenpwned-downloader -n myfile`  
multiple files in dir (./mydir) sha1 `haveibeenpwned-downloader mydir -s false`  
multiple filse in dir (./mydir) ntlm `haveibeenpwned-downloader -n mydir -s false`

## Spitballing / Scratch
1. downdoot one larg fiel
2. loop through five hex chars uppercase exclusive
3. rg for those
4. output eachi to da proper fiel :3

ls -q 20251019_haveibeenpwned_sha1 | head
head 20251019_haveibeenpwned_sha1/00000.txt

## normalizztion
dis silly sort FOOKAN WORTKS??
`awk '{val="0x" $1; print strtonum(val),$0 ;}' $tmp_file | sort -n -k 1 | sed 's/^[^ ]* //' > "$sorted_file"`

timing vers wit webhookie
`start=$(date +%s); awk '{val="0x" $1; print strtonum(val),$0 ;}' $tmp_file | sort -n -k 1 | sed 's/^[^ ]* //' > "$sorted_file"; end=$(date +%s); duration=$(($end - $start)); echo "$duration seconds" | tee -a time_log.txt; webhook "DILDO MACCARONI ITS FOOKAN DONE IN FOOKAN $duration SECONDS" true`

