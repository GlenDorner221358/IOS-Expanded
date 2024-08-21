import SwiftUI
import Charts

struct MonthlyDetailsView: View {
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
            
            if manager.healthStatsMonthly.isEmpty {
                Text("Loading data...")
            } else {
                Chart {
                    ForEach(manager.healthStatsMonthly, id: \.title) { stat in
                        BarMark(
                            x: .value("Day", stat.title),
                            y: .value("Steps", Double(stat.amount) ?? 0)
                        )
                    }
                }
                .chartStyle(BarChartStyle())
                .padding()
            }
        }//END OF VSTACK
        .onAppear {
            manager.getStepsThisMonth()
        }
    }
}

struct MonthlyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyDetailsView()
    }
}
