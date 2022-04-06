//
//  RSSFeedItem+Identifier.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit
import CryptoKit

extension RSSArticle {
    
    /// Article identifier
    /// - Returns: String
    func identifier() -> String {
        
        let string = self.title
        let inputData = Data(string.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
