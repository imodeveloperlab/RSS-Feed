//
//  BaseConnector.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 24.11.2020.
//

import Foundation

class BaseConnector {
    
    /// Execute server requests and map the result to an generic cod-able type
    /// - Parameters:
    ///   - service: Service url
    ///   - method: BaseConnectorRequestMethod
    ///   - success: Decoded generic cod-able type
    ///   - fail: BaseConnectorError
    public func makeRequest<T: Codable>(service: String,
                                        method: BaseConnectorRequestMethod,
                                        _ success: @escaping (T) -> Void,
                                        _ fail: @escaping (BaseConnectorError) -> Void) {
        
        let session = URLSession.shared
        
        guard let url = URL(string: service) else {
            fail(BaseConnectorError.invalidServiceURL(service: service))
            return
        }
        
        /// Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/x-plist", forHTTPHeaderField: "Accept")
        
        /// Make the request
        let task = session.dataTask(with: request) {(data, response, error) in
            
            /// Check if we have any error
            if let error = error {
                self.handleError(error: BaseConnectorError.underlyingError(error: error), fail)
            }
            /// Check if we have response data
            else if let data = data {
                
                /// Decode server data
                guard let object = try? PropertyListDecoder().decode(T.self, from: data) else {
                    self.handleError(error: BaseConnectorError.cantMapTheResult(service: service), fail)
                    return
                }
                
                /// Success response
                self.handleSuccess(object: object, success)
                
            } else {
                self.handleError(error: BaseConnectorError.unknownError(message: "We can't determine what cause the problem"), fail)
            }
        }
        
        print("🔌 Request \(service)")
        task.resume()
    }
    
    /// Handle error and transfer handling to main thread
    /// - Parameters:
    ///   - error: BaseConnectorError
    ///   - failClosure: Fail closure to transfer error on main thread
    func handleError(error: BaseConnectorError, _ failClosure: @escaping (BaseConnectorError) -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            failClosure(error)
        })
    }
    
    /// Handle success and transfer handling to main thread
    /// - Parameters:
    ///   - error: BaseConnectorError
    ///   - failClosure: Fail closure to transfer error on main thread
    func handleSuccess<T: Codable>(object: T, _ success: @escaping (T) -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            success(object)
        })
    }
}
