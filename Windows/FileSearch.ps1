param
(
[string]$searchstring,
[string]$searchlocation
)

# 设置查找的目录
Set-Location $searchlocation

# 执行查找并将查找的结果保存到filename变量
$filename = Get-ChildItem *.* -Include *.txt -Recurse | Select-String -Pattern $searchstring | select filename

# 设置log文件的格式和路径
$logfile = "reslut_"+(Get-Date).ToString("yyyyMMddhhmmss")+".csv"

# 将查询的结果保存到logfile中
$filename | Export-Csv -Path $logfile -Encoding Default