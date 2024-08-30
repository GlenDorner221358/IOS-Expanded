import SwiftUI
import Charts

struct WeeklyDetailsView: View {
    @ObservedObject var manager = StepManager()
    
    var body: some View {
        VStack {
            
            if manager.healthStatsWeekly.isEmpty {
                Text("Error obtaining weekly steps")
            } else {
                Chart {
                    ForEach(manager.healthStatsWeekly, id: \.title) { stat in
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
                        AxisValueLabel {
                            Text("\(value.as(Int.self) ?? 0)")
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            manager.getStepsThisWeek()
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

struct WeeklyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyDetailsView()
    }
}
