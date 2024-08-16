//
//  ContentView.swift
//  Stepper
//
//  Created by Glen on 2024/07/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboarded") private var isOnboarded = false

    var body: some View {
        if isOnboarded {
            LoginView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
