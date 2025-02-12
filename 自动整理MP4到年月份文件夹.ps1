param(  
    [string]$sourceDir 
)
if (Test-Path -Path $sourceDir -PathType Container) {
    # ����ļ����ڣ������ִ�к�������
    Write-Output "ȷ���ļ�·�����ڣ�����ִ��"
 
} else {
    # ����ļ������ڣ����˳��ű�
    Write-Output $sourceDir" ·�������ڣ�����ִ��"
    exit 1  # ʹ�÷����˳������ʾ����
}  
# ����Ŀ¼�µ�����MP4�ļ�  
Get-ChildItem -Path $sourceDir -Filter *.mp4 -File | ForEach-Object {  
    # ��ȡ�ļ����޸�����  
    $file = $_  
    $modDate = $file.LastWriteTime  
  
    # �����޸����ڹ���Ŀ���ļ���·�������+�·ݣ�  
    $targetDir = Join-Path $sourceDir ($modDate.Year.ToString() + "_" + $modDate.Month.ToString("D2"))  
  
    # ���Ŀ���ļ��в����ڣ��򴴽���  
    if (-not (Test-Path $targetDir)) {  
        New-Item -ItemType Directory -Path $targetDir | Out-Null  
    }  
  
    # ���ļ��ƶ���Ŀ���ļ���  
    Move-Item -Path $file.FullName -Destination $targetDir  
  
    # ��ѡ��������ƶ��ļ���·����Ŀ���ļ���  
    Write-Host "Moved $($file.FullName) to $targetDir"  
}