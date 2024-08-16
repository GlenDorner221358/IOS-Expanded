import SwiftUI

struct DashboardView: View {

    @ObservedObject var manager = StepManager()

    var body: some View {
        // Safely unwrap the step count
        let stepCount = manager.healthStats.first?.amount ?? "0"
        
        VStack{
            // MAIN STEP TRACKER
            VStack{
                Text("STEPS WALKED TODAY")
                Text(stepCount)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(.lightGray))
            .cornerRadius(10)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 2, y: 10)
           
            // pb tracker STILL HAVE TO IMPLEMENT
            Text("Personal Best: 91,275")
                .frame(maxWidth: .infinity)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 2, y: 10)

            HStack{
                NavigationLink(destination: DetailsView()){
                    Button(action: {
                    // send user to Steps this month chart
                    }){
                        Text("Steps this month")
                            .padding()
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                NavigationLink(destination: DetailsView()){
                    Button(action: {
                    // send user to Steps this week chart
                    }){
                        Text("Steps this Week")
                            .padding()
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
