//
//  MealDetails.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/8.
//

import Foundation

struct MealDetails: Codable, Identifiable{
    var id: UUID 
    var type: String
    var name: String
    var time: Date
}
