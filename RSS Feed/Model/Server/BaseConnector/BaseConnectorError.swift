//
//  BaseConnectorError.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 24.11.2020.
//

import Foundation

enum BaseConnectorError {
    case invalidServiceURL(service: String)
    case unknownError(message: String?)
    case cantMapTheResult(service: String)
    case underlyingError(error: Error)
}
