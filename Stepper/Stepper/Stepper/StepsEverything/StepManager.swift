import Foundation
import HealthKit

class HealthManager : ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var healthStats: [HealthStat] = []
    
    init() {
        authoriseHealthAccess()
    }
    
    func authoriseHealthAccess(){

        if HKHealthStore.isHealthDataAvailable(){
            let dataTypes: Set = [
                HKQuantityType(.stepCount)
            ]
            
            Task {
                do {
                    
                    try await healthStore.requestAuthorization(toShare: [], read: dataTypes)

                    print("Healthkit allowed :)")
                    getStepCountForToday()
                    
                    
                } catch {
                    print("Healthkit Not Allowed :(")
                }
            }
        }
    }
 
    func getStepCountForToday() {
        let steps = HKQuantityType(.stepCount) 
        //timeframe
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {
            _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error getting stepcount for today: \(error?.localizedDescription)")
                return
            }
            
            //the actual step count
            let stepCountValue = quantity.doubleValue(for: .count())
            
            DispatchQueue.main.async {
                self.healthStats.append(
                    HealthStat(
                        title: "Total Steps For Today: ",
                        amount: "\(stepCountValue.rounded(.towardZero))",
                    )
                )
            }  
        }
        
        healthStore.execute(query)
        
    }
    
}
