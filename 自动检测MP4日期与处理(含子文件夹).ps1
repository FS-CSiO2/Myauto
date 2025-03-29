#Ӧ�ó�����ĸ�ļ��к����ļ����ﶼ���ܴ���MP4�ļ���ÿ��һ��ʱ��ĸ�ļ��л��ƶ�MP4�����ļ��У�ͬ���Ĳ��ƶ������Զ����ĸ���ļ���MP4�ļ������޸�ʱ�䣬�������ļ���������ж�
param(  
    [string]$sourceDir #�����ⲿ������ַ���·��
)

# ����ṩ��Ŀ¼·���Ƿ����
if (Test-Path -Path $sourceDir -PathType Container) {
    # ����ļ�·�����ڣ������ִ�к�������
    Write-Output "ȷ���ļ�·�����ڣ�����ִ��"
 
} else {
    # ����ļ�·�������ڣ����˳��ű�
    Write-Output "$sourceDir ·�������ڣ���ִ��"
    exit 1  # ʹ�÷����˳������ʾ����
}

$OutName = ".\�����2.txt"  

# ��ȡĿ¼������ .mp4 �ļ�
$mp4Files = Get-ChildItem -Path $sourceDir -Filter "*.mp4"
# ��ȡĿ¼�������ļ��У������� .mp4 �ļ�
$mp4Files2 = Get-ChildItem -Path $sourceDir -Filter "*.mp4" -Recurse

# �����Ŀ¼�Ƿ��� .mp4 �ļ�
if ($mp4Files.Count -gt 0) {
    Write-Host "��Ŀ¼���ҵ���.mp4 �ļ�"
    # �ҵ���Ŀ¼��������ļ��޸�ʱ��
    $latestModifiedFile = $mp4Files | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $lastMP4Date = $latestModifiedFile.LastWriteTime
} else {
    Write-Host "��Ŀ¼��û�� .mp4 �ļ�"
    $lastMP4Date = "��Ŀ¼��û�� .mp4 �ļ�"
}

# ��麬ĸ���ļ������Ƿ��� .mp4 �ļ�
if ($mp4Files2.Count -gt 0) {
    # �ҵ�Ŀ¼�У������ļ��У��޸�ʱ��������ļ�
    $latestModifiedFile2 = $mp4Files2 | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    Write-Host "Ŀ¼�У������ļ��У��޸�ʱ��������ļ���: $($latestModifiedFile2.Name), �޸�ʱ����: $($latestModifiedFile2.LastWriteTime)"
    Write-Host "����·����: $($latestModifiedFile2.FullName)"
    $lastMP4Name2 = $latestModifiedFile2.Name
    $lastMP4Date2 = $latestModifiedFile2.LastWriteTime
    # �ҵ� "���" ���ַ����е�λ��
    $index = $latestModifiedFile2.FullName.IndexOf("���")
    # ��ȡ�� "���" ��ʼ�����ַ���
    $lastMP4FullName2 = $latestModifiedFile2.FullName.Substring($index)
} else {
    Write-Host "Ŀ¼�У������ļ��У�û�� .mp4 �ļ�"
    $lastMP4Name2 = "Ŀ¼�У������ļ��У�û�� .mp4 �ļ�"
    $lastMP4Date2 = "00/00/0000 00:00:00"
    $lastMP4FullName2 = "û�� .mp4 �ļ�����ϸ·��"
}

# �ж�����
if ($lastMP4Date -eq $lastMP4Date2) { # ĸ�ļ��к�ĸ���ļ�������ʱ����ͬ������
    $now = Get-Date #��ȡ��ǰʱ��
    $timeSpan = $now - $lastMP4Date # ����ʱ���
    $DaysSpan = New-Object TimeSpan(15, 0, 0, 0) # ����ʱ���Ϊ15��
    if ($timeSpan -gt $DaysSpan) {
        $PD = "�ļ�����(15��ǰ)�������¾�ͬ��"
    } else {
        $PD = "������"
    }
} elseif ($lastMP4Date2 -eq "00/00/0000 00:00:00") { # ĸ���ļ��ж�û��MP4
    $PD = "û��MP4�ļ���浽����"
} elseif ($lastMP4Date2 -ne "00/00/0000 00:00:00" -and $lastMP4Date -eq "��Ŀ¼��û�� .mp4 �ļ�") { # ĸ���ļ�����MP4��Ϊ�գ���ĸ�ļ���û��MP4�������ļ�����MP4
    $now = Get-Date #��ȡ��ǰʱ��
    $timeSpan = $now - $lastMP4Date2 # ����ʱ���
    $DaysSpan = New-Object TimeSpan(15, 0, 0, 0)   # ����ʱ���Ϊ15��
    if ($timeSpan -gt $DaysSpan) {
        $PD = "��Ŀ¼�ļ�����(15��ǰ)�����ܴ汾��"
    } else {
        $PD = "����Ŀ¼����ո�����"        
    }
} else { # ʱ�䲻ͬ�쳣��ֻʣ�����¹�ĸ�������
    if ($latestModifiedFile.Name -eq $lastMP4Name2) {
        $PD = "���¾�ͬ���ļ���$($latestModifiedFile.Name)"
    } else {
        $PD = "���¾�ͬ���ļ��������Ŀ¼��"
    }
}

# ���������ļ�
"$($sourceDir)|$($lastMP4Name2)|$($lastMP4Date2)|$($lastMP4FullName2)|$($lastMP4Date)|$($PD)" | Out-File -FilePath $OutName -Append
