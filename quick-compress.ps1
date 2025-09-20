param(
    [string]$InputFile
)

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

# Call ffmpeg
& ffmpeg -i $InputFile -vf scale=1080:-1 $output

# the current window doesn't display the file always
explorer.exe $dir
