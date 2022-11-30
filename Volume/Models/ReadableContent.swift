//
//  ReadableContent.swift
//  Volume
//
//  Created by Hanzheng Li on 11/30/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

protocol ReadableContent: Hashable, Identifiable {
    var id: String { get }
    var publication: Publication { get }
}

extension ReadableContent {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum ReaderViewInitType<Content: ReadableContent> {
    case readyForDisplay(Content), fetchRequired(String)
}
