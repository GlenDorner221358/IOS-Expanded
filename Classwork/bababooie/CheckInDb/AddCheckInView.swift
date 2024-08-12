//view

import SwiftUI

struct AddCheckInView: View {

    // input field state vars
    @State var title: = ""
    @State var description = ""

    @EnvironmentObject var viewModel: CheckInViewModel

    var body: some View {
        VStack {
            Text("Add a new check in item")

            TextField("title", text: $title, prompt: Text("Your Check In Title"))
                .padding()
                .background(.black)
                .foregroundColor(.white)
                .foregroundStyle(.white)

            TextField("description", text: $description, prompt: Text("Your Check In description"))
                .padding()
                .background(.black)
                .foregroundColor(.white)
                .foregroundStyle(.white)

            Button(action: {
                viewModel.createItem(checkIn: CheckInItem(title: self.title, description: self.description, isCompleted: false))
            }) {
                Text("Add Check In")
            }.padding()

            Spacer()

        }.padding()
    }
}

#Preview {
    AddCheckInView()
}