#Do和While可能产生死循环，为了防止死循环的发生，你必须确切的指定循环终止的条件。
#指定了循环终止的条件后，一旦条件不满足就会退出循环
#1)下面循环结束的条件是输入0，如果$x不等于0，则永远不结束
do
{
    $x =Read-Host
}
while ($x -ne 0)

#2）单独使用while

$n=5
while($n -gt 0)
{
    $n
    $n=$n-1
    }

    #3）使用continue关键字，可是终止当前循环，跳过continue后其它语句，重新下一次循环
    $n=1
    while ($n -lt 6)
    {
    if($n -eq 4)
    {
    $n=$n+1
    continue
    }
    else
    {
    $n
    }
    $n=$n+1
    }
    <#结果
1
2
3
5
#>

    #4）跳出循环语句使用break关键字
     $n=1
    while ($n -lt 6)
    {
    if($n -eq 4)
    {
    break
    }
    $n
    $n++
    }

#结果
1
2
3