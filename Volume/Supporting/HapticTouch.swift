//
//  HapticTouch.swift
//  Volume
//
//  Created by Vin Bui on 3/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import UIKit

/// `Haptics` provides haptic feedback as a response to tap gestures
class Haptics {

    static let shared = Haptics()

    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

}
