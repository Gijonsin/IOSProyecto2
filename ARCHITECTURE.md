# Arquitectura de EcoImpacto

## Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────────┐
│                      EcoImpacto iOS App                          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        App Delegate                              │
│  - Gestión del ciclo de vida de la app                          │
│  - Configuración de notificaciones                              │
│  - Recordatorios diarios (9 AM y 8 PM)                          │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   DashboardViewController                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Dashboard UI (Vista Principal)                         │   │
│  │  - Tarjeta de progreso diario                           │   │
│  │  - Tarjeta de progreso semanal                          │   │
│  │  - Tarjeta de progreso total                            │   │
│  │  - Lista de desafíos activos                            │   │
│  │  - Botón "Registrar Hábito"                             │   │
│  │  - Botón "Ver Historial"                                │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                            │
                            │ usa
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DataManager (Singleton)                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Gestión de Datos                                       │   │
│  │  - saveHabit / allHabits / deleteHabit                  │   │
│  │  - saveChallenge / allChallenges / deleteChallenge      │   │
│  │  - totalCarbonSavedForDate / ForWeek / AllTime          │   │
│  │  - habitsForDate / habitsForWeek                        │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                            │
            ┌───────────────┴────────────────┐
            ▼                                 ▼
┌──────────────────────────┐    ┌──────────────────────────┐
│     EcoHabit Model       │    │   EcoChallenge Model     │
│  ┌────────────────────┐  │    │  ┌────────────────────┐  │
│  │ Propiedades:       │  │    │  │ Propiedades:       │  │
│  │ - habitID          │  │    │  │ - challengeID      │  │
│  │ - type             │  │    │  │ - title            │  │
│  │ - name             │  │    │  │ - description      │  │
│  │ - date             │  │    │  │ - startDate        │  │
│  │ - carbonSaved      │  │    │  │ - endDate          │  │
│  │ - quantity         │  │    │  │ - targetDays       │  │
│  │ - unit             │  │    │  │ - completedDays    │  │
│  └────────────────────┘  │    │  │ - isCompleted      │  │
│  ┌────────────────────┐  │    │  └────────────────────┘  │
│  │ Métodos:           │  │    │  ┌────────────────────┐  │
│  │ - init...          │  │    │  │ Métodos:           │  │
│  │ - calculateCarbon  │  │    │  │ - init...          │  │
│  │ - toDictionary     │  │    │  │ - markDayCompleted │  │
│  │ - fromDictionary   │  │    │  │ - progressPercent  │  │
│  └────────────────────┘  │    │  │ - isActive         │  │
└──────────────────────────┘    │  └────────────────────┘  │
                                └──────────────────────────┘
                                             │
                                             ▼
                                ┌──────────────────────────┐
                                │  Default Challenges      │
                                │  - Evitar plásticos      │
                                │  - Caminar/bicicleta     │
                                │  - Ahorro energía        │
                                │  - Reciclar todo         │
                                │  - Vegetariano           │
                                └──────────────────────────┘

            ┌───────────────────┴────────────────────┐
            ▼                                        ▼
┌──────────────────────────┐         ┌──────────────────────────┐
│   NSUserDefaults         │         │   UNNotificationCenter   │
│  (Persistencia Local)    │         │  (Notificaciones)        │
│                          │         │                          │
│  Claves:                 │         │  - Morning reminder      │
│  - "SavedHabits"         │         │  - Evening reminder      │
│  - "SavedChallenges"     │         │                          │
└──────────────────────────┘         └──────────────────────────┘
```

## Flujo de Datos

### Registrar un Hábito

```
Usuario → DashboardVC → "Registrar Hábito"
                 ↓
         Selecciona tipo
                 ↓
         Ingresa cantidad
                 ↓
         Crea EcoHabit → calculateCarbonSaved()
                 ↓
         DataManager → saveHabit()
                 ↓
         NSUserDefaults → Guarda array de diccionarios
                 ↓
         DashboardVC → updateStatistics()
                 ↓
         Actualiza UI
```

### Completar Desafío

```
Usuario → DashboardVC → Toca desafío
                 ↓
         Muestra detalles
                 ↓
         "Marcar día completado"
                 ↓
         EcoChallenge → markDayCompleted()
                 ↓
         DataManager → saveChallenge()
                 ↓
         NSUserDefaults → Actualiza challenge
                 ↓
         Si isCompleted → Muestra felicitación
                 ↓
         DashboardVC → loadActiveChallenges()
                 ↓
         Actualiza TableView
```

### Cálculo de Estadísticas

```
DashboardVC → viewWillAppear
                 ↓
         DataManager → totalCarbonSavedForDate(today)
                 ↓
         habitsForDate(today) → Suma carbonSaved
                 ↓
         DataManager → totalCarbonSavedForWeek(weekStart)
                 ↓
         habitsForWeek(weekStart) → Suma carbonSaved
                 ↓
         DataManager → totalCarbonSavedAllTime()
                 ↓
         allHabits() → Suma carbonSaved de todos
                 ↓
         DashboardVC → Actualiza labels con resultados
```

## Tipos de Hábitos y Fórmulas

```
┌────────────────────────────────────────────────────────────┐
│  Tipo de Hábito     │  Unidad  │  Factor CO₂  │  Fórmula  │
├────────────────────────────────────────────────────────────┤
│  Walking            │   km     │   0.2        │  km × 0.2 │
│  Recycling          │   kg     │   0.5        │  kg × 0.5 │
│  ReduceElectricity  │   kWh    │   0.5        │ kWh × 0.5 │
│  PublicTransport    │   km     │   0.15       │  km × 0.15│
│  AvoidPlastic       │   items  │   2.0        │  items×2.0│
│  Other              │   units  │   0.1        │  qty × 0.1│
└────────────────────────────────────────────────────────────┘
```

## Ciclo de Vida de la Aplicación

```
App Launch
    ↓
AppDelegate → didFinishLaunchingWithOptions
    ↓
Request Notification Permissions
    ↓
Schedule Daily Reminders (9 AM, 8 PM)
    ↓
SceneDelegate → willConnectToSession
    ↓
Load Main.storyboard
    ↓
Instantiate ViewController (extends DashboardViewController)
    ↓
DashboardViewController → viewDidLoad
    ↓
Setup UI (labels, cards, buttons, tableView)
    ↓
loadDefaultChallengesIfNeeded
    ↓
viewWillAppear
    ↓
updateStatistics
    ↓
loadActiveChallenges
    ↓
Display Dashboard
```

## Patrones de Diseño Utilizados

1. **Singleton**: DataManager para gestión centralizada de datos
2. **MVC**: Separación clara entre Model, View, Controller
3. **Delegation**: UITableViewDelegate, UITableViewDataSource
4. **Observer**: Notificaciones de sistema (UNUserNotificationCenter)
5. **Factory**: Métodos de clase para crear objetos predeterminados

## Seguridad y Privacidad

```
┌─────────────────────────────────────────────────┐
│  Capa de Seguridad                              │
├─────────────────────────────────────────────────┤
│  ✓ NSSecureCoding para prevenir ataques        │
│  ✓ Datos locales (no transmisión externa)      │
│  ✓ NSUserDefaults para datos no sensibles      │
│  ✓ Sin APIs externas                           │
│  ✓ Sin recolección de datos personales         │
│  ✓ Permisos claros para notificaciones         │
└─────────────────────────────────────────────────┘
```

---

Esta arquitectura proporciona una base sólida y escalable para la aplicación EcoImpacto.
