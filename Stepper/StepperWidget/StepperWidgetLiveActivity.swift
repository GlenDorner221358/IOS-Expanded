//
//  StepperWidgetLiveActivity.swift
//  StepperWidget
//
//  Created by student on 2024/08/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StepperWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StepperWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StepperWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension StepperWidgetAttributes {
    fileprivate static var preview: StepperWidgetAttributes {
        StepperWidgetAttributes(name: "World")
    }
}

extension StepperWidgetAttributes.ContentState {
    fileprivate static var smiley: StepperWidgetAttributes.ContentState {
        StepperWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StepperWidgetAttributes.ContentState {
         StepperWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StepperWidgetAttributes.preview) {
   StepperWidgetLiveActivity()
} contentStates: {
    StepperWidgetAttributes.ContentState.smiley
    StepperWidgetAttributes.ContentState.starEyes
}
