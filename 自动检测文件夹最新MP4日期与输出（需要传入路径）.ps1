param(  
    [string]$sourceDir 
)
if (Test-Path -Path $sourceDir -PathType Container) {
    # 如果文件路径存在，则继续执行后续操作
    Write-Output "确认文件路径存在，继续执行"
 
} else {
    # 如果文件不存在，则退出脚本
    Write-Output $sourceDir" 路径不存在，不执行"
    exit 1  # 使用非零退出代码表示错误
}
$OutName = ".\检测结果.txt"  
# 获取目录中所有 .mp4 文件
$mp4Files = Get-ChildItem -Path $sourceDir -Filter "*.mp4"

# 检查是否有 .mp4 文件
if ($mp4Files.Count -gt 0) {
    # 找到修改时间最晚的文件
    $latestModifiedFile = $mp4Files | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    Write-Host "修改时间最晚的文件是: $($latestModifiedFile.Name)"
    Write-Host "修改时间是: $($latestModifiedFile.LastWriteTime)"
    "$($sourceDir)|$($latestModifiedFile.Name)| $($latestModifiedFile.LastWriteTime)" | Out-File -FilePath $OutName -Append

} else {
    Write-Host "目录中没有 .mp4 文件"
    "$($sourceDir)|目录中没有 .mp4 文件| 00/00/0000 00:00:00" | Out-File -FilePath $OutName -Append
}