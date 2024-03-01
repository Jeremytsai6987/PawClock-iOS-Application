//
//  GameView.swift
//  
//
//  Created by Ya Wei Tsai on 2024/2/21.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .aspectFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 300, height: 400) // Adjust the frame as needed
            .edgesIgnoringSafeArea(.all)
    }
}
