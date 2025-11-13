//
//  DashboardViewController.m
//  IOSProyecto2
//

#import "DashboardViewController.h"
#import "DataManager.h"
#import "EcoHabit.h"
#import "EcoChallenge.h"

@interface DashboardViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *todayCarbonLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *weekCarbonLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *totalCarbonLabel;
@property (nonatomic, strong) UILabel *activeChallengesLabel;
@property (nonatomic, strong) UITableView *challengesTableView;
@property (nonatomic, strong) UIButton *addHabitButton;
@property (nonatomic, strong) UIButton *viewHistoryButton;

@property (nonatomic, strong) NSArray<EcoChallenge *> *activeChallenges;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.98 blue:0.95 alpha:1.0];
    self.title = @"EcoImpacto";
    
    [self setupUI];
    [self loadDefaultChallengesIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateStatistics];
    [self loadActiveChallenges];
}

- (void)setupUI {
    // Title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"🌍 Panel de Control Ecológico";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleLabel];
    
    // Today's Progress
    UIView *todayCard = [self createCardView];
    self.todayLabel = [[UILabel alloc] init];
    self.todayLabel.text = @"Hoy";
    self.todayLabel.font = [UIFont boldSystemFontOfSize:18];
    self.todayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [todayCard addSubview:self.todayLabel];
    
    self.todayCarbonLabel = [[UILabel alloc] init];
    self.todayCarbonLabel.text = @"0.0 kg CO₂ ahorrados";
    self.todayCarbonLabel.font = [UIFont systemFontOfSize:16];
    self.todayCarbonLabel.textColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.3 alpha:1.0];
    self.todayCarbonLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [todayCard addSubview:self.todayCarbonLabel];
    
    // Weekly Progress
    UIView *weekCard = [self createCardView];
    self.weekLabel = [[UILabel alloc] init];
    self.weekLabel.text = @"Esta Semana";
    self.weekLabel.font = [UIFont boldSystemFontOfSize:18];
    self.weekLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [weekCard addSubview:self.weekLabel];
    
    self.weekCarbonLabel = [[UILabel alloc] init];
    self.weekCarbonLabel.text = @"0.0 kg CO₂ ahorrados";
    self.weekCarbonLabel.font = [UIFont systemFontOfSize:16];
    self.weekCarbonLabel.textColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.3 alpha:1.0];
    self.weekCarbonLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [weekCard addSubview:self.weekCarbonLabel];
    
    // Total Progress
    UIView *totalCard = [self createCardView];
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.text = @"Total Histórico";
    self.totalLabel.font = [UIFont boldSystemFontOfSize:18];
    self.totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [totalCard addSubview:self.totalLabel];
    
    self.totalCarbonLabel = [[UILabel alloc] init];
    self.totalCarbonLabel.text = @"0.0 kg CO₂ ahorrados";
    self.totalCarbonLabel.font = [UIFont systemFontOfSize:16];
    self.totalCarbonLabel.textColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.3 alpha:1.0];
    self.totalCarbonLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [totalCard addSubview:self.totalCarbonLabel];
    
    // Active Challenges
    self.activeChallengesLabel = [[UILabel alloc] init];
    self.activeChallengesLabel.text = @"Desafíos Activos";
    self.activeChallengesLabel.font = [UIFont boldSystemFontOfSize:20];
    self.activeChallengesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.activeChallengesLabel];
    
    self.challengesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.challengesTableView.delegate = self;
    self.challengesTableView.dataSource = self;
    self.challengesTableView.backgroundColor = [UIColor clearColor];
    self.challengesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.challengesTableView];
    
    // Buttons
    self.addHabitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addHabitButton setTitle:@"➕ Registrar Hábito" forState:UIControlStateNormal];
    self.addHabitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.addHabitButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    [self.addHabitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addHabitButton.layer.cornerRadius = 10;
    [self.addHabitButton addTarget:self action:@selector(addHabitTapped) forControlEvents:UIControlEventTouchUpInside];
    self.addHabitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.addHabitButton];
    
    self.viewHistoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.viewHistoryButton setTitle:@"📊 Ver Historial" forState:UIControlStateNormal];
    self.viewHistoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.viewHistoryButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1.0];
    [self.viewHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.viewHistoryButton.layer.cornerRadius = 10;
    [self.viewHistoryButton addTarget:self action:@selector(viewHistoryTapped) forControlEvents:UIControlEventTouchUpInside];
    self.viewHistoryButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.viewHistoryButton];
    
    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [todayCard.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:20],
        [todayCard.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [todayCard.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [todayCard.heightAnchor constraintEqualToConstant:70],
        
        [self.todayLabel.topAnchor constraintEqualToAnchor:todayCard.topAnchor constant:10],
        [self.todayLabel.leadingAnchor constraintEqualToAnchor:todayCard.leadingAnchor constant:15],
        [self.todayCarbonLabel.topAnchor constraintEqualToAnchor:self.todayLabel.bottomAnchor constant:5],
        [self.todayCarbonLabel.leadingAnchor constraintEqualToAnchor:todayCard.leadingAnchor constant:15],
        
        [weekCard.topAnchor constraintEqualToAnchor:todayCard.bottomAnchor constant:10],
        [weekCard.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [weekCard.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [weekCard.heightAnchor constraintEqualToConstant:70],
        
        [self.weekLabel.topAnchor constraintEqualToAnchor:weekCard.topAnchor constant:10],
        [self.weekLabel.leadingAnchor constraintEqualToAnchor:weekCard.leadingAnchor constant:15],
        [self.weekCarbonLabel.topAnchor constraintEqualToAnchor:self.weekLabel.bottomAnchor constant:5],
        [self.weekCarbonLabel.leadingAnchor constraintEqualToAnchor:weekCard.leadingAnchor constant:15],
        
        [totalCard.topAnchor constraintEqualToAnchor:weekCard.bottomAnchor constant:10],
        [totalCard.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [totalCard.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [totalCard.heightAnchor constraintEqualToConstant:70],
        
        [self.totalLabel.topAnchor constraintEqualToAnchor:totalCard.topAnchor constant:10],
        [self.totalLabel.leadingAnchor constraintEqualToAnchor:totalCard.leadingAnchor constant:15],
        [self.totalCarbonLabel.topAnchor constraintEqualToAnchor:self.totalLabel.bottomAnchor constant:5],
        [self.totalCarbonLabel.leadingAnchor constraintEqualToAnchor:totalCard.leadingAnchor constant:15],
        
        [self.activeChallengesLabel.topAnchor constraintEqualToAnchor:totalCard.bottomAnchor constant:20],
        [self.activeChallengesLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        
        [self.challengesTableView.topAnchor constraintEqualToAnchor:self.activeChallengesLabel.bottomAnchor constant:10],
        [self.challengesTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.challengesTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.challengesTableView.heightAnchor constraintEqualToConstant:150],
        
        [self.addHabitButton.topAnchor constraintEqualToAnchor:self.challengesTableView.bottomAnchor constant:20],
        [self.addHabitButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.addHabitButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.addHabitButton.heightAnchor constraintEqualToConstant:50],
        
        [self.viewHistoryButton.topAnchor constraintEqualToAnchor:self.addHabitButton.bottomAnchor constant:10],
        [self.viewHistoryButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.viewHistoryButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.viewHistoryButton.heightAnchor constraintEqualToConstant:50],
    ]];
}

- (UIView *)createCardView {
    UIView *card = [[UIView alloc] init];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 10;
    card.layer.shadowColor = [UIColor blackColor].CGColor;
    card.layer.shadowOffset = CGSizeMake(0, 2);
    card.layer.shadowRadius = 4;
    card.layer.shadowOpacity = 0.1;
    card.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:card];
    return card;
}

- (void)updateStatistics {
    DataManager *manager = [DataManager sharedManager];
    
    // Today's carbon savings
    double todayCarbon = [manager totalCarbonSavedForDate:[NSDate date]];
    self.todayCarbonLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂ ahorrados", todayCarbon];
    
    // This week's carbon savings
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *weekStart = [calendar dateFromComponents:[calendar components:NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekOfYear fromDate:[NSDate date]]];
    double weekCarbon = [manager totalCarbonSavedForWeek:weekStart];
    self.weekCarbonLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂ ahorrados", weekCarbon];
    
    // Total carbon savings
    double totalCarbon = [manager totalCarbonSavedAllTime];
    self.totalCarbonLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂ ahorrados", totalCarbon];
}

- (void)loadDefaultChallengesIfNeeded {
    DataManager *manager = [DataManager sharedManager];
    NSArray *existing = [manager allChallenges];
    
    if (existing.count == 0) {
        NSArray *defaultChallenges = [EcoChallenge defaultWeeklyChallenges];
        for (EcoChallenge *challenge in defaultChallenges) {
            [manager saveChallenge:challenge];
        }
    }
}

- (void)loadActiveChallenges {
    self.activeChallenges = [[DataManager sharedManager] activeChallenges];
    [self.challengesTableView reloadData];
}

- (void)addHabitTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registrar Hábito Sostenible"
                                                                   message:@"Selecciona el tipo de hábito"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Caminar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showHabitDetailForType:HabitTypeWalking];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Reciclar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showHabitDetailForType:HabitTypeRecycling];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Reducir Electricidad" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showHabitDetailForType:HabitTypeReduceElectricity];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Transporte Público" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showHabitDetailForType:HabitTypePublicTransport];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Evitar Plástico" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showHabitDetailForType:HabitTypeAvoidPlastic];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showHabitDetailForType:(HabitType)type {
    NSString *title = [EcoHabit nameForHabitType:type];
    NSString *unit = @"";
    NSString *message = @"";
    
    switch (type) {
        case HabitTypeWalking:
            unit = @"km";
            message = @"¿Cuántos kilómetros caminaste en lugar de usar el coche?";
            break;
        case HabitTypeRecycling:
            unit = @"kg";
            message = @"¿Cuántos kg de materiales reciclaste?";
            break;
        case HabitTypeReduceElectricity:
            unit = @"kWh";
            message = @"¿Cuántos kWh de electricidad ahorraste?";
            break;
        case HabitTypePublicTransport:
            unit = @"km";
            message = @"¿Cuántos km viajaste en transporte público?";
            break;
        case HabitTypeAvoidPlastic:
            unit = @"items";
            message = @"¿Cuántos productos de plástico evitaste?";
            break;
        default:
            unit = @"unidades";
            message = @"Ingresa la cantidad";
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = unit;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Guardar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields.firstObject;
        double quantity = [textField.text doubleValue];
        
        if (quantity > 0) {
            EcoHabit *habit = [[EcoHabit alloc] initWithType:type
                                                        name:title
                                                 description:@"Hábito registrado desde el panel"
                                                    quantity:quantity
                                                        unit:unit];
            [[DataManager sharedManager] saveHabit:habit];
            [self updateStatistics];
            
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"¡Éxito!"
                                                                                   message:[NSString stringWithFormat:@"Has ahorrado %.1f kg CO₂", habit.carbonSaved]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewHistoryTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Historial"
                                                                   message:@"Función de historial con gráficos - Próximamente"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeChallenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChallengeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChallengeCell"];
    }
    
    EcoChallenge *challenge = self.activeChallenges[indexPath.row];
    cell.textLabel.text = challenge.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Progreso: %ld/%ld días (%.0f%%)", 
                                  (long)challenge.completedDays, 
                                  (long)challenge.targetDays,
                                  [challenge progressPercentage]];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EcoChallenge *challenge = self.activeChallenges[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:challenge.title
                                                                   message:[NSString stringWithFormat:@"%@\n\nProgreso: %ld/%ld días", challenge.challengeDescription, (long)challenge.completedDays, (long)challenge.targetDays]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Marcar día completado" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [challenge markDayCompleted];
        [[DataManager sharedManager] saveChallenge:challenge];
        [self loadActiveChallenges];
        
        if (challenge.isCompleted) {
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"¡Desafío Completado!"
                                                                                   message:[NSString stringWithFormat:@"Has completado el desafío '%@' y ahorrado aproximadamente %.1f kg CO₂", challenge.title, challenge.potentialCarbonSavings]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"¡Genial!" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
