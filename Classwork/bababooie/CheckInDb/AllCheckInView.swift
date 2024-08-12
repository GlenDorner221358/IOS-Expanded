//view

import SwiftUI

struct AllCheckInView: View {

    @ObservedObject var viewModel = CheckInViewModel()

    // var of all the checkins
    var listOfItems: [CheckInItem] = [
        CheckInItem(title: "Test", description: "test", isCompleted: false)
    ]
    
    var body: some View {
        NavigationView{

            VStack {

                NavigationLink(destination: AddCheckInView().environmentObject(ViewModel)) {
                    HStack {
                        Text("Add New Item")
                        
                        Spacer()
                        
                        Image(systemName: "doc.badge.plus")
                    }
                }

                List {

                    ForEach(viewModel.allCheckInItems) { item in
                        NavigationLink(destination: CheckInDetailView(item: item).environmentObject(viewModel)) {
                            Text(item.title)
                        }
                    }

                }

            }.padding()

            .onAppear(perform: {
                if(viewModel.allCheckInItems.isEmpty) {
                    viewModel.getAllItems()
                } else {
                    print("data there")
                }
            })
        }
    }
}

#Preview {
    AllCheckInView()
}