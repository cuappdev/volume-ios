//
//  MagazinesList.swift
//  Volume
//
//  Created by Hanzheng Li on 3/4/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MagazinesList: View {
    @State private var state: MainView.TabState<Results> = .loading
    
    private func fetchContent(_ done: @escaping () -> Void = { }) {
        // simulate network request delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // TODO: add actual network request
            done()
            state = .results((
                trendingMagazines: [Magazine](),
                otherMagazines: [String : [Magazine]]()
            ))
        }
    }
    
    private var featureMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .leading, .trailing])
            ScrollView(.horizontal, showsIndicators: false) {
                switch state {
                case .loading:
                    HStack(spacing: 24) {
                        ForEach(0..<2) { _ in
                            // TODO: replace w/ trending magazine skeleton
                            SkeletonView()
                                .frame(width: 152, height: 368)
                        }
                    }
                case .reloading(let results), .results(let results):
                    HStack(spacing: 24) {
                        ForEach(results.trendingMagazines) { magazine in
                            // TODO: replace w/ trending magazine cell
                            SkeletonView()
                                .frame(width: 152, height: 368)
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
    
    var body: some View {
        RefreshableScrollView { done in
            switch state {
            case .loading, .reloading:
                return
            case .results(let results):
                state = .reloading(results)
                fetchContent(done)
            }
        } content: {
            Text("Read some 'zines!")
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Image("volume-logo")
            }
        }
        .onAppear {
            fetchContent()
        }
    }
}

extension MagazinesList {
    typealias Results = (
        trendingMagazines: [Magazine],
        otherMagazines: [String : [Magazine]]
    )
    
    // TODO: implement when query objects have been designed
//    typealias ResultsPublisher = Publishers.Zip<
//        Publishers.Map<OperationPublisher<GetTrendingMagazinesQuery.Data>, MagazineFields>,
//        Publishers.Map<OperationPublisher<GetAllMagazinesQuery.Data>, MagazineFields>
//    >
}

struct MagazinesList_Previews: PreviewProvider {
    static var previews: some View {
        MagazinesList()
    }
}
