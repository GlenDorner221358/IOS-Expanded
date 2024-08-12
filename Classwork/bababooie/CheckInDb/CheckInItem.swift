//view

import SwiftUI

// Check in model

struct CheckInItem: Identifiable {
    var id = UUID()
    var docId: String?
    var title: String
    var description: String
    var isCompleted: Bool
}