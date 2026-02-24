# Social Challenge - Flutter Clean Architecture

[![CI/CD Android & iOS](https://github.com/YOUR_USERNAME/social_challenge/actions/workflows/main.yml/badge.svg)](https://github.com/YOUR_USERNAME/social_challenge/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/YOUR_USERNAME/social_challenge/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR_USERNAME/social_challenge)

Aplicación Flutter para Android e iOS implementando Clean Architecture con gestión de estado híbrida (Bloc + Provider +
Riverpod) y comunicación nativa mediante Pigeon.

**Desarrollado por Johan Castaño** con asistencia de Amazon Q Developer para optimización de código, arquitectura y
CI/CD.

---

## 🏗️ Arquitectura

### Clean Architecture + MVVM

```
lib/
├── app/
│   ├── config/              # Configuración global
│   │   ├── di/              # Inyección de dependencias (GetIt)
│   │   ├── router/          # Navegación (GoRouter)
│   │   └── theme/           # Temas Material Design 3
│   ├── domain/              # Capa de dominio (Entidades, Repositorios, Use Cases)
│   │   ├── entities/        # Modelos de negocio
│   │   ├── repositories/    # Contratos de repositorios
│   │   └── usecases/        # Casos de uso
│   ├── data/                # Capa de datos
│   │   ├── datasources/     # Fuentes de datos (API, Local)
│   │   ├── models/          # DTOs y mappers
│   │   └── repositories/    # Implementación de repositorios
│   └── presentation/        # Capa de presentación (UI + Estado)
│       ├── bloc/            # Bloc/Cubit para lógica compleja
│       ├── providers/       # Provider para micro-estados
│       └── screens/         # Pantallas y widgets
├── pigeons/                 # Definiciones Pigeon para comunicación nativa
└── main.dart
```

### Principios Aplicados

- **SOLID**: Separación de responsabilidades, inversión de dependencias
- **Clean Architecture**: Independencia de frameworks, testeable, mantenible
- **MVVM**: Separación clara entre UI y lógica de negocio
- **Repository Pattern**: Abstracción de fuentes de datos
- **Dependency Injection**: GetIt para gestión de dependencias

---

## 🚀 Características

- ✅ Clean Architecture con SOLID
- ✅ Gestión de estado híbrida (Bloc + Provider + Riverpod)
- ✅ Comunicación nativa con **Pigeon** (Android/iOS)
- ✅ Notificaciones locales nativas al dar like
- ✅ Persistencia local con SharedPreferences
- ✅ Material Design 3
- ✅ Responsive (Mobile, Tablet)
- ✅ Tests unitarios, integración y UI
- ✅ CI/CD automatizado para Android e iOS
- ✅ Skeleton screens y animaciones staggered
- ✅ Debouncing en búsqueda (500ms)

---

## 📱 Plataformas Soportadas

- ✅ Android (APK)
- ✅ iOS (IPA)
- ❌ Web, Windows, macOS, Linux (restringido en pubspec.yaml)

---

## 🛠️ Setup del Proyecto

### Requisitos

- Flutter 3.24.0+
- Dart 3.5.0+
- Android Studio / Xcode
- Ruby (para scripts iOS)
- Gem `xcodeproj` (se instala automáticamente)

### Instalación

```bash
# 1. Clonar repositorio
git clone https://github.com/YOUR_USERNAME/social_challenge.git
cd social_challenge

# 2. Instalar dependencias
flutter pub get

# 3. Generar código (Pigeon + build_runner)
./generate.sh
# O manualmente:
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run pigeon --input pigeons/api.dart

# 4. Ejecutar en modo desarrollo
flutter run
```

---

## 🐦 Pigeon Setup

### ¿Qué es Pigeon?

Pigeon genera código type-safe para comunicación entre Flutter y código nativo (Android/iOS), eliminando la necesidad de
MethodChannels manuales.

### Comando de Generación

```bash
flutter pub run pigeon --input pigeons/api.dart
```

### Archivos Generados

- `lib/app/data/datasources/native_api.g.dart` - Código Dart
- `android/app/src/main/kotlin/com/example/lilab_test_flutter/NativeApi.g.kt` - Código Kotlin
- `ios/Runner/NativeApi.g.swift` - Código Swift

### Definición de API (pigeons/api.dart)

```dart
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/app/data/datasources/native_api.g.dart',
  kotlinOut: 'android/app/src/main/kotlin/com/example/lilab_test_flutter/NativeApi.g.kt',
  swiftOut: 'ios/Runner/NativeApi.g.swift',
))
class NotificationPayload {
  final String titulo;
  final String mensaje;
}

@HostApi()
abstract class NativeService {
  bool requestNotificationPermission();

  void sendLocalNotification(NotificationPayload payload);
}
```

### Uso en Flutter

```dart

final nativeService = NativeService();
await
nativeService.sendLocalNotification
(
NotificationPayload(
titulo: 'Like',
mensaje: 'Te ha gustado: 
$
postTitle
'
,
)
,
);
```

---

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Con cobertura
flutter test --coverage

# Generar mocks (si es necesario)
flutter pub run build_runner build
```

---

## 📦 Build Local

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Salida: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
# Debug (sin codesign)
flutter build ios --debug --no-codesign

# Release (sin codesign)
flutter build ios --release --no-codesign

# Crear IPA manualmente
cd build/ios/iphoneos
mkdir Payload
cp -r Runner.app Payload/
zip -r app-release.ipa Payload
```

---

## 🔄 CI/CD con GitHub Actions

### Arquitectura del Pipeline

El proyecto utiliza un workflow optimizado con **3 jobs paralelos**:

```yaml
jobs:
  prepare:       # Genera código una sola vez
  build_android: # Compila APK en paralelo
  build_ios:     # Compila IPA en paralelo
```

### Workflow: `.github/workflows/main.yml`

#### Job 1: Prepare (Generación de Código)

```yaml
prepare:
  runs-on: ubuntu-latest
  steps:
    - Checkout código
    - Setup Flutter 3.24.0
    - flutter pub get
    - dart run build_runner build --delete-conflicting-outputs || true
    - dart run pigeon --input pigeons/api.dart
    - Upload artifacts (*.g.dart, *.freezed.dart, *.g.kt, *.g.swift)
```

#### Job 2: Build Android

```yaml
build_android:
  needs: prepare
  runs-on: ubuntu-latest
  steps:
    - Checkout código
    - Download artifacts generados
    - Setup Java 17
    - Setup Flutter 3.24.0
    - flutter pub get
    - flutter build apk --release
    - Upload APK artifact
```

#### Job 3: Build iOS

```yaml
build_ios:
  needs: prepare
  runs-on: macos-latest
  steps:
    - Checkout código
    - Download artifacts generados
    - Setup Flutter 3.24.0
    - flutter pub get
    - flutter build ios --release --no-codesign
    - Crear IPA (mkdir Payload, cp Runner.app, zip)
    - Upload IPA artifact
```

### Triggers

- **Push** a `develop` o `main`
- **Pull Request** a `develop`
- **Tags** `v*` para releases

### Descargar Artefactos

Después de cada build exitoso, los artefactos están disponibles en:

- **Actions** → **Workflow Run** → **Artifacts**
  - `android-apk` (app-release.apk)
  - `ios-ipa` (app-release.ipa)

---

## 📚 Dependencias Principales

| Dependencia          | Versión | Propósito                           |
|----------------------|---------|-------------------------------------|
| `flutter_bloc`       | 8.1.6   | Gestión de estado (lógica compleja) |
| `provider`           | 6.1.2   | Micro-estados UI                    |
| `flutter_riverpod`   | 2.6.1   | Service locator global              |
| `get_it`             | 7.7.0   | Inyección de dependencias           |
| `dio`                | 5.7.0   | Cliente HTTP                        |
| `go_router`          | 14.8.1  | Navegación declarativa              |
| `freezed`            | 2.5.8   | Inmutabilidad y code generation     |
| `pigeon`             | 22.7.4  | Comunicación nativa type-safe       |
| `shared_preferences` | 2.3.3   | Persistencia local                  |
| `json_serializable`  | 6.9.5   | Serialización JSON                  |

---

## 🎨 UI/UX

- **Skeleton screens** durante carga de datos
- **Debouncing** en búsqueda (500ms)
- **Animaciones staggered** en comentarios
- **Micro-animaciones** en likes
- **SliverAppBar** con gradientes
- **Diseño responsivo** con LayoutBuilder
- **Material Design 3** con ColorScheme

---

## 🧩 Gestión de Estado

### Estrategia Híbrida

| Herramienta    | Uso                                               |
|----------------|---------------------------------------------------|
| **Bloc/Cubit** | Lógica de negocio pesada (posts, comments, users) |
| **Provider**   | UI pura y micro-estados (likes, favoritos)        |
| **Riverpod**   | Estado global y service locator                   |

### Ejemplo: PostBloc

```dart
class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;

  PostBloc(this.getPostsUseCase) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await getPostsUseCase();
    result.fold(
              (failure) => emit(PostError(failure.message)),
              (posts) => emit(PostLoaded(posts)),
    );
  }
}
```

---

## 🤖 Uso de IA en el Desarrollo

### Amazon Q Developer

Este proyecto fue **orquestado y dirigido por Johan Castaño**, utilizando **Amazon Q Developer** como herramienta de
asistencia para:

#### Arquitectura y Diseño

- ✅ Definición de Clean Architecture con capas domain/data/presentation
- ✅ Implementación de patrones Repository y Dependency Injection
- ✅ Diseño de gestión de estado híbrida (Bloc + Provider + Riverpod)

#### Comunicación Nativa con Pigeon

- ✅ Configuración de Pigeon para Android/iOS
- ✅ Generación de código type-safe para notificaciones locales
- ✅ Integración con AppDelegate (iOS) y MainActivity (Android)

#### CI/CD y DevOps

- ✅ Diseño de pipeline optimizado con jobs paralelos
- ✅ Estrategia de artifacts para compartir código generado
- ✅ Configuración de builds para Android (APK) e iOS (IPA)

#### Resolución de Problemas

- ✅ Fix de crash en iOS por force unwrap de window
- ✅ Eliminación de SceneDelegate.swift y actualización de Info.plist
- ✅ Corrección de CardThemeData deprecado en Flutter 3.24
- ✅ Agregado de permiso INTERNET en AndroidManifest.xml
- ✅ Actualización de NDK version para Android

#### Scripts de Automatización

- ✅ `generate.sh` para generación de código
- ✅ Scripts Ruby para manipulación de proyecto Xcode
- ✅ Configuración de build_runner con manejo de errores

### Filosofía de Desarrollo

> **"La IA es el instrumento, el desarrollador es el director de la orquesta."**  
> — Johan Castaño

Amazon Q Developer fue utilizado como una herramienta de **aceleración y optimización**, pero todas las decisiones
arquitectónicas, estrategias de implementación y dirección del proyecto fueron **lideradas y supervisadas por Johan
Castaño**.

---

## 🔧 Scripts Útiles

### generate.sh

```bash
#!/bin/bash
echo "🔨 Generando código con build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🐦 Generando código Pigeon..."
flutter pub run pigeon --input pigeons/api.dart

echo "📱 Configurando proyecto iOS..."
cd ios
ruby add_pigeon_file.rb
cd ..

echo "✅ Generación de código completada"
```

### Uso

```bash
chmod +x generate.sh
./generate.sh
flutter run
```

---

## 📝 Notas Importantes

### Android

- Requiere NDK version `27.0.12077973`
- Permiso `INTERNET` obligatorio en AndroidManifest.xml

### iOS

- No usar SceneDelegate (removido del proyecto)
- UIApplicationSceneManifest eliminado de Info.plist
- Pigeon setup en AppDelegate después de `super.application()`

### Flutter

- SDK constraint: `>=3.5.0 <4.0.0`
- CardThemeData deprecado, usar propiedades directas en ThemeData

---

## 📄 Licencia

MIT License

---

## 👨‍💻 Autor

**Johan Castaño**  
Arquitecto de Software | Flutter Developer

*Desarrollado con asistencia de Amazon Q Developer*
