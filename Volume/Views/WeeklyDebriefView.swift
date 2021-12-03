//
//  WeeklyDebriefView.swift
//  Volume
//
//  Created by Amy Chin Siu Huang on 12/1/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WeeklyDebriefView: View {
    @EnvironmentObject private var userData: UserData
    let weeklyDebrief: WeeklyDebrief
    let article: Article
    @Binding var openedWeeklyDebrief: Bool

    init(openedWeeklyDebrief: Binding<Bool>, weeklyDebrief: WeeklyDebrief, article: Article) {
        UIPageControl.appearance().currentPageIndicatorTintColor = .gray
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        _openedWeeklyDebrief = openedWeeklyDebrief
        self.weeklyDebrief = weeklyDebrief
        self.article = article
    }
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 64, height: 3)
                .padding(10)
            TabView {
                VStack {
                    Image("volume-logo")
                        .resizable()
                        .frame(width: 245, height: 75)
                        .padding(.top, 24)
                    Text("Your weekly debrief, 5/3 - 5/9")
                        .padding([.top, .bottom], 32)
                        .font(.begumMedium(size: 16))
                    Divider()
                        .frame(width: 100)
                        .padding(.bottom, 48)
                    VStack(spacing: 24, content: {
                        HStack {
                            Text("In the past week, you...")
                                .font(.begumRegular(size: 16))
                            Spacer()
                        }
                        StatisticViewRow(image: "volume", leftText: "read", number: 10, rightText: "articles")
                        StatisticViewRow(image: "shout-out", leftText: "gave", number: 45, rightText: "shout-outs")
                        StatisticViewRow(image: "bookmark", leftText: "bookmarked", number: 10, rightText: "articles")
                        HStack {
                            Text("You were among the top ")
                                .font(.begumRegular(size: 16)) +
                            Text("10% ")
                                .font(.begumMedium(size: 36))
                                .foregroundColor(Color.volume.orange) +
                            Text("active readers last week!")
                                .font(.begumRegular(size: 16))
                            Spacer()
                        }
                        HStack {
                            Text("Keep up the volume! 📣")
                                .font(.begumRegular(size: 16))
                                .frame(alignment: .leading)
                            Spacer()
                        }
                    })
                        .padding([.leading, .trailing], 48)

                    Spacer()

                }

                // TODO - create a DebriefArticleView for each article
//                DebriefArticleView(header: "Share What You Read", article: article)
//                DebriefArticleView(header: "Share What You Read", article: article)
                VStack {
                    Header("See You Next Week!", .center)
                        .padding(.top, 24)
                    VStack {
                        VStack {
                            Image("volume-logo")
                                .resizable()
                                .frame(width: 245, height: 75)
                            Text("Stay updated with Cornell student publications, all in one place")
                                .font(.begumRegular(size: 16))
                        }
                        .padding(.top, 200)
                        Button {
                            openedWeeklyDebrief = false
                        } label: {
                            Text("Continue to Volume")
                                .foregroundColor(Color.volume.orange)
                                .font(.helveticaBold(size: 16))
                        }
                        .frame(width: 184, height: 45, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.volume.orange, lineWidth: 2))
                        .padding(.top, 200)
                        Spacer()
                    }
                }
                .padding([.leading, .trailing], 50)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

//struct WeeklyDebriefView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyDebriefView()
//    }
//}
