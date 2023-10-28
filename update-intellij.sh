#!/usr/bin/env bash
nixFile="./packages/intellij.nix"
info=$(curl --silent --fail --show-error "https://download.jetbrains.com/idea/ideaIU-$1.tar.gz.sha256")
checksum=$(echo $info | grep -oE '^[0-9a-f]{64}')
filename=$(echo $info | grep -oE '[^* ]+$')
if [ -z "${checksum}" ] || [ -z "${filename}" ]; then
  exit -1
fi
echo "Filename: $filename"
echo "Checksum: $checksum"

sed -i "s|version\s*=.*|version = \"$1\";|" "$nixFile"
sed -i "s|url\s*=.*|url = \"https://download.jetbrains.com/idea/$filename\";|" "$nixFile"
sed -i "s|sha256\s*=.*|sha256 = \"$checksum\";|" "$nixFile"

echo ""
echo "IntelliJ updated to $1"

