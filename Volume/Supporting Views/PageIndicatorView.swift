//
//  PageIndicatorView.swift
//  Volume
//
//  Created by Vin Bui on 3/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PageIndicatorView: View {
    
    let totalPage: Int
    @StateObject var pdfView: PDFViewUnselectable
    
    var body: some View {
        ZStack {
            if let pdfDoc = pdfView.document, let page = pdfView.currentPage {
                
                let currentPage = pdfDoc.index(for: page) + 1
                
                Rectangle()
                    .fill(Constants.indicatorColor)
                    .frame(width: Constants.indicatorWidth, height: Constants.indicatorHeight)
                    .cornerRadius(Constants.indicatorCorner)
                    .blur(radius: 0.5)
                
                Label(String(currentPage) + " of " + String(totalPage), systemImage: "")
                    .labelStyle(.titleOnly)
                    .font(.newYorkMedium(size: 12))
            }
        }
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
        .zIndex(1)
    }
}

// MARK: - Constants
extension PageIndicatorView {
    
    private struct Constants {
        static let indicatorWidth: CGFloat = 80
        static let indicatorHeight: CGFloat = 30
        static let indicatorCorner: CGFloat = 15
        static let indicatorColor = Color(white: 0.93)
    }
}
