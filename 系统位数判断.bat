@echo off  
rem ͨ��PROCESSOR_ARCHITECTURE���ж�ϵͳλ��
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (  
    echo ʶ��ϵͳΪ 64 λϵͳ
) ELSE IF "%PROCESSOR_ARCHITECTURE%" == "x86" (  
    echo ʶ��ϵͳΪ 32 λϵͳ
) else (
    echo �޷���֪��PROCESSOR_ARCHITECTURE����ֵ��ϵͳλ���ж�ʧ��
)
pause