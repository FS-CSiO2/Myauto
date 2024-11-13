@echo off
echo 提示：每次打开时会取消之前的关机任务
shutdown -a

:XZ
echo ==========================分割线==========================
echo 请选择关机模式
echo 1.倒计时关机模式
echo 2.自定义定时关机模式（小于当前时间将在第二天执行）
echo 3.五点半定时关机模式（小于当前时间将在第二天执行）
echo ==========================分割线==========================
set /p inputA="请按数字键选择执行的操作，然后按下enter回车键:"
if "%inputA%"=="1" (
goto DaoJiShi
) else if "%inputA%"=="2" (
goto DingShi
) else if "%inputA%"=="3" (
goto GuDing
) else (
 echo 输入不能为空或无效输入
goto XZ
)

rem 倒计时区域====================================================
:DaoJiShi
echo ==========================分割线==========================
set /p inputB="请输入倒计时分钟数，然后按下enter回车键:"

rem 判断输入是否合理
if "%inputB%"=="" (
echo 输入不能为空或无效输入
goto DaoJiShi
) 
for /f "delims=0123456789" %%a in ("%inputB%") do (
echo 输入不能为空或无效输入
goto DaoJiShi
)
if %inputB% leq 0 (
echo 输入不能小于或等于0
goto DaoJiShi
) 

rem 开始计算秒数，并放入关机指令里
set /a m=60
set /a T=%inputB%*%m%
shutdown -s -t "%T%"
echo %inputB%分钟后将会关机
pause
exit
rem 倒计时区域====================================================

rem 定时区域=====================================================
:DingShi
rem 一小时为60分钟
set /a h=60

rem 获取预期时间，会先进行输入时间的正确性判断
:retimeH
echo ==========================分割线==========================
rem 获取时钟，会先把时钟变量清空
set nexth=""
set /p nexth="请输入时钟："
rem 初步获取当前时间字符串时位，作为时,参与判断
set /a nowh=%time:~0,2%
rem 进行输入时间的正确性判断
if "%nexth%"=="" (
echo 输入不能为空或无效输入
goto retimeH
) 
for /f "delims=0123456789" %%a in ("%nexth%") do (
echo 输入不能为空或无效输入
goto retimeH
)
if %nexth% gtr 24 (
echo 时间异常 ，大于24小时（只支持一天内时间）
goto retimeH
)

:retimeM
rem 获取分钟，会先把分钟变量清空
set nextm=""
set /p nextm="请输入分钟："
rem 进行输入时间的正确性判断
if "%nextm%"=="" (
echo 输入不能为空
goto retimeM
) 
for /f "delims=0123456789" %%a in ("%nextm%") do (
echo 输入不能为空或无效输入
goto retimeM
)
if %nextm% gtr 59 (
echo 时间异常 ，超过59分钟
goto retimeM
)

rem 转换预期时间为分钟
set /a NextTimeM=%nexth%*%h%+%nextm%

rem 重新获取最新的当前时间字符串时位，作为时，用作判断，防止输入用时过长导致时间变化引起问题
set /a nowh=%time:~0,2%

rem 重新获取最新的当前时间字符串分位，作为分，用作判断，防止输入用时过长致时间变化引起问题
if "%time:~3,1%"=="0" (
set /a nowm=%time:~4,1%
) else (
set /a nowm=%time:~3,2%
)

rem 转换当前时间为分钟
set /a NowTimeM=(%nowh%*%h%)+%nowm%

rem 判断时间差是否正常，超过当前时间就第二天执行
if %NowTimeM% geq %NextTimeM% (
goto NextDayTime
)

rem 获取当前秒数
if "%time:~6,1%"=="0" (
set /a NowTimeS=%time:~7,1%
) else (
set /a NowTimeS=%time:~6,2%
)

rem 计算相差时间
set /a T=(%NextTimeM% - %NowTimeM%)*%h%-%NowTimeS%

rem 将T放入关机指令
shutdown -s -t "%T%"

rem 显示关机时间
rem echo %nexth%时%nextm%分会关机

rem pause
exit
rem 定时区域=====================================================

rem 固定定时区域=====================================================
:GuDing
rem 一小时为60分钟
set /a h=60

rem 为预期时间赋值
set /a nexth="17"
set /a nextm="30"

rem 转换预期时间为分钟
set /a NextTimeM=(%nexth%*%h%)+%nextm%

rem 获取最新的当前时间字符串时位，作为时，用作判断，防止输入用时过长导致时间变化引起问题
set /a nowh=%time:~0,2%

rem 获取最新的当前时间字符串分位，作为分，用作判断，防止输入用时过长致时间变化引起问题
if "%time:~3,1%"=="0" (
set /a nowm=%time:~4,1%
) else (
set /a nowm=%time:~3,2%
)

rem 转换当前时间为分钟
set /a NowTimeM=(%nowh%*%h%)+%nowm%

rem 判断时间差是否正常
if %NowTimeM% geq %NextTimeM% (
goto NextDayTime
)

rem 获取当前秒数
if "%time:~6,1%"=="0" (
set /a NowTimeS=%time:~7,1%
) else (
set /a NowTimeS=%time:~6,2%
)

rem 计算相差时间
set /a T=(%NextTimeM% - %NowTimeM%)*%h%-%NowTimeS%

rem 将T放入关机指令
shutdown -s -t "%T%"

rem 显示关机时间
rem echo %nexth%时%nextm%分会关机
rem pause
exit

rem 固定定时区域=====================================================

rem 第二天定时区域====================================================

:NextDayTime

rem 获取当前秒数
if "%time:~6,1%"=="0" (
set /a NowTimeS=%time:~7,1%
) else (
set /a NowTimeS=%time:~6,2%
)

rem Daym为一天的分钟数
set /a Daym=1440
echo 预期时间%nexth%时%nextm%分，当前时间为%nowh%时%nowm%分,将在第二天%nexth%时%nextm%分执行

rem 计算相差时间，算出与明天预期时间差秒数
set /a FT=(%Daym% - %NowTimeM% + %NextTimeM%)*%h%-%NowTimeS%
shutdown -s -t "%FT%"
exit

rem 第二天定时区域====================================================