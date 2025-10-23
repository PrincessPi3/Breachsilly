# Roadmap
## Sources
todo: links and torrents
todo: log all acquired leaks/files

## Decompression and Localiztion
decompressitalllol.sh
    log all da info
    recursively decompress to a new dir
    decompress da files in dat dir (for recursive compressions)
    log all da new file info
    find all da good files and move them into a final output dir

## Normalization
todo:
    do a best to make tooling to make this a bit less manual
        convert encoding to whatever haveibeenpwned expects for sha1
        remove duplicates
    output
        sql?

## Checking
test them against haveibeenpwned sha1 list
    sanity checks
    sha1 encoden each entry
    check against list
    output matches with the sha1 to good output file
    log non-matching files to non-matching output file
ntlm list too? idk if its different data

## Cracking Haveibeenpwned remainders
    aws gpu node
        hashcat
            todo: define mixed attacks