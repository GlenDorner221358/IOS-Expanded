import Foundation
import HealthKit
import Foundation
import FirebaseAuth
import FirebaseFirestore

class StepManager: ObservableObject {
    
    // FUV section (Frequently Used Variables)
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid ?? "defaultUserId"
    let calendar = Calendar.current

    let healthStore = HKHealthStore()
    @Published var healthStats: [HealthStat] = []
    @Published var healthStatsPb: [HealthStat] = []
    @Published var healthStatsWeekly: [HealthStat] = []
    @Published var healthStatsMonthly: [HealthStat] = []

    
    // authorizes health access
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
 
    // gets the steps for today
    func getStepCountForToday() {
        guard let steps = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("Step count type is unavailable.")
            return
        }
        
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

    // gets the steps for this month
    func getStepsThisMonth() {
        let currentDate = Date()
        
        let year = String(calendar.component(.year, from: currentDate))
        let month = calendar.monthSymbols[calendar.component(.month, from: currentDate) - 1]
        
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = range.count
        
        db.collection("users").document(userId)
            .collection("history").document(year)
            .collection(month)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    self.healthStatsMonthly.removeAll()
                    for day in 1...numDays {
                        let dayString = String(format: "%02d", day)
                        if let document = querySnapshot?.documents.first(where: { $0.documentID == dayString }),
                        let stepsTaken = document.data()["Steps Taken"] as? Double {
                            DispatchQueue.main.async {
                                self.healthStatsMonthly.append(
                                    HealthStat(
                                        title: "Steps Taken on \(month) \(dayString), \(year): ",
                                        amount: "\(stepsTaken.rounded(.towardZero))"
                                    )
                                )
                            }
                        } else {
                            print("No data available for \(month) \(dayString), \(year). Skipping this day.")
                        }
                    }
                }
            }
    }

    // gets the steps for this week
    func getStepsThisWeek() {
        let today = Date()

        let dispatchGroup = DispatchGroup()
        self.healthStatsWeekly.removeAll()

        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let year = calendar.component(.year, from: date)
                let month = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
                let day = calendar.component(.day, from: date)
                let dayString = String(format: "%02d", day)
                
                dispatchGroup.enter()
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
                            }
                        } else {
                            print("Document does not exist for \(month) \(dayString), \(year). Skipping this day.")
                        }
                        dispatchGroup.leave()
                    }
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("Finished fetching weekly steps")
        }
    }

    // you wont believe what this one does
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

    // stores the steps for today in the database
    func storeSteps() {
        guard let steps = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("Step count type is unavailable.")
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: calendar.startOfDay(for: Date()), end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {
            _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error getting step count for today: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let stepCountValue = quantity.doubleValue(for: .count())
            let currentDate = Date()
            
            let year = String(self.calendar.component(.year, from: currentDate))
            let month = self.calendar.monthSymbols[self.calendar.component(.month, from: currentDate) - 1]
            let day = String(format: "%02d", self.calendar.component(.day, from: currentDate))
            
            let documentData: [String: Any] = [
                "Steps Taken": stepCountValue
            ]
            
            self.db.collection("users").document(self.userId)
                .collection("history").document(year)
                .collection(month).document(day)
                .setData(documentData) { error in
                    if let error = error {
                        print("Error storing steps data: \(error.localizedDescription)")
                    } else {
                        print("Successfully stored steps data for \(day) \(month), \(year).")
                    }
                }
        }
        
        healthStore.execute(query)
    }


}
