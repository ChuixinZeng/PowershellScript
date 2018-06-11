$csv =Import-Csv -Path E:\worklist\运维脚本\time.csv
foreach ($c in $csv)
{
(get-date $c.time).AddHours(8)
}