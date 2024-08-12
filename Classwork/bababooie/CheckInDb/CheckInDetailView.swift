//view

import SwiftUI

struct CheckInDetailView: View {

    var item: CheckInItem?

    @EnvironmentObject var viewModel: CheckInViewModel

    var body: some View {
        VStack{
            Text(item!.title)
            Text(item!.description)
            Text(item!.docId ?? "none")

            if(item!.isCompleted) {
                Text("All Done...")
            } else {
                Button(action: {
                    print("update...1")

                    if(item!.docId != nil) {
                        viewModel.markItemCompleted(docId: item!.docId ?? "")
                    }

                }, label: {
                    Text("Complete Check In")
                }).padding()
            }

            

        }
    }
}

#Preview {
    CheckInDetailView()
}