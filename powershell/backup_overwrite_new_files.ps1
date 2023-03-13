$source = "D:\SQL\SQL Scripts"
$target = "D:\SQL\sql_scripts_bak"

$files = get-childitem $source -Recurse
foreach ($file in $files)
{
    if ($file.LastWriteTime -ge (get-date).AddDays(-7))
    {
        $targetFile = $target + $file.FullName.SubString($source.Length)
        New-Item -ItemType File -Path $targetFile -Force
        Copy-Item $file.FullName -destination $targetFile -Force
    }
}