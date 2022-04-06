//
//  RSSSource+UI.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 21.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit
import DSKit

extension Array where Element == RSSSource {
    
    /// Get sections from [RSSSource]
    /// - Parameters:
    ///   - presenter: DSViewController
    ///   - style: DisplayStyle
    ///   - filter: String?
    /// - Returns: [DSSection]
    func sections(presenter: DSViewController, style: DisplayStyle, filter: String? = nil) -> [DSSection] {
        let articles = RSSTimeLine.rssFeedTimeLine(for: self)
        return articles.sections(presenter: presenter, style: style, filter: filter)
    }
}
