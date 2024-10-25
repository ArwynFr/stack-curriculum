[CmdletBinding(SupportsShouldProcess)]
param ()

Install-Module ArwynFr.SemanticVersion -Force
Import-Module ArwynFr.SemanticVersion -Force

$TargetVersion = New-GithubSemanticVersionRelease -WhatIf:$WhatIfPreference
$ImageName = 'ghcr.io/arwynfr/stack-curriculum'
$DockerImage = "${ImageName}:${TargetVersion}"
$RootPath = Join-Path $PSScriptRoot .. | Convert-Path
$SourcesPath = Join-Path $RootPath src
$KubePath = Join-Path $RootPath kube
$Manifest = Join-Path $KubePath kustomization.yaml
$Authority = Join-Path $RootPath ca.crt

if ($PSCmdlet.ShouldProcess($SourcesPath, 'docker build')) {
  docker build $SourcesPath --tag $DockerImage
  if (-not $?) { throw 'docker build failed' }
}

if ($PSCmdlet.ShouldProcess($DockerImage, 'docker push')) {
  docker push $DockerImage
  if (-not $?) { throw 'docker push failed' }
}

"
images:
- name: app
  newName: $ImageName
  newTag: $TargetVersion" | Add-Content $Manifest
$env:KUBE_AUTHORITY | Set-Content $Authority

if ($PSCmdlet.ShouldProcess($DockerImage, 'kubectl apply')) {
  "kubectl apply --kustomize=""$KubePath"" --token=""$env:KUBE_TOKEN"" --server=""$env:KUBE_SERVER"" --certificate-authority=""$Authority""" | Write-Verbose
  kubectl apply --kustomize="$KubePath" --token="$env:KUBE_TOKEN" --server="$env:KUBE_SERVER" --certificate-authority="$Authority"
  if (-not $?) { throw 'kubectl apply failed' }
}