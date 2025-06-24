#!/bin/bash

#charger les variables d'environnements
source .env

echo "🔧 Build de l'image ${IMAGE_NAME}..."
docker-compose build

echo "🚀 Démarrage des conteneurs..."
docker-compose up -d

git add .
git commit -m "message de commit"
git branch -M main
git remote add origin "path/repository.git"
git pull -u origine main --rebase
git push -u origin main