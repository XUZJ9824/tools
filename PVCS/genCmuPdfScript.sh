#!/usr/bin/bash

getCmuPdf.bat

cat files-cmumain.lst | sed -n '/.*pdf.*/p' |sed -e 's/ \{1,\}/ /g' | sed -e 's/.*"CMU/"CMU/g' | awk '{print $1 " " $2}' | sed -e 's/\\Dimension/Dimension/g' > ./tmp.txt

#FI "CMU:A7576.A-CM4;1" /USER_FILENAME="c:\SVP_REVIEW_CHECKLIST.pdf" /NOEXPAND /NOOVERWRITE /WORKSET="CMU:_WORK_MAIN"

awk '{print "dmcli.exe FI " $1 " /USER_FILENAME=\"c:\\tmp\\" $2 "\"" " \/NOEXPAND \/NOOVERWRITE \/WORKSET=\"CMU:_WORK_MAIN\"" } ' ./tmp.txt > ./getCmuPdf.bat

unix2dos.exe ./getCmuPdf.bat

cat ./getCmuPdf.bat