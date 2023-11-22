Write-Host -ForegroundColor DarkYellow "                                                           :                                             "
Write-Host -ForegroundColor DarkYellow "                                            ,;            t#,                                            "
Write-Host -ForegroundColor DarkYellow "                         j.               f#i t          ;##W.                                           "
Write-Host -ForegroundColor DarkYellow "                         EW,            .E#t  ED.       :#L:WE                                           "
Write-Host -ForegroundColor DarkYellow "                         E##j          i#W,   E#K:     .KG  ,#D                                          "
Write-Host -ForegroundColor DarkYellow "                         E###D.       L#D.    E##W;    EE    ;#f                                         "
Write-Host -ForegroundColor DarkYellow "                         E#jG#W;    :K#Wfff;  E#E##t  f#.     t#i                                        "
Write-Host -ForegroundColor DarkYellow "                         E#t t##f   i##WLLLLt E#ti##f :#G     GK                                         "
Write-Host -ForegroundColor DarkYellow "                         E#t  :K#E:  .E#L     E#t ;##D.;#L   LW.                                         "
Write-Host -ForegroundColor DarkYellow "                         E#KDDDD###i   f#E:   E#ELLE##K:t#f f#:                                          "
Write-Host -ForegroundColor DarkYellow "                         E#f,t#Wi,,,    ,WW;  E#L;;;;;;, f#D#;                                           "
Write-Host -ForegroundColor DarkYellow "                         E#t  ;#W:       .D#; E#t         G#t                                            "
Write-Host -ForegroundColor DarkYellow "                         DWi   ,KK:        tt E#t          t                                             "
Write-Host -ForegroundColor DarkYellow ""                                                                                                         
Write-Host -ForegroundColor DarkYellow ""
Write-Host -ForegroundColor DarkYellow ""                                                                                                         
Write-Host -ForegroundColor DarkYellow ""                                                                                                         
Write-Host -ForegroundColor DarkYellow "                                                                                        :                "
Write-Host -ForegroundColor DarkYellow "                      ,;L.                     ,;                                      t#,               "
Write-Host -ForegroundColor DarkYellow "          .Gt       f#i EW:        ,ft       f#i j.                                   ;##W.   j.         "
Write-Host -ForegroundColor DarkYellow "         j#W:     .E#t  E##;       t#E     .E#t  EW,                   .. GEEEEEEEL  :#L:WE   EW,        "
Write-Host -ForegroundColor DarkYellow "       ;K#f      i#W,   E###t      t#E    i#W,   E##j                 ;W, ,;;L#K;;. .KG  ,#D  E##j       "
Write-Host -ForegroundColor DarkYellow "     .G#D.      L#D.    E#fE#f     t#E   L#D.    E###D.              j##,    t#E    EE    ;#f E###D.     "
Write-Host -ForegroundColor DarkYellow "    j#K;      :K#Wfff;  E#t D#G    t#E :K#Wfff;  E#jG#W;            G###,    t#E   f#.     t#iE#jG#W;    "
Write-Host -ForegroundColor DarkYellow "  ,K#f   ,GD; i##WLLLLt E#t  f#E.  t#E i##WLLLLt E#t t##f         :E####,    t#E   :#G     GK E#t t##f   "
Write-Host -ForegroundColor DarkYellow "   j#Wi   E#t  .E#L     E#t   t#K: t#E  .E#L     E#t  :K#E:      ;W#DG##,    t#E    ;#L   LW. E#t  :K#E: "
Write-Host -ForegroundColor DarkYellow "    .G#D: E#t    f#E:   E#t    ;#W,t#E    f#E:   E#KDDDD###i    j###DW##,    t#E     t#f f#:  E#KDDDD###i"
Write-Host -ForegroundColor DarkYellow "      ,K#fK#t     ,WW;  E#t     :K#D#E     ,WW;  E#f,t#Wi,,,   G##i,,G##,    t#E      f#D#;   E#f,t#Wi,,,"
Write-Host -ForegroundColor DarkYellow "        j###t      .D#; E#t      .E##E      .D#; E#t  ;#W:   :K#K:   L##,    t#E       G#t    E#t  ;#W:  "
Write-Host -ForegroundColor DarkYellow "         .G#t        tt ..         G#E        tt DWi   ,KK: ;##D.    L##,     fE        t     DWi   ,KK: "
Write-Host -ForegroundColor DarkYellow "           ;;                       fE                      ,,,      .,,       :                         "
Write-Host -ForegroundColor DarkYellow "                                     ,                                                                   "
Write-Host -ForegroundColor DarkYellow ""

$RepoName = Read-Host "Please enter a Name for the new Repository: "

if ($RepoName.length -eq 0)
{
    Write-Host "Repository Name is Required."
    Exit 1
}

$loginStatus = gh auth status -h github.com | Select-String -Pattern "Logged in"

if($loginStatus.length -eq 0)
{
    Write-Host "You are not logged into GitHub. Please Log In Now"
    gh auth login github.com
}
else
{
    Write-Host "You are already logged into GitHub. Continuing."
    Write-Host
}

$cloneDir = Resolve-Path ../
Write-Host "The Repository Creator needs to clean up some files from the template project which requires the new repo to be cloned."
$dirInput = Read-Host "Please enter a path to clone the new repository to (default: ${cloneDir})"

if ($dirInput.length -gt 0)
{
    $cloneDir = $dirInput
}

Push-Location $cloneDir

gh repo create loadrpm/${RepoName} --template loadrpm/GitHubTemplate --private --clone

Push-Location $RepoName

Remove-Item branch-protection.json
Remove-Item RepoGenerator.ps1

Write-Host "Committing Cleaned Up Repo."
Write-Host

git add -A
git commit -S -m "Template Repo Cleanup"
git push origin main

Pop-Location
Pop-Location

Write-Host "Creating Standard Branch Protection Policy."
gh api /repos/loadrpm/${RepoName}/branches/main/protection -H "Accept: application/vnd.github+json" -X "PUT" --input "branch-protection.json"


Write-Host "Assigning Standard Dev Team (dev-write) access to ${RepoName}"
gh api "/orgs/loadrpm/teams/dev-write/repos/loadrpm/${RepoName}" -X PUT -f permission='push'

Write-Host "Assigning Senior Dev Team access to ${RepoName} to view PRs"
gh api "/orgs/loadrpm/teams/sr-devs/repos/loadrpm/${RepoName}" -X PUT -f permission='push'

Write-Host "Assigning SQL Approvers Team access to ${RepoName} to view PRs"
gh api "/orgs/loadrpm/teams/sql-approvers/repos/loadrpm/${RepoName}" -X PUT -f permission='push'

Write-Host ""
Write-Host "Thank you for using the Repo Generator!"
Write-Host ""