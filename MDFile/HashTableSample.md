## 示例脚本

通过哈希表对输出的结果进行格式化
注意：为了测试能输出结果，本地计算机必须打开winrm quickconfig
<
Get-Process powershell -ComputerName localhost, Server01, Server02 | Format-Table -Property Handles, @{Label="NPM(K)";Expression={[int]($_.NPM/1024)}}, @{Label="PM(K)";Expression={[int]($_.PM/1024)}}, @{Label="WS(K)";Expression={[int]($_.WS/1024)}}, @{Label="VM(M)";Expression={[int]($_.VM/1MB)}}, @{Label="CPU(s)";Expression={if ($_.CPU -ne $()){$_.CPU.ToString("N")}}}, Id, ProcessName, MachineName -auto
>

## 执行结果

<
Handles NPM(K)  PM(K)  WS(K)   VM(M) CPU(s)   Id ProcessName MachineName
    519     27  59912  68124 2101917 0.94   6768 powershell  zengchuixin-pc
    953     48 199904 202744 2101981 9.14   9676 powershell  zengchuixin-pc
>