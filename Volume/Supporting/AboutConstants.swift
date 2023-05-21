//
//  AboutConstants.swift
//  Volume
//
//  Created by Vin Bui on 4/25/21.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct AboutConstants {
    
    static let missionStatement = "Created by Cornell AppDev, Volume aims to amplify the voices of student publications and organizations by making it easy and accessible to digest student created content.\n\nVolume believes in the unique power that lies in the sharing and distribution of content by students and for students to spark conversation, experiences, and connections that improve the collegiate experience."
    
    static let volumeRoster: [PodRoster] = [
        PodRoster(
            semester: "Spring 2023",
            subteams: [
                .podLead("Liam Du"),
                .ios([
                    "Vin Bui",
                    "Vivian Nguyen"
                ]),
                .backend([
                    "Isaac Han",
                    "Sasha Loayza"
                ]),
                .android([
                    "Zach Seidner"
                ]),
                .design([
                    "Amy Ge",
                    "Liam Du"
                ]),
                .marketing([
                    "Jane Lee",
                    "Sanjana Kaicker"
                ])
            ]
        ),
        PodRoster(
            semester: "Fall 2022",
            subteams: [
                .podLead("Archit Mehta"),
                .ios([
                    "Jennifer Gu",
                    "Vivian Nguyen",
                    "Hanzheng Li"
                ]),
                .backend([
                    "Archit Mehta",
                    "Kidus Zegeye"
                ]),
                .android([
                    "Emily Hu",
                    "Benjamin Harris"
                ]),
                .design([
                    "Tise Alatise",
                    "Kayla Sprayberry"
                ]),
                .marketing([
                    "Vivian Park",
                    "Eddie Chi"
                ])
            ]
        ),
        PodRoster(
            semester: "Spring 2022",
            subteams: [
                .podLead("Hanzheng Li"),
                .ios([
                    "Justin Ngai",
                    "Hanzheng Li"
                ]),
                .backend([
                    "Kidus Zegeye"
                ]),
                .android([
                    "Emily Hu",
                    "Benjamin Harris"
                ]),
                .design([
                    "Kayla Sprayberry",
                    "Christina Zeng"
                ]),
                .marketing([
                    "Neha Malepati",
                    "Carnell Zhou"
                ])
            ]
        ),
        PodRoster(
            semester: "Fall 2021",
            subteams: [
                .podLead("Tedi Mitiku"),
                .ios([
                    "Hanzheng Li",
                    "Amy Huang"
                ]),
                .backend([
                    "Kidus Zegeye",
                    "Tedi Mitiku",
                    "Orko Sinha"
                ]),
                .android([
                    "Benjamin Harris",
                    "Chris Desir"
                ]),
                .design([
                    "Christina Zeng",
                    "Amanda He",
                    "Zixian Jia"
                ]),
                .marketing([
                    "Gordon Tran",
                    "Jonna Chen"
                ])
            ]
        ),
        PodRoster(
            semester: "Spring 2021",
            subteams: [
                .podLead("Tedi Mitiku"),
                .ios([
                    "Sergio Diaz",
                    "Cameron Russell"
                ]),
                .backend([
                    "Tedi Mitiku",
                    "Orko Sinha"
                ]),
                .android([
                    "Chris Desir"
                ]),
                .design([
                    "Zixian Jia",
                    "Maggie Ying"
                ]),
                .marketing([
                    "Jonna Chen",
                    "Monan Modi"
                ])
            ]
        ),
        PodRoster(
            semester: "Fall 2020",
            subteams: [
                .podLead("Maggie Ying"),
                .ios([
                    "Cameron Russell",
                    "Daniel Vebman"
                ]),
                .backend([
                    "Tedi Mitiku",
                    "Orko Sinha"
                ]),
                .android([
                    "Justin Jiang",
                    "Aastha Shah"
                ]),
                .design([
                    "Maggie Ying"
                ]),
                .marketing([
                    "Yi Hsin Wei"
                ])
            ]
        )
    ]
    
}

extension AboutConstants {
    
    struct PodRoster: Hashable, Codable {
        var id: UUID = UUID()
        let semester: String
        let subteams: [Subteam]
        
        static func == (lhs: AboutConstants.PodRoster, rhs: AboutConstants.PodRoster) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    enum Subteam: Codable, Hashable {
        case android([String])
        case backend([String])
        case design([String])
        case ios([String])
        case marketing([String])
        case podLead(String)
    }
    
}
