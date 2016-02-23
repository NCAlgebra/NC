#!/bin/sh
#         THE AVERAGE USER SHOULD IGNORE THIS FILE 
#
#  Shell:   The bourne shell 
#
#  Purpose:  This script may be used to convert all of the
#            (hopefully) test files which exist in subdirectories
#            into MS-Dos format.   It is useful for creating the
#            Windows version of NCAlgbera .....
#

echo "Hey dell!  Why don't you M$ some files !!!  " 

FILES=`find . -name "*.cpp" -print`;

FILES="$FILES `find . -name "*.m" -print`";
FILES="$FILES `find . -name "*.c" -print`";
FILES="$FILES `find . -name "*.hpp" -print`";
FILES="$FILES `find . -name "*.h" -print`";
FILES="$FILES `find . -name "*.tex" -print`";
FILES="$FILES `find . -name "*Makef*" -print`";
FILES="$FILES `find . -name "*makefi*" -print`";
FILES="$FILES `find . -name "*.html" -print`";

#echo $FILES

for f in $FILES
do
	 unix2dos $f > tempfile
     /usr/bin/mv tempfile $f
done




