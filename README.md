# Social Challenge - Flutter Clean Architecture

[![CI/CD Android & iOS](https://github.com/YOUR_USERNAME/social_challenge/actions/workflows/main.yml/badge.svg)](https://github.com/YOUR_USERNAME/social_challenge/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/YOUR_USERNAME/social_challenge/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR_USERNAME/social_challenge)

Aplicación Flutter para Android e iOS implementando Clean Architecture con gestión de estado híbrida (Bloc + Provider +
Riverpod).

## 🏗️ Arquitectura

```
lib/
├── app/
│   ├── config/           # Configuración (DI, Router, Theme)
│   ├── domain/           # Entidades, Repositorios, Use Cases
│   ├── data/             # Data Sources, Repositorios Impl
│   └── presentation/     # UI, Bloc, Providers
```

## 🚀 Características

- ✅ Clean Architecture con SOLID
- ✅ Gestión de estado híbrida (Bloc + Provider + Riverpod)
- ✅ Comunicación nativa con Pigeon (Android/iOS)
- ✅ Persistencia local con SharedPreferences
- ✅ Material Design 3
- ✅ Responsive (Mobile, Tablet)
- ✅ Tests unitarios, integración y UI
- ✅ CI/CD para Android e iOS

## 📱 Plataformas Soportadas

- Android (APK)
- iOS (IPA)

## 🛠️ Configuración

### Requisitos

- Flutter 3.24.0+
- Dart 3.11.0+
- Android Studio / Xcode

### Instalación

```bash
# Clonar repositorio
git clone https://github.com/YOUR_USERNAME/social_challenge.git
cd social_challenge

# Instalar dependencias
flutter pub get

# Generar código
dart run build_runner build --delete-conflicting-outputs
dart run pigeon --input pigeons/api.dart

# Ejecutar
flutter run
```

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Con cobertura
flutter test --coverage

# Generar mocks
dart run build_runner build
```

## 📦 Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔄 CI/CD

El proyecto incluye workflows de GitHub Actions para:

- **main.yml**: Build automático para Android e iOS
- **release.yml**: Release automático al crear tags

### Triggers

- Push a `develop` o `main`
- Pull requests a `develop`
- Tags `v*` para releases

## 📚 Dependencias Principales

- `flutter_bloc`: Gestión de estado
- `provider`: Micro-estados UI
- `flutter_riverpod`: Service locator global
- `get_it`: Inyección de dependencias
- `dio`: Cliente HTTP
- `go_router`: Navegación
- `freezed`: Inmutabilidad
- `pigeon`: Comunicación nativa
- `shared_preferences`: Persistencia local

## 🎨 UI/UX

- Skeleton screens durante carga
- Debouncing en búsqueda (500ms)
- Animaciones staggered en comentarios
- Micro-animaciones en likes
- SliverAppBar con gradientes
- Diseño responsivo con LayoutBuilder

## 🧩 Gestión de Estado

- **Bloc/Cubit**: Lógica de negocio pesada
- **Provider**: UI pura y micro-estados
- **Riverpod**: Estado global y service locator

## 📄 Licencia

MIT License
