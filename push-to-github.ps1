# Quick GitHub Push Script
# Run this after creating your repository on GitHub

param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "ai-devcontainer"
)

Write-Host "`n🚀 GitHub Push Setup" -ForegroundColor Cyan
Write-Host "==================`n" -ForegroundColor Cyan

# Check if remote already exists
$remotes = git remote
if ($remotes -contains "origin") {
    Write-Host "⚠️  Remote 'origin' already exists" -ForegroundColor Yellow
    $currentRemote = git remote get-url origin
    Write-Host "   Current URL: $currentRemote" -ForegroundColor Gray
    
    $response = Read-Host "`nDo you want to replace it? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        git remote remove origin
        Write-Host "✓ Removed existing remote" -ForegroundColor Green
    } else {
        Write-Host "Keeping existing remote. Exiting." -ForegroundColor Yellow
        exit 0
    }
}

# Add remote
$repoUrl = "https://github.com/$Username/$RepoName.git"
Write-Host "`n📝 Adding remote..." -ForegroundColor Yellow
Write-Host "   URL: $repoUrl" -ForegroundColor Gray

git remote add origin $repoUrl

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Remote added successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to add remote" -ForegroundColor Red
    exit 1
}

# Verify remote
Write-Host "`n🔍 Verifying remote..." -ForegroundColor Yellow
git remote -v

# Confirm push
Write-Host "`n⚠️  Ready to push to GitHub" -ForegroundColor Yellow
Write-Host "   Repository: github.com/$Username/$RepoName" -ForegroundColor Gray
Write-Host "   Branch: main" -ForegroundColor Gray
Write-Host "   Files: $(git ls-files | Measure-Object -Line).Lines files" -ForegroundColor Gray

$confirm = Read-Host "`nProceed with push? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "`nℹ️  Push cancelled. Remote is configured but not pushed." -ForegroundColor Cyan
    Write-Host "   Run 'git push -u origin main' when ready." -ForegroundColor Gray
    exit 0
}

# Push to GitHub
Write-Host "`n📤 Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "`n🎉 Your repository is now live at:" -ForegroundColor Cyan
    Write-Host "   https://github.com/$Username/$RepoName`n" -ForegroundColor Blue
    
    Write-Host "📋 Next steps:" -ForegroundColor Cyan
    Write-Host "   1. Visit your repository and add topics/description"
    Write-Host "   2. Enable Discussions and Issues"
    Write-Host "   3. Set up branch protection rules"
    Write-Host "   4. Invite collaborators"
    Write-Host "   5. Share with your team!`n"
} else {
    Write-Host "`n✗ Push failed" -ForegroundColor Red
    Write-Host "`nℹ️  Common issues:" -ForegroundColor Yellow
    Write-Host "   • Repository doesn't exist on GitHub - create it first"
    Write-Host "   • Authentication failed - use personal access token"
    Write-Host "   • Network issues - check your connection`n"
    Write-Host "See docs/GITHUB_SETUP.md for detailed help`n" -ForegroundColor Gray
    exit 1
}
