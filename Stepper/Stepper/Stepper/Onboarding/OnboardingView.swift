//
//  OnboardingScreen.swift
//  GameLogger
//
//  Created by Glen on 2024/07/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("isOnboarded") var isOnboarded = false
    
    var body: some View {
        ZStack{
        
            VStack{
                TabView{
                    OnboardingCardView(title: "Welcome", icon: "ADD WELCOMING SYMBOL HERE", description: "Welcome to stepper. The only fitness app you will ever need...").padding()
                    
                    OnboardingCardView(title: "Walk", icon: "ADD WALKING SYMBOL HERE!", description: "Experience the euphoria of taking a walk... and then tracking it...").padding()
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                
                NavigationLink(destination: LoginView()){
                    Button(action: {
                        isOnboarded.toggle()
                    }){
                        HStack{
                            Text("Finish")
                                .padding()
                                .bold()
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .padding()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }

            }//END Vstack
        }.background(.white)
            .ignoresSafeArea(.all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

