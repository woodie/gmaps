#!/bin/bash

SOURCE=http://boostapps.com/files
DIST_BASE=https://raw.githubusercontent.com/woodie/gmaps/master/dist

mkdir -p downloads
cd downloads

if [ -f gMapsSigned.jad ]; then
  echo "The source jad file exists."
else
  echo "Downloading jad file."
  curl -O $SOURCE/gMapsSigned.jad 
fi

if [ -f gMapsSigned.jar ]; then
  echo "The source jar file exists."
else
  echo "Downloading jar file."
  curl -O $SOURCE/gMapsSigned.jar
fi

cd ..
cp downloads/gMapsSigned.jar dist/gMapsUnsigned.jar
cd res # Add appropriate icon
jar uf ../dist/gMapsUnsigned.jar icon72x72.png 
cd ..

while read line; do
  if [[ "$line" =~ "MIDlet-Jar-URL" ]]; then
    echo MIDlet-Jar-URL: $DIST_BASE/gMapsUnsigned.jar
  elif [[ "$line" =~ "MIDlet-Icon" ]]; then
    echo MIDlet-Icon: icon72x72.png
  elif [[ ! "$line" =~ "RSA-SHA1" ]]; then
    echo $line
  fi
done < downloads/gMapsSigned.jad > dist/gMapsUnsigned.jad
