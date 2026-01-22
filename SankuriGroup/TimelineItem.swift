//
//  TimelineItem.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 22/01/26.
//

import Foundation

enum TimelineStatus {
    case completed
    case pending
}

struct TimelineItem {
    let name: String
    let date: String
    let status: TimelineStatus
}


