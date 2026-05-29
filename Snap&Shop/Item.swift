//
//  Item.swift
//  Snap&Shop
//
//  Created by Etefworkie Melaku on 2026-05-29.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
