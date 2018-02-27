#!/bin/sh

echo "开始导出Xcode工程"

#参数判断  
if [ $# != 1 ];then  
    echo "需要一个参数。 参数是游戏包的名子"  
    exit     
fi  
 
#UNITY程序的路径#
UNITY_PATH=/Applications/Unity/Unity.app/Contents/MacOS/Unity
 
#游戏程序路径#
PROJECT_PATH=/Users/like/Desktop/add/Pro
 
#将unity导出成xcode工程#
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_PATH -executeMethod ProjectBuild.BuildForIPhone project-$1
 
echo "Xcode工程生成完毕"