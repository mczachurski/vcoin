//
//  CustomGestureRecognizer.swift
//  vcoin
//
//  Created by Marcin Czachurski on 20.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

enum TwoFingersMove {
    case moveUp
    case moveDown
    case unknown
}

class TwoFingersGestureRecognizer: UIGestureRecognizer {
    var fingersDirection = TwoFingersMove.unknown

    private var firstTouchedPoints: [CGPoint] = []
    private var secondTouchedPoints: [CGPoint] = []

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        if touches.count >= 1 {
            state = .began
            return
        }

        state = .failed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        if self.twoFingersMoveUp() {
            self.fingersDirection = TwoFingersMove.moveUp
            state = .ended
            return
        }

        if self.twoFingersMoveDown() {
            self.fingersDirection = TwoFingersMove.moveDown
            state = .ended
            return
        }

        state = .failed
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if state == .failed || touches.count != 2 {
            return
        }

        let window = view?.window
        let arrayTouches = Array(touches)

        // First finger
        if let loc = arrayTouches.first?.location(in: window) {
            firstTouchedPoints.append(loc)
            state = .changed
        }

        // Second finger
        if let loc = arrayTouches.last?.location(in: window) {
            secondTouchedPoints.append(loc)
            state = .changed
        }
    }

    private func twoFingersMoveUp() -> Bool {
        var firstFingerWasMoveUp = false
        if firstTouchedPoints.count > 1 && firstTouchedPoints[0].y > firstTouchedPoints[firstTouchedPoints.count - 1].y {
            firstFingerWasMoveUp = true
        }

        var secondFingerWasMoveUp = false
        if secondTouchedPoints.count > 1 && secondTouchedPoints[0].y > secondTouchedPoints[secondTouchedPoints.count - 1].y {
            secondFingerWasMoveUp = true
        }

        return firstFingerWasMoveUp && secondFingerWasMoveUp
    }

    private func twoFingersMoveDown() -> Bool {
        var firstFingerWasMoveDown = false
        if firstTouchedPoints.count > 1 && firstTouchedPoints[0].y < firstTouchedPoints[firstTouchedPoints.count - 1].y {
            firstFingerWasMoveDown = true
        }

        var secondFingerWasMoveDown = false
        if secondTouchedPoints.count > 1 && secondTouchedPoints[0].y < secondTouchedPoints[secondTouchedPoints.count - 1].y {
            secondFingerWasMoveDown = true
        }

        return firstFingerWasMoveDown && secondFingerWasMoveDown
    }

    override func reset() {
        super.reset()

        self.fingersDirection = TwoFingersMove.unknown
        self.firstTouchedPoints.removeAll(keepingCapacity: true)
        self.secondTouchedPoints.removeAll(keepingCapacity: true)

        state = .possible
    }
}
