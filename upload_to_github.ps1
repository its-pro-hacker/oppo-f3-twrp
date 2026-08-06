# upload_to_github.ps1 - GitHub Par Upload Karne Ke Liye
# OPPO F3 (CPH1609) TWRP Project

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "OPPO F3 TWRP - GitHub Upload Helper" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Git
Write-Host "Step 1: Git Check Kar Raha Hai..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "✅ Git installed hai: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git nahi mila! Pehle Git install karo:" -ForegroundColor Red
    Write-Host "   https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Git install karne ke baad:" -ForegroundColor Yellow
    Write-Host "   1. Git download karo" -ForegroundColor White
    Write-Host "   2. Install karo" -ForegroundColor White
    Write-Host "   3. PC restart karo" -ForegroundColor White
    Write-Host "   4. Phir ye script dobara run karo" -ForegroundColor White
    Read-Host "Enter dabao to continue"
    exit 1
}

# Step 2: Project Folder
Write-Host ""
Write-Host "Step 2: Project Folder Check Kar Raha Hai..." -ForegroundColor Yellow
$projectPath = "D:\oppo\oppo-f3-twrp"

if (Test-Path $projectPath) {
    Write-Host "✅ Project folder mila: $projectPath" -ForegroundColor Green
} else {
    Write-Host "❌ Project folder nahi mila!" -ForegroundColor Red
    Write-Host "   D:\oppo\oppo-f3-twrp check karo" -ForegroundColor Yellow
    Read-Host "Enter dabao to continue"
    exit 1
}

# Step 3: Git Initialize
Write-Host ""
Write-Host "Step 3: Git Initialize Kar Raha Hai..." -ForegroundColor Yellow
Set-Location $projectPath

# Check if already initialized
if (Test-Path ".git") {
    Write-Host "✅ Git already initialized hai" -ForegroundColor Green
} else {
    git init
    Write-Host "✅ Git initialize ho gaya" -ForegroundColor Green
}

# Step 4: Files Add Karo
Write-Host ""
Write-Host "Step 4: Files Add Kar Raha Hai..." -ForegroundColor Yellow
git add .
Write-Host "✅ Files add ho gaye" -ForegroundColor Green

# Step 5: Commit Karo
Write-Host ""
Write-Host "Step 5: Commit Kar Raha Hai..." -ForegroundColor Yellow
$commitMessage = Read-Host "Commit message daalo (Enter for default)"
if ([string]::IsNullOrEmpty($commitMessage)) {
    $commitMessage = "Initial commit - OPPO F3 TWRP Recovery"
}
git commit -m $commitMessage
Write-Host "✅ Commit ho gaya" -ForegroundColor Green

# Step 6: GitHub Username Poocho
Write-Host ""
Write-Host "Step 6: GitHub Username Chahiye..." -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠️  Pehle GitHub par repository banao:" -ForegroundColor Red
Write-Host "   1. https://github.com par jao" -ForegroundColor White
Write-Host "   2. '+' icon par click karo" -ForegroundColor White
Write-Host "   3. 'New repository' select karo" -ForegroundColor White
Write-Host "   4. Name: oppo-f3-twrp" -ForegroundColor White
Write-Host "   5. 'Public' select karo" -ForegroundColor White
Write-Host "   6. 'Create repository' par click karo" -ForegroundColor White
Write-Host ""
$githubUsername = Read-Host "Apna GitHub username daalo"

if ([string]::IsNullOrEmpty($githubUsername)) {
    Write-Host "❌ Username nahi daala!" -ForegroundColor Red
    Read-Host "Enter dabao to continue"
    exit 1
}

# Step 7: Remote Add Karo
Write-Host ""
Write-Host "Step 7: Remote Add Kar Raha Hai..." -ForegroundColor Yellow
$remoteUrl = "https://github.com/$githubUsername/oppo-f3-twrp.git"

# Check if remote already exists
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    git remote set-url origin $remoteUrl
    Write-Host "✅ Remote URL update ho gaya" -ForegroundColor Green
} else {
    git remote add origin $remoteUrl
    Write-Host "✅ Remote add ho gaya" -ForegroundColor Green
}

# Step 8: Branch Set Karo
Write-Host ""
Write-Host "Step 8: Branch Set Kar Raha Hai..." -ForegroundColor Yellow
git branch -M main
Write-Host "✅ Branch 'main' par set ho gayi" -ForegroundColor Green

# Step 9: Push Karo
Write-Host ""
Write-Host "Step 9: Code Push Kar Raha Hai..." -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠️  GitHub login info daalo jab puche:" -ForegroundColor Red
Write-Host ""

try {
    git push -u origin main
    Write-Host ""
    Write-Host "✅ Code Successfully Push Ho Gaya!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "❌ Push Failed! Common reasons:" -ForegroundColor Red
    Write-Host "   1. GitHub username galat hai" -ForegroundColor Yellow
    Write-Host "   2. Repository nahi bana" -ForegroundColor Yellow
    Write-Host "   3. Internet connection issue" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Try karo manually:" -ForegroundColor Yellow
    Write-Host "   git push -u origin main" -ForegroundColor White
    Read-Host "Enter dabao to continue"
    exit 1
}

# Success Message
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "🎉 SAB HO GAYA! " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Ab GitHub par check karo:" -ForegroundColor Cyan
Write-Host "   https://github.com/$githubUsername/oppo-f3-twrp" -ForegroundColor White
Write-Host ""
Write-Host "GitHub Actions automatically build karega!" -ForegroundColor Cyan
Write-Host "   - 'Actions' tab par build dikhega" -ForegroundColor White
Write-Host "   - Build complete hone par email aayega" -ForegroundColor White
Write-Host "   - 'Releases' se recovery image download kar sako" -ForegroundColor White
Write-Host ""
Write-Host "Recovery Image Download:" -ForegroundColor Yellow
Write-Host "   1. https://github.com/$githubUsername/oppo-f3-twrp/releases" -ForegroundColor White
Write-Host "   2. Latest release par click karo" -ForegroundColor White
Write-Host "   3. twrp_CPH1609.img download karo" -ForegroundColor White
Write-Host ""
Write-Host "Phone Par Flash:" -ForegroundColor Yellow
Write-Host "   adb reboot bootloader" -ForegroundColor White
Write-Host "   fastboot flash recovery twrp_CPH1609.img" -ForegroundColor White
Write-Host "   fastboot boot twrp_CPH1609.img" -ForegroundColor White
Write-Host ""
Read-Host "Enter dabao to exit"
