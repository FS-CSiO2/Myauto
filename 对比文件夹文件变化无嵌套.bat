@echo off
setlocal enabledelayedexpansion
:: ��ȡ�ļ���·�����ļ��е����ֲ�����txt����Ƕ�ף�
dir /B /a:d "C:\Users\8577\Desktop\������">"��ǰ�ļ����б�.txt"
cls
title �ļ����б�Ա�
cd /d %~dp0
color 0a
:: �����ļ�·��
set "file1=���ļ����б�.txt"
set "file2=��ǰ�ļ����б�.txt"
echo �ԱȽ��>�ԱȽ��.txt
:: ��ȡ ��ǰ�ļ����б�.txt ��ÿһ�У��� ���ļ����б�.txt ����������Ҫ��׼���þ��ļ����б�.txt��ע����Ҫ��ansi���룬�����ڵ�һ�δ�ʱ���ɵĵ�ǰ�ļ����б�.txt�����ϸ����֣�
echo ================����==================
echo ================����==================>>�ԱȽ��.txt
:: ��found=1˵������txt���У���֮˵��û��
:: ��PD=1˵��txt�����в�ͬ�ĵط�����֮˵��û�У���������ж��Ƿ�������
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
    if not defined found echo %%a>>�ԱȽ��.txt
)
if not defined PD echo (������)
if not defined PD echo (������)>>�ԱȽ��.txt
echo ================����==================
echo ================����==================>>�ԱȽ��.txt
:: ��found=1˵������txt���У���֮˵��û��
:: ��PD=1˵��txt�����в�ͬ�ĵط�����֮˵��û�У���������ж��Ƿ��޼���
set "PD="
:: ��ȡ ��ǰ�ļ����б�.txt ��ÿһ�У��� ���ļ����б�.txt ����������Ҫ��׼���þ��ļ����б�.txt��ע����Ҫ��ansi���룬�����ڵ�һ�δ�ʱ���ɵĵ�ǰ�ļ����б�.txt�����ϸ����֣�
for /f "usebackq delims=" %%a in ("%file1%") do (
    set "found="
    for /f "usebackq delims=" %%b in ("%file2%") do (
        if "%%a"=="%%b" set "found=1"
    )
    if not defined found  (
        echo %%a 
        set PD=1
    )
    if not defined found echo %%a>>�ԱȽ��.txt
)
if not defined PD echo (�޼���)
if not defined PD echo (�޼���)>>�ԱȽ��.txt
echo ================����==================
echo ================����==================>>�ԱȽ��.txt
echo %date%>>�ԱȽ��.txt
echo %time%>>�ԱȽ��.txt
endlocal
pause