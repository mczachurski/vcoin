//
//  Sounds.swift
//  vcoin
//
//  Created by Marcin Czachurski on 20.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class Player {
    private var audioPlayer: AVAudioPlayer?

    func play(name: String) {
        do {
            let category = AVAudioSession.Category(rawValue: AVAudioSession.Category.ambient.rawValue)
            try AVAudioSession.sharedInstance().setCategory(category)

            try AVAudioSession.sharedInstance().setActive(true, options: [])

            let asset = NSDataAsset(name: name)!
            audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: AVFileType.wav.rawValue)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
