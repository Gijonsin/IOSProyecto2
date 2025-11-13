//
//  EcoHabit.m
//  IOSProyecto2
//

#import "EcoHabit.h"

@implementation EcoHabit

- (instancetype)initWithType:(HabitType)type 
                        name:(NSString *)name 
                 description:(NSString *)description 
                    quantity:(double)quantity 
                        unit:(NSString *)unit {
    self = [super init];
    if (self) {
        _habitID = [[NSUUID UUID] UUIDString];
        _type = type;
        _name = name;
        _habitDescription = description;
        _date = [NSDate date];
        _quantity = quantity;
        _unit = unit;
        _carbonSaved = [self calculateCarbonSaved];
    }
    return self;
}

- (double)calculateCarbonSaved {
    // Basic carbon savings estimates (kg CO2)
    switch (self.type) {
        case HabitTypeWalking:
            // Walking instead of driving: ~0.2 kg CO2 per km
            return self.quantity * 0.2;
        case HabitTypeRecycling:
            // Recycling: ~0.5 kg CO2 per kg recycled
            return self.quantity * 0.5;
        case HabitTypeReduceElectricity:
            // Reducing electricity: ~0.5 kg CO2 per kWh saved
            return self.quantity * 0.5;
        case HabitTypePublicTransport:
            // Public transport vs car: ~0.15 kg CO2 per km
            return self.quantity * 0.15;
        case HabitTypeAvoidPlastic:
            // Avoiding plastic: ~2 kg CO2 per kg plastic avoided
            return self.quantity * 2.0;
        case HabitTypeOther:
            return self.quantity * 0.1;
        default:
            return 0.0;
    }
}

+ (NSString *)nameForHabitType:(HabitType)type {
    switch (type) {
        case HabitTypeWalking:
            return @"Caminar";
        case HabitTypeRecycling:
            return @"Reciclar";
        case HabitTypeReduceElectricity:
            return @"Reducir Electricidad";
        case HabitTypePublicTransport:
            return @"Transporte Público";
        case HabitTypeAvoidPlastic:
            return @"Evitar Plástico";
        case HabitTypeOther:
            return @"Otro";
        default:
            return @"Desconocido";
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_habitID forKey:@"habitID"];
    [coder encodeInteger:_type forKey:@"type"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_habitDescription forKey:@"habitDescription"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeDouble:_carbonSaved forKey:@"carbonSaved"];
    [coder encodeDouble:_quantity forKey:@"quantity"];
    [coder encodeObject:_unit forKey:@"unit"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _habitID = [coder decodeObjectOfClass:[NSString class] forKey:@"habitID"];
        _type = [coder decodeIntegerForKey:@"type"];
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _habitDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"habitDescription"];
        _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
        _carbonSaved = [coder decodeDoubleForKey:@"carbonSaved"];
        _quantity = [coder decodeDoubleForKey:@"quantity"];
        _unit = [coder decodeObjectOfClass:[NSString class] forKey:@"unit"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - Dictionary Conversion

- (NSDictionary *)toDictionary {
    return @{
        @"habitID": _habitID,
        @"type": @(_type),
        @"name": _name,
        @"habitDescription": _habitDescription ?: @"",
        @"date": @([_date timeIntervalSince1970]),
        @"carbonSaved": @(_carbonSaved),
        @"quantity": @(_quantity),
        @"unit": _unit
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dictionary {
    EcoHabit *habit = [[EcoHabit alloc] init];
    habit.habitID = dictionary[@"habitID"];
    habit.type = [dictionary[@"type"] integerValue];
    habit.name = dictionary[@"name"];
    habit.habitDescription = dictionary[@"habitDescription"];
    habit.date = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"date"] doubleValue]];
    habit.carbonSaved = [dictionary[@"carbonSaved"] doubleValue];
    habit.quantity = [dictionary[@"quantity"] doubleValue];
    habit.unit = dictionary[@"unit"];
    return habit;
}

@end
