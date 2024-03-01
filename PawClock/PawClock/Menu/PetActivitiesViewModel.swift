//
//  PetActivitiesViewModel.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/9.
//

import Foundation

struct ActivityDetails: Codable, Identifiable {
    var id: UUID
    var type: String
    var time: Date
}

class PetActivitiesViewModel: ObservableObject {
    @Published var activities: [ActivityDetails] = [] {
        didSet {
            saveActivities()
        }
    }

    init() {
        loadActivities()
    }

    func removePastActivities() {
        activities.removeAll { $0.time < Date() }
    }

}

extension PetActivitiesViewModel {
    
    // Save and load activities
    func saveActivities() {
            do {
                let filePath = getDocumentsDirectory().appendingPathComponent("activities.json")
                let data = try JSONEncoder().encode(activities)
                try data.write(to: filePath, options: [.atomicWrite, .completeFileProtection])
                print("Activities saved")
            } catch {
                print("Could not save activities: \(error)")
            }
        }

    func loadActivities() {
        let filePath = getDocumentsDirectory().appendingPathComponent("activities.json")
        guard let data = try? Data(contentsOf: filePath) else { return }
        do {
            activities = try JSONDecoder().decode([ActivityDetails].self, from: data)
            print("Activities loaded")
        } catch {
            print("Could not load activities: \(error)")
        }
    }

    // Get the path of the document directory
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}
