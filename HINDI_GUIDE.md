# 🚀 OPPO F3 TWRP - GitHub Par Build Kaise Kare (Hindi Guide)

## Tumhe Kya Karna Hai (Sirf 3 Steps!)

### Step 1: GitHub Account Banao
1. https://github.com par jao
2. "Sign Up" par click karo
3. Email aur password se account banao

### Step 2: Repository Banao
1. GitHub par login karo
2. Top right par "+" icon par click karo
3. "New repository" select karo
4. Repository name: `oppo-f3-twrp`
5. "Public" select karo
6. "Create repository" par click karo

### Step 3: Code Upload Karo
Tumhare computer mein ye commands run karo:

```bash
# Pehle project folder mein jao
cd D:\oppo\oppo-f3-twrp

# Git initialize karo
git init
git add .
git commit -m "Initial commit - OPPO F3 TWRP"

# GitHub se connect karo (apna username dalo)
git remote add origin https://github.com/TUMHARA_USERNAME/oppo-f3-twrp.git

# Code push karo
git branch -M main
git push -u origin main
```

## Bas! GitHub Actions Automatically Build Karega! 🎉

### Kya Hoga:
1. ✅ Code push karte hi GitHub Actions start hoga
2. ✅ Build server par TWRP automatically build hoga
3. ✅ Build complete hone par tumhe email aayega
4. ✅ "Releases" section se recovery image download kar sako

### Recovery Image Download Kaise Kare:
1. GitHub par apni repository kholo
2. "Releases" section par jao (right side)
3. Latest release par click karo
4. `twrp_CPH1609.img` download karo

### Phone Par Flash Kaise Kare:
```bash
# Phone ko PC se connect karo
# Command prompt kholo

# Phone ko bootloader mode mein le jao
adb reboot bootloader

# TWRP flash karo
fastboot flash recovery twrp_CPH1609.img

# Phone ko recovery mode mein boot karo
fastboot boot twrp_CPH1609.img
```

## Koi Problem Aaye To:

### Build Fail Ho Jaye:
- GitHub repository mein "Actions" tab par jao
- Failed workflow par click karo
- Logs dekho kya error hai

### Phone Boot Na Kare:
- Bootloader unlock hai check karo
- Fastboot se try karo: `fastboot boot twrp.img`

### Main Kya Karunga:
- ✅ Code maintain karunga
- ✅ Bugs fix karunga
- ✅ Updates dunga
- ✅ Build optimize karunga

## Important Links:
- **Repository:** https://github.com/TUMHARA_USERNAME/oppo-f3-twrp
- **Actions:** https://github.com/TUMHARA_USERNAME/oppo-f3-twrp/actions
- **Releases:** https://github.com/TUMHARA_USERNAME/oppo-f3-twrp/releases

## Koi Sawal Ho To:
- GitHub Issues mein likho
- Ya mujhe yahan batao

**Bas 3 steps aur TWRP ready! 🚀**