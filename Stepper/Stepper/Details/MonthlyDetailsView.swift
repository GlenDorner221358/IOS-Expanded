import SwiftUI
import Charts

struct MonthlyDetailsView: View {
    @ObservedObject var manager = StepManager()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                NavigationLink(destination: DashboardView()) {
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
                            x: .value("Day", dayFromTitle(stat.title)),
                            y: .value("Steps", Double(stat.amount) ?? 0)
                        )
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: 1)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .number)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            manager.getStepsThisMonth()
        }
    }
    
    func dayFromTitle(_ title: String) -> Int {
        // Extract the day from the title string
        let components = title.split(separator: " ")
        if let dayComponent = components.first(where: { Int($0) != nil }) {
            return Int(dayComponent) ?? 1
        }
        return 1
    }
}

struct MonthlyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyDetailsView()
    }
}
