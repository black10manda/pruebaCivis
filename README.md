# Promociones · Prueba Técnica Flutter

Aplicación móvil para crear, gestionar y enviar promociones. Construida con **Flutter + Firebase** siguiendo arquitectura limpia y manejo de estado con Riverpod.

> Prueba técnica para el puesto de **Desarrollador Flutter / FlutterFlow + Firebase**.

---

## ✨ Funcionalidades

### Autenticación
- **Login** con correo y contraseña (Firebase Auth).
- **Registro** de nuevos usuarios desde la misma pantalla.
- **Persistencia de sesión** automática (el usuario sigue logueado al reabrir la app).
- **Modal de confirmación** premium al cerrar sesión.
- Validación de formularios + mensajes de error claros.

### Gestión de promociones
- **Crear** y **editar** promociones con título, descripción, fecha, imagen opcional y estado activo/pausada.
- **Imagen** opcional desde la galería (subida a Firebase Storage).
- **Listado en tiempo real** sincronizado con Firestore.
- **Filtros**: Todas / Activas / Inactivas / Enviadas / No enviadas (chips horizontales con scroll).
- **Estados vacíos** específicos para cada filtro.
- **Pull-to-refresh** en el listado.

### Envío de promociones
- Botón **"Enviar promoción"** dentro de cada card activa no enviada.
- El estado cambia visualmente al instante (badge "Enviada" + fecha).
- Persistencia del envío en Firestore (`enviadaEn`).

### Cuenta y perfil
- **Drawer** lateral con avatar, nombre, correo y opciones.
- **Datos del solicitante** en bottom sheet (tap para copiar email/teléfono/portafolio).
- **Cerrar sesión** con confirmación.

### Diseño y UX
- **Light theme** con paleta personalizada (azul `#3B82F6`).
- **Animaciones** sutiles: fade-up staggered al cargar pantallas, morph del botón primario en loading, shake del form en errores de credenciales.
- **Responsive** con `flutter_screenutil` (mismo aspecto en distintos tamaños de pantalla).

---

## 🛠 Stack técnico

| Capa | Paquete | Por qué |
|---|---|---|
| Estado | `flutter_riverpod` | Type-safe, `AsyncValue`, sin `BuildContext` para leer estado |
| Auth | `firebase_auth` | Email/password + persistencia automática |
| Base de datos | `cloud_firestore` | Streams reactivos en tiempo real |
| Archivos | `firebase_storage` | Imágenes de promociones |
| Routing | `go_router` | Redirect por auth state, deep links |
| Responsive | `flutter_screenutil` | `.w`, `.h`, `.sp`, `.r` para escalado consistente |
| Imágenes | `image_picker` | Selección desde galería |
| Fechas | `intl` | Formato `'d MMM y'` en español |

---

## 🚀 Instalación

### Requisitos previos
- **Flutter** SDK `^3.11.3` ([instalar](https://docs.flutter.dev/get-started/install))
- **Dart** incluido con Flutter
- **Android Studio** o **Xcode** para correr en emulador/dispositivo
- Cuenta de **Firebase** (solo si vas a usar tu propio backend)

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/black10manda/pruebaCivis.git
cd pruebaCivis

# 2. Instalar dependencias
flutter pub get

# 3. Verificar que todo compila
flutter analyze

# 4. Correr en un emulador/dispositivo conectado
flutter run
```

### Firebase
El proyecto ya viene preconfigurado con `firebase_options.dart` apuntando al backend de prueba. **No necesitas configurar nada** para correrlo.

Si quieres usar tu propio proyecto de Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Y habilita en la consola:
- Authentication → método **Email/Password**
- Firestore Database
- Storage

---

## 🔑 Accesos de prueba

Puedes **registrar un usuario nuevo** desde la pantalla de login (link "Regístrate"), o usar la cuenta de prueba:

```
Correo:      prueba@mail.com
Contraseña:  Password123#
```

---

## 📁 Estructura del proyecto

```
lib/
├── main.dart
├── firebase_options.dart
│
├── core/                            # Infraestructura compartida
│   ├── router/app_router.dart       # GoRouter + redirect por auth
│   ├── theme/app_theme.dart         # ThemeData centralizado
│   ├── utils/                       # validators, error_mapper
│   └── widgets/                     # app_button (morph), app_text_field, fade_in_up
│
├── features/
│   ├── auth/
│   │   ├── data/                    # AuthRepository (Firebase Auth)
│   │   ├── application/             # login, register, auth providers
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── widgets/             # brand hero, forms, drawer, dialogs, sheet
│   │
│   └── promociones/
│       ├── domain/                  # Promocion, PromocionDraft
│       ├── data/                    # PromocionesRepository (Firestore + Storage)
│       ├── application/             # providers, form controller, envío controller
│       └── presentation/
│           ├── lista_promociones_screen.dart
│           ├── promocion_form_screen.dart
│           └── widgets/             # card, header, chips, FAB, empty, image picker...
│
└── shared/
    └── constants.dart               # rutas, colecciones, paths de storage
```

---

## 🧱 Arquitectura

**Presentación → Application (controllers/providers) → Data (repositorios) → Firebase**

- Cada feature tiene sus 3 capas (`data` / `application` / `presentation`).
- Widgets reutilizables específicos de la feature en `presentation/widgets/`.
- Widgets de infraestructura cross-feature en `core/widgets/`.
- Sin `BuildContext` para leer estado; todo via `ref.watch` / `ref.read`.

---

## 📦 Build de release

```bash
flutter build apk --release
```

El APK queda en `build/app/outputs/flutter-apk/app-release.apk`.

---

## 👤 Autor

**Juan Andrés Argueta Bermúdez**
Desarrollador Flutter
[juan-argueta.com](https://juan-argueta.com) · msjuanchila@gmail.com
