@echo off
setlocal enabledelayedexpansion
:: 获取文件夹路径里文件夹的名字并生成txt（非嵌套）
dir /B /a:d "C:\Users\8577\Desktop\进行中">"当前文件夹列表.txt"
cls
title 文件夹列表对比
cd /d %~dp0
color 0a
:: 定义文件路径
set "file1=旧文件夹列表.txt"
set "file2=当前文件夹列表.txt"
echo 对比结果>对比结果.txt
:: 读取 当前文件夹列表.txt 的每一行，在 旧文件夹列表.txt 中搜索（需要先准备好旧文件夹列表.txt，注意需要用ansi编码，可以在第一次打开时生成的当前文件夹列表.txt基础上改名字）
echo ================新增==================
echo ================新增==================>>对比结果.txt
:: 当found=1说明两个txt都有，反之说明没有
:: 当PD=1说明txt存在有不同的地方，反之说明没有，用作最后判断是否无新增
set "PD="
for /f "usebackq delims=" %%a in ("%file2%") do (
    set "found="
    for /f "usebackq delims=" %%b in ("%file1%") do (
        if "%%a"=="%%b" set "found=1"
    )
    if not defined found  (
        echo %%a 
        set PD=1
    )
    if not defined found echo %%a>>对比结果.txt
)
if not defined PD echo (无新增)
if not defined PD echo (无新增)>>对比结果.txt
echo ================减少==================
echo ================减少==================>>对比结果.txt
:: 当found=1说明两个txt都有，反之说明没有
:: 当PD=1说明txt存在有不同的地方，反之说明没有，用作最后判断是否无减少
set "PD="
:: 读取 当前文件夹列表.txt 的每一行，在 旧文件夹列表.txt 中搜索（需要先准备好旧文件夹列表.txt，注意需要用ansi编码，可以在第一次打开时生成的当前文件夹列表.txt基础上改名字）
for /f "usebackq delims=" %%a in ("%file1%") do (
    set "found="
    for /f "usebackq delims=" %%b in ("%file2%") do (
        if "%%a"=="%%b" set "found=1"
    )
    if not defined found  (
        echo %%a 
        set PD=1
    )
    if not defined found echo %%a>>对比结果.txt
)
if not defined PD echo (无减少)
if not defined PD echo (无减少)>>对比结果.txt
echo ================结束==================
echo ================结束==================>>对比结果.txt
echo %date%>>对比结果.txt
echo %time%>>对比结果.txt
endlocal
pause