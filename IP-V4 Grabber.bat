@echo off

:: URL de ton webhook Discord
set "WEBHOOK_URL=Your_Webhook_Url"

:: Test de base pour vérifier si curl fonctionne
echo Test de la connexion avec curl...
curl -s Your_Webhook_Url -X POST -H "Content-Type: application/json" -d "{\"content\": \"Test de connexion\"}"
if %errorlevel% neq 0 (
    echo Erreur lors de l'envoi au webhook. Assurez-vous que curl fonctionne et que l'URL est correcte.
    pause
    exit /b
)

:: Récupérer l'adresse IP locale v4
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do set IP_V4_LOCAL=%%a
set IP_V4_LOCAL=%IP_V4_LOCAL: =%

:: Récupérer l'adresse IP publique v4 en utilisant une API externe
for /f "delims=" %%i in ('curl -s https://api.ipify.org') do set IP_PUBLIQUE_V4=%%i

:: Créer le message JSON
set "MESSAGE={\"content\":\"Voici les adresses IP v4 de l'ordinateur : IP Locale v4: %IP_V4_LOCAL%, IP Publique v4: %IP_PUBLIQUE_V4%!\"}"

:: Afficher le message
echo Message à envoyer :
echo %MESSAGE%

:: Envoi au webhook
echo Envoi au webhook...
curl -X POST -H "Content-Type: application/json" -d "%MESSAGE%" %WEBHOOK_URL%

:: Vérifier l'état du curl
if %errorlevel% neq 0 (
    echo Erreur lors de l'envoi au webhook Discord.
) else (
    echo Adresses IP v4 envoyées au webhook Discord.
)

pause
