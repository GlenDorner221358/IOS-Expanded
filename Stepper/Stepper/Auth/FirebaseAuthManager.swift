import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    
    func login() {
        self.errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                self.errorMessage = error!.localizedDescription
                return
            }
            
            if authResult != nil {
                self.isLoggedIn = true
                print("Logged in USER: \(authResult!.user.uid)")
                
            }
            
        }
    }
    
    func signup() {
        self.errorMessage = ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                self.errorMessage = error!.localizedDescription
                return
            }
            
            if let authResult = authResult {
                self.isLoggedIn = true
                print("Signed Up USER: \(authResult.user.uid)")
                
                let db = Firestore.firestore()
                let userId = authResult.user.uid
                let calendar = Calendar.current
                let currentDate = Date()
                
                let year = String(calendar.component(.year, from: currentDate))
                let month = calendar.monthSymbols[calendar.component(.month, from: currentDate) - 1]
                let day = String(format: "%02d", calendar.component(.day, from: currentDate))

                // Create the new user document in Firestore
                db.collection("users").document(userId).setData([
                    "email": self.email,
                    "name": "", // Add other fields as necessary
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("User document added with ID: \(userId)")
                        
                        // Initialize the history structure
                        db.collection("users").document(userId)
                            .collection("history").document(year)
                            .setData(["PersonalBest": 0]) { err in
                                if let err = err {
                                    print("Error adding PersonalBest document: \(err)")
                                } else {
                                    // Create the specific month and day entry with today's date
                                    db.collection("users").document(userId)
                                        .collection("history").document(year)
                                        .collection(month).document(day)
                                        .setData(["Steps Taken": 0]) { err in
                                            if let err = err {
                                                print("Error creating day entry: \(err)")
                                            } else {
                                                print("Today's date entry created in the database")
                                            }
                                        }
                                }
                            }
                    }
                }
            }
        }
    }

    
}