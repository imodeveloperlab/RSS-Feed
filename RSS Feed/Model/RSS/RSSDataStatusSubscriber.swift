//
//  RSSDataStatusSubscriber.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 23.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Combine

class RSSDataStatusSubscriber: Subscriber {
        
    public var statusDidUpdate: ((RSSUpdateStatus) -> Void)?
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: RSSUpdateStatus) -> Subscribers.Demand {
        statusDidUpdate?(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion: \(completion)")
    }
    
    init() {
        RSSDataParser.shared.dataStatusPublisher.subscribe(self)
    }
}
