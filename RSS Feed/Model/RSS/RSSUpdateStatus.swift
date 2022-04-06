//
//  RSSUpdateStatus.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 23.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

struct RSSUpdateStatus {
    let updated: Int
    let totalSources: Int
}

extension RSSUpdateStatus {
    
    func progress() -> Float {        
        return Float((100 / totalSources) * updated) / 100
    }
}
