import SwiftUI

struct DetailsView: View {
    var body: some View {
        
        VStack{
            HStack{
                Spacer()

                NavigationLink(destination: DashboardView()){
                    Image(systemName: "xmark.circle.fill")  
                    .font(.title2)
                }
            }
             
            Spacer()

            Text("Detailed firebase chart comes here")
        }//END OF VSTACK
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

