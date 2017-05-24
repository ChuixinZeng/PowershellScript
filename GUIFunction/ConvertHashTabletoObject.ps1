#将哈希表转换为对象

function ConvertHashTableToObject
{
	begin
	{
		$object = New-Object Object
	}
	process
	{
		$_.GetEnumerator() | ForEach-Object {
			Add-Member -inputObject $object -memberType NoteProperty -name $_.Name -value $_.Value
		}
	}
	end
	{
		$object
	}
}

#使用方式：将生成的哈希表变量传递给ConvertHashTableToObject函数，例如哈希表保存在$hashresult里面，则$hashresult | ConvertHashTableToObject