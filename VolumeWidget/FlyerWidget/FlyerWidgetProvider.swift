//
//  FlyerWidgetProvider.swift
//  Volume
//
//  Created by Vin Bui on 11/12/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Apollo
import Combine
import OSLog
import WidgetKit

@available(iOS 17.0, *)
struct FlyerWidgetProvider: AppIntentTimelineProvider {

    // MARK: - Properties

    typealias Entry = FlyerEntry
    typealias Intent = FlyerIntent

    class ProviderCancellable {
        static var queryBag = Set<AnyCancellable>()
    }

    // MARK: - TimelineProvider Methods

    /// Provides a Flyer entry representing a placeholder version of the Flyer widget.
    func placeholder(in context: Context) -> FlyerEntry {
        FlyerEntry(date: .now, flyer: FlyerWidgetProvider.dummyFlyer!)
    }

    /// Provides a Flyer entry representing the current time and state of the Flyer widget.
    func snapshot(for configuration: FlyerIntent, in context: Context) async -> FlyerEntry {
        FlyerEntry(date: .now, flyer: FlyerWidgetProvider.dummyFlyer!)
    }

    /// Provides an array of Flyer entries for the current time and any future times to update the Flyer widget.
    func timeline(for configuration: FlyerIntent, in context: Context) async -> Timeline<FlyerEntry> {
        await withCheckedContinuation { continuation in
            WidgetViewModel.shared.fetchAllFlyers(forSlug: configuration.selectedOrg.organization.slug) { flyers in
                var entries: [FlyerEntry] = []

                // Generate a timeline with at most 4 entries every hour
                for hourOffset in 0..<flyers.count {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: .now)
                    let entry = FlyerEntry(date: entryDate!, flyer: flyers[hourOffset])
                    entries.append(entry)
                }

                let timeline = Timeline(entries: entries, policy: .atEnd)
                continuation.resume(returning: timeline)
            }
        }
    }

}

@available(iOS 17.0, *)
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
                "numFlyers": 3,
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
            let flyerFields = try VolumeAPI.FlyerFields(data: data)
            return Flyer(from: flyerFields)
        } catch {
            Logger.services.error("Error in FlyerWidgetProvider: \(error.localizedDescription)")
            return nil
        }
    }

}
