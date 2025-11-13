//
//  EcoChallenge.m
//  IOSProyecto2
//

#import "EcoChallenge.h"

@implementation EcoChallenge

- (instancetype)initWithTitle:(NSString *)title 
                  description:(NSString *)description 
                   targetDays:(NSInteger)targetDays
        potentialCarbonSavings:(double)savings {
    self = [super init];
    if (self) {
        _challengeID = [[NSUUID UUID] UUIDString];
        _title = title;
        _challengeDescription = description;
        _startDate = [NSDate date];
        _endDate = [_startDate dateByAddingTimeInterval:targetDays * 24 * 60 * 60];
        _targetDays = targetDays;
        _completedDays = 0;
        _isCompleted = NO;
        _potentialCarbonSavings = savings;
    }
    return self;
}

- (void)markDayCompleted {
    if (!self.isCompleted && self.completedDays < self.targetDays) {
        self.completedDays++;
        if (self.completedDays >= self.targetDays) {
            self.isCompleted = YES;
        }
    }
}

- (double)progressPercentage {
    if (self.targetDays == 0) return 0.0;
    return (double)self.completedDays / (double)self.targetDays * 100.0;
}

- (BOOL)isActive {
    NSDate *now = [NSDate date];
    return [now compare:self.startDate] != NSOrderedAscending && 
           [now compare:self.endDate] != NSOrderedDescending &&
           !self.isCompleted;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_challengeID forKey:@"challengeID"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_challengeDescription forKey:@"challengeDescription"];
    [coder encodeObject:_startDate forKey:@"startDate"];
    [coder encodeObject:_endDate forKey:@"endDate"];
    [coder encodeInteger:_targetDays forKey:@"targetDays"];
    [coder encodeInteger:_completedDays forKey:@"completedDays"];
    [coder encodeBool:_isCompleted forKey:@"isCompleted"];
    [coder encodeDouble:_potentialCarbonSavings forKey:@"potentialCarbonSavings"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _challengeID = [coder decodeObjectOfClass:[NSString class] forKey:@"challengeID"];
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _challengeDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"challengeDescription"];
        _startDate = [coder decodeObjectOfClass:[NSDate class] forKey:@"startDate"];
        _endDate = [coder decodeObjectOfClass:[NSDate class] forKey:@"endDate"];
        _targetDays = [coder decodeIntegerForKey:@"targetDays"];
        _completedDays = [coder decodeIntegerForKey:@"completedDays"];
        _isCompleted = [coder decodeBoolForKey:@"isCompleted"];
        _potentialCarbonSavings = [coder decodeDoubleForKey:@"potentialCarbonSavings"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - Dictionary Conversion

- (NSDictionary *)toDictionary {
    return @{
        @"challengeID": _challengeID,
        @"title": _title,
        @"challengeDescription": _challengeDescription,
        @"startDate": @([_startDate timeIntervalSince1970]),
        @"endDate": @([_endDate timeIntervalSince1970]),
        @"targetDays": @(_targetDays),
        @"completedDays": @(_completedDays),
        @"isCompleted": @(_isCompleted),
        @"potentialCarbonSavings": @(_potentialCarbonSavings)
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dictionary {
    EcoChallenge *challenge = [[EcoChallenge alloc] init];
    challenge.challengeID = dictionary[@"challengeID"];
    challenge.title = dictionary[@"title"];
    challenge.challengeDescription = dictionary[@"challengeDescription"];
    challenge.startDate = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"startDate"] doubleValue]];
    challenge.endDate = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"endDate"] doubleValue]];
    challenge.targetDays = [dictionary[@"targetDays"] integerValue];
    challenge.completedDays = [dictionary[@"completedDays"] integerValue];
    challenge.isCompleted = [dictionary[@"isCompleted"] boolValue];
    challenge.potentialCarbonSavings = [dictionary[@"potentialCarbonSavings"] doubleValue];
    return challenge;
}

#pragma mark - Default Challenges

+ (NSArray<EcoChallenge *> *)defaultWeeklyChallenges {
    return @[
        [[EcoChallenge alloc] initWithTitle:@"Evita el uso de plásticos"
                                description:@"No uses plásticos de un solo uso durante 3 días"
                                 targetDays:3
                      potentialCarbonSavings:2.5],
        [[EcoChallenge alloc] initWithTitle:@"Camina o usa bicicleta"
                                description:@"Ve al trabajo caminando o en bicicleta durante 5 días"
                                 targetDays:5
                      potentialCarbonSavings:5.0],
        [[EcoChallenge alloc] initWithTitle:@"Ahorro de energía"
                                description:@"Reduce tu consumo eléctrico apagando luces innecesarias por 7 días"
                                 targetDays:7
                      potentialCarbonSavings:3.5],
        [[EcoChallenge alloc] initWithTitle:@"Recicla todo"
                                description:@"Separa y recicla todos tus desechos durante 7 días"
                                 targetDays:7
                      potentialCarbonSavings:4.0],
        [[EcoChallenge alloc] initWithTitle:@"Vegetariano por una semana"
                                description:@"Come solo vegetales durante 5 días"
                                 targetDays:5
                      potentialCarbonSavings:6.0]
    ];
}

@end
