//
//  Protocols.swift
//  eQueue
//
//  Created by Виталий Никоноров on 26.11.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation

//protocol QueueCallback {
//    func onQueueInfoLoaded(response: Queue);
//    func onError(error: Error)
//}

//protocol JoinCallback {
//    func onJoinResponse(response: Dictionary<String, AnyObject>);
//}

protocol NetworkRequestCallback {
    func onSucces(response: Any, type: RequestType);
    func onError(error: Error)
}

enum RequestType {
    
    case queue
    case queueList
    case joinQueue
    
}
