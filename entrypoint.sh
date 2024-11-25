#!/usr/bin/env bash

setup_key() {
    # Copy the key
    echo "$INPUT_KEY" > key
    chmod 400 key
}

deploy_scp() {
    result=

    remote_dir="$INPUT_REMOTE_DIR"
    if [ "$remote_dir" = "~" ]; then
        remote_dir="/home/$INPUT_USERNAME/"
    else
        ssh -i key -o "StrictHostKeyChecking no" -p $INPUT_PORT "$INPUT_USERNAME"@"$INPUT_HOST" "mkdir -p ${remote_dir}/"
        
        result="$?"

        if [ "$result" != "0" ]; then
            return "$result"
        fi
    fi
    
    recursive=""
    if [ "$INPUT_RECURSIVE" = "true" ]; then
        recursive="-r"
    fi
    
    # Copy the file
    scp $recursive -i key -o "StrictHostKeyChecking no" -P $INPUT_PORT "$INPUT_SOURCE" "$INPUT_USERNAME"@"$INPUT_HOST":$remote_dir

    result="$?"

    return "$result"
}

clean_run() {
    cat /dev/null > ~/.bash_history
    rm -f key
}

main() {
    setup_key
    deploy_scp
    result="$?"
    clean_run

    return $result
}

main
exit "$?"