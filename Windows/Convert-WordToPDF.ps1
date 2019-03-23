$docPath = 'd:\powershellscript\SPO-002-AppDNA lab guide.docx'
$pdfPath = 'd:\powershellscript\SPO-002-AppDNA lab guide.pdf'
$wordApp = New-Object -ComObject Word.Application
 
$document = $wordApp.Documents.Open($docPath)
$document.SaveAs([ref] $pdfPath, [ref] 17)
$document.Close()
$wordApp.Quit()