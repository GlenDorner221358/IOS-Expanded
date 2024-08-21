import Foundation
import HealthKit

class StepManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var healthStats: [HealthStat] = []
    @Published var healthStatsPb: [HealthStat] = []
    @Published var healthStatsWeekly: [HealthStat] = []
    @Published var healthStatsMonthly: [HealthStat] = []

    
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

    func getStepsThisMonth() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? "defaultUserId"
        let year = "2024"
        let month = "August"
        
        for day in 1...30 {
            let dayString = String(format: "%02d", day)
            
            db.collection("users").document(userId)
                .collection("history").document(year)
                .collection(month).document(dayString)
                .getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let stepsTaken = document.data()?["Steps Taken"] as? Double {
                            DispatchQueue.main.async {
                                self.healthStatsMonthly.append(
                                    HealthStat(
                                        title: "Steps Taken on \(month) \(dayString), \(year): ",
                                        amount: "\(stepsTaken.rounded(.towardZero))"
                                    )
                                )
                            }
                        } else {
                            print("Steps Taken data is not available for \(month) \(dayString), \(year).")
                        }
                    } else {
                        print("Document does not exist for \(month) \(dayString), \(year): \(String(describing: error?.localizedDescription))")
                    }
                }
        }
    }

    func getStepsThisWeek() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? "defaultUserId"
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let year = calendar.component(.year, from: date)
                let month = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
                let day = calendar.component(.day, from: date)
                let dayString = String(format: "%02d", day)
                
                db.collection("users").document(userId)
                    .collection("history").document("\(year)")
                    .collection(month).document(dayString)
                    .getDocument { (document, error) in
                        if let document = document, document.exists {
                            if let stepsTaken = document.data()?["Steps Taken"] as? Double {
                                DispatchQueue.main.async {
                                    self.healthStatsWeekly.append(
                                        HealthStat(
                                            title: "Steps Taken on \(month) \(dayString), \(year): ",
                                            amount: "\(stepsTaken.rounded(.towardZero))"
                                        )
                                    )
                                }
                            } else {
                                print("Steps Taken data is not available for \(month) \(dayString), \(year).")
                            }
                        } else {
                            print("Document does not exist for \(month) \(dayString), \(year): \(String(describing: error?.localizedDescription))")
                        }
                    }
            }
        }
    }

    func getPersonalBest() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? "defaultUserId"
        
        db.collection("users").document(userId).collection("history").document("personalBest").getDocument { (document, error) in
            if let document = document, document.exists {
                if let Pb = document.data()?["Pb"] as? Double {
                    DispatchQueue.main.async {
                        self.healthStatsPb.append(
                            HealthStat(
                                title: "Personal Best: ",
                                amount: "\(Pb.rounded(.towardZero))"
                            )
                        )
                    }
                } else {
                    print("Personal best data is not available.")
                }
            } else {
                print("Document does not exist: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}