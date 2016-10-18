//
//  Queue.swift
//  eQueue
//
//  Created by Виталий Никоноров on 18.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation

class Queue {

    init(name: String, description: String?, location: String?, waitingTime: Int, size: Int, forwardMe: Int){
        self.name = name
        self.descriprion = description
        self.location = location
        self.waitingTime = waitingTime
        self.size = size
        self.forwardMe = forwardMe
    }
    
    public private(set) var name: String?
    public private(set) var descriprion: String?
    public private(set) var location: String?
    
    public private(set) var waitingTime: Int?
    public private(set) var size: Int?
    public private(set) var forwardMe: Int?

}
