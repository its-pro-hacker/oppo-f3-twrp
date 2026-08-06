# 🚀 OPPO F3 TWRP - Sirf 3 Steps Mein Root Karo!

## Tumhe Bas Ye 3 Steps Karne Hain:

### Step 1: GitHub Account Banao (1 minute)
- https://github.com par jao
- "Sign Up" par click karo
- Email aur password daalo
- Account ban jayega

### Step 2: Repository Banao (2 minute)
- GitHub par login karo
- Top right "+" par click karo
- "New repository" select karo
- Name: `oppo-f3-twrp`
- "Public" select karo
- "Create repository" par click karo

### Step 3: Code Upload Karo (2 minute)
Apne computer mein ye commands run karo:

**Windows Users:**
```
D:\oppo\oppo-f3-twrp\upload_to_github.bat
```

**Ya manually:**
```bash
cd D:\oppo\oppo-f3-twrp
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/TUMHARA_USERNAME/oppo-f3-twrp.git
git branch -M main
git push -u origin main
```

## 🎉 Bas! GitHub Automatically Build Karega!

### Kya Hoga:
1. ✅ Code push karte hi GitHub Actions start hoga
2. ✅ 10-15 minute mein build complete hoga
3. ✅ Tumhe email aayega
4. ✅ "Releases" se recovery image download ho jayegi

### Recovery Image Download:
1. GitHub par apni repository kholo
2. "Releases" par click karo
3. `twrp_CPH1609.img` download karo

### Phone Par Flash:
```bash
adb reboot bootloader
fastboot flash recovery twrp_CPH1609.img
fastboot boot twrp_CPH1609.img
```

## 📱 Phone Mein Kya Karna Hai:

### Pehle Bootloader Unlock Karo:
1. Phone mein Settings → About Phone → Build Number (7 baar tap karo)
2. Settings → Additional Settings → Developer Options
3. OEM Unlock ON karo
4. USB Debugging ON karo

### Phir TWRP Flash Karo:
1. Phone ko PC se connect karo
2. Command prompt kholo
3. `adb reboot bootloader` run karo
4. `fastboot flash recovery twrp_CPH1609.img` run karo
5. `fastboot boot twrp_CPH1609.img` run karo

## ⚠️ Important Notes:
- Bootloader unlock se phone ka data delete ho jayega
- Pehle backup zaroor lo
- Root se warranty khatam ho jayegi

## 🔗 Important Links:
- **GitHub Repository:** https://github.com/TUMHARA_USERNAME/oppo-f3-twrp
- **Build Actions:** https://github.com/TUMHARA_USERNAME/oppo-f3-twrp/actions
- **Downloads:** https://github.com/TUMHARA_USERNAME/oppo-f3-twrp/releases

## ❓ Koi Problem?
- GitHub Issues mein likho
- Ya mujhe batao

**Bas 3 steps aur TWRP ready! 🚀**