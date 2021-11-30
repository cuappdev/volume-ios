//
//  TrackableScrollView.swift
//  Volume
//
//  Created by Daniel Vebman on 10/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//
import SwiftUI

struct TrackableScrollView<Content: View>: UIViewControllerRepresentable {
    /// Lets the parent control the storage of `contentOffset`. Updates the parent's
    /// value on scroll and lets it update the actual offset.
    @Binding var contentOffset: CGPoint
    @Binding var contentHeight: CGFloat
    /// Notifies the parent when the max offset changes. Does not allow it to update this
    /// value directly.
    let maxOffsetDidChange: ((CGPoint) -> Void)?
    /// The `ScrollView`'s content. It's width is constrained to equal this view's width.
    let content: () -> Content

    init(
        contentOffset: Binding<CGPoint>,
        contentHeight: Binding<CGFloat>,
        maxOffsetDidChange: ((CGPoint) -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _contentOffset = contentOffset
        _contentHeight = contentHeight
        self.maxOffsetDidChange = maxOffsetDidChange
        self.content = content
    }

    func makeCoordinator() -> Coordinator<Content> {
        Coordinator(contentOffset: $contentOffset, contentHeight: $contentHeight)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = context.coordinator.viewController

        let scrollView = UIScrollView()
        scrollView.verticalScrollIndicatorInsets.top = -20
        scrollView.delegate = context.coordinator
        viewController.view.addSubview(scrollView)
        pinEdges(of: scrollView, to: viewController.view)
        scrollView.contentSize.height = contentHeight
        DispatchQueue.main.async {
            maxOffsetDidChange?(
                CGPoint(
                    x: 0,
                    y: scrollView.contentSize.height
                        + scrollView.contentInset.bottom
                        - scrollView.bounds.height
                )
            )
        }

        let hostingController = UIHostingController(rootView: content())
        if let contentView = hostingController.view {
            viewController.addChild(hostingController)
            scrollView.addSubview(contentView)
            pinEdges(of: contentView, to: scrollView)
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let viewController = context.coordinator.viewController
        guard let scrollView = viewController.view.subviews.first as? UIScrollView,
            let oldHost = viewController.children.last as? UIHostingController<Content> else {
            return
        }

        oldHost.rootView = content()
        
        scrollView.contentSize.height = contentHeight

        DispatchQueue.main.async {
            maxOffsetDidChange?(
                CGPoint(
                    x: 0,
                    y: scrollView.contentSize.height
                        + scrollView.contentInset.bottom
                        - scrollView.bounds.height
                )
            )
        }

        scrollView.contentOffset = contentOffset
    }

    class Coordinator<Content: View>: NSObject, UIScrollViewDelegate {
        @Binding var contentOffset: CGPoint
        @Binding var contentHeight: CGFloat
        let viewController = UIViewController()

        init(contentOffset: Binding<CGPoint>, contentHeight: Binding<CGFloat>) {
            _contentOffset = contentOffset
            _contentHeight = contentHeight
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentOffset = scrollView.contentOffset
            contentHeight = scrollView.contentSize.height
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
