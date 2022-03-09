//
//  TabBarReader.swift
//  Volume
//
//  Created by Hanzheng Li on 3/9/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TabBarReader: UIViewControllerRepresentable {
    var completion: (UITabBar) -> Void
    private let proxy = ProxyController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarReader>) -> UIViewController {
        proxy.completion = completion
        return proxy
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarReader>) { }
}

extension TabBarReader {
    private class ProxyController: UIViewController {
        var completion: (UITabBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBarController = self.tabBarController {
                self.completion(tabBarController.tabBar)
            }
        }
    }
}
