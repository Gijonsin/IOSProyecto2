//
//  EcoChallenge.h
//  IOSProyecto2
//
//  Weekly ecological challenge model
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EcoChallenge : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, strong) NSString *challengeID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *challengeDescription;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger targetDays;
@property (nonatomic, assign) NSInteger completedDays;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, assign) double potentialCarbonSavings;

- (instancetype)initWithTitle:(NSString *)title 
                  description:(NSString *)description 
                   targetDays:(NSInteger)targetDays
        potentialCarbonSavings:(double)savings;

- (void)markDayCompleted;
- (double)progressPercentage;
- (BOOL)isActive;

- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dictionary;

+ (NSArray<EcoChallenge *> *)defaultWeeklyChallenges;

@end

NS_ASSUME_NONNULL_END
