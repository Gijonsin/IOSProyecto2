# EcoImpacto - Aplicación iOS de Monitoreo Ambiental

## Descripción

EcoImpacto es una aplicación móvil desarrollada para iOS con Objective-C que permite a los usuarios monitorear, analizar y reducir su impacto ambiental. La app incentiva la adopción de hábitos sostenibles mediante el seguimiento de actividades diarias, cálculo de huella de carbono y desafíos ecológicos.

## Objetivo del Proyecto

Desarrollar una aplicación funcional que permita a los usuarios registrar y analizar sus hábitos ecológicos, proporcionando información útil y motivadora para fomentar la sostenibilidad personal y comunitaria.

## Características Implementadas

### ✅ Pantalla de Inicio / Dashboard
- Visualización de progreso diario de carbono ahorrado
- Visualización de progreso semanal
- Estadísticas totales históricas
- Interfaz intuitiva con tarjetas visuales

### ✅ Registro de Hábitos Sostenibles
- **Caminar**: Registra kilómetros caminados en lugar de usar coche
- **Reciclar**: Registra cantidad de materiales reciclados
- **Reducir Consumo Eléctrico**: Registra kWh ahorrados
- **Transporte Público**: Registra kilómetros en transporte público
- **Evitar Plástico**: Registra productos de plástico evitados

### ✅ Cálculo de Huella de Carbono
- Algoritmos básicos para estimar el carbono ahorrado por cada actividad
- Cálculos basados en:
  - Caminar vs conducir: ~0.2 kg CO₂ por km
  - Reciclaje: ~0.5 kg CO₂ por kg reciclado
  - Reducción eléctrica: ~0.5 kg CO₂ por kWh ahorrado
  - Transporte público: ~0.15 kg CO₂ por km
  - Evitar plástico: ~2 kg CO₂ por kg de plástico evitado

### ✅ Desafíos Ecológicos Semanales
- **Evita el uso de plásticos**: 3 días sin plásticos de un solo uso
- **Camina o usa bicicleta**: 5 días al trabajo caminando/en bici
- **Ahorro de energía**: 7 días reduciendo consumo eléctrico
- **Recicla todo**: 7 días separando y reciclando todos los desechos
- **Vegetariano por una semana**: 5 días de alimentación vegetariana
- Sistema de seguimiento de progreso por desafío
- Notificaciones de logros completados

### ✅ Almacenamiento Local
- Persistencia de datos usando NSUserDefaults
- Almacenamiento de hábitos registrados
- Almacenamiento de desafíos y su progreso
- Conversión segura entre objetos y diccionarios

### ✅ Notificaciones y Recordatorios Sostenibles
- Recordatorio matutino (9:00 AM): Registro de hábitos
- Recordatorio vespertino (8:00 PM): Revisión del impacto diario
- Sistema de notificaciones locales con UNUserNotificationCenter

### ✅ Estadísticas
- Total de carbono ahorrado por día
- Total de carbono ahorrado por semana
- Total histórico de carbono ahorrado
- Visualización clara en el dashboard

## Arquitectura Técnica

### Modelos de Datos

#### EcoHabit
Modelo para representar hábitos sostenibles registrados:
- `habitID`: Identificador único
- `type`: Tipo de hábito (enum)
- `name`: Nombre del hábito
- `description`: Descripción
- `date`: Fecha de registro
- `carbonSaved`: Carbono ahorrado calculado
- `quantity`: Cantidad registrada
- `unit`: Unidad de medida

#### EcoChallenge
Modelo para desafíos ecológicos:
- `challengeID`: Identificador único
- `title`: Título del desafío
- `description`: Descripción
- `startDate` y `endDate`: Período del desafío
- `targetDays`: Días objetivo
- `completedDays`: Días completados
- `isCompleted`: Estado de completitud
- `potentialCarbonSavings`: Ahorro potencial de CO₂

#### DataManager
Singleton para gestión de datos:
- Guardado y recuperación de hábitos
- Guardado y recuperación de desafíos
- Cálculo de estadísticas
- Filtrado por fecha y período

### Controladores

