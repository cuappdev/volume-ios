//
//  FlyerWidgetIntent.swift
//  Volume
//
//  Created by Vin Bui on 11/12/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppIntents
import Combine
import WidgetKit

struct WidgetOrganization: AppEntity {

    var id: String
    var organization: Organization

    static var defaultQuery = WidgetOrganizationQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget Organization"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(organization.name)")
    }

}

struct WidgetOrganizationQuery: EntityStringQuery {

    // MARK: - Properties

    class ProviderCancellable {
        static var queryBag = Set<AnyCancellable>()
    }

    // MARK: - Functions

    func entities(matching string: String) async throws -> [WidgetOrganization] {
        await withCheckedContinuation { continuation in
            WidgetViewModel.shared.fetchOrganizationNames { organizations in
                let organizations = organizations.filter {
                    $0.name.lowercased().hasPrefix(string.lowercased())
                }

                let widgetOrgs = organizations.map { org in
                    WidgetOrganization(id: org.name, organization: org)
                }

                continuation.resume(returning: widgetOrgs)
            }
        }
    }

    func entities(for identifiers: [WidgetOrganization.ID]) async throws -> [WidgetOrganization] {
        await withCheckedContinuation { continuation in
            WidgetViewModel.shared.fetchOrganizationNames { organizations in
                let widgetOrgs = organizations.map { org in
                    WidgetOrganization(id: org.name, organization: org)
                }

                continuation.resume(returning: widgetOrgs)
            }
        }
    }

    func suggestedEntities() async throws -> [WidgetOrganization] {
        await withCheckedContinuation { continuation in
            WidgetViewModel.shared.fetchOrganizationNames { organizations in
                let widgetOrgs = organizations.map { org in
                    WidgetOrganization(id: org.name, organization: org)
                }

                continuation.resume(returning: widgetOrgs)
            }
        }
    }

    func defaultResult() async -> WidgetOrganization? {
        await withCheckedContinuation { continuation in
            WidgetViewModel.shared.fetchOrganizationNames { organizations in
                guard let org = organizations.first(where: { $0.slug == "appdev" }) else { return }

                let widgetOrg = WidgetOrganization(id: org.name, organization: org)
                continuation.resume(returning: widgetOrg)
            }
        }
    }

}

@available(iOS 17.0, *)
struct FlyerIntent: WidgetConfigurationIntent {

    static var title: LocalizedStringResource = "Select Organization"
    static var description = IntentDescription("Selects the organization to display information for.")

    @Parameter(title: "Organization")
    var selectedOrg: WidgetOrganization

}
