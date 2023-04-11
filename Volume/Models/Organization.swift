//
//  Organization.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO: Reimplement once backend is finished

struct Organization: Hashable, Identifiable {
    
    let backgroundImageURL: String
    let bio: String
    let bioShort: String
    let contentType: Organization.ContentType
    let id: String
    let name: String
    let profileImageURL: String
    let rssName: String
    let rssURL: String?
    let slug: String
    let shoutouts: Int? = 0
    let websiteURL: String
    
    // TODO: init for OrganizationFields
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Organization {

    enum ContentType: Equatable {
        case all, academic, art, awareness, comedy, cultural, dance, foodDrinks, greekLife, music, socialJustice, spiritual, sports
    }
    
    static func contentTypeString(type: Organization.ContentType) -> String {
        switch type {
        case .all:
            return "All"
        case .academic:
            return "Academic"
        case .art:
            return "Art"
        case .awareness:
            return "Awareness"
        case .comedy:
            return "Comedy"
        case .cultural:
            return "Cultural"
        case .dance:
            return "Dance"
        case .foodDrinks:
            return "Food & Drinks"
        case .greekLife:
            return "Greek Life"
        case .music:
            return "Music"
        case .socialJustice:
            return "Social Justice"
        case .spiritual:
            return "Spritual"
        case .sports:
            return "Sports"
        }
    }

}

// TODO: Remove dummy data below

let esports = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .sports, id: "1", name: "Esports at Cornell", profileImageURL: "", rssName: "", rssURL: "", slug: "esports", websiteURL: "")
let wicc = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "2", name: "WICC", profileImageURL: "", rssName: "", rssURL: "", slug: "wicc", websiteURL: "")
let urmc = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "3", name: "URMC", profileImageURL: "", rssName: "", rssURL: "", slug: "urmc", websiteURL: "")
let cia = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "4", name: "Campus Installation Artists", profileImageURL: "", rssName: "", rssURL: "", slug: "cia", websiteURL: "")
let fintech = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "5", name: "Cornell Fintech", profileImageURL: "", rssName: "", rssURL: "", slug: "fintech", websiteURL: "")
let rsl = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "6", name: "Residential Sustainability Leaders", profileImageURL: "", rssName: "", rssURL: "", slug: "rsl", websiteURL: "")
let sitara = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "7", name: "Cornell Sitara", profileImageURL: "", rssName: "", rssURL: "", slug: "sitara", websiteURL: "")
let liondance = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "8", name: "Cornell Lion Dance", profileImageURL: "", rssName: "", rssURL: "", slug: "liondance", websiteURL: "")
let loko = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "9", name: "Loko", profileImageURL: "", rssName: "", rssURL: "", slug: "loko", websiteURL: "")
let emotion = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "10", name: "E-Motion", profileImageURL: "", rssName: "", rssURL: "", slug: "emotion", websiteURL: "")
let assortedaces = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "11", name: "Assorted Aces", profileImageURL: "", rssName: "", rssURL: "", slug: "assortedaces", websiteURL: "")
let rise = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "12", name: "Rise Dance Group", profileImageURL: "", rssName: "", rssURL: "", slug: "rise", websiteURL: "")
let breakfree = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "13", name: "Break Free", profileImageURL: "", rssName: "", rssURL: "", slug: "breakfree", websiteURL: "")
let freespace = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "14", name: "Free Space", profileImageURL: "", rssName: "", rssURL: "", slug: "freespace", websiteURL: "")
let bigredraas = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "15", name: "Big Red Raas", profileImageURL: "", rssName: "", rssURL: "", slug: "bigredraas", websiteURL: "")
let csa = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "16", name: "Chinese Student Association", profileImageURL: "", rssName: "", rssURL: "", slug: "csa", websiteURL: "")
let hksa = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "17", name: "Hong Kong Student Association", profileImageURL: "", rssName: "", rssURL: "", slug: "hksa", websiteURL: "")
let jusa = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "18", name: "Japan US Association", profileImageURL: "", rssName: "", rssURL: "", slug: "jusa", websiteURL: "")
let ctas = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "19", name: "Cornell Taiwanese American Society", profileImageURL: "", rssName: "", rssURL: "", slug: "ctas", websiteURL: "")
let kasa = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "20", name: "Korean American Student Association", profileImageURL: "", rssName: "", rssURL: "", slug: "kasa", websiteURL: "")
let capsu = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "21", name: "Cornell Asian Pacific Student Union", profileImageURL: "", rssName: "", rssURL: "", slug: "capsu", websiteURL: "")
let pantsimprov = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .comedy, id: "22", name: "Pants Improv Comedy", profileImageURL: "", rssName: "", rssURL: "", slug: "pantsimprov", websiteURL: "")
let whistlingshrimp = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .comedy, id: "23", name: "Whistling Shrimp", profileImageURL: "", rssName: "", rssURL: "", slug: "whistlingshrimp", websiteURL: "")
let midnightcomedy = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .comedy, id: "24", name: "Midnight Comedy", profileImageURL: "", rssName: "", rssURL: "", slug: "midnightcomedy", websiteURL: "")
let thrift = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .awareness, id: "25", name: "Cornell Thrift", profileImageURL: "", rssName: "", rssURL: "", slug: "thrift", websiteURL: "")
let aaiv = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .spiritual, id: "26", name: "Asian American Intervarsity", profileImageURL: "", rssName: "", rssURL: "", slug: "aaiv", websiteURL: "")
let cornellchimes = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .music, id: "27", name: "Cornell Chimes", profileImageURL: "", rssName: "", rssURL: "", slug: "cornellchimes", websiteURL: "")
let shimtah = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .music, id: "28", name: "Shimtah", profileImageURL: "", rssName: "", rssURL: "", slug: "shimtah", websiteURL: "")
let yamatai = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .music, id: "29", name: "Yamatai", profileImageURL: "", rssName: "", rssURL: "", slug: "yamatai", websiteURL: "")
let mediumdesigncollective = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .art, id: "30", name: "Medium Design Collective", profileImageURL: "", rssName: "", rssURL: "", slug: "mediumdesigncollective", websiteURL: "")
let dti = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "31", name: "Design & Tech Initiative", profileImageURL: "", rssName: "", rssURL: "", slug: "dti", websiteURL: "")
let appdev = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .academic, id: "32", name: "AppDev", profileImageURL: "", rssName: "", rssURL: "", slug: "appdev", websiteURL: "")
