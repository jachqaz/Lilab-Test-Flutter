#!/bin/bash

echo "🔨 Generando código con build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "🐦 Generando código Pigeon..."
dart run pigeon --input pigeons/api.dart

echo "✅ Generación de código completada"
