[CmdletBinding(SupportsShouldProcess)]
param ()

$RootPath = Join-Path $PSScriptRoot .. | Convert-Path
$SourcesPath = Join-Path $RootPath src

docker build $SourcesPath --no-cache
