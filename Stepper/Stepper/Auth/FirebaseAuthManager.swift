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

        //TODO: Fix what is being created in firestore when a new user signs up
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
                
                // Create a new document in Firestore
                let db = Firestore.firestore()
                let userId = authResult.user.uid
                db.collection("users").document(userId).setData([
                    "email": self.email,
                    "name": "", // Add other fields as necessary

                    "steps": 0,
                    "personalBest": 0
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(userId)")
                    }
                }
            }
        }
    }
    
}