//
//  LottieView.swift
//  Volume
//
//  Created by Vin Bui on 4/6/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {

    typealias UIViewType = UIView
    
    var filename: String
    var play: Bool

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit

        if play {
            animationView.play()
        } else {
            animationView.currentProgress = 1
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }

}
