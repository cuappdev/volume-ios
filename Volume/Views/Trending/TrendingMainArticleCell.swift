//
//  TrendingMainArticleCell.swift
//  Volume
//
//  Created by Vin Bui on 4/5/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TrendingMainArticleCell: View {

    // MARK: - Properties

    let article: Article
    @ObservedObject var urlImageModel: URLImageModel
    
    // MARK: - Constants
    
    private struct Constants {
        static let imageHeight: CGFloat = UIScreen.main.bounds.width
        static let infoGradientHeight: CGFloat = 60
        static let infoViewSpacing: CGFloat = 4
        static let sidePadding: CGFloat = 16
        static let skeletonHeight: CGFloat = 480
    }

    // MARK: - UI

    var body: some View {
        if let image = urlImageModel.image {
            VStack(spacing: -Constants.infoGradientHeight) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.imageHeight, height: Constants.imageHeight)
                    .clipped()

                articleInfoView(image: image)
            }
        } else {
            SkeletonView()
                .frame(width: UIScreen.main.bounds.width, height: Constants.skeletonHeight)
        }
    }
    
    @ViewBuilder
    private func articleInfoView(image: UIImage) -> some View {
        VStack(spacing: 0) {
            Color(image.bottomAverageColor ?? .gray)
                .frame(width: Constants.imageHeight, height: Constants.infoGradientHeight)
                .mask(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top))
            
            ZStack(alignment: .topLeading) {
                Color(image.bottomAverageColor ?? .gray)
                    .frame(width: Constants.imageHeight)
                
                VStack(alignment: .leading, spacing: Constants.infoViewSpacing) {
                    Text(article.publication.name)
                        .font(.newYorkMedium(size: 10))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, Constants.infoViewSpacing)
                        .padding([.leading, .trailing], Constants.sidePadding)

                    Text(article.title)
                        .font(.newYorkMedium(size: 20))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], Constants.sidePadding)

                    Text("Posted \(article.date.fullString)")
                        .font(.helveticaRegular(size: 10))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], Constants.sidePadding)
                }
                .frame(maxWidth: UIScreen.main.bounds.width)
                .padding(.bottom)
            }
        }
    }

}

// MARK: - Uncomment below if needed

//struct TrendingMainArticleCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendingMainArticleCell(article: <#T##Article#>)
//    }
//}
