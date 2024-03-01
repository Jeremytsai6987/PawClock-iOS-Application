//
//  AudioManager.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/18.
//

import AVFoundation

extension GameScene {
    // Set up for the Backgroud Music
    func setupBackgroundMusic() {
        guard let backgroundMusicURL = Bundle.main.url(forResource: "backgroundmusic", withExtension: "mp3") else {
            print("Could not find background music file.")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
            backgroundMusicPlayer?.numberOfLoops = -1  // Loop indefinitely
            backgroundMusicPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
}
