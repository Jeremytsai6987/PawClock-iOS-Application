//
//  MenuListView.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/8.
//

import SwiftUI

struct MenuListView: View {
    @ObservedObject var mealViewModel: MealViewModel
    @ObservedObject var petActivitiesViewModel: PetActivitiesViewModel
    @State private var backgroundColor = Color.pink // Default background color
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Meals")) {
                    NavigationLink(destination: BreakfastView(mealViewModel: mealViewModel)) {
                        Text("Breakfast")
                    }
                    NavigationLink(destination: LunchView(mealViewModel: mealViewModel)) {
                        Text("Lunch")
                    }
                    NavigationLink(destination: FikaView(mealViewModel: mealViewModel)) {
                        Text("Fika")
                    }
                    NavigationLink(destination: DinnerView(mealViewModel: mealViewModel)) {
                        Text("Dinner")
                    }
                }

                Section(header: Text("Pets")) {
                    NavigationLink(destination: FeedPetsView(petActivitiesViewModel: petActivitiesViewModel)) {
                        Text("Feed Pets")
                    }
                    NavigationLink(destination: WalkingPetsView(petActivitiesViewModel: petActivitiesViewModel)) {
                        Text("Walking Pets")
                    }
                    NavigationLink(destination: PlayWithPetsView(petActivitiesViewModel: petActivitiesViewModel)) {
                        Text("Play With Pets")
                    }
                }
                
            }
            .navigationTitle("Menu")
        }
    }
}



struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        // Correctly initialize both ViewModel instances for the preview
        MenuListView(mealViewModel: MealViewModel(), petActivitiesViewModel: PetActivitiesViewModel())
    }
}
