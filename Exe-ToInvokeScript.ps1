Param (
    [Parameter(Mandatory = $True, Position = 0)]
    [String]
    $InFile,

    [Parameter(Position = 1)]
    [String]
    $OutFile
)

$cultureTextInfo = (Get-Culture).TextInfo
$exePath = $InFile;
if (!$exePath.ToLower().EndsWith(".exe")) {
    Write-Warning "Please provide an EXE file"
    return
}
$exeName = $cultureTextInfo.ToTitleCase($exePath.Split('/')[-1].Replace(".exe", ""));

try {
	$in = [System.IO.File]::ReadAllBytes($exePath)
	[System.IO.MemoryStream] $out = New-Object System.IO.MemoryStream
	$gzipStream = New-Object System.IO.Compression.DeflateStream $out, ([IO.Compression.CompressionMode]::Compress)
	$gzipStream.Write( $in, 0, $in.Length )
	$gzipStream.Close()
	$out.Close()
	$b64 = [Convert]::ToBAsE64String($out.ToArray())
} catch {
	Write-Error "An error occurred processing the file: $_"
	return
}

$script = 'function Invoke-' +$exeName +'
{

    [CmdletBinding()]
    Param (
        [Parameter(Position = 0)]
        [String]
        $Arguments

    )
    $b=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("' + $b64 + '"))
    $decompressed = New-Object IO.Compression.DeflateStream($b,[IO.Compression.CoMPressionMode]::DEComPress)
    $out = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $out )
    [byte[]] $byteOutArray = $out.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)

    $RAS.EntryPoint.Invoke($null, @(,([String[]] @($Arguments.Split(" ")))));

    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}'

if ($OutFile) {
    $script | Out-File -FilePath $OutFile
    Write-Host "Script 'Invoke-$exeName' written to $OutFile."
} else {
    $script
}
