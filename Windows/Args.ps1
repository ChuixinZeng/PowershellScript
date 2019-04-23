function test-conn
{
Test-Connection -Count 3 -ComputerName $args
#args充当占位符的作用，这个占位符必须以args命名，否则不能识别，会抛出异常
}
Set-Alias tc Test-Conn
tc localhost
结果

'''
tc localhost

Source        Destination     IPV4Address      IPV6Address
------        -----------     -----------      -----------
5CD60537FF    localhost       127.0.0.1        ::1
5CD60537FF    localhost       127.0.0.1        ::1
5CD60537FF    localhost       127.0.0.1        ::1
'''