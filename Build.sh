#!/bin/sh

echo "开始导出资源"
 
#UNITY程序的路径#
UNITY_PATH=/Applications/Unity/Unity.app/Contents/MacOS/Unity
#游戏程序路径#
PROJECT_PATH=/Users/like/Desktop/new/Pro
 
#unity准备Copy资源Lua#
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_PATH -executeMethod ToLuaMenu.CopyLuaFilesToStreamingAssets
#unity准备导出资源bundle#
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_PATH -executeMethod GenFilesMenuItems.BuildAssetBundles
 
echo "导出资源完毕"