//
//  PlayWithPetsView.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/8.
//
import SwiftUI

struct PlayWithPetsView: View {
    @ObservedObject var petActivitiesViewModel: PetActivitiesViewModel
    @State private var scheduledActivityTime = Date()
    @State private var showingConfirmation = false
    @State private var showingPastTimeAlert = false

    var body: some View {
        Form {
            Section(header: Text("Schedule Play With Pet")) {
                DatePicker(
                    "Time",
                    selection: $scheduledActivityTime,
                    in: Date()..., // Ensure you can only select future dates and times
                    displayedComponents: [.date, .hourAndMinute]
                )
                Button("Schedule") {
                    // Check if the selected time is in the future
                    if scheduledActivityTime > Date() {
                        addPetActivityToViewModel()
                        showingConfirmation = true
                    } else {
                        showingConfirmation = false
                        showingPastTimeAlert = true
                    }
                }
            }
        }
        .navigationTitle("Play With Pets")
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Scheduled!"),
                message: Text("Play With pets scheduled for \(scheduledActivityTime.formatted(date: .long, time: .shortened))"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert("Invalid Time", isPresented: $showingPastTimeAlert) {
            Button("OK") {}
        } message: {
            Text("Please select a future time.")
        }
    }
    // Add the scheduled pet activity to the view model
    private func addPetActivityToViewModel() {
        let activityDetails = ActivityDetails(id: UUID(), type: "Play With Pets", time: scheduledActivityTime)
        petActivitiesViewModel.activities.append(activityDetails)
        NotificationManager.shared.scheduleNotification(
            title: "Time to play with Your Pets",
            body: "It's time to play with your pets as scheduled.",
            date: scheduledActivityTime
        )
    }
}




