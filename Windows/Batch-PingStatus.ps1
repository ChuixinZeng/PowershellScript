$csv = Import-Csv E:\IP.csv -Encoding Default

foreach ($c in $csv)

{


Test-Connection -ComputerName $c.address -Count 1 -ErrorAction Ignore



}