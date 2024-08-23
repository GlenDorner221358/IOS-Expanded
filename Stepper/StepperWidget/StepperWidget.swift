//
//  StepperWidget.swift
//  StepperWidget
//
//  Created by student on 2024/08/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.co.za.openwindow.stepper")
        let stepsForToday = userDefaults?.double(forKey: "stepsForToday")
        
        entries[0]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, steps: stepsForToday ?? 0)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var steps: Double = 0
}

// swift ui view
struct StepperWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        
        switch widgetFamily {
            
        case .systemSmall:
            
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps Taken")
            }
            
        case .systemMedium:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps Taken")
            }
            
        case .systemLarge:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps Taken")
            }
            
        case .systemExtraLarge:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps Taken")
            }
            
        case .accessoryCircular:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps")
            }
            
        case .accessoryRectangular:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps")
            }
            
        case .accessoryInline:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps")
            }
            
        @unknown default:
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                
                Text("Steps Taken")
            }
            
        }
        
    }
}

struct StepperWidget: Widget {
    let kind: String = "StepperWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StepperWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    StepperWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
