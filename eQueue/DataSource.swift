//
//  DataSource.swift
//  eQueue
//
//  Created by Виталий Никоноров on 17.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation

class DataSource {
    var dataString: String?
    private var json: Any?
    private var queues: [Queue]?
    
    init() {
        dataString = "[{\"qid\": 1, \"name\": \"my Queue1\", \"description\": \"Description\", \"users_quantity\": 5, \"address\": \"\\u041d\\u0435\\u0438\\u0437\\u0432\\u0435\\u0441\\u0442\\u043d\\u043e\", \"wait_time\": 2, \"in_front\": 1, \"number\": 2, \"coords\": \"55.7648773124,37.6858637854\"}, {\"qid\": 3, \"name\": \"my Queue2\", \"description\": \"Description2\", \"users_quantity\": 52, \"address\": \"\\u041b\\u0435\\u0444\\u043e\\u0440\\u0442\\u043e\\u0432\\u0441\\u043a\\u0430\\u044f \\u043d\\u0430\\u0431\\u0435\\u0440\\u0435\\u0436\\u043d\\u0430\\u044f\", \"wait_time\": 22, \"in_front\": 12, \"number\": 22, \"coords\": \"55.7648773124,37.6858637854\"}, {\"qid\": 6, \"name\": \"my Queue3\", \"description\": \"Description2\", \"users_quantity\": 52, \"address\": \"address2\", \"wait_time\": 22, \"in_front\": 12, \"number\": 22, \"coords\": \"55.7648773124,37.6858637854\"}, {\"qid\": 33, \"name\": \"my Queue4\", \"description\": \"Description23\", \"users_quantity\": 532, \"address\": \"address23\", \"wait_time\": 232, \"in_front\": 132, \"number\": 232, \"coords\": \"\"}]"
        
        let data = dataString?.data(using: .utf8)!
        
        json = try? JSONSerialization.jsonObject(with: data!)
        queues = parseJson(anyObj: json as AnyObject)
    }
    
    func parseJson(anyObj:AnyObject) -> Array<Queue>{
        
        var list:Array<Queue> = []
        
        if  anyObj is Array<AnyObject> {
            
            for json in anyObj as! Array<AnyObject>{
                let q = Queue( name: (json["name"] as AnyObject? as? String) ?? "", description: (json["description"] as AnyObject? as? String) ?? "", location: (json["address"] as AnyObject? as? String) ?? "", waitingTime: (json["wait_time"] as AnyObject? as? Int) ?? 0, size: (json["number"] as AnyObject? as? Int) ?? 0, forwardMe: (json["in_front"] as AnyObject? as? Int) ?? 0, coords: (json["coords"] as AnyObject? as? String) ?? "")
                list.append(q)
            }
        }
        
        return list
        
    }

    public func getMyQueues() -> Array<Queue> {
        return self.queues!
    }
}
