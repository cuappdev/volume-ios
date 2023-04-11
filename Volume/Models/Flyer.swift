//
//  Flyer.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO: Reimplement once backend finishes

typealias FlyerID = String

struct Flyer: Hashable, Identifiable {
    
    let date: DateInterval
    let description: String?
    let id: String
    let imageURL: String
    let isFiltered: Bool
    let isTrending: Bool = false
    let location: String
    let nsfw: Bool = false
    let organizations: [Organization]
    let organizationSlugs: [String]
    let pageURL: String
    let shoutouts: Int = 0
    let title: String
    let trendiness: Int = 0
    
    // TODO: init for FlyerFields
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// TODO: Map FlyerFields to Flyer

// TODO: Remove dummy data below

struct FlyerDummyData {
    
    /// Returns a `Date` object from a string in the format "MMM d yy h::mm a". For example, "Apr 11 23 2:12 AM" gives 4/11/23, 2:12 AM.
    static func retrieveDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yy h:mm a"
        return dateFormatter.date(from: str) ?? Date()
    }
    
    static let flyers = [
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 24 23 7:30 PM"), end: retrieveDate(str: "Apr 24 23 9:00 PM")), description: "", id: "1", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/338264842_768029518212110_5728061673408562899_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=102&_nc_ohc=2WIpVHyb-O0AX9yBwVr&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2OTMzNjczNDk2NjM1NzAwMg%3D%3D.2-ccb7-5&oh=00_AfCdTsPWk3nyl_q2jcsAz4MWMOa8rhe48Wfx7-MRw9ENdQ&oe=6439026C&_nc_sid=978cb9", isFiltered: false, location: "Statler Ballroom", organizations: [wicc], organizationSlugs: ["wicc"], pageURL: "https://www.instagram.com/p/CqYeX-XuhwK/?img_index=1", title: "CIS Formal")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 24 23 5:00 PM"), end: retrieveDate(str: "Apr 24 23 7:00 PM")), description: "", id: "2", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/338215798_1229120841312095_3199717692894958389_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=111&_nc_ohc=O-6bh7WZAHwAX-FjfrP&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2OTMzNTg0MTAwOTA3NDI2Nw%3D%3D.2-ccb7-5&oh=00_AfClNZRSksruN97SPXSkA14rwKhAen1gAAiQHaDVAWYkgg&oe=643A1F1B&_nc_sid=978cb9", isFiltered: false, location: "Statler Ballroom", organizations: [wicc], organizationSlugs: ["wicc"], pageURL: "https://www.instagram.com/p/CqYeK9zuIBb/", title: "DEIB Awards")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 28 23 6:00 PM"), end: retrieveDate(str: "Mar 28 23 7:00 PM")), description: "", id: "3", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/337638853_1627911024319922_6468744201411130752_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=102&_nc_ohc=0DbvwnslNwMAX9xGfIY&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2NzIxMzI1OTY5OTE0NTIyNw%3D%3D.2-ccb7-5&oh=00_AfAPuylavnulnyLi8ttJgj9avdwNrzyTZZUqXReIME59uA&oe=643A5BDA&_nc_sid=978cb9", isFiltered: false, location: "Upson 216", organizations: [wicc, urmc], organizationSlugs: ["wicc", "urmc"], pageURL: "https://www.instagram.com/p/CqQ7jV6vEoL/", title: "Resume Review Workshop")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 25 23 5:30 PM"), end: retrieveDate(str: "Mar 25 23 7:30 PM")), description: "", id: "4", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/335936517_231182469470369_88972418122421548_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=105&_nc_ohc=fadQuuutMUoAX9zF8K5&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA1OTg3NjExMTM3NTE5OTIxMQ%3D%3D.2-ccb7-5&oh=00_AfByKz6nMLHuul7QeN4vNGgbXJQ-3giOth2ByNXLx7rCqQ&oe=64392886&_nc_sid=978cb9", isFiltered: false, location: "Statler Ballroom", organizations: [wicc], organizationSlugs: ["wicc"], pageURL: "https://www.instagram.com/p/Cp23RyDOOvr/", title: "10th Birthday")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 29 23 2:00 PM"), end: retrieveDate(str: "Apr 29 23 5:00 PM")), description: "", id: "5", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/339332064_558759853028364_2040170377887726462_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=100&_nc_ohc=fdzviYlzxhMAX8HUFoH&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA3MzA0NjYyMjg2NzU5MTIzOA%3D%3D.2-ccb7-5&oh=00_AfAdxvdXNUjZnoNx-fNTLubnt7VubZd7H9MAYSXumKN8tg&oe=643A652B&_nc_sid=978cb9", isFiltered: false, location: "Greater Ithaca Activities Center", organizations: [urmc], organizationSlugs: ["urmc"], pageURL: "https://www.instagram.com/p/Cqlp58uPJBG/", title: "All-Star Weekend")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 10 23 6:00 PM"), end: retrieveDate(str: "Mar 10 23 7:00 PM")), description: "", id: "6", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/334458065_749815333204575_1454109666297094719_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=103&_nc_ohc=QKeJ8EBV7_wAX_DyWp4&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA1NTU5MzU3NTk5NjI2NDI1Mw%3D%3D.2-ccb7-5&oh=00_AfCUJyCxjeHRB6G-lyPooGOC0tnF21x2HOS1VarFC1e0_Q&oe=643A5B1E&_nc_sid=978cb9", isFiltered: false, location: "Phillips 213", organizations: [urmc], organizationSlugs: ["urmc"], pageURL: "https://www.instagram.com/p/CpnpisLOQ89/", title: "M&M Create Your Cookies")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 23 23 5:00 PM"), end: retrieveDate(str: "Mar 23 23 5:00 PM")), description: "", id: "7", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/336939349_1383861402406603_2778541409157638500_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=107&_nc_ohc=b3_M5rmRNh0AX9kMHg-&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2MzEwNjc2Nzk2NTY3NzE1Ng%3D%3D.2-ccb7-5&oh=00_AfC-O6eIqwLdzQaJTeESih82a6F5ZxSAHZnUZIPyegCXgQ&oe=6439D5DC&_nc_sid=978cb9", isFiltered: false, location: "Sage Hall B06", organizations: [fintech], organizationSlugs: ["cornellfintech"], pageURL: "https://www.instagram.com/p/CqCV2BdsGZk/", title: "Shareholder Meeting")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 11 23 4:30 PM"), end: retrieveDate(str: "Apr 11 23 5:30 PM")), description: "", id: "8", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/340666607_932075931462146_3551731447930561272_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=102&_nc_ohc=E3CNWxY5NqkAX_G5DzK&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA3ODEwODg0MDM1MzEzMDcxMg%3D%3D.2-ccb7-5&oh=00_AfANYWgJ5EjMDFUbey4DGCBPbb5iw5paIlOeB52VaDjm3g&oe=643A541D&_nc_sid=978cb9", isFiltered: false, location: "Willard Straight Hall", organizations: [rsl], organizationSlugs: ["rsl"], pageURL: "https://www.instagram.com/p/Cq3o66JPOjY/", title: "Sustainable Laundry Day 1")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 26 23 8:00 PM"), end: retrieveDate(str: "Mar 26 23 10:00 PM")), description: "", id: "10", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/336021523_164033852771080_1781047580820900239_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=104&_nc_ohc=PX2VskYulz4AX_pkpp9&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA1Nzc0NzQyMzY4Njk1OTgxMQ%3D%3D.2-ccb7-5&oh=00_AfBNCDLuZBDcUXLNGB08Ei2TPRNjAgT7HstM4Ff0qh90Lg&oe=643A7BB5&_nc_sid=978cb9", isFiltered: false, location: "Barnes Hall", organizations: [sitara], organizationSlugs: ["sitara"], pageURL: "https://www.instagram.com/p/CpvTRTJuiLD/", title: "Sitara Night")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 23 23 7:00 PM"), end: retrieveDate(str: "Apr 23 23 9:00 PM")), description: "", id: "11", imageURL: "https://scontent-lga3-1.cdninstagram.com/v/t51.2885-15/333090903_1244868712785167_2193036692101338573_n.jpg?stp=dst-jpg_e35_p1080x1080&_nc_ht=scontent-lga3-1.cdninstagram.com&_nc_cat=111&_nc_ohc=WFpZi7hA_CUAX9iNB4i&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA1NjI4NTg1MDEyMzc2MDUzNA%3D%3D.2-ccb7-5&oh=00_AfCCmmgYKjTkPvK8qmFpRWw4DGz5zPYZKUP3LfHBsYt3fw&oe=64391249&_nc_sid=1527a3", isFiltered: false, location: "WSH Memorial Room", organizations: [liondance], organizationSlugs: ["liondance"], pageURL: "https://www.instagram.com/p/CpqG8msrfOW/", title: "New Beginnings")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 3 23 8:00 PM"), end: retrieveDate(str: "Mar 3 23 10:00 PM")), description: "", id: "12", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/331235434_1223583991605084_4794817220794994401_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=100&_nc_ohc=E6Bu9YmoREwAX_F-ASX&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzAzOTAwMjg5MjMzMDI5NDAwNg%3D%3D.2-ccb7-5&oh=00_AfDHr4YEKmDU8fUx2UqCXlD8-lkvneG7txgZ6rfdvl-MiA&oe=643928E7&_nc_sid=978cb9", isFiltered: false, location: "Bailey Hall", organizations: [loko], organizationSlugs: ["loko"], pageURL: "https://www.instagram.com/p/CostQd8u1r2/", title: "Project Loko")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "May 7 23 7:00 PM"), end: retrieveDate(str: "May 7 23 9:00 PM")), description: "", id: "13", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/337757884_1655652588209785_1948040996386300640_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=101&_nc_ohc=LK4NL_BlEbgAX_STmyU&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2NjQ2MDMxMjQyMTU0OTMyNA%3D%3D.2-ccb7-5&oh=00_AfAcDW48kFcZZEbtcgEg3YNUJLYYTrwLOG_c-oOgZKrMTA&oe=64397000&_nc_sid=978cb9", isFiltered: false, location: "Cornell Cinema", organizations: [emotion], organizationSlugs: ["emotion"], pageURL: "https://www.instagram.com/p/CqOQWhHuEUM/", title: "The Album")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 25 23 4:00 PM"), end: retrieveDate(str: "Mar 25 23 5:30 PM")), description: "", id: "14", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/337185568_739887957577831_2044581050129933587_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=107&_nc_ohc=qSaVhhNwUPEAX_wYe-u&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2NDUwMTMwMTQyNjAxMjI4OQ%3D%3D.2-ccb7-5&oh=00_AfCVi6-OUBa1NKIWfHsSV_KE7IPh4ep-BnNRaLT9eiebQw&oe=64390F0E&_nc_sid=978cb9", isFiltered: false, location: "Physical Sciences Building", organizations: [assortedaces], organizationSlugs: ["assortedaces"], pageURL: "https://www.instagram.com/p/CqHS7NQurd3/", title: "Freestyle Workshop")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 4 23 7:00 PM"), end: retrieveDate(str: "Mar 4 23 9:00 PM")), description: "", id: "15", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/329966201_725711022595919_527682190514236512_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=111&_nc_ohc=JF5vEF85AU0AX_cmtE4&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA1MTM0ODgxOTQ1OTk5Mjk3NA%3D%3D.2-ccb7-5&oh=00_AfCYkwDOARmI5tS2mruSfSveOYsnNExVRm9bjwv-BkGQSA&oe=6439ABD7&_nc_sid=978cb9", isFiltered: false, location: "Bailey Hall", organizations: [rise], organizationSlugs: ["rise"], pageURL: "https://www.instagram.com/p/CpYkZWluG2O/", title: "Rise to the Top")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 14 23 7:30 PM"), end: retrieveDate(str: "Apr 14 23 9:30 PM")), description: "", id: "16", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/338169147_932070311252779_4414189127983840768_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=107&_nc_ohc=BWpST_8AubMAX9mpPFB&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2OTQxMDM4MjY5MTg1MDAwNQ%3D%3D.2-ccb7-5&oh=00_AfAWIXzd-nwjMPy7atqbzRIuI3VMtbu2iso0DTJHI5-mhQ&oe=6439D4AF&_nc_sid=978cb9", isFiltered: false, location: "Bailey Hall", organizations: [breakfree], organizationSlugs: ["breakfree"], pageURL: "https://www.instagram.com/p/CqYvHsKPlcV/", title: "New Destinations")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 15 23 7:00 PM"), end: retrieveDate(str: "Apr 15 23 9:00 PM")), description: "", id: "17", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/338184942_3163964410574027_4073572980905469667_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=111&_nc_ohc=__qtrId-uqYAX-BZY8O&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA2NzM2MDkyNjA1MDg4MzA4OA%3D%3D.2-ccb7-5&oh=00_AfDA-7ePZ1ZYDkGESxh7FvhtecjH6ogFTRGUmdakVguBtw&oe=64397B47&_nc_sid=978cb9", isFiltered: false, location: "Big Red Barn", organizations: [csa], organizationSlugs: ["csa"], pageURL: "https://www.instagram.com/p/CqRdIK7LRYQ/", title: "Spring Formal")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 19 23 2:30 PM"), end: retrieveDate(str: "Mar 19 23 4:30 PM")), description: "", id: "18", imageURL: "https://scontent.cdninstagram.com/v/t51.2885-15/334758734_529363089313284_4194567180413620976_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent.cdninstagram.com&_nc_cat=100&_nc_ohc=gYQk3Qj63soAX_pF_c2&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzA1NzcxNTQzNDc3OTA0OTM2MA%3D%3D.2-ccb7-5&oh=00_AfChsUoaZoejl4iJt-Nu82XHhYE0gG6UYjCJEZGSmz3j_A&oe=643A8F21&_nc_sid=978cb9", isFiltered: false, location: "Phillips 213", organizations: [csa], organizationSlugs: ["csa"], pageURL: "https://www.instagram.com/p/CpvL_zKO_2Q/", title: "Paint and Sip")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 21 23 7:00 PM"), end: retrieveDate(str: "Apr 21 23 9:00 PM")), description: "", id: "20", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/336578060_5973274726112635_4609565247124906241_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=107&_nc_ohc=TrxTtsGT3gkAX-XRO90&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA2MzAyMzA4OTk0MDI4Mjc3Mg%3D%3D.2-ccb7-5&oh=00_AfDsUuQgLmXzZiIl-2AKQDrczPgk4X4GlL7KuvPx4cN0_A&oe=643A9991&_nc_sid=30a2ef", isFiltered: false, location: "Ho Plaza", organizations: [kasa], organizationSlugs: ["kasa"], pageURL: "https://www.instagram.com/p/CqCC0WOtb2U/", title: "K-Night")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 25 23 7:00 PM"), end: retrieveDate(str: "Mar 25 23 10:00 PM")), description: "", id: "21", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/335598882_746161053690881_3957553982610564652_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=105&_nc_ohc=YH8wKgtw2LcAX8jETSB&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA1NjQ1MzM0OTU0NTg0NDQwOA%3D%3D.2-ccb7-5&oh=00_AfCwZUotPlNoDvE7zJ9rO4wMqmACdTvMCsuhxZuFspur7Q&oe=643AC2A4&_nc_sid=30a2ef", isFiltered: false, location: "Klarman Atrium", organizations: [capsu], organizationSlugs: ["capsu"], pageURL: "https://www.instagram.com/p/CpqtCCsO564/", title: "Into the Asiaverse")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 15 23 7:00 PM"), end: retrieveDate(str: "Apr 15 23 8:00 PM")), description: "", id: "22", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/340512312_6055974424456278_491073660633832077_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=106&_nc_ohc=SlRszarxHWEAX8H46wy&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA3Nzg5Nzg2ODA1Mjg3NjY2Mg%3D%3D.2-ccb7-5&oh=00_AfBhc-OlQ7okis75DvI_9wOoss6TY-p30aeBk9Ev3a2hag&oe=6439D9C6&_nc_sid=30a2ef", isFiltered: false, location: "Rockefeller 201", organizations: [pantsimprov], organizationSlugs: ["pantsimprov"], pageURL: "https://www.instagram.com/p/Cq24824OU12/", title: "It was all a Dream Show 1")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 15 23 7:00 PM"), end: retrieveDate(str: "Apr 15 23 8:00 PM")), description: "", id: "24", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/340021681_2121224098074841_8728647178749429481_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=101&_nc_ohc=8YLyYHfGALwAX-n36kM&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA3NjgxMDM0ODgyMDM5NDg4Mg%3D%3D.2-ccb7-5&oh=00_AfDehm5vTWfTHFyiL6D2hZ6yI-mW-a4Aq3Bqqo77eDNCQg&oe=643A7535&_nc_sid=30a2ef", isFiltered: false, location: "Uris Hall G01", organizations: [whistlingshrimp], organizationSlugs: ["whistlingshrimp"], pageURL: "https://www.instagram.com/p/CqzBrXqr3OC/", title: "Dogville: Show 1")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 13 23 11:00 AM"), end: retrieveDate(str: "Apr 13 23 3:00 PM")), description: "", id: "26", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/340666160_1386800548800300_3345069803082356158_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=100&_nc_ohc=xlQz5dZRZjYAX_8le10&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA3ODI2MzQzMDc4NzY2NTA0OA%3D%3D.2-ccb7-5&oh=00_AfCzP-lMFU2z6OvTIxg6TClid1FUx9T2YqAFxkBgBzFeGg&oe=643A7038&_nc_sid=30a2ef", isFiltered: false, location: "Mann Library Lobby", organizations: [thrift], organizationSlugs: ["thrift"], pageURL: "https://www.instagram.com/p/Cq4MEftLIyY/", title: "Spring Thrift Pop-Up Shop")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Feb 18 23 7:00 PM"), end: retrieveDate(str: "Feb 18 23 9:00 PM")), description: "", id: "27", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/330131347_231973802509285_2453710738607945332_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=101&_nc_ohc=Ry7lnYFvUssAX8LaNGo&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzAzNjM5ODk2MTg3MTY2NDE4NA%3D%3D.2-ccb7-5&oh=00_AfBtNe41QeyVuR0OPbWPYQthLq2rSbnXiBOqEkV6Bpyp9g&oe=643A77AE&_nc_sid=30a2ef", isFiltered: false, location: "Willard Straight Hall", organizations: [shimtah], organizationSlugs: ["shimtah"], pageURL: "https://www.instagram.com/p/CojdMSuubQ4/", title: "21st Annual Showcase")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Apr 15 23 7:00 PM"), end: retrieveDate(str: "Apr 15 23 9:00 PM")), description: "", id: "28", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/327906326_1396763147747609_1888355929101930928_n.jpg?stp=dst-jpg_e35_s1080x1080&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=105&_nc_ohc=8oCETEMO3SkAX_vl1Sx&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA2ODUxMjk0NjkzNDYzMDMzMw%3D%3D.2-ccb7-5&oh=00_AfB6K0CricibzMFGz44Uo9N_I9GVHgM3J9Mxy1rvHUoy7A&oe=64393B14&_nc_sid=30a2ef", isFiltered: false, location: "Bailey Hall", organizations: [yamatai], organizationSlugs: ["yamatai"], pageURL: "https://www.instagram.com/p/CqVjER-uce9/", title: "Pulse")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 27 23 5:30 PM"), end: retrieveDate(str: "Mar 27 23 7:00 PM")), description: "", id: "29", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/336961035_547126090841539_3022468344442742889_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=107&_nc_ohc=cTfSB9Jvb-EAX9QqO0I&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA2Mjk1NDc4MjUwMzk4NDM1OQ%3D%3D.2-ccb7-5&oh=00_AfC_6z5f7_gjdRJ1hkp9u8Hrs26D5kUtf_P86G8vpOlfFw&oe=6439C022&_nc_sid=30a2ef", isFiltered: false, location: "Gates G01", organizations: [dti], organizationSlugs: ["dti"], pageURL: "https://www.instagram.com/p/CqBzSV-O9zn/", title: "Teamspace NotionFest")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 21 23 5:00 PM"), end: retrieveDate(str: "Mar 21 23 6:30 PM")), description: "", id: "30", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/336337965_249416184086611_842057011090530378_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=107&_nc_ohc=Ku5wDwtcGSwAX8VY6qc&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA1OTM4Mzk0OTQwMzU3NzYzMg%3D%3D.2-ccb7-5&oh=00_AfBCegYbyN7Vi2X9Oqi_RHXwMsGC_fUF1KqURPemcNVtdQ&oe=643989A0&_nc_sid=30a2ef", isFiltered: false, location: "Malott 251", organizations: [dti, appdev], organizationSlugs: ["dti", "appdev"], pageURL: "https://www.instagram.com/p/Cp1HX4fu10g/?img_index=1", title: "Resume Workshop")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Mar 4 23 4:00 PM"), end: retrieveDate(str: "Mar 4 23 6:00 PM")), description: "", id: "31", imageURL: "https://scontent-lga3-1.cdninstagram.com/v/t51.2885-15/332516058_696162158912378_6322245012728184622_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-1.cdninstagram.com&_nc_cat=102&_nc_ohc=ZbnpkjZk0roAX8yo40j&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzA0NDA2MDgyNjYxNzY3OTA4Mg%3D%3D.2-ccb7-5&oh=00_AfDqEC_Q5Tsp-CqxXxfxYdiqri85aqqvSrLxTkaWyZKo2w&oe=643A7FC1&_nc_sid=30a2ef", isFiltered: false, location: "Helen Newman Hall", organizations: [csa], organizationSlugs: ["csa"], pageURL: "https://www.instagram.com/p/Co-rTGVOozq/", title: "Bowling Social")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Feb 20 23 1:00 PM"), end: retrieveDate(str: "Feb 20 23 7:00 PM")), description: "", id: "32", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/330286238_137077669233672_8786859139928685212_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=100&_nc_ohc=KiGjU9buThQAX_dtPSA&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzAzNDA0MDYyNzk5NDc5NDg5OA%3D%3D.2-ccb7-5&oh=00_AfDxqtVziudcatquVCubDS8gaJxgIAEZonmQVK7ho783yw&oe=643A745F&_nc_sid=30a2ef", isFiltered: false, location: "Duffield Workday Table", organizations: [csa], organizationSlugs: ["csa"], pageURL: "https://www.instagram.com/p/CobE-BJu5uS/", title: "Boba Fundraiser")
        ,
        Flyer(date: DateInterval(start: retrieveDate(str: "Feb 3 23 6:00 PM"), end: retrieveDate(str: "Feb 3 23 7:30 PM")), description: "", id: "33", imageURL: "https://scontent-lga3-1.cdninstagram.com/v/t51.2885-15/328689714_551278403617394_2843396773937333049_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-1.cdninstagram.com&_nc_cat=102&_nc_ohc=ErFBmvWOO8wAX-CpPDZ&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzAzMDEzOTgwMTE0MDE3NjU0MA%3D%3D.2-ccb7-5&oh=00_AfCEJks76kbRTLYS9vwucUIsQj4kqLr4-03yYGmbWxSyHg&oe=643AEEA4&_nc_sid=30a2ef", isFiltered: false, location: "WSH Memorial Room", organizations: [csa], organizationSlugs: ["csa"], pageURL: "https://www.instagram.com/p/CoNOBhCu6ac/", title: "Lunar New Year")
    ]
}
