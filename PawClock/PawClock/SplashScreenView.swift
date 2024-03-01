//
//  SplashScreenView.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/23.
//

import SwiftUI


struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // Background color of the splash screen
            VStack {
                Text("PawClock: Nourish & Bond")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Developed by Ya-Wei Tsai")
                    .font(.title2)
            }
        }
    }
}


#Preview {
    SplashScreenView()
}
