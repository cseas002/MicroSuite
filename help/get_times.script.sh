#!/bin/bash

cd ../results

touch all_results.txt
for file in *
do
    printf "$file:\n" >> all_results.txt
    python3 ../help/get_statistics_from_file.py $file >> all_results.txt
    printf "\n\n" >> all_results.txt
done
