//
//  PhysicsCategory.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/18.
//

// Define the physics categories for collision detection
struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let frisbee: UInt32 = 0x1         // 01
    static let hitZone: UInt32 = 0x1 << 1    // 02
}
