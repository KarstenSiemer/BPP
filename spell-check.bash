#!/usr/bin/env bash

readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly NC='\033[0m' # No Color

for file in $(find . -type f -name "*.tex");
        # Pass each .md file through aspell.
        do output=$(cat "${file}" | aspell --lang=de -t list);
        if [[ $? != 0 ]]; then
                echo -e "${RED}Error found in output${NC}, cannot continue. Please check manually for aspell -c $file?"
                exit 1
        elif [[ $output ]]; then
                echo -e "-> ${RED}Spelling errors found${NC} <-"
                echo -e "${YELLOW}$output${NC}" |sort -u
                echo "Please check with: aspell -c $file"
                bad="yes"
                good="yes"
        fi
done

# Matched in aspell
if [[ "$bad" == "yes" ]]; then
        exit 1
fi

# No match in aspell
if [[ "$good" == "yes" ]]; then
        echo -e "Spelling check is ${RED}OK${NC}, good to go."
        exit 0
fi
