import Foundation
import HealthKit

class StepManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var healthStats: [HealthStat] = []
    
    init() {
        authoriseHealthAccess()
    }
    
    func authoriseHealthAccess() {

        if HKHealthStore.isHealthDataAvailable() {
            guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
                print("Step count type is unavailable.")
                return
            }
            
            let dataTypes: Set = [stepCountType]
            
            Task {
                do {
                    try await healthStore.requestAuthorization(toShare: [], read: dataTypes)
                    print("HealthKit allowed :)")
                    getStepCountForToday()
                } catch {
                    print("HealthKit Not Allowed :(")
                }
            }
        }
    }
 
    func getStepCountForToday() {
        guard let steps = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("Step count type is unavailable.")
            return
        }
        
        // timeframe
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {
            _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error getting step count for today: \(String(describing: error?.localizedDescription))")
                return
            }
            
            // the actual step count
            let stepCountValue = quantity.doubleValue(for: .count())
            
            DispatchQueue.main.async {
                self.healthStats.append(
                    HealthStat(
                        title: "Total Steps For Today: ",
                        amount: "\(stepCountValue.rounded(.towardZero))"
                    )
                )
            }
        }
        
        healthStore.execute(query)
    }
}
