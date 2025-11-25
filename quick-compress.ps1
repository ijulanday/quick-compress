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
    # variable for downscaling
    $downscale = 3

    # get width height to see divisible
    $widthheight = ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $InputFile
    $width = $widthheight.split("x")[0]
    $height = $widthheight.split("x")[1]
    if ((($width / $downscale) % 2) -ne 0 -or (($height / $downscale) % 2) -ne 0)
    {
        $downscale = 2
    }
    $newwidth = $width / $downscale
    & ffmpeg -i $InputFile -vf scale=${newwidth}:-1 $output
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
