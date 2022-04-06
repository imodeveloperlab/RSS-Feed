//
//  RSSDataPublisher.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 23.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Combine

class RSSDataSubscriber: Subscriber {
    
    public var dataDidUpdate: (([RSSSource]) -> Void)?
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: [RSSSource]) -> Subscribers.Demand {
        dataDidUpdate?(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion: \(completion)")
    }
    
    init() {
        RSSDataParser.shared.dataPublisher.subscribe(self)
    }
}
