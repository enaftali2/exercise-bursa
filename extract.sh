#!/usr/bin/bash

# Display help message
show_help() {
    echo "Usage: extract [-h] [-r] [-v] file [file...]"
    echo "Unpacks multiple compressed files based on the actual file type."
    echo ""
    echo "Options:"
    echo "  -h    Show this help message and exit"
    echo "  -r    Recursive mode: process directories and their subdirectories"
    echo "  -v    Verbose mode: print details about processed files"
    echo ""
    echo "Supported formats: gzip, bzip2, zip, compress"
    exit 0
}

verbose=0
recursive=0
not_decompressed=0
decompressed=0

# Parse options
while getopts ":hrv" opt; do
    case "$opt" in
        h) show_help ;;
        r) recursive=1 ;;
        v) verbose=1 ;;
        ?) echo "Unknown option: -$OPTARG"; exit 1 ;;
    esac
done

# Shift arguments to remove parsed options
shift $((OPTIND - 1))

# Function to extract files
extract_file() {
    local file="$1"

    # Check if file exists
    if [[ ! -e "$file" ]]; then
        [[ $verbose -eq 1 ]] && echo "WARNING: File '$file' does not exist."
        ((not_decompressed++))
        return
    fi

    # Check if file is a directory
    if [[ -d "$file" ]]; then
        if [[ $recursive -eq 1 ]]; then
            [[ $verbose -eq 1 ]] && echo "Entering directory: $file"
            for f in "$file"/*; do
                extract_file "$f"
            done
        fi
        return
    fi

    # Determine file type
    file_type=$(file -b "$file")

    case "$file_type" in
        *gzip*)
            [[ $verbose -eq 1 ]] && echo "Decompressing: $file (gzip)"
            gunzip -f "$file" && ((decompressed++))
            ;;
        *bzip2*)
            [[ $verbose -eq 1 ]] && echo "Decompressing: $file (bzip2)"
            bunzip2 -f "$file" && ((decompressed++))
            ;;
        *Zip*)
            [[ $verbose -eq 1 ]] && echo "Decompressing: $file (zip)"
            unzip -o "$file" && ((decompressed++))
            ;;
        *compress*)
            [[ $verbose -eq 1 ]] && echo "Decompressing: $file (compress)"
            uncompress -f "$file" && ((decompressed++))
            ;;
        *)
            [[ $verbose -eq 1 ]] && echo "WARNING: '$file' is not a compressed file."
            ((not_decompressed++))
            ;;
    esac
}

# Process all files
if [[ $# -eq 0 ]]; then
    echo "ERROR: No files specified."
    show_help
fi

for file in "$@"; do
    extract_file "$file"
done

# Summary
[[ $verbose -eq 1 ]] && echo "Decompressed: $decompressed file(s)"
[[ $verbose -eq 1 ]] && echo "Skipped: $not_decompressed file(s)"
exit $not_decompressed
