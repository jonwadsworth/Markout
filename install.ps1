$dir = Join-Path $HOME 'Documents\MarkOut'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$scriptUrl = 'https://markout.cloud/markout.ps1'
$scriptPath = Join-Path $dir 'markout.ps1'
Invoke-RestMethod -Uri $scriptUrl -OutFile $scriptPath
Write-Host "Downloaded markout.ps1 to $scriptPath" -ForegroundColor Green

$shell = New-Object -ComObject WScript.Shell
$desktop = $shell.SpecialFolders('Desktop')
$lnk = $shell.CreateShortcut((Join-Path $desktop 'MarkOut.lnk'))
$lnk.TargetPath = (Get-Command pwsh).Source
$lnk.Arguments = "-WindowStyle Hidden -File `"$scriptPath`""
$lnk.Hotkey = 'CTRL+SHIFT+M'
$lnk.Description = 'Convert clipboard Markdown to rich text'
$lnk.Save()
Write-Host "Created Desktop shortcut with Ctrl+Shift+M" -ForegroundColor Green
Write-Host "`nDone! Copy Markdown, press Ctrl+Shift+M, paste into Outlook." -ForegroundColor Cyan
