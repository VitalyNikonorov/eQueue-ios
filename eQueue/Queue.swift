//
//  Queue.swift
//  eQueue
//
//  Created by Виталий Никоноров on 18.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation
import RealmSwift

class Queue {

    init(qid: Int, name: String, description: String?, location: String?, waitingTime: Int, size: Int, forwardMe: Int, coords: String?, myNumber: Int){
        self.qid = qid
        self.name = name
        self.descriprion = description
        self.location = location
        self.waitingTime = waitingTime
        self.size = size
        self.forwardMe = forwardMe
        self.coords = coords
        self.myNumber = myNumber
    }
    
    public private(set) var qid: Int
    public private(set) var name: String?
    public private(set) var descriprion: String?
    public private(set) var location: String?
    
    public private(set) var waitingTime: Int
    public private(set) var myNumber: Int
    public private(set) var size: Int
    public private(set) var forwardMe: Int
    public private(set) var coords: String?
}

class QueueDAO: Object {
    
    dynamic var qid = 0
    dynamic var name = ""
    dynamic var descriprion = ""
    dynamic var location = ""
    
    dynamic var waitingTime = 0
    dynamic var myNumber = 0
    dynamic var size = 0
    dynamic var forwardMe = 0
    dynamic var coords = ""

}
