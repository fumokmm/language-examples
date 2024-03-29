﻿$reposName = 'svnrepossync'
$remoteBaseDir = 'N:\repos\svn\'

# フェッチを実装
function doFetch {
    param(
        $localReposDir,
        $remoteReposDir,
        $syncRevision,
        $localRevision
    )

    # ローカルリポジトリを退避
    robocopy $localReposDir (Join-Path $PSScriptRoot "\..\.svnrepos_bk\.svnrepos_$((Get-Date).ToString('yyyyMMddHHmmss'))_r$($($syncRevision))to$($localRevision)") /MIR /E /R:1
    # リポジトリフォルダのコピーを実行
    robocopy $remoteReposDir $localReposDir /MIR /E /R:1
}

# リポジトリのリビジョン番号を調べる
# リポジトリがない場合、リビジョン0を返却
function getReposRevision {
    param(
        $reposDir # リポジトリのディレクトリ
    )
    if (($reposDir -ne $null) -and (Test-Path $reposDir) -eq $True) {
        return [int](Get-Content (Join-Path (Join-Path $reposDir 'db') 'current'))
    } else {
        return [int]0
    }
}

# 同期化したリビジョンを更新
function updateSyncRevision{
    param(
        $newRevision
    )
    Set-Content -Path (Join-Path $PSScriptRoot \..\.svnrepossyncrevision) -Value $newRevision
}

######################################
# ここからメイン処理
######################################

#$localReposDir = Resolve-Path (Join-Path $PSScriptRoot \..\.svnrepos)
if (-not (Test-Path (Join-Path $PSScriptRoot \..\.svnrepos))) {
    New-Item -Type Directory (Join-Path $PSScriptRoot \..\.svnrepos)
}
$localReposDir = Resolve-Path (Join-Path $PSScriptRoot \..\.svnrepos)
$remoteReposDir = Join-Path $remoteBaseDir "$($reposName).svnrepos"

# リポジトリのリビジョンを調べる
$localRevision = getReposRevision -reposDir $localReposDir
$remoteRevision = getReposRevision -reposDir $remoteReposDir
if ((Test-Path (Join-Path $PSScriptRoot \..\.svnrepossyncrevision))) {
    $syncRevision = [int](Get-Content (Join-Path $PSScriptRoot \..\.svnrepossyncrevision))
} else {
    $syncRevision = [int]0
}
Write-Host "local  : $localRevision"
Write-Host "remote : $remoteRevision"
Write-Host "sync   : $syncRevision"

# 前回同期時とリモートリビジョンが同じ場合、fetch不要
if ($remoteRevision -eq $syncRevision) {
    Write-Host '前回同期化時からリモートリポジトリに更新がないため、Fetchの必要がありません。'
    exit 0

# 前回同期化時よりもリモートリビジョンが下がった場合、状態が変
} elseif ($remoteRevision -lt $syncRevision) {
    Write-Host "状態が変です。前回同期化時よりもリモートリポジトリが古くなっています。前回同期化時のリビジョン:$syncRevision、リモートのリビジョン:$remoteRevision"
    exit 1

# 前回同期化後にリモートリビジョンが上がった場合、fetch可能
} else {
    # Write-Host 'Fetch可能です。'
    
    # 前回同期化時よりもローカルリビジョンが上がっている場合、確認メッセージを入れてからFetchする
    if ($syncRevision -lt $localRevision) {
        $objYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "実行する"
        $objNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "やめておく"
        $objOptions = [System.Management.Automation.Host.ChoiceDescription[]]($objYes, $objNo)
        $objMessage = @"
リモートが最新ですが、ローカルにもコミットしています。
ローカル: $($syncRevision) -> $($localRevision)
リモート: $($syncRevision) -> $($remoteRevision)
※Fetchするとローカルにコミットした内容は失われますので、データを退避するなりして備えて下さい。
"@
        $resultVal = $host.ui.PromptForChoice('実行しますか？', $objMessage, $objOptions, 1)
        if ($resultVal -ne 0) {
            Write-Host "処理が中断されました。"
            exit 0
        }
    }
    
    # フェッチを実行
    doFetch -localReposDir $localReposDir `
            -remoteReposDir $remoteReposDir `
            -syncRevision $syncRevision `
            -localRevision $localRevision

    # 同期化したリビジョンを更新
    updateSyncRevision -newRevision $remoteRevision

    exit 0
}
