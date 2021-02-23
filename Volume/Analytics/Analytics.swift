//
//  Analytics.swift
//  Volume
//
//  Created by Conner Swenberg on 2/23/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics

// volume-specific extensions of base Event protocol

struct StartOnboarding: Event {
    let name = "start_onboarding"
}

struct CompleteOnboarding: Event {
    let name = "complete_onboarding"
}
