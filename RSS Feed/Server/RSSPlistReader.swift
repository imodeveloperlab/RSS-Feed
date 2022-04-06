//
//  RSSPlistReader.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 25.05.2021.
//

import Foundation

class RSSPlistReader: BaseConnector {
    
    /// Get all launches
    /// - Parameters:
    ///   - success: [Launch]
    ///   - fail: BaseConnectorError
    func getPropertyList(success: @escaping (Dictionary<String, String>) -> Void,
                         fail: @escaping (BaseConnectorError) -> Void) {
        
        makeRequest(service: "\(propertyListServerResourceUrl)", method: .GET, success, fail)
    }
}
