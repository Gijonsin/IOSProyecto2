//
//  DataManager.h
//  IOSProyecto2
//
//  Singleton manager for local data persistence
//

#import <Foundation/Foundation.h>
#import "EcoHabit.h"
#import "EcoChallenge.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (instancetype)sharedManager;

// Habit Management
- (void)saveHabit:(EcoHabit *)habit;
- (NSArray<EcoHabit *> *)allHabits;
- (NSArray<EcoHabit *> *)habitsForDate:(NSDate *)date;
- (NSArray<EcoHabit *> *)habitsForWeek:(NSDate *)weekStart;
- (void)deleteHabit:(EcoHabit *)habit;

// Challenge Management
- (void)saveChallenge:(EcoChallenge *)challenge;
- (NSArray<EcoChallenge *> *)allChallenges;
- (NSArray<EcoChallenge *> *)activeChallenges;
- (void)deleteChallenge:(EcoChallenge *)challenge;

// Statistics
- (double)totalCarbonSavedForDate:(NSDate *)date;
- (double)totalCarbonSavedForWeek:(NSDate *)weekStart;
- (double)totalCarbonSavedAllTime;

// Data Clearing
- (void)clearAllData;

@end

NS_ASSUME_NONNULL_END
