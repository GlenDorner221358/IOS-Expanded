import SwiftUI
import Charts

struct WeeklyDetailsView: View {
    @ObservedObject var manager = StepManager()
    
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
            
            if manager.healthStatsWeekly.isEmpty {
                Text("Loading data...")
            } else {
                Chart {
                    ForEach(manager.healthStatsWeekly, id: \.title) { stat in
                        BarMark(
                            x: .value("Day", stat.title),
                            y: .value("Steps", Double(stat.amount) ?? 0)
                        )
                    }
                }
                .padding()
            }
        }//END OF VSTACK
        .onAppear {
            manager.getStepsThisWeek()
        }
    }
}

struct WeeklyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyDetailsView()
    }
}
