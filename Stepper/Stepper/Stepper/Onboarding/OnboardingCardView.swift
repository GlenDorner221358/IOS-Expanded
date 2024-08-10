//
//  OnboardingCardView.swift
//  GameLogger
//
//  Created by Open Window Developer on 2023/11/03.
//

import SwiftUI

struct OnboardingCardView: View {
    var title: String
    var icon: String
    var description: String
    
    var body: some View {
        VStack (alignment: .center, spacing: 20){
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .white)
                .frame(width: 140, height: 140)
                .padding()
            Text(title)
                .font(.system(size: 52, weight: .heavy))
                .multilineTextAlignment(.center)
                .bold()
            Text(description)
                .multilineTextAlignment(.center)
                .font(.title)
                .bold()
        }//END OF VSTACK
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color(.lightGray))
        .cornerRadius(20)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 2, y: 10)
    }
}

struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCardView(title: "hello", icon: "flame", description: "bababooie")
    }
}
