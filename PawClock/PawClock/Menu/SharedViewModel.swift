//
//  SharedViewModel.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/8.
//

import Foundation

class MealViewModel: ObservableObject {
    @Published var meals: [MealDetails] = []{
        didSet{
            saveMeals()
        }
        
    }
    init(){
        loadMeals()
    }
    
    var closestMeal: MealDetails? {
        let now = Date()
        return meals.min(by: { abs($0.time.timeIntervalSince(now)) < abs($1.time.timeIntervalSince(now)) })
    }
}

extension MealViewModel {
    // Remove past meals

    func removePastMeals() {
        meals.removeAll { $0.time < Date() }
    }
    // Save and load meals
    func saveMeals() {
            do {
                let filePath = getDocumentsDirectory().appendingPathComponent("meals.json")
                let data = try JSONEncoder().encode(meals)
                try data.write(to: filePath, options: [.atomicWrite, .completeFileProtection])
                print("Meals saved")
            } catch {
                print("Could not save meals: \(error)")
            }
        }

        func loadMeals() {
            let filePath = getDocumentsDirectory().appendingPathComponent("meals.json")
            guard let data = try? Data(contentsOf: filePath) else { return }
            do {
                meals = try JSONDecoder().decode([MealDetails].self, from: data)
            } catch {
                print("Could not load meals: \(error)")
            }
        }

        private func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
}

