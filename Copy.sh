#!/bin/sh

echo "开始Copy资源"

/Users/like/Desktop/add/Build.sh

FROM=/Users/like/Desktop/add/Pro/Assets/StreamingAssets/
TO=/Users/like/Desktop/add/Pro/iOS/Data/Raw/

cp -rf $FROM $TO  

echo "Copy资源完毕"