#!/bin/sh

file="rawdata"
createHtml="touch /root/mkToHtml/data"
extractdata="/sbin/unixcat /var/nagios/var/rw/live < /root/mkToHtml/query >> /root/mkToHtml/$file"
eval $extractdata

sed -i -- 's/\;0\;/\;OK\;/g' /root/mkToHtml/$file
sed -i -- 's/\;1\;/\;WARNING\;/g' /root/mkToHtml/$file
sed -i -- 's/\;2\;/\;CRITICAL\;/g' /root/mkToHtml/$file
sed -i -- 's/\;3\;/\;UNKNOWN\;/g' /root/mkToHtml/$file

echo "<html><head><title>some title</title><style>body{font-size:12px};table{margin:10px}</style></head>" > "/root/mkToHtml/data"

while IFS='' read -r line || [[ -n "$line" ]]
do
  hostname=$(echo "$line" | cut -d \; -f1)
  hostaddress=$(echo "$line" | cut -d \; -f2)
  service=$(echo "$line" | cut -d \; -f3)
  state=$(echo "$line" | cut -d \; -f4)
  output=$(echo "$line" | cut -d \; -f5)

  echo "<table><tbody>" >> "/root/mkToHtml/data"
  echo "<tr>" >> "/root/mkToHtml/data"
  echo "<td>$hostname</td>" >> "/root/mkToHtml/data"
  echo "<td>;</td>" >> "/root/mkToHtml/data"
  echo "<td>$hostaddress</td>" >> "/root/mkToHtml/data"
  echo "<td>;</td>" >> "/root/mkToHtml/data"
  echo "<td>$service</td>" >> "/root/mkToHtml/data"
  echo "<td>;</td>" >> "/root/mkToHtml/data"
  echo "<td>$state</td>" >> "/root/mkToHtml/data"
  echo "<td>;</td>" >> "/root/mkToHtml/data"
  echo "<td>$output</td>" >> "/root/mkToHtml/data"
  echo "</tr></tbody></table>" >> "/root/mkToHtml/data"
done < "/root/mkToHtml/$file"

echo "</body>" >> "/root/mkToHtml/data"
echo "</html>" >> "/root/mkToHtml/data"

rm -f /root/mkToHtml/rawdata
rm -f /somefolder/data
mv /root/mkToHtml/data /somefolder/
