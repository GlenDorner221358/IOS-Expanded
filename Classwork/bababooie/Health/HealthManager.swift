//
//  HealthManager.swift
//  bababooie
//
//  Created by student on 2024/07/26.
//

import Foundation
import HealthKit

class HealthManager : ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var healthStats: [HealthStat] = []
    
    //runs when the app is launched
    init() {
        authoriseHealthAccess()
    }
    
    func authoriseHealthAccess(){
        
        if HKHealthStore.isHealthDataAvailable(){
            let dataTypes: Set = [
                HKQuantityType(.stepCount),
                HKQuantityType(.heartRate),
                HKQuantityType(.activeEnergyBurned)
            ]
            
            Task {
                do {
                    
                    try await healthStore.requestAuthorization(toShare: [], read: dataTypes)
                    print("Access granted to healthkit")
                    
                    //ACCESS GRANTED
                    getStepCounts()
                    
                    
                } catch {
                    print("Error handling HealthKit Access.")
                }
            }
        }
    
    }
 
    func getStepCounts() {
        let steps = HKQuantityType(.stepCount) //what do we want
        //timeframe - predicate - when do we want it
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) 
        {
            _, result, error in
            
            //error handling
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error getting stepcount: \(error?.localizedDescription)")
                return
            }
            
            //the actual step count
            let stepCountValue = quantity.doubleValue(for: .count())
            
            DispatchQueue.main.async {
                self.healthStats.append(
                    HealthStat(
                        title: "Total Steps",
                        amount: "\(stepCountValue.rounded(.towardZero))",
                        image: "figure.walk.circle",
                        color: .green
                    )
                )
            }
            
        }
        
        healthStore.execute(query)
        
    }
    
}
