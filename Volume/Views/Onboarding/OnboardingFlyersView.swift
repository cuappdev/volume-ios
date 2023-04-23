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
                        FlyerCellUpcoming(
                            flyer: flyer,
                            urlImageModel: URLImageModel(urlString: flyer.imageURL)
                        )
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
        .transition(.move(edge: .trailing))
        .onAppear {
            Task {
                await fetchUpcoming()
            }
        }
    }
    
    private func fetchUpcoming() async {
        // TODO: Fetch flyers under "Upcoming"
        guard let url = URL(string: "\(Secrets.cboardEndpoint)/flyers/upcoming/") else { return }
        
        cancellableQuery = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Flyer].self, decoder: JSONDecoder.flyersDecoder)
            .sink { completion in
                print("Fetching upcoming flyers: \(completion)")
            } receiveValue: { newFlyers in
                flyers = Array(sortFlyersByDateAsc(for: newFlyers).prefix(Constants.flyersLimit))
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
