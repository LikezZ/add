#!/bin/sh

echo "开始Copy资源"

/Users/like/Desktop/new/Build.sh

FROM=/Users/like/Desktop/new/Pro/Assets/StreamingAssets/
TO=/Users/like/Desktop/new/Pro/iOS/Data/Raw/

cp -rf $FROM $TO  

echo "Copy资源完毕"