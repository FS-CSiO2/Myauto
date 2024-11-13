@echo off  
rem 通过PROCESSOR_ARCHITECTURE来判断系统位数
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (  
    echo 识别到系统为 64 位系统
) ELSE IF "%PROCESSOR_ARCHITECTURE%" == "x86" (  
    echo 识别到系统为 32 位系统
) else (
    echo 无法得知“PROCESSOR_ARCHITECTURE”的值，系统位数判断失败
)
pause