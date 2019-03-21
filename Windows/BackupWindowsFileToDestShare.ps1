$date = Get-Date -format yyyy-MM-dd
$SourceDir = "D:\TEST"  
$DestinationDir = "E:\$date"

$AddDays = -1 #增加的天数,可正可负
#$AddHours = -1  #增加的小时,可正可负
#$SourceFileArray = Get-ChildItem -Path $SourceDir -Recurse | Where-Object -FilterScript {($_.LastWriteTime -gt (Get-Date).AddDays($AddDays).AddHours($AddHours))} | Select-Object -ExpandProperty Name  
$SourceFileArray = Get-ChildItem -Path $SourceDir -Recurse | Where-Object -FilterScript {($_.LastWriteTime -gt (Get-Date).AddDays($AddDays))} | Select-Object -ExpandProperty Name  
$SourceFileArray
  
$date = Get-Date  
Write-Host "$date 拷贝开始……"   

if (!(Test-Path -path $DestinationDir) ){
New-Item -path $DestinationDir -type Directory | out-null
}
  
foreach ( $file in $SourceFileArray ){  
$SourcePath = $SourceDir + "\" +$file 
$SourcePath 

Copy-Item -Path $SourcePath -Destination $DestinationDir -Recurse -Force
}
Write-Host "$date 完成：" + $SourcePath 

Write-Host "$date 拷贝完成！" 