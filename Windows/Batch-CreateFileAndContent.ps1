# Provide Folder name and create
$Folder=’C:\Demo’

New-Item -ItemType Directory -Path $Folder

# Create a series of 10 files
for ($x=0;$x -lt 10; $x++)

{
# Let’s create a completely random filename
$filename=”$($Folder)\$((Get-Random 100000).tostring()).txt”

# Now we’ll create the file with some content
Add-Content -Value ‘Just a simple demo file’ -Path $filename

}

# 执行结果如下

<#

PS C:\Demo> dir


    目录: C:\Demo


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         2019/8/7     11:35             25 13345.txt
-a----         2019/8/7     11:35             25 15069.txt
-a----         2019/8/7     11:35             25 20606.txt
-a----         2019/8/7     11:35             25 42725.txt
-a----         2019/8/7     11:35             25 58390.txt
-a----         2019/8/7     11:35             25 70266.txt
-a----         2019/8/7     11:35             25 75358.txt
-a----         2019/8/7     11:35             25 81938.txt
-a----         2019/8/7     11:35             25 83732.txt
-a----         2019/8/7     11:35             25 95419.txt

#>

# 上面的代码有两个问题

# Each file was the same size
# Each filename was just a number followed by txt

# 下面同样是批量创建文件，文件的名称和日期时间戳都不同

# We’re going to build files up to 1K in size

$limit=(Get-random 1024)
$Folder=’C:\Demo’

New-Item -ItemType Directory -Path $Folder

# Let’s build the random content
for($y=0;$y -lt $limit;$y++)
{
    # We’re building a content of pure ASCII data
    # a的值是随着循环的不断进行，不断增加的，最开始第一次循环的时候，只有一个单一的数值，比如H
    $a=$a+[char][byte]((Get-Random 64)+32)
    $filename=$Folder+’\Logfile’+((Get-Random 100000).tostring())+’.txt’

    $DaysToMove=((Get-Random 120) -60)
    $HoursToMove=((Get-Random 48) -24)
    $MinutesToMove=((Get-Random 120) -60)
    $TimeSpan=New-TimeSpan -Days $DaysToMove -Hours $HoursToMove -Minutes $MinutesToMove

    # Now we adjust the Date and Time by the new TimeSpan
    # Needs Admin rights to do this as well!

    Set-Date -Adjust $Timespan | Out-Null

    # Create that file
    Add-Content -Value $a -Path $filename

    # Now we REVERSE the Timespan by the exact same amount
    $TimeSpan=New-TimeSpan -Days (-$DaysToMove) -Hours (-$HoursToMove) -Minutes (-$MinutesToMove)
    Set-Date -Adjust ($Timespan) | Out-Null
}

   # 结果如下

   <#
   -a----        2019/9/10      6:57            842 Logfile97093.txt
-a----        2019/7/10     10:21           1231 Logfile97138.txt
-a----        2019/9/22     13:03           1319 Logfile97191.txt
-a----        2019/6/20     23:00            703 Logfile97212.txt
-a----        2019/9/11      6:01           1343 Logfile97275.txt
-a----        2019/9/19      8:44           1308 Logfile97299.txt
-a----        2019/8/16      7:17            723 Logfile97424.txt
-a----        2019/9/12      1:38           1323 Logfile97790.txt
-a----        2019/6/17      9:22           1173 Logfile97898.txt
-a----        2019/8/10     10:37            823 Logfile98229.txt
-a----        2019/8/27     15:08            710 Logfile98683.txt
-a----        2019/6/20      4:09            764 Logfile99206.txt
-a----         2019/8/9     18:52            680 Logfile99394.txt
-a----        2019/8/13      1:04            783 Logfile9942.txt
-a----         2019/8/1      7:35           1128 Logfile99640.txt
-a----         2019/6/8     13:48            730 Logfile99769.txt
-a----        2019/7/23      0:24            672 Logfile9991.txt
   #>

# 注意：以上的操作会把本机的时间给搞乱掉，需要自己注意调整，或者等待时钟服务器自动同步
