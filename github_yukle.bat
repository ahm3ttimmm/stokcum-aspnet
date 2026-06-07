@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

echo.
echo ============================================================
echo         GitHub Otomatik Yukleme Scripti
echo ============================================================
echo.

:: ============================================================
:: GIT KURULUM KONTROLU
:: ============================================================
where git > nul 2>&1
if %errorlevel% neq 0 (
    echo [BILGI] Git kurulu degil. Winget ile kurulum basliyor...
    echo.
    winget install --id Git.Git -e --source winget
    if !errorlevel! neq 0 (
        echo.
        echo [HATA] Git kurulumu basarisiz oldu!
        echo Lutfen https://git-scm.com adresinden manuel kurun.
        echo.
        pause
        exit /b 1
    )
    echo.
    echo ============================================================
    echo  Git basariyla kuruldu!
    echo  PATH guncellenmesi icin scripti KAPATIP TEKRAR ACIN.
    echo ============================================================
    echo.
    pause
    exit /b 0
)

echo [OK] Git kurulu bulundu.
echo.

:: ============================================================
:: CALISMA DIZINI KONTROL
:: ============================================================
echo [BILGI] Mevcut dizin: %CD%
echo.

:: ============================================================
:: GITHUB REPO LINKI AL
:: ============================================================
echo Lutfen GitHub repo linkinizi asagiya yapistiriniz.
echo Ornek: https://github.com/kullanici/repo.git
echo.
set /p "RAW_URL=GitHub Repo URL: "

:: Tırnak isaretlerini temizle
set "REPO_URL=!RAW_URL:"=!"

:: Bosluk temizle (baş ve son)
for /f "tokens=* delims= " %%A in ("!REPO_URL!") do set "REPO_URL=%%A"

:: Boş kontrolü
if "!REPO_URL!"=="" (
    echo.
    echo [HATA] URL bos birakılamaz!
    echo.
    pause
    exit /b 1
)

echo.
echo [BILGI] Kullanilacak URL: !REPO_URL!
echo.

:: ============================================================
:: GIT INIT - sadece .git klasoru yoksa
:: ============================================================
if not exist ".git" (
    echo [ADIM 1/6] git init calisiyor...
    git init
    if !errorlevel! neq 0 (
        echo [HATA] git init basarisiz!
        echo.
        pause
        exit /b 1
    )
    echo [OK] git init tamamlandi.
) else (
    echo [ADIM 1/6] .git klasoru zaten mevcut, init atlandi.
)
echo.

:: ============================================================
:: GIT ADD
:: ============================================================
echo [ADIM 2/6] git add . calisiyor...
git add .
if !errorlevel! neq 0 (
    echo [HATA] git add basarisiz!
    echo.
    pause
    exit /b 1
)
echo [OK] Dosyalar eklendi.
echo.

:: ============================================================
:: GIT COMMIT
:: ============================================================
echo [ADIM 3/6] git commit calisiyor...
git commit -m "Otomatik Yukleme"
if !errorlevel! neq 0 (
    echo [UYARI] Commit basarisiz olabilir. Bos commit veya config eksikligi.
    echo Devam edilmeye calisiliyor...
    echo.
)
echo.

:: ============================================================
:: GIT BRANCH
:: ============================================================
echo [ADIM 4/6] Branch main olarak ayarlaniyor...
git branch -M main
if !errorlevel! neq 0 (
    echo [UYARI] Branch ayarlanamadi. Devam ediliyor...
)
echo.

:: ============================================================
:: REMOTE TEMIZLE VE EKLE
:: ============================================================
echo [ADIM 5/6] Remote origin ayarlaniyor...
git remote remove origin > nul 2>&1
git remote add origin "!REPO_URL!"
if !errorlevel! neq 0 (
    echo [HATA] Remote eklenemedi! URL'yi kontrol edin: !REPO_URL!
    echo.
    pause
    exit /b 1
)
echo [OK] Remote eklendi.
echo.

:: ============================================================
:: GIT PUSH
:: ============================================================
echo [ADIM 6/6] git push calisiyor...
echo (Bu adim GitHub kimlik dogrulamasi isteyebilir.)
echo.
git push -u origin main
if !errorlevel! neq 0 (
    echo.
    echo [HATA] Push basarisiz!
    echo Olasi sebepler:
    echo   - GitHub kullanici adi / sifre / token yanlis
    echo   - Repo URL hatali
    echo   - Remote repoda cakisan dosya var (pull gerekebilir)
    echo.
    pause
    exit /b 1
)

:: ============================================================
:: BASARI
:: ============================================================
echo.
echo ============================================================
echo   [BASARILI] Proje GitHub'a yuklendi!
echo   URL: !REPO_URL!
echo ============================================================
echo.
pause
exit /b 0
