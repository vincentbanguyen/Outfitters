//
//  Post+Extensions.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import Foundation
extension Post: Identifiable {}
extension Post: Equatable {
    public static func ==(lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id && lhs.imageKey == rhs.imageKey && lhs.itemType == rhs.itemType
    }
}

extension Post: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + imageKey + itemType)
    }
}
