# EcoImpacto - Guía de Desarrollo

## Estructura de la Aplicación

### Modelos de Datos

#### EcoHabit (EcoHabit.h/m)
Representa un hábito sostenible registrado por el usuario.

**Propiedades:**
- `habitID`: Identificador único del hábito
- `type`: Tipo de hábito (enum: Walking, Recycling, ReduceElectricity, PublicTransport, AvoidPlastic, Other)
- `name`: Nombre del hábito
- `habitDescription`: Descripción del hábito
- `date`: Fecha de registro
- `carbonSaved`: Cantidad de CO₂ ahorrado (calculado automáticamente)
- `quantity`: Cantidad de la actividad
- `unit`: Unidad de medida (km, kg, kWh, etc.)

**Métodos principales:**
- `initWithType:name:description:quantity:unit:` - Inicializa un nuevo hábito
- `calculateCarbonSaved` - Calcula el CO₂ ahorrado basado en el tipo de hábito
- `toDictionary` / `fromDictionary:` - Serialización/deserialización

**Fórmulas de cálculo de CO₂:**
- Caminar: 0.2 kg CO₂ por km (vs. conducir)
- Reciclar: 0.5 kg CO₂ por kg reciclado
- Reducir electricidad: 0.5 kg CO₂ por kWh ahorrado
- Transporte público: 0.15 kg CO₂ por km (vs. coche)
- Evitar plástico: 2.0 kg CO₂ por kg de plástico evitado

#### EcoChallenge (EcoChallenge.h/m)
Representa un desafío ecológico semanal.

**Propiedades:**
- `challengeID`: Identificador único del desafío
- `title`: Título del desafío
- `challengeDescription`: Descripción detallada
- `startDate` / `endDate`: Fechas de inicio y fin
- `targetDays`: Número de días objetivo
- `completedDays`: Días completados hasta ahora
- `isCompleted`: Estado de completitud
- `potentialCarbonSavings`: CO₂ potencial a ahorrar

**Métodos principales:**
- `initWithTitle:description:targetDays:potentialCarbonSavings:` - Crea un nuevo desafío
- `markDayCompleted` - Marca un día como completado
- `progressPercentage` - Calcula el progreso actual (0-100%)
- `isActive` - Verifica si el desafío está activo

**Desafíos predefinidos:**
1. Evita el uso de plásticos (3 días) - 2.5 kg CO₂
2. Camina o usa bicicleta (5 días) - 5.0 kg CO₂
3. Ahorro de energía (7 días) - 3.5 kg CO₂
4. Recicla todo (7 días) - 4.0 kg CO₂
5. Vegetariano por una semana (5 días) - 6.0 kg CO₂

### Gestión de Datos

#### DataManager (DataManager.h/m)
Singleton que gestiona toda la persistencia de datos usando NSUserDefaults.

**Métodos de hábitos:**
- `saveHabit:` - Guarda un hábito
- `allHabits` - Obtiene todos los hábitos
- `habitsForDate:` - Obtiene hábitos de un día específico
- `habitsForWeek:` - Obtiene hábitos de una semana
- `deleteHabit:` - Elimina un hábito

**Métodos de desafíos:**
- `saveChallenge:` - Guarda un desafío
- `allChallenges` - Obtiene todos los desafíos
- `activeChallenges` - Obtiene solo los desafíos activos
- `deleteChallenge:` - Elimina un desafío

**Métodos de estadísticas:**
- `totalCarbonSavedForDate:` - CO₂ total de un día
- `totalCarbonSavedForWeek:` - CO₂ total de una semana
- `totalCarbonSavedAllTime` - CO₂ total histórico

**Implementación:**
- Usa NSUserDefaults para almacenamiento persistente
- Convierte objetos a diccionarios para serialización
- Patrón Singleton para acceso global

### Vistas y Controladores

#### DashboardViewController (DashboardViewController.h/m)
Vista principal de la aplicación.

**Componentes visuales:**
- Título de la aplicación
- Tarjeta de progreso diario
- Tarjeta de progreso semanal
- Tarjeta de progreso total
- Lista de desafíos activos
- Botón para registrar hábitos
- Botón para ver historial

**Funcionalidad:**
- Actualiza estadísticas al aparecer la vista
- Permite registrar nuevos hábitos mediante diálogos
- Muestra y permite interactuar con desafíos activos
- Diseño con UITableView para desafíos
- Uso de UIAlertController para entrada de datos

**Ciclo de vida:**
- `viewDidLoad` - Configura la UI inicial
- `viewWillAppear` - Actualiza datos antes de mostrar
- `updateStatistics` - Recalcula y muestra estadísticas
- `loadActiveChallenges` - Carga desafíos del DataManager

#### ViewController (ViewController.h/m)
Controlador principal que hereda de DashboardViewController.

### Notificaciones

#### AppDelegate (AppDelegate.m)
Gestiona las notificaciones de la aplicación.

