//
//  Sounds.swift
//  vcoin
//
//  Created by Marcin Czachurski on 20.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Player {
    private var audioPlayer: AVAudioPlayer?

    func play(name: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true, with: [])

            let asset = NSDataAsset(name: name)!
            audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: AVFileType.wav.rawValue)
            audioPlayer?.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
