//
//  LunchView.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/8.
//

import SwiftUI

struct LunchView: View {
    @ObservedObject var mealViewModel: MealViewModel
    @State private var foodName: String = ""
    @State private var scheduledTime = Date()
    @State private var showingConfirmation = false
    @State private var showingPastTimeAlert = false // Add this for showing an alert for past time selection

    var body: some View {
        Form {
            Section(header: Text("Meal Information")) {
                TextField("Food Name", text: $foodName)
                DatePicker("Time", selection: $scheduledTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                Button("Done") {
                    if scheduledTime > Date() {
                        addMealToViewModel()
                        showingConfirmation = true
                    } else {
                        showingConfirmation = false
                        showingPastTimeAlert = true // Show alert if time is in the past
                    }
                }
            }
        }
        .navigationTitle("Lunch")
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Confirmation"), message: Text("Food Name: \(foodName)\nScheduled Time: \(scheduledTime.formatted(date: .omitted, time: .shortened))"), dismissButton: .default(Text("OK")))
        }
        .alert("Invalid Time", isPresented: $showingPastTimeAlert) {
            Button("OK") {}
        } message: {
            Text("Please select a future time.")
        }
    }
    
    // Add meal to view model and schedule notification
    private func addMealToViewModel() {
        let mealDetails = MealDetails(id: UUID(), type: "Lunch", name: foodName, time: scheduledTime)
        mealViewModel.meals.append(mealDetails)
        NotificationManager.shared.scheduleNotification(
            title: "Time to eat!",
            body: "It's time to have lunch as scheduled.",
            date: scheduledTime
        )

    }
}
