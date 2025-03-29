#应用场景，母文件夹和子文件夹里都可能存入MP4文件，每隔一段时间母文件夹会移动MP4到子文件夹（同名的不移动），自动检测母子文件夹MP4文件最新修改时间，并根据文件情况给出判断
param(  
    [string]$sourceDir #接收外部传入的字符串路径
)

# 检查提供的目录路径是否存在
if (Test-Path -Path $sourceDir -PathType Container) {
    # 如果文件路径存在，则继续执行后续操作
    Write-Output "确认文件路径存在，继续执行"
 
} else {
    # 如果文件路径不存在，则退出脚本
    Write-Output "$sourceDir 路径不存在，不执行"
    exit 1  # 使用非零退出代码表示错误
}

$OutName = ".\检测结果2.txt"  

# 获取目录中所有 .mp4 文件
$mp4Files = Get-ChildItem -Path $sourceDir -Filter "*.mp4"
# 获取目录（含子文件夹）中所有 .mp4 文件
$mp4Files2 = Get-ChildItem -Path $sourceDir -Filter "*.mp4" -Recurse

# 检查主目录是否有 .mp4 文件
if ($mp4Files.Count -gt 0) {
    Write-Host "主目录中找到了.mp4 文件"
    # 找到主目录中最晚的文件修改时间
    $latestModifiedFile = $mp4Files | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $lastMP4Date = $latestModifiedFile.LastWriteTime
} else {
    Write-Host "主目录中没有 .mp4 文件"
    $lastMP4Date = "主目录中没有 .mp4 文件"
}

# 检查含母子文件夹里是否有 .mp4 文件
if ($mp4Files2.Count -gt 0) {
    # 找到目录中（含子文件夹）修改时间最晚的文件
    $latestModifiedFile2 = $mp4Files2 | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    Write-Host "目录中（含子文件夹）修改时间最晚的文件是: $($latestModifiedFile2.Name), 修改时间是: $($latestModifiedFile2.LastWriteTime)"
    Write-Host "完整路径是: $($latestModifiedFile2.FullName)"
    $lastMP4Name2 = $latestModifiedFile2.Name
    $lastMP4Date2 = $latestModifiedFile2.LastWriteTime
    # 找到 "标记" 在字符串中的位置
    $index = $latestModifiedFile2.FullName.IndexOf("标记")
    # 获取从 "标记" 开始的子字符串
    $lastMP4FullName2 = $latestModifiedFile2.FullName.Substring($index)
} else {
    Write-Host "目录中（含子文件夹）没有 .mp4 文件"
    $lastMP4Name2 = "目录中（含子文件夹）没有 .mp4 文件"
    $lastMP4Date2 = "00/00/0000 00:00:00"
    $lastMP4FullName2 = "没有 .mp4 文件无详细路径"
}

# 判断问题
if ($lastMP4Date -eq $lastMP4Date2) { # 母文件夹和母子文件夹最新时间相同，正常
    $now = Get-Date #获取当前时间
    $timeSpan = $now - $lastMP4Date # 计算时间差
    $DaysSpan = New-Object TimeSpan(15, 0, 0, 0) # 设置时间差为15天
    if ($timeSpan -gt $DaysSpan) {
        $PD = "文件过旧(15天前)，可能新旧同名"
    } else {
        $PD = "无问题"
    }
} elseif ($lastMP4Date2 -eq "00/00/0000 00:00:00") { # 母子文件夹都没有MP4
    $PD = "没有MP4文件或存到本地"
} elseif ($lastMP4Date2 -ne "00/00/0000 00:00:00" -and $lastMP4Date -eq "主目录中没有 .mp4 文件") { # 母子文件夹有MP4不为空，但母文件夹没有MP4，即子文件夹有MP4
    $now = Get-Date #获取当前时间
    $timeSpan = $now - $lastMP4Date2 # 计算时间差
    $DaysSpan = New-Object TimeSpan(15, 0, 0, 0)   # 设置时间差为15天
    if ($timeSpan -gt $DaysSpan) {
        $PD = "子目录文件过旧(15天前)，可能存本地"
    } else {
        $PD = "存子目录，或刚刚整理"        
    }
} else { # 时间不同异常（只剩下子新过母的情况）
    if ($latestModifiedFile.Name -eq $lastMP4Name2) {
        $PD = "有新旧同名文件，$($latestModifiedFile.Name)"
    } else {
        $PD = "有新旧同名文件，或存子目录里"
    }
}

# 输出结果到文件
"$($sourceDir)|$($lastMP4Name2)|$($lastMP4Date2)|$($lastMP4FullName2)|$($lastMP4Date)|$($PD)" | Out-File -FilePath $OutName -Append
