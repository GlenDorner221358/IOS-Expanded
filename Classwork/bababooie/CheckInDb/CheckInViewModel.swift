//view

import Foundation
import FirebaseFirestore
// All our firestore functionality

class CheckInViewModel: ObservableObject {

    let db = Firestore.firestore()
    let collectionName = "checkins"

    @Publushed var allCheckInItems: [CheckInItem] = []

    //add a new item
    func createItem(checkIn: CheckInItem) {
        
        var ref: DocumentReference?

        ref = db.collection(collectionName).addDocument(data: [
            "title": checkIn.title,
            "description": checkIn.description,
            "isCompleted": checkIn.isCompleted
        ]) { err in
        
            if let err = err {
                print("Something went wrong: \(err.localizedDescription)")
            } else {
                print("New item added Successfully")

                var newCheckIn = checkIn
                newCheckIn.docId = ref?.documentID

                // dont have to
                // self.allCheckInItems.append(CheckIn)
            }
        
        }
    }


    //get all items
    func getAllItems() {

        db.collection(collectionName).getDocuments{ snapshot, error in
            
            if error == nil {

                DispatchQueue.main.async {

                    self.allCheckInItems = snapshot!.documents.map{ doc in

                        return CheckInItem(
                            docId: doc.documentID,
                            title: doc["title"] as? String ?? "None",
                            description: doc["description"] as? String ?? "None",
                            isCompleted: doc["isCompleted"] as? Bool ?? false
                        )

                    }
                }

            } else {
                print(error?.localizedDescription?? "Something went wrong")
            }

        }

    }

    // edit an item ("mark item as completed")
    func markItemCompleted(docId: String){

        db.collection(collectionName).document(docId).updateData(["isCompleted": true]) { error in 
        
            if let error = error {
                print("something went wrong updating: \(error.localizedDescription)")
            } else {
                print("document marked completed")
            }

        }

    }


}