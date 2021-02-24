//
//  ShareModalView.swift
//  Volume
//
//  Created by Sergio Diaz on 2/24/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ShareModalView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Satisfies UIViewControllerRepresentable
    }
}
