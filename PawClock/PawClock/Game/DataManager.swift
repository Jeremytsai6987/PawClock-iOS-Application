//
//  DataManager.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/17.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    private let scoresKey = "highScores"
    
    private init() {} // Private initializer to enforce singleton pattern
    
    // Saves a score and ensures only the top ten scores are kept
    func saveScore(_ score: Int) {
        var scores = getScores()
        
        scores.append(score)
        scores.sort(by: >) // Sort scores in descending order
        scores = Array(scores.prefix(10)) // Keep only the top ten scores
        
        UserDefaults.standard.set(scores, forKey: scoresKey)
    }
    
    // Retrieves the top ten scores
    func getScores() -> [Int] {
        return UserDefaults.standard.array(forKey: scoresKey) as? [Int] ?? []
    }
}
