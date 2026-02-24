#!/bin/bash

echo "🔨 Generando código con build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🐦 Generando código Pigeon..."
flutter pub run pigeon --input pigeons/api.dart

echo "📱 Configurando proyecto iOS..."
cd ios

# Instalar xcodeproj en directorio de usuario si no existe
if ! gem list xcodeproj -i > /dev/null 2>&1; then
  echo "Instalando xcodeproj..."
  gem install xcodeproj --user-install --no-document
fi

# Ejecutar script Ruby
ruby add_pigeon_file.rb

cd ..

echo "✅ Generación de código completada"
echo ""
echo "Ahora ejecuta: flutter run"
