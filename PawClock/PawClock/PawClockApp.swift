//
//  PawClockApp.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/8.
//

import SwiftUI
import UserNotifications

@main
struct PawClockApp: App {
    @StateObject private var viewModel = ViewModel()

    init() {
        NotificationManager.shared.requestAuthorization()
        setupInitialLaunchDate()
        incrementLaunchCount()

    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                            .environmentObject(viewModel)
                            .onAppear {
                                showRateAppAlertIfNeeded()
                            }
                            .alert(isPresented: $viewModel.showingRateAppAlert) {
                                        Alert(
                                            title: Text("Rate Our App"),
                                            message: Text("If you enjoy using our app, please take a moment to rate it. Thanks for your support!"),
                                            primaryButton: .default(Text("Rate Now")) {
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
        }
    }
    
    private func setupInitialLaunchDate() {
        if UserDefaults.standard.object(forKey: "InitialLaunch") == nil {
            UserDefaults.standard.set(Date(), forKey: "InitialLaunch")
            print("Setting initial launch date.")
        } else if let initialLaunchDate = UserDefaults.standard.object(forKey: "InitialLaunch") as? Date {
            print("App was first launched on: \(initialLaunchDate)")
        }
    }
    
    private func incrementLaunchCount() {
            let launchCountKey = "launchCount"
            var launchCount = UserDefaults.standard.integer(forKey: launchCountKey)
            launchCount += 1
            UserDefaults.standard.set(launchCount, forKey: launchCountKey)
        }
    
    private func showRateAppAlertIfNeeded() {
            let launchCount = UserDefaults.standard.integer(forKey: "launchCount")
            if launchCount == 3 {
                viewModel.showingRateAppAlert = true
            }
        }
}

class ViewModel: ObservableObject {
    @Published var showingRateAppAlert = false
}
