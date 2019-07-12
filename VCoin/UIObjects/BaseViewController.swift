//
//  BaseViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 19.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    var settingsHandler = SettingsHandler()
    var settings: Settings!
    var twoFingersGestureAction = TwoFingersGestureAction()

    // MARK: - View loading

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)

        let twoFingersGestureReognizer = TwoFingersGestureRecognizer(
            target: self.twoFingersGestureAction, action: #selector(self.twoFingersGestureAction.gestureRecognizer))

        twoFingersGestureReognizer.cancelsTouchesInView = false
        twoFingersGestureReognizer.delegate = self
        self.view.addGestureRecognizer(twoFingersGestureReognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.settings = self.settingsHandler.getDefaultSettings()
        self.settings.isDarkMode ? enableDarkMode() : disableDarkMode()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    // MARK: - Gesture recognizer

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: - Theme

    @objc
    func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
    }

    @objc
    func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
    }

    func enableDarkMode() {
        self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
    }

    func disableDarkMode() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
    }
}
