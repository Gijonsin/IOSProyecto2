//
//  IOSProyecto2Tests.m
//  IOSProyecto2Tests
//
//  Created by Guest User on 13/11/25.
//

#import <XCTest/XCTest.h>
#import "EcoHabit.h"
#import "EcoChallenge.h"
#import "DataManager.h"

@interface IOSProyecto2Tests : XCTestCase

@end

@implementation IOSProyecto2Tests

- (void)setUp {
    // Clear all data before each test
    [[DataManager sharedManager] clearAllData];
}

- (void)tearDown {
    // Clear all data after each test
    [[DataManager sharedManager] clearAllData];
}

- (void)testEcoHabitCreation {
    EcoHabit *habit = [[EcoHabit alloc] initWithType:HabitTypeWalking
                                                name:@"Caminar"
                                         description:@"Test walking"
                                            quantity:5.0
                                                unit:@"km"];
    
    XCTAssertNotNil(habit);
    XCTAssertEqual(habit.type, HabitTypeWalking);
    XCTAssertEqualObjects(habit.name, @"Caminar");
    XCTAssertEqual(habit.quantity, 5.0);
    XCTAssertEqualObjects(habit.unit, @"km");
    XCTAssertEqual(habit.carbonSaved, 1.0); // 5.0 km * 0.2 kg CO2/km
}

- (void)testEcoHabitCarbonCalculation {
    // Test walking
    EcoHabit *walkingHabit = [[EcoHabit alloc] initWithType:HabitTypeWalking
                                                       name:@"Caminar"
                                                description:@"Test"
                                                   quantity:10.0
                                                       unit:@"km"];
    XCTAssertEqual(walkingHabit.carbonSaved, 2.0); // 10 * 0.2
    
    // Test recycling
    EcoHabit *recyclingHabit = [[EcoHabit alloc] initWithType:HabitTypeRecycling
                                                         name:@"Reciclar"
                                                  description:@"Test"
                                                     quantity:4.0
                                                         unit:@"kg"];
    XCTAssertEqual(recyclingHabit.carbonSaved, 2.0); // 4 * 0.5
}

- (void)testEcoHabitDictionaryConversion {
    EcoHabit *habit = [[EcoHabit alloc] initWithType:HabitTypeRecycling
                                                name:@"Reciclar"
                                         description:@"Test"
                                            quantity:3.0
                                                unit:@"kg"];
    
    NSDictionary *dict = [habit toDictionary];
    XCTAssertNotNil(dict);
    
    EcoHabit *reconstructed = [EcoHabit fromDictionary:dict];
    XCTAssertNotNil(reconstructed);
    XCTAssertEqual(reconstructed.type, habit.type);
    XCTAssertEqualObjects(reconstructed.name, habit.name);
    XCTAssertEqual(reconstructed.quantity, habit.quantity);
}

- (void)testEcoChallengeCreation {
    EcoChallenge *challenge = [[EcoChallenge alloc] initWithTitle:@"Test Challenge"
                                                      description:@"Test Description"
                                                       targetDays:7
                                            potentialCarbonSavings:5.0];
    
    XCTAssertNotNil(challenge);
    XCTAssertEqualObjects(challenge.title, @"Test Challenge");
    XCTAssertEqual(challenge.targetDays, 7);
    XCTAssertEqual(challenge.completedDays, 0);
    XCTAssertFalse(challenge.isCompleted);
}

- (void)testEcoChallengeProgress {
    EcoChallenge *challenge = [[EcoChallenge alloc] initWithTitle:@"Test"
                                                      description:@"Test"
                                                       targetDays:5
                                            potentialCarbonSavings:5.0];
    
    XCTAssertEqual([challenge progressPercentage], 0.0);
    
    [challenge markDayCompleted];
    XCTAssertEqual(challenge.completedDays, 1);
    XCTAssertEqual([challenge progressPercentage], 20.0);
    
    for (int i = 0; i < 4; i++) {
        [challenge markDayCompleted];
    }
    
    XCTAssertEqual(challenge.completedDays, 5);
    XCTAssertTrue(challenge.isCompleted);
    XCTAssertEqual([challenge progressPercentage], 100.0);
}

- (void)testDataManagerSaveAndRetrieveHabit {
    DataManager *manager = [DataManager sharedManager];
    
    EcoHabit *habit = [[EcoHabit alloc] initWithType:HabitTypeWalking
                                                name:@"Test Habit"
                                         description:@"Test"
                                            quantity:5.0
                                                unit:@"km"];
    
    [manager saveHabit:habit];
    
    NSArray *habits = [manager allHabits];
    XCTAssertEqual(habits.count, 1);
    
    EcoHabit *retrieved = habits.firstObject;
    XCTAssertEqualObjects(retrieved.name, @"Test Habit");
    XCTAssertEqual(retrieved.quantity, 5.0);
}

- (void)testDataManagerCarbonStatistics {
    DataManager *manager = [DataManager sharedManager];
    
    EcoHabit *habit1 = [[EcoHabit alloc] initWithType:HabitTypeWalking
                                                 name:@"Walking"
                                          description:@"Test"
                                             quantity:10.0
                                                 unit:@"km"];
    
    EcoHabit *habit2 = [[EcoHabit alloc] initWithType:HabitTypeRecycling
                                                 name:@"Recycling"
                                          description:@"Test"
                                             quantity:2.0
                                                 unit:@"kg"];
    
    [manager saveHabit:habit1];
    [manager saveHabit:habit2];
    
    double total = [manager totalCarbonSavedAllTime];
    XCTAssertEqual(total, 3.0); // 10*0.2 + 2*0.5 = 2.0 + 1.0 = 3.0
}

- (void)testDataManagerDeleteHabit {
    DataManager *manager = [DataManager sharedManager];
    
    EcoHabit *habit = [[EcoHabit alloc] initWithType:HabitTypeWalking
                                                name:@"Test"
                                         description:@"Test"
                                            quantity:5.0
                                                unit:@"km"];
    
    [manager saveHabit:habit];
    XCTAssertEqual([manager allHabits].count, 1);
    
    [manager deleteHabit:habit];
    XCTAssertEqual([manager allHabits].count, 0);
}

- (void)testDefaultChallenges {
    NSArray *challenges = [EcoChallenge defaultWeeklyChallenges];
    XCTAssertNotNil(challenges);
    XCTAssertTrue(challenges.count > 0);
    
    EcoChallenge *firstChallenge = challenges.firstObject;
    XCTAssertNotNil(firstChallenge.title);
    XCTAssertNotNil(firstChallenge.challengeDescription);
    XCTAssertTrue(firstChallenge.targetDays > 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        DataManager *manager = [DataManager sharedManager];
        for (int i = 0; i < 100; i++) {
            EcoHabit *habit = [[EcoHabit alloc] initWithType:HabitTypeWalking
                                                        name:@"Test"
                                                 description:@"Test"
                                                    quantity:1.0
                                                        unit:@"km"];
            [manager saveHabit:habit];
        }
    }];
}

@end
