//
//  GameSceneView.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/21.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        SpriteView(scene: self.scene)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true) // Hide the navigation bar in the game scene view
    }

    var scene: GameScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .aspectFill
        scene.onButtonTap = {
            DispatchQueue.main.async {
                self.presentationMode.wrappedValue.dismiss() // Navigate back
            }
        }
        return scene
    }
}
