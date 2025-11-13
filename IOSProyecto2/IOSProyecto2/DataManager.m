//
//  DataManager.m
//  IOSProyecto2
//

#import "DataManager.h"

static NSString *const kHabitsKey = @"SavedHabits";
static NSString *const kChallengesKey = @"SavedChallenges";

@interface DataManager ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Habit Management

- (void)saveHabit:(EcoHabit *)habit {
    NSMutableArray *habits = [[self allHabits] mutableCopy];
    if (!habits) {
        habits = [NSMutableArray array];
    }
    [habits addObject:habit];
    
    NSMutableArray *habitDicts = [NSMutableArray array];
    for (EcoHabit *h in habits) {
        [habitDicts addObject:[h toDictionary]];
    }
    
    [self.userDefaults setObject:habitDicts forKey:kHabitsKey];
    [self.userDefaults synchronize];
}

- (NSArray<EcoHabit *> *)allHabits {
    NSArray *habitDicts = [self.userDefaults arrayForKey:kHabitsKey];
    if (!habitDicts) {
        return @[];
    }
    
    NSMutableArray *habits = [NSMutableArray array];
    for (NSDictionary *dict in habitDicts) {
        EcoHabit *habit = [EcoHabit fromDictionary:dict];
        [habits addObject:habit];
    }
    
    // Sort by date, most recent first
    return [habits sortedArrayUsingComparator:^NSComparisonResult(EcoHabit *obj1, EcoHabit *obj2) {
        return [obj2.date compare:obj1.date];
    }];
}

- (NSArray<EcoHabit *> *)habitsForDate:(NSDate *)date {
    NSArray *allHabits = [self allHabits];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSMutableArray *filteredHabits = [NSMutableArray array];
    for (EcoHabit *habit in allHabits) {
        if ([calendar isDate:habit.date inSameDayAsDate:date]) {
            [filteredHabits addObject:habit];
        }
    }
    
    return filteredHabits;
}

- (NSArray<EcoHabit *> *)habitsForWeek:(NSDate *)weekStart {
    NSArray *allHabits = [self allHabits];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *weekEnd = [calendar dateByAddingUnit:NSCalendarUnitDay value:7 toDate:weekStart options:0];
    
    NSMutableArray *filteredHabits = [NSMutableArray array];
    for (EcoHabit *habit in allHabits) {
        if ([habit.date compare:weekStart] != NSOrderedAscending && 
            [habit.date compare:weekEnd] == NSOrderedAscending) {
            [filteredHabits addObject:habit];
        }
    }
    
    return filteredHabits;
}

- (void)deleteHabit:(EcoHabit *)habit {
    NSMutableArray *habits = [[self allHabits] mutableCopy];
    NSUInteger index = [habits indexOfObjectPassingTest:^BOOL(EcoHabit *obj, NSUInteger idx, BOOL *stop) {
        return [obj.habitID isEqualToString:habit.habitID];
    }];
    
    if (index != NSNotFound) {
        [habits removeObjectAtIndex:index];
        
        NSMutableArray *habitDicts = [NSMutableArray array];
        for (EcoHabit *h in habits) {
            [habitDicts addObject:[h toDictionary]];
        }
        
        [self.userDefaults setObject:habitDicts forKey:kHabitsKey];
        [self.userDefaults synchronize];
    }
}

#pragma mark - Challenge Management

- (void)saveChallenge:(EcoChallenge *)challenge {
    NSMutableArray *challenges = [[self allChallenges] mutableCopy];
    if (!challenges) {
        challenges = [NSMutableArray array];
    }
    
    // Check if challenge already exists and update it
    NSUInteger index = [challenges indexOfObjectPassingTest:^BOOL(EcoChallenge *obj, NSUInteger idx, BOOL *stop) {
        return [obj.challengeID isEqualToString:challenge.challengeID];
    }];
    
    if (index != NSNotFound) {
        [challenges replaceObjectAtIndex:index withObject:challenge];
    } else {
        [challenges addObject:challenge];
    }
    
    NSMutableArray *challengeDicts = [NSMutableArray array];
    for (EcoChallenge *c in challenges) {
        [challengeDicts addObject:[c toDictionary]];
    }
    
    [self.userDefaults setObject:challengeDicts forKey:kChallengesKey];
    [self.userDefaults synchronize];
}

- (NSArray<EcoChallenge *> *)allChallenges {
    NSArray *challengeDicts = [self.userDefaults arrayForKey:kChallengesKey];
    if (!challengeDicts) {
        return @[];
    }
    
    NSMutableArray *challenges = [NSMutableArray array];
    for (NSDictionary *dict in challengeDicts) {
        EcoChallenge *challenge = [EcoChallenge fromDictionary:dict];
        [challenges addObject:challenge];
    }
    
    return challenges;
}

- (NSArray<EcoChallenge *> *)activeChallenges {
    NSArray *allChallenges = [self allChallenges];
    NSMutableArray *active = [NSMutableArray array];
    
    for (EcoChallenge *challenge in allChallenges) {
        if ([challenge isActive]) {
            [active addObject:challenge];
        }
    }
    
    return active;
}

- (void)deleteChallenge:(EcoChallenge *)challenge {
    NSMutableArray *challenges = [[self allChallenges] mutableCopy];
    NSUInteger index = [challenges indexOfObjectPassingTest:^BOOL(EcoChallenge *obj, NSUInteger idx, BOOL *stop) {
        return [obj.challengeID isEqualToString:challenge.challengeID];
    }];
    
    if (index != NSNotFound) {
        [challenges removeObjectAtIndex:index];
        
        NSMutableArray *challengeDicts = [NSMutableArray array];
        for (EcoChallenge *c in challenges) {
            [challengeDicts addObject:[c toDictionary]];
        }
        
        [self.userDefaults setObject:challengeDicts forKey:kChallengesKey];
        [self.userDefaults synchronize];
    }
}

#pragma mark - Statistics

- (double)totalCarbonSavedForDate:(NSDate *)date {
    NSArray *habits = [self habitsForDate:date];
    double total = 0.0;
    for (EcoHabit *habit in habits) {
        total += habit.carbonSaved;
    }
    return total;
}

- (double)totalCarbonSavedForWeek:(NSDate *)weekStart {
    NSArray *habits = [self habitsForWeek:weekStart];
    double total = 0.0;
    for (EcoHabit *habit in habits) {
        total += habit.carbonSaved;
    }
    return total;
}

- (double)totalCarbonSavedAllTime {
    NSArray *habits = [self allHabits];
    double total = 0.0;
    for (EcoHabit *habit in habits) {
        total += habit.carbonSaved;
    }
    return total;
}

#pragma mark - Data Clearing

- (void)clearAllData {
    [self.userDefaults removeObjectForKey:kHabitsKey];
    [self.userDefaults removeObjectForKey:kChallengesKey];
    [self.userDefaults synchronize];
}

@end
