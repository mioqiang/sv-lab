$ErrorActionPreference = 'Continue'
$bin  = 'D:\Vivado2024.2\Vivado\2024.2\bin'
$work = 'C:\Users\jyd10\Desktop\question\.sv-probe'
Set-Location $work

# strip BOM from probe files (xvlog rejects 0xEF at file start)
foreach ($f in Get-ChildItem *.sv) {
    $t = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $t = $t.TrimStart([char]0xFEFF)
    [System.IO.File]::WriteAllText($f.FullName, $t, [System.Text.Encoding]::ASCII)
}

"=== xvlog compile ==="
$rows = @()
foreach ($f in Get-ChildItem *.sv | Sort-Object Name) {
    $out  = (& "$bin\xvlog.bat" $f.Name 2>&1) -join "`n"
    $code = $LASTEXITCODE
    $err  = if ($out -match 'ERROR') { ($out -split "`n" | Where-Object { $_ -match 'ERROR' } | Select-Object -First 1).Trim() } else { '' }
    $st   = if ($code -eq 0 -and $err -eq '') { 'OK' } else { 'FAIL' }
    $rows += [pscustomobject]@{ feature = $f.BaseName; compile = $st; rc = $code; first_error = $err }
}
$rows | Format-Table -AutoSize -Wrap | Out-String -Width 200

"=== end-to-end: xelab + xsim on p6 (class) ==="
$lab = (& "$bin\xelab.bat" p6 -s sim_p6 2>&1) -join "`n"
if ($LASTEXITCODE -eq 0) {
    (& "$bin\xsim.bat" sim_p6 -runall 2>&1) -join "`n"
} else {
    "xelab FAILED: " + (($lab -split "`n" | Where-Object { $_ -match 'ERROR' } | Select-Object -First 2) -join ' | ')
}
