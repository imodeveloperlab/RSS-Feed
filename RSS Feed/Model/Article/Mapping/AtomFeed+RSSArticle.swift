//
//  RSSFeed+RSSArticle.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 21.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import FeedKit

extension AtomFeed {
    
    /// Get list of [RSSArticle] from atom feed
    /// - Returns: [RSSArticle]?
    func articles() -> [RSSArticle]? {
        
        guard let items = entries else {
            return nil
        }
        
        return items.map { (item) -> RSSArticle? in
            return item.article()
        }.compactMap({ $0 })
    }
}
