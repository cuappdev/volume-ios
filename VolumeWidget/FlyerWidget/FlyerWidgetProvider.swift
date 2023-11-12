//
//  FlyerWidgetProvider.swift
//  Volume
//
//  Created by Vin Bui on 11/12/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import WidgetKit

struct FlyerWidgetProvider: TimelineProvider {

    // MARK: - Properties

    class ProviderCancellable {
        static var queryBag = Set<AnyCancellable>()
    }

    // MARK: - TimelineProvider Methods

    /// Provides a Flyer  entry  representing a placeholder version of the Flyer widget.
    func placeholder(in context: Context) -> FlyerEntry {
        FlyerEntry(date: .now, flyer: FlyerWidgetProvider.dummyFlyer!)
    }

    /// Provides a Flyer entry representing the current time and state of the Flyer widget.
    func getSnapshot(in context: Context, completion: @escaping (FlyerEntry) -> Void) {
        let entry = FlyerEntry(date: .now, flyer: FlyerWidgetProvider.dummyFlyer!)
        completion(entry)
    }

    /// Provides an array of Flyer entries for the current time and any future times to update the Flyer widget.
    func getTimeline(in context: Context, completion: @escaping (Timeline<FlyerEntry>) -> Void) {
        fetchPastFlyers { flyers in
            var entries: [FlyerEntry] = []

            // Generate a timeline with at most 4 entries every hour
            for hourOffset in 0..<flyers.count {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: .now)
                let entry = FlyerEntry(date: entryDate!, flyer: flyers[hourOffset])
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

    // MARK: - Network Requests

    private func fetchUpcomingFlyers(completion: @escaping ([Flyer]) -> Void) {
        Network.shared.publisher(
            for: GetFlyersAfterDateQuery(limit: 4, since: Date().flyerUTCISOString)
        )
        .compactMap { $0.flyers.map(\.fragments.flyerFields) }
        .sink { completion in
            if case let .failure(error) = completion {
                print("Error: GetFlyersAfterDateQuery failed in FlyerWidgetProvider: \(error)")
            }
        } receiveValue: { flyerFields in
            var flyers = [Flyer](flyerFields)
            flyers = flyers.sorted { $0.startDate < $1.startDate }
            completion(flyers)
        }
        .store(in: &ProviderCancellable.queryBag)
    }

    private func fetchPastFlyers(completion: @escaping ([Flyer]) -> Void) {
        Network.shared.publisher(
            for: GetFlyersBeforeDateQuery(limit: 4, before: Date().flyerUTCISOString)
        )
        .compactMap { $0.flyers.map(\.fragments.flyerFields) }
        .sink { completion in
            if case let .failure(error) = completion {
                print("Error: GetFlyersBeforeDateQuery failed in FlyerWidgetProvider: \(error)")
            }
        } receiveValue: { flyerFields in
            var flyers = [Flyer](flyerFields)
            flyers = flyers.sorted { $0.startDate < $1.startDate }
            completion(flyers)
        }
        .store(in: &ProviderCancellable.queryBag)
    }

}

extension FlyerWidgetProvider {

    // swiftlint:disable line_length

    /// Dummy flyer data of a Cornell Filipino Association flyer.
    static var dummyFlyer: Flyer? {
        let data: [String: Any] = [
            "__typename": "Flyer",
            "id": "65495e0ee74a5f00132c9d9c",
            "categorySlug": "cultural",
            "endDate": "2023-11-13T02:00:30.000Z",
            "flyerURL": "https://www.instagram.com/p/CzSYQwXNRC5/?igshid=MzRlODBiNWFlZA==",
            "imageURL": "https://appdev-upload.nyc3.digitaloceanspaces.com/volume/si8vwehr.png",
            "location": "Willard Straight Memorial Room",
            "organization": [
                "__typename": "Organization",
                "id": "644ea608f910705ca19ab607",
                "backgroundImageURL": "https://raw.githubusercontent.com/cuappdev/assets/master/volume/cfa/background.png",
                "bio": "",
                "categorySlug": "cultural",
                "name": "Cornell Filipino Association",
                "profileImageURL": "https://raw.githubusercontent.com/cuappdev/assets/master/volume/cfa/profile.png",
                "slug": "cfa",
                "shoutouts": 0,
                "websiteURL": "https://www.instagram.com/cornellfilipino/?hl=en"
            ],
            "organizationSlug": "cfa",
            "startDate": "2023-11-13T00:00:30.000Z",
            "timesClicked": 16,
            "title": "Kamayan",
            "trendiness": -0.0002785253184562748
        ]

        // swiftlint:enable line_length

        do {
            let flyerQuery = try GetFlyersByIDsQuery.Data.Flyer(jsonObject: data)
            return Flyer(from: flyerQuery.fragments.flyerFields)
        } catch {
            print("Error in FlyerWidgetProvider: \(error)")
            return nil
        }
    }

}
