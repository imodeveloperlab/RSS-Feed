//
//  BFFConnector.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 24.11.2020.
//

import Foundation

class BaseDispatchGroupConnector: BaseConnector {
    
    var completedError: BaseConnectorError? = nil
    
    /// Handle error closure
    /// - Parameter group: DispatchGroup
    /// - Returns: (Error) -> (Void)
    func handleError(_ group: DispatchGroup) -> (BaseConnectorError) -> (Void) {
        return { error in
            self.handleError(group, error)
        }
    }
    
    /// Handle error on group
    /// - Parameters:
    ///   - group: DispatchGroup
    ///   - error: Error
    func handleError(_ group: DispatchGroup, _ error: BaseConnectorError) {
        completedError = error
        group.leave()
    }
    
    /// Handle DispatchGroup execution
    /// - Parameters:
    ///   - group: DispatchGroup
    ///   - done: () -> Void
    ///   - fail: (Error) -> Void
    func handleDispatchExecution(_ group: DispatchGroup, done:  @escaping () -> Void, fail: @escaping (BaseConnectorError) -> Void) {
        
        group.notify(queue: DispatchQueue.main) {
            if let error = self.completedError {
                fail(error)
                self.completedError = nil
            } else {
                done()
            }
        }
    }
}
