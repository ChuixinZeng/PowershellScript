try

{

Get-Childitem c:\Foo -ErrorAction stop

}

catch [System.Management.Automation.ItemNotFoundException]

{

'oops, I guess that folder was not there'

}

# https://devblogs.microsoft.com/scripting/powertip-ensure-that-errors-in-powershell-are-caught/

# 下面的步骤演示了如何找到catch后面的[]内容
# https://devblogs.microsoft.com/scripting/script-wars-the-farce-awakens-part-ii/

<#
PS D:\worklist\GitHub\PowershellScript\Windows> $error = $error[0]
无法覆盖变量 Error，因为该变量为只读变量或常量。
所在位置 行:1 字符: 1
+ $error = $error[0]
+ ~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : WriteError: (Error:String) [], SessionStateUnauthorizedAccessException
    + FullyQualifiedErrorId : VariableNotWritable

PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult = $error[0]
PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult
无法覆盖变量 Error，因为该变量为只读变量或常量。
所在位置 行:1 字符: 1
+ $error = $error[0]
+ ~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : WriteError: (Error:String) [], SessionStateUnauthorizedAccessException
    + FullyQualifiedErrorId : VariableNotWritable

PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult | gm


   TypeName:System.Management.Automation.ErrorRecord

Name                  MemberType     Definition
----                  ----------     ----------
Equals                Method         bool Equals(System.Object obj)
GetHashCode           Method         int GetHashCode()
GetObjectData         Method         void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context), void ISerializable.GetObjectData(System.Runtime...
GetType               Method         type GetType()
ToString              Method         string ToString()
CategoryInfo          Property       System.Management.Automation.ErrorCategoryInfo CategoryInfo {get;}
ErrorDetails          Property       System.Management.Automation.ErrorDetails ErrorDetails {get;set;}
Exception             Property       System.Exception Exception {get;}
FullyQualifiedErrorId Property       string FullyQualifiedErrorId {get;}
InvocationInfo        Property       System.Management.Automation.InvocationInfo InvocationInfo {get;}
PipelineIterationInfo Property       System.Collections.ObjectModel.ReadOnlyCollection[int] PipelineIterationInfo {get;}
ScriptStackTrace      Property       string ScriptStackTrace {get;}
TargetObject          Property       System.Object TargetObject {get;}
PSMessageDetails      ScriptProperty System.Object PSMessageDetails {get=& { Set-StrictMode -Version 1; $this.Exception.InnerException.PSMessageDetails };}


PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult.Exception
无法覆盖变量 Error，因为该变量为只读变量或常量。
PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult.Exception | gm


   TypeName:System.Management.Automation.SessionStateUnauthorizedAccessException

Name                        MemberType Definition
----                        ---------- ----------
Equals                      Method     bool Equals(System.Object obj), bool _Exception.Equals(System.Object obj)
GetBaseException            Method     System.Exception GetBaseException(), System.Exception _Exception.GetBaseException()
GetHashCode                 Method     int GetHashCode(), int _Exception.GetHashCode()
GetObjectData               Method     void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context), void ISerializable.GetObjectData(System.Runti...
GetType                     Method     type GetType(), type _Exception.GetType()
ToString                    Method     string ToString(), string _Exception.ToString()
Data                        Property   System.Collections.IDictionary Data {get;}
ErrorRecord                 Property   System.Management.Automation.ErrorRecord ErrorRecord {get;}
HelpLink                    Property   string HelpLink {get;set;}
HResult                     Property   int HResult {get;set;}
InnerException              Property   System.Exception InnerException {get;}
ItemName                    Property   string ItemName {get;}
Message                     Property   string Message {get;}
SessionStateCategory        Property   System.Management.Automation.SessionStateCategory SessionStateCategory {get;}
Source                      Property   string Source {get;set;}
StackTrace                  Property   string StackTrace {get;}
TargetSite                  Property   System.Reflection.MethodBase TargetSite {get;}
WasThrownFromThrowStatement Property   bool WasThrownFromThrowStatement {get;set;}


PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult.Exception.gettype()

IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     SessionStateUnauthorizedAccessException  System.Management.Automation.SessionStateException


PS D:\worklist\GitHub\PowershellScript\Windows> $errorresult.Exception.gettype().Fullname
System.Management.Automation.SessionStateUnauthorizedAccessException
#>