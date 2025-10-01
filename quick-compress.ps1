param(
    [string]$InputFile
)

function Get-logicalYesNo([string]$question) {
do { $sAnswer = Read-Host "$question [Y/N]" } until ($sAnswer.ToUpper()[0] -match '[yYnN]')
    return ($sAnswer.ToUpper()[0] -match '[Y]') #return  $True or $False
}

echo $InputFile

# Generate output filename by replacing vowels with numbers
$basename = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
$dir = [System.IO.Path]::GetDirectoryName($InputFile)

$leet = $basename `
    -replace 'a','4' `
    -replace 'e','3' `
    -replace 'i','1' `
    -replace 'o','0' `

if ($leet -eq $basename)
{
    $leet = $basename + "-c0mpr3ss3d"
}

$output = Join-Path $dir ($leet + ".mp4")

echo $output

# check for ffmpeg
$cmdName = "ffmpeg"

if (Get-Command $cmdName -errorAction SilentlyContinue)
{
    # Call ffmpeg
    & ffmpeg -i $InputFile -vf scale=1080:-1 $output
}
else
{
    if (Get-logicalYesNo("ffmpeg not installed, install now?"))
    {
        winget install ffmpeg
        echo "ffmpeg installed successfully, pls re-run Quick Compress"
        exit
    }
    else
    {
        echo "pls install ffmpeg thx!"
        exit
    }
}

# the current window doesn't display the file always
explorer.exe $dir
