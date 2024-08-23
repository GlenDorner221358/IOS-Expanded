//
//  StepWidget.swift
//  StepWidget
//
//  Created by student on 2024/08/23.
//

import WidgetKit
import SwiftUI

//sets up our entry point and refresh timeline
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.co.za.openwindow.bababooie")
        let totalSteps = userDefaults?.double(forKey: "totalSteps")
        
        entries[0]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, steps: totalSteps ?? 0)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

//model of our widget data
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var steps: Double = 0 // adding the steps that will be displayed
}

//swift ui view
struct StepWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily  //represents all the different widget types

    var body: some View {
        
        switch widgetFamily {
            
        case .systemSmall:
            
            VStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
                Text("Today:")
                Text(entry.date, style: .date)
            }
            
        case .systemMedium:
            VStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
                Text(entry.date, style: .date)
            }
            
        case .systemLarge:
            VStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
                Text("Today:")
                Text(entry.date, style: .date)
            }
            
        case .systemExtraLarge:
            VStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
                Text("Today:")
                Text(entry.date, style: .date)
            }
            
        case .accessoryCircular:
            VStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("\(entry.steps)")
                    .font(.headline)
                    .padding(5)
            
            }
            
        case .accessoryRectangular:
            HStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
            }
            
        case .accessoryInline:
            HStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
            }
            
        @unknown default:
            VStack {
                Image(systemName: "figure.walk.diamond")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.purple)
                
                Text("\(entry.steps) Steps")
                    .font(.headline)
                    .padding(5)
                
                Text("Today:")
                Text(entry.date, style: .date)
            }
        }
        
        
    }
}

struct StepWidget: Widget {
    let kind: String = "StepWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StepWidgetEntryView(entry: entry)
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
                //change this to change what is previewed
#Preview(as: .systemMedium) {
    StepWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
