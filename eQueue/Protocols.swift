//
//  Protocols.swift
//  eQueue
//
//  Created by Виталий Никоноров on 26.11.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation

protocol QueueCallback {
    func onQueueInfoLoaded(response: Dictionary<String, AnyObject>);
}

protocol JoinCallback {
    func onJoinResponse(response: Dictionary<String, AnyObject>);
}

protocol QueueListCallback {
    func onQueueListResponse(response: Array<Queue>);
}
