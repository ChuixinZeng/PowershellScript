可以通过使用哈希表数组中对不同属性进行不同的顺序进行排序。

~~~ powershell
Get-ChildItem |
  Sort-Object -Property @{ Expression = 'LastWriteTime'; Descending = $true }, @{ Expression = 'Name'; Ascending = $true } |
  Format-Table -Property LastWriteTime, Name
~~~

为了提高可读性，可以将哈希表放到一个单独的变量：

~~~ powershell
$order = @(
  @{ Expression = 'LastWriteTime'; Descending = $true }
  @{ Expression = 'Name'; Ascending = $true }
)
Get-ChildItem |
  Sort-Object $order |
  Format-Table LastWriteTime, Name
~~~

哈希表中进行排序的键可缩写如下所示：

~~~ powershell
Sort-Object @{ e = 'LastWriteTime'; d = $true }, @{ e = 'Name'; a = $true }
~~~

