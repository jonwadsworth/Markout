Add-Type -AssemblyName System.Windows.Forms

$md = [System.Windows.Forms.Clipboard]::GetText()
if (-not $md) { exit }

$html = (ConvertFrom-Markdown -InputObject $md).Html

$prefix = "<html><body>`r`n<!--StartFragment-->"
$suffix = "<!--EndFragment-->`r`n</body></html>"

$enc    = [System.Text.Encoding]::UTF8
$hdrTpl = "Version:0.9`r`nStartHTML:AAAAAAAAAA`r`nEndHTML:BBBBBBBBBB`r`nStartFragment:CCCCCCCCCC`r`nEndFragment:DDDDDDDDDD`r`n"
$hdrLen = $enc.GetByteCount($hdrTpl)
$preLen = $enc.GetByteCount($prefix)
$htmLen = $enc.GetByteCount($html)
$sufLen = $enc.GetByteCount($suffix)

$sH = $hdrLen
$sF = $hdrLen + $preLen
$eF = $sF + $htmLen
$eH = $eF + $sufLen

$header = $hdrTpl
$header = $header.Replace('AAAAAAAAAA', ('{0:D10}' -f $sH))
$header = $header.Replace('BBBBBBBBBB', ('{0:D10}' -f $eH))
$header = $header.Replace('CCCCCCCCCC', ('{0:D10}' -f $sF))
$header = $header.Replace('DDDDDDDDDD', ('{0:D10}' -f $eF))

$cfHtml = $header + $prefix + $html + $suffix

$dataObj = New-Object System.Windows.Forms.DataObject
$dataObj.SetData('HTML Format', $cfHtml)
$dataObj.SetData([System.Windows.Forms.DataFormats]::UnicodeText, $md)
[System.Windows.Forms.Clipboard]::SetDataObject($dataObj, $true)
