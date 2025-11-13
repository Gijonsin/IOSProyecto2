//
//  EcoHabit.h
//  IOSProyecto2
//
//  Environmental habit tracking model
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HabitType) {
    HabitTypeWalking,
    HabitTypeRecycling,
    HabitTypeReduceElectricity,
    HabitTypePublicTransport,
    HabitTypeAvoidPlastic,
    HabitTypeOther
};

@interface EcoHabit : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, strong) NSString *habitID;
@property (nonatomic, assign) HabitType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *habitDescription;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) double carbonSaved; // kg CO2
@property (nonatomic, assign) double quantity; // distance walked, items recycled, etc.
@property (nonatomic, strong) NSString *unit;

- (instancetype)initWithType:(HabitType)type 
                        name:(NSString *)name 
                 description:(NSString *)description 
                    quantity:(double)quantity 
                        unit:(NSString *)unit;

- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dictionary;
+ (NSString *)nameForHabitType:(HabitType)type;

@end

NS_ASSUME_NONNULL_END
