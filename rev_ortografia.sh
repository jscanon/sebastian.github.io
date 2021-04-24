#!/usr/bin/env bash

echo "Procesando pre-commit"
echo ""
echo "Autor :  $GIT_AUTHOR_NAME"
echo "Email :  $GIT_AUTHOR_EMAIL"
echo ""

#!/bin/bash
changed=$(git diff --cached --name-status | grep -v '^D' |grep .md | awk '{print $2}')
echo $changed
errorFile=spellingErrors.txt
touch $errorFile
echo -n "" > $errorFile
for f in $changed
do
	echo "-----------------" >> $errorFile
	echo "$f" >> $errorFile
	echo "" >> $errorFile

	misspelled=$(hunspell -d en_US -l $f )
    for word in $misspelled
	do
		echo "  "$word >> $errorFile
		echo "  "$word
		has_misspelled=1
	done
done
if [ -n "$has_misspelled" ]
then
	echo "====================================="
	echo "Commit aborted due to spelling mistakes. Please see $errorFile for all spelling isues"
	echo "To force commit execute git commit --no-verify"
	exit 1
fi