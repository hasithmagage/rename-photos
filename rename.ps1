$shell = New-Object -ComObject shell.application
Get-ChildItem -Recurse -file *.jpg,*jpeg,*.mp4,*.mov -ErrorAction Stop | ForEach{
    $iterator = 1
    if ($_.Name.StartsWith("WhatsApp Image")) {
        continue
    }
    $folder = $shell.NameSpace($_.DirectoryName)
    $file = $folder.ParseName($_.Name)
    $property = $folder.GetDetailsOf($file,12)
    if (-not $property) {
        $property = $folder.GetDetailsOf($file,3)
        if (-not $property) {
            $property = $folder.GetDetailsOf($file,4)
        }
    }
    $RawDate = ($property -Replace "[^\w /:]")
    $datetime = [DateTime]::Parse($RawDate)
    $DateTaken = $datetime.ToString("yyyyMMdd_HHmm")
    $FileName = $DateTaken + "_" + $iterator
    $path = $_.DirectoryName + "\" + $FileName + $_.Extension
    while (Test-Path -Path $path -PathType Leaf) {
        $iterator = $iterator + 1
        $FileName = $DateTaken + "_" + $iterator
        $path = $_.DirectoryName + "\" + $FileName + $_.Extension
    }
    Write-Output $_.Name"=>"$FileName
    Rename-Item $_.FullName ($FileName + $_.Extension)
}

# .\rename.ps1 -ErrorAction Stop