**Notificaciones implementadas:**
- Recordatorio matutino (9:00 AM): "¡Buenos días! Recuerda registrar tus hábitos sostenibles de hoy."
- Recordatorio vespertino (8:00 PM): "No olvides revisar tu impacto ambiental de hoy."

**Configuración:**
- Solicita permisos al iniciar la app
- Usa UNUserNotificationCenter
- Programadas con UNCalendarNotificationTrigger
- Se repiten diariamente

## Flujo de Usuario

### Primer uso
1. Usuario abre la aplicación
2. Se solicitan permisos de notificación
3. Se cargan desafíos predefinidos si no existen
4. Se muestra el dashboard con estadísticas en 0

### Registrar un hábito
1. Usuario toca "➕ Registrar Hábito"
2. Selecciona tipo de hábito
3. Ingresa cantidad
4. Sistema calcula CO₂ ahorrado
5. Hábito se guarda en DataManager
6. Estadísticas se actualizan automáticamente

### Completar un desafío
1. Usuario toca un desafío activo
2. Sistema muestra detalles del desafío
3. Usuario marca día completado
4. Progreso se actualiza
5. Si se completa, se muestra mensaje de felicitación

## Pruebas

### Pruebas unitarias (IOSProyecto2Tests.m)

**Pruebas de EcoHabit:**
- Creación de hábitos
- Cálculo de carbono ahorrado
- Conversión a/desde diccionario

**Pruebas de EcoChallenge:**
- Creación de desafíos
- Marcado de progreso
- Cálculo de porcentaje de completitud
- Estado activo/completado

**Pruebas de DataManager:**
- Guardado y recuperación de hábitos
- Guardado y recuperación de desafíos
- Cálculo de estadísticas
- Eliminación de datos
- Prueba de rendimiento

### Ejecutar pruebas
```bash
xcodebuild test -scheme IOSProyecto2 -destination 'platform=iOS Simulator,name=iPhone 14'
```

## Arquitectura

### Patrón de diseño
- **MVC (Model-View-Controller)**
  - Modelos: EcoHabit, EcoChallenge
  - Vistas: DashboardViewController
  - Controlador: DataManager (también actúa como servicio)

- **Singleton**
  - DataManager para acceso centralizado a datos

### Persistencia
- NSUserDefaults para almacenamiento simple
- Serialización mediante protocolos NSCoding y diccionarios
- Claves de almacenamiento: "SavedHabits", "SavedChallenges"

### Notificaciones
- UNUserNotificationCenter para notificaciones locales
- Permisos solicitados en AppDelegate
- Triggers basados en calendario para repetición diaria

## Extensibilidad

### Agregar nuevos tipos de hábitos
1. Añadir caso en enum `HabitType` (EcoHabit.h)
2. Añadir cálculo en `calculateCarbonSaved` (EcoHabit.m)
3. Añadir caso en `nameForHabitType:` (EcoHabit.m)
4. Añadir opción en menú (DashboardViewController.m)

### Agregar nuevos desafíos
1. Modificar `defaultWeeklyChallenges` en EcoChallenge.m
2. O crear desafíos dinámicamente con `initWithTitle:description:targetDays:potentialCarbonSavings:`

### Cambiar persistencia
1. Implementar nueva versión de DataManager
2. Mantener misma interfaz pública
3. Migrar datos existentes si es necesario

## Mejores Prácticas Implementadas

✅ Uso de protocolos NSCoding para serialización
✅ Patrón Singleton para gestión centralizada
✅ Separación de responsabilidades (MVC)
✅ Constantes para claves de almacenamiento
✅ Métodos de conveniencia para conversión de datos
✅ Validación de datos antes de guardar
✅ Pruebas unitarias exhaustivas
✅ Comentarios y documentación en código
✅ Nombres descriptivos en español para UI
✅ Uso de Auto Layout para UI responsive

## Seguridad

### Consideraciones implementadas:
- NSUserDefaults para datos no sensibles (no se guardan contraseñas ni tokens)
- NSSecureCoding para prevenir ataques de deserialización
- No se exponen APIs externas
- Datos almacenados localmente en el dispositivo
- No hay transmisión de datos a servidores externos

### Limitaciones:
- NSUserDefaults no está encriptado por defecto
- Para datos sensibles, se recomienda usar Keychain
- En esta app, los datos son estadísticas personales sin información crítica

## Mantenimiento

### Limpieza de datos
```objc
[[DataManager sharedManager] clearAllData];
```

### Depuración
- Usar logs con NSLog para seguimiento
- Revisar UserDefaults con:
```bash
defaults read com.yourcompany.IOSProyecto2
```

### Actualización de versiones
1. Incrementar versión en Info.plist
2. Añadir migración de datos si cambia formato
3. Probar en simulador antes de desplegar

---

Este documento proporciona una visión completa de la arquitectura y funcionamiento de EcoImpacto.
