//
//  ContentView.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var mealViewModel = MealViewModel()
    @StateObject var petActivitiesViewModel = PetActivitiesViewModel()
    @State private var showSplashScreen = true    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
        
        UITabBar.appearance().tintColor = UIColor.black
        
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.white
        if let initialLaunchDate = UserDefaults.standard.value(forKey: "InitialLaunch") as? Date {
            print("App was first launched on: \(initialLaunchDate)")
        }

    }

    var body: some View {
           Group {
               if showSplashScreen {
                   SplashScreenView()
                       .onTapGesture {
                           withAnimation {
                               showSplashScreen = false
                           }
                       }
                       .onAppear {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                               withAnimation {
                                   showSplashScreen = false
                               }
                           }
                       }
               } else {
                   mainTabView
               }
           }
       }

       var mainTabView: some View {
           TabView {
               HomeView(mealViewModel: mealViewModel, petActivitiesViewModel: petActivitiesViewModel)
                   .tabItem {
                       Label("Home", systemImage: "house")
                   }
               MenuListView(mealViewModel: mealViewModel, petActivitiesViewModel: petActivitiesViewModel)
                   .tabItem {
                       Label("Menu", systemImage: "menucard")
                   }
               ScheduleView(mealViewModel: mealViewModel, petActivitiesViewModel: petActivitiesViewModel)
                   .tabItem {
                       Label("Schedule", systemImage: "calendar")
                   }
           }
           .background(Color.white)
       }
   }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
