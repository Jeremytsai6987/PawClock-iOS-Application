//
//  ScheduleView.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/26.
//
import SwiftUI

struct ScheduleView: View {
    @ObservedObject var mealViewModel: MealViewModel
    @ObservedObject var petActivitiesViewModel: PetActivitiesViewModel

    var body: some View {
        List {
            Section(header: Text("Meals")) {
                ForEach(mealViewModel.meals) { meal in
                    Text("\(meal.type): \(meal.name) at \(meal.time.formatted())")
                }
                .onDelete(perform: deleteMeal)
            }
            
            Section(header: Text("Pet Activities")) {
                ForEach(petActivitiesViewModel.activities) { activity in
                    Text("\(activity.type) at \(activity.time.formatted())")
                }
                .onDelete(perform: deleteActivity)
            }
        }
        .navigationTitle("Schedule")
    }
    // Swipe to Delete the meals
    func deleteMeal(at offsets: IndexSet) {
        mealViewModel.meals.remove(atOffsets: offsets)
    }
    // Swipe to Delete the activities
    func deleteActivity(at offsets: IndexSet) {
        petActivitiesViewModel.activities.remove(atOffsets: offsets)
    }
}