#### DashboardViewController
- Vista principal de la aplicación
- Muestra estadísticas en tiempo real
- Lista de desafíos activos
- Botones de acción para registrar hábitos y ver historial
- Gestión de alertas y diálogos de entrada

## Requisitos del Sistema

- iOS 13.0 o superior
- Xcode 11.0 o superior
- Objective-C

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/Gijonsin/IOSProyecto2.git
```

2. Abrir el proyecto en Xcode:
```bash
cd IOSProyecto2
open IOSProyecto2.xcodeproj
```

3. Compilar y ejecutar en simulador o dispositivo iOS

## Uso de la Aplicación

### Registrar un Hábito
1. Pulsa el botón "➕ Registrar Hábito"
2. Selecciona el tipo de hábito
3. Ingresa la cantidad (km, kg, kWh, etc.)
4. La aplicación calculará automáticamente el CO₂ ahorrado

### Seguir un Desafío
1. En el dashboard, visualiza los desafíos activos
2. Pulsa sobre un desafío para ver detalles
3. Marca cada día completado
4. Recibe notificación al completar el desafío

### Ver Estadísticas
- El dashboard muestra automáticamente:
  - Carbono ahorrado hoy
  - Carbono ahorrado esta semana
  - Total histórico de carbono ahorrado

## Pruebas

El proyecto incluye pruebas unitarias para:
- Creación y validación de modelos EcoHabit
- Cálculo de huella de carbono
- Conversión entre objetos y diccionarios
- Creación y progreso de EcoChallenge
- Operaciones de DataManager (guardar, recuperar, eliminar)
- Cálculo de estadísticas

Para ejecutar las pruebas:
```bash
# Desde Xcode: Product > Test (⌘U)
# O desde línea de comandos:
xcodebuild test -scheme IOSProyecto2 -destination 'platform=iOS Simulator,name=iPhone 14'
```

## Estructura del Proyecto

```
IOSProyecto2/
├── IOSProyecto2/
│   ├── AppDelegate.h/m          # Configuración de la app y notificaciones
│   ├── SceneDelegate.h/m        # Gestión de escenas
│   ├── ViewController.h/m       # Controlador principal (hereda Dashboard)
│   ├── DashboardViewController.h/m  # Dashboard principal
│   ├── EcoHabit.h/m            # Modelo de hábitos
│   ├── EcoChallenge.h/m        # Modelo de desafíos
│   ├── DataManager.h/m         # Gestor de persistencia
│   ├── Base.lproj/
│   │   ├── Main.storyboard     # Interfaz principal
│   │   └── LaunchScreen.storyboard
│   ├── Assets.xcassets/        # Recursos visuales
│   └── Info.plist              # Configuración
├── IOSProyecto2Tests/          # Pruebas unitarias
└── IOSProyecto2UITests/        # Pruebas de UI
```

## Competencias Desarrolladas

✅ Implementación de soluciones móviles para iOS empleando Objective-C en Xcode
✅ Aplicación de principios de diseño sostenible
✅ Implementación de persistencia de datos local
✅ Creación de experiencia de usuario responsable con el medio ambiente
✅ Desarrollo de algoritmos de cálculo de impacto ambiental
✅ Implementación de sistema de notificaciones
✅ Diseño de arquitectura MVC (Model-View-Controller)
✅ Pruebas unitarias y validación de funcionalidad

## Futuras Mejoras

- [ ] Gráficos visuales para el historial (usando Charts framework)
- [ ] Exportación de datos a CSV/PDF
- [ ] Integración con redes sociales para compartir logros
- [ ] Sistema de logros y gamificación
- [ ] Comparación con promedios de otros usuarios
- [ ] Consejos personalizados basados en hábitos
- [ ] Integración con HealthKit para datos de actividad física
- [ ] Modo oscuro
- [ ] Soporte para múltiples idiomas

## Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto fue desarrollado como parte de un proyecto educativo.

## Autor

Desarrollado para demostrar competencias en desarrollo iOS con Objective-C y conciencia ambiental.

---

**¡Juntos podemos hacer la diferencia por el planeta! 🌍💚**
