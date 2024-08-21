//
//  ContentView.swift
//  Stepper
//
//  Created by Glen on 2024/07/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboarded") private var isOnboarded = false

    @ObservedObject var firebaseAuthManager = FirebaseAuthManager()

    var body: some View {
        if isOnboarded {
            if firebaseAuthManager.isLoggedIn {
                DashboardView()
            } else {
                LoginView()
            }
        } else {
            OnboardingView()
        }  
    }
}

#Preview {
    ContentView()
}
