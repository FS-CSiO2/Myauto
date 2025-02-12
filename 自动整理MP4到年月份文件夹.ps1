param(  
    [string]$sourceDir 
)
if (Test-Path -Path $sourceDir -PathType Container) {
    # 如果文件存在，则继续执行后续操作
    Write-Output "确认文件路径存在，继续执行"
 
} else {
    # 如果文件不存在，则退出脚本
    Write-Output $sourceDir" 路径不存在，跳过执行"
    exit 1  # 使用非零退出代码表示错误
}  
# 遍历目录下的所有MP4文件  
Get-ChildItem -Path $sourceDir -Filter *.mp4 -File | ForEach-Object {  
    # 获取文件的修改日期  
    $file = $_  
    $modDate = $file.LastWriteTime  
  
    # 根据修改日期构建目标文件夹路径（年份+月份）  
    $targetDir = Join-Path $sourceDir ($modDate.Year.ToString() + "_" + $modDate.Month.ToString("D2"))  
  
    # 如果目标文件夹不存在，则创建它  
    if (-not (Test-Path $targetDir)) {  
        New-Item -ItemType Directory -Path $targetDir | Out-Null  
    }  
  
    # 将文件移动到目标文件夹  
    Move-Item -Path $file.FullName -Destination $targetDir  
  
    # 可选：输出已移动文件的路径和目标文件夹  
    Write-Host "Moved $($file.FullName) to $targetDir"  
}