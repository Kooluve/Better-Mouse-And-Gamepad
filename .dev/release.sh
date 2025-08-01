#!/bin/sh
rm -rf ./.releases
mkdir .releases

bmag_release_tag=$(git tag --points-at HEAD | tail -n 1)
if [ -n "$release_tag" ]; then
    exit 1
fi
bmag_prefix="bmag_${bmag_release_tag}"
bmag_tar_name="${bmag_prefix}.tar.gz"
bmag_zip_name="${bmag_prefix}.zip"

cd ./.releases || exit
tar -cvf "$bmag_tar_name" ../localization ../src ../bmag.json ../LICENSE ../README.md
zip -r "$bmag_zip_name" ../localization ../src ../bmag.json ../LICENSE ../README.md
