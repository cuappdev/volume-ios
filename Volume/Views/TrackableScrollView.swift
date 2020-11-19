//
//  TrackableScrollView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TrackableScrollView: UIViewControllerRepresentable {
    
    @Binding var contentOffset: CGPoint

    private var content: AnyView

    init<Content: View>(contentOffset: Binding<CGPoint>, @ViewBuilder content: @escaping () -> Content) {
        _contentOffset = contentOffset
        self.content = AnyView(content())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(contentOffset: $contentOffset)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        viewController.view.addSubview(scrollView)
        pinEdges(of: scrollView, to: viewController.view)

        let hostingController = UIHostingController(rootView: content)
        if let contentView = hostingController.view {
            viewController.addChild(hostingController)
            scrollView.addSubview(contentView)
            pinEdges(of: contentView, to: scrollView)
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let scrollView = uiViewController.view.subviews.first as? UIScrollView {
            scrollView.contentOffset = contentOffset
//            print("Update co to", contentOffset.y)
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var contentOffset: CGPoint

        init(contentOffset: Binding<CGPoint>) {
            _contentOffset = contentOffset
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentOffset = scrollView.contentOffset
        }
    }

    private func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor)
        ])
    }
    
}
