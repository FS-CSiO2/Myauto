param(  
    [string]$sourceDir 
)
if (Test-Path -Path $sourceDir -PathType Container) {
    # ����ļ�·�����ڣ������ִ�к�������
    Write-Output "ȷ���ļ�·�����ڣ�����ִ��"
 
} else {
    # ����ļ������ڣ����˳��ű�
    Write-Output $sourceDir" ·�������ڣ���ִ��"
    exit 1  # ʹ�÷����˳������ʾ����
}
$OutName = ".\�����.txt"  
# ��ȡĿ¼������ .mp4 �ļ�
$mp4Files = Get-ChildItem -Path $sourceDir -Filter "*.mp4"

# ����Ƿ��� .mp4 �ļ�
if ($mp4Files.Count -gt 0) {
    # �ҵ��޸�ʱ��������ļ�
    $latestModifiedFile = $mp4Files | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    Write-Host "�޸�ʱ��������ļ���: $($latestModifiedFile.Name)"
    Write-Host "�޸�ʱ����: $($latestModifiedFile.LastWriteTime)"
    "$($sourceDir)|$($latestModifiedFile.Name)| $($latestModifiedFile.LastWriteTime)" | Out-File -FilePath $OutName -Append

} else {
    Write-Host "Ŀ¼��û�� .mp4 �ļ�"
    "$($sourceDir)|Ŀ¼��û�� .mp4 �ļ�| 00/00/0000 00:00:00" | Out-File -FilePath $OutName -Append
}