//
//  OnboardingFlyersView.swift
//  Volume
//
//  Created by Vin Bui on 4/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct OnboardingFlyersView: View {
    
    // MARK: - Properties
    
    @State private var cancellableQuery: AnyCancellable?
    @State private var contentOffset: CGPoint = .zero
    @State private var flyers: [Flyer]?
        
    // MARK: - Constants
    private struct Constants {
        static let flyersLimit: Int = 15
        static let spacing: CGFloat = 16
        static let verticalPadding: CGFloat = 30
    }
    
    // MARK: - UI
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: Constants.spacing) {
                switch flyers {
                case .none:
                    ForEach(0..<4) { _ in
                        FlyerCellUpcoming.Skeleton()
                            .padding(.trailing)
                    }
                case .some(let flyers):
                    ForEach(flyers) { flyer in
                        if let urlString = flyer.imageUrl?.absoluteString {
                            FlyerCellUpcoming(
                                flyer: flyer,
                                navigationSource: .onboarding,
                                urlImageModel: URLImageModel(urlString: urlString),
                                viewModel: FlyersView.ViewModel()
                            )
                        }
                    }
                }
            }
            .padding(.vertical, Constants.verticalPadding)
        }
        .overlay(
            VStack {
                ScrollFadingView(fadesDown: false)
                
                Spacer()
                
                ScrollFadingView(fadesDown: true)
            }
        )
        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
        .onAppear {
            Task {
                await fetchUpcoming()
            }
        }
    }
    
    private func fetchUpcoming() async {
        cancellableQuery = Network.shared.publisher(for: GetFlyersAfterDateQuery(since: Date().flyerUTCISOString))
            .map { $0.flyers.map(\.fragments.flyerFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetFlyersAfterDateQuery failed on OnboardingFlyersView: \(error.localizedDescription)")
                }
            } receiveValue: { flyerFields in
                flyers = sortFlyersByDateAsc(for: [Flyer](flyerFields))
            }
    }
    
    /// Returns a list of Flyers sorted by date ascending
    private func sortFlyersByDateAsc(for flyers: [Flyer]) -> [Flyer] {
        return flyers.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
    }
    
}

// MARK: - Uncomment below if needed

//struct OnboardingFlyersView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingFlyersView()
//    }
//}
