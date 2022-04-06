//
//  AtomFeedEntry+RSSArticle.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit

extension AtomFeedEntry {
    
    /// Get RSSArticle from AtomFeedEntry
    /// - Returns: RSSArticle?
    func article() -> RSSArticle? {
        
        // Title
        guard let title = title else {
            return nil
        }
        
        // Date
        guard let date = updated else {
            return nil
        }
        
        // URL
        guard let link = links?.first?.attributes?.href else {
            return nil
        }
        
        // Image
        var imageUrl = summary?.value?.getImageUrl()
        
        // Image from media
        if imageUrl == nil {
            if let url = media?.mediaThumbnails?.first?.attributes?.url {
                imageUrl = URL(string: url)
            }
        }
        
        if imageUrl == nil {
            if let url = media?.mediaGroup?.mediaContents?.first?.mediaThumbnails?.first?.attributes?.url {
                imageUrl = URL(string: url)
            }
        }
        
        let article = RSSArticle(title: title,
                                 description: summary?.value,
                                 date: date,
                                 link: link,
                                 author: authors?.first?.name,
                                 image: imageUrl)
        
        if article.isValid() {
            return article
        } else {
            return nil
        }
    }
}
