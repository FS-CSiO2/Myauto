@echo off
echo ��ʾ��ÿ�δ�ʱ��ȡ��֮ǰ�Ĺػ�����
shutdown -a

:XZ
echo ==========================�ָ���==========================
echo ��ѡ��ػ�ģʽ
echo 1.����ʱ�ػ�ģʽ
echo 2.�Զ��嶨ʱ�ػ�ģʽ��С�ڵ�ǰʱ�佫�ڵڶ���ִ�У�
echo 3.���붨ʱ�ػ�ģʽ��С�ڵ�ǰʱ�佫�ڵڶ���ִ�У�
echo ==========================�ָ���==========================
set /p inputA="�밴���ּ�ѡ��ִ�еĲ�����Ȼ����enter�س���:"
if "%inputA%"=="1" (
goto DaoJiShi
) else if "%inputA%"=="2" (
goto DingShi
) else if "%inputA%"=="3" (
goto GuDing
) else (
 echo ���벻��Ϊ�ջ���Ч����
goto XZ
)

rem ����ʱ����====================================================
:DaoJiShi
echo ==========================�ָ���==========================
set /p inputB="�����뵹��ʱ��������Ȼ����enter�س���:"

rem �ж������Ƿ����
if "%inputB%"=="" (
echo ���벻��Ϊ�ջ���Ч����
goto DaoJiShi
) 
for /f "delims=0123456789" %%a in ("%inputB%") do (
echo ���벻��Ϊ�ջ���Ч����
goto DaoJiShi
)
if %inputB% leq 0 (
echo ���벻��С�ڻ����0
goto DaoJiShi
) 

rem ��ʼ����������������ػ�ָ����
set /a m=60
set /a T=%inputB%*%m%
shutdown -s -t "%T%"
echo %inputB%���Ӻ󽫻�ػ�
pause
exit
rem ����ʱ����====================================================

rem ��ʱ����=====================================================
:DingShi
rem һСʱΪ60����
set /a h=60

rem ��ȡԤ��ʱ�䣬���Ƚ�������ʱ�����ȷ���ж�
:retimeH
echo ==========================�ָ���==========================
rem ��ȡʱ�ӣ����Ȱ�ʱ�ӱ������
set nexth=""
set /p nexth="������ʱ�ӣ�"
rem ������ȡ��ǰʱ���ַ���ʱλ����Ϊʱ,�����ж�
set /a nowh=%time:~0,2%
rem ��������ʱ�����ȷ���ж�
if "%nexth%"=="" (
echo ���벻��Ϊ�ջ���Ч����
goto retimeH
) 
for /f "delims=0123456789" %%a in ("%nexth%") do (
echo ���벻��Ϊ�ջ���Ч����
goto retimeH
)
if %nexth% gtr 24 (
echo ʱ���쳣 ������24Сʱ��ֻ֧��һ����ʱ�䣩
goto retimeH
)

:retimeM
rem ��ȡ���ӣ����Ȱѷ��ӱ������
set nextm=""
set /p nextm="��������ӣ�"
rem ��������ʱ�����ȷ���ж�
if "%nextm%"=="" (
echo ���벻��Ϊ��
goto retimeM
) 
for /f "delims=0123456789" %%a in ("%nextm%") do (
echo ���벻��Ϊ�ջ���Ч����
goto retimeM
)
if %nextm% gtr 59 (
echo ʱ���쳣 ������59����
goto retimeM
)

rem ת��Ԥ��ʱ��Ϊ����
set /a NextTimeM=%nexth%*%h%+%nextm%

rem ���»�ȡ���µĵ�ǰʱ���ַ���ʱλ����Ϊʱ�������жϣ���ֹ������ʱ��������ʱ��仯��������
set /a nowh=%time:~0,2%

rem ���»�ȡ���µĵ�ǰʱ���ַ�����λ����Ϊ�֣������жϣ���ֹ������ʱ������ʱ��仯��������
if "%time:~3,1%"=="0" (
set /a nowm=%time:~4,1%
) else (
set /a nowm=%time:~3,2%
)

rem ת����ǰʱ��Ϊ����
set /a NowTimeM=(%nowh%*%h%)+%nowm%

rem �ж�ʱ����Ƿ�������������ǰʱ��͵ڶ���ִ��
if %NowTimeM% geq %NextTimeM% (
goto NextDayTime
)

rem ��ȡ��ǰ����
if "%time:~6,1%"=="0" (
set /a NowTimeS=%time:~7,1%
) else (
set /a NowTimeS=%time:~6,2%
)

rem �������ʱ��
set /a T=(%NextTimeM% - %NowTimeM%)*%h%-%NowTimeS%

rem ��T����ػ�ָ��
shutdown -s -t "%T%"

rem ��ʾ�ػ�ʱ��
rem echo %nexth%ʱ%nextm%�ֻ�ػ�

rem pause
exit
rem ��ʱ����=====================================================

rem �̶���ʱ����=====================================================
:GuDing
rem һСʱΪ60����
set /a h=60

rem ΪԤ��ʱ�丳ֵ
set /a nexth="17"
set /a nextm="30"

rem ת��Ԥ��ʱ��Ϊ����
set /a NextTimeM=(%nexth%*%h%)+%nextm%

rem ��ȡ���µĵ�ǰʱ���ַ���ʱλ����Ϊʱ�������жϣ���ֹ������ʱ��������ʱ��仯��������
set /a nowh=%time:~0,2%

rem ��ȡ���µĵ�ǰʱ���ַ�����λ����Ϊ�֣������жϣ���ֹ������ʱ������ʱ��仯��������
if "%time:~3,1%"=="0" (
set /a nowm=%time:~4,1%
) else (
set /a nowm=%time:~3,2%
)

rem ת����ǰʱ��Ϊ����
set /a NowTimeM=(%nowh%*%h%)+%nowm%

rem �ж�ʱ����Ƿ�����
if %NowTimeM% geq %NextTimeM% (
goto NextDayTime
)

rem ��ȡ��ǰ����
if "%time:~6,1%"=="0" (
set /a NowTimeS=%time:~7,1%
) else (
set /a NowTimeS=%time:~6,2%
)

rem �������ʱ��
set /a T=(%NextTimeM% - %NowTimeM%)*%h%-%NowTimeS%

rem ��T����ػ�ָ��
shutdown -s -t "%T%"

rem ��ʾ�ػ�ʱ��
rem echo %nexth%ʱ%nextm%�ֻ�ػ�
rem pause
exit

rem �̶���ʱ����=====================================================

rem �ڶ��춨ʱ����====================================================

:NextDayTime

rem ��ȡ��ǰ����
if "%time:~6,1%"=="0" (
set /a NowTimeS=%time:~7,1%
) else (
set /a NowTimeS=%time:~6,2%
)

rem DaymΪһ��ķ�����
set /a Daym=1440
echo Ԥ��ʱ��%nexth%ʱ%nextm%�֣���ǰʱ��Ϊ%nowh%ʱ%nowm%��,���ڵڶ���%nexth%ʱ%nextm%��ִ��

rem �������ʱ�䣬���������Ԥ��ʱ�������
set /a FT=(%Daym% - %NowTimeM% + %NextTimeM%)*%h%-%NowTimeS%
shutdown -s -t "%FT%"
exit

rem �ڶ��춨ʱ����====================================================