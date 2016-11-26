//
//  DataSource.swift
//  eQueue
//
//  Created by Виталий Никоноров on 17.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation

class DataSource {
    private var json: Any?
    private var jsonResponse: Any?
    private var token: String?
    private let URL_BASE = "http://equeue.org"
    
    static let sharedInstance: DataSource = {
        let instance = DataSource()
        return instance
    }()
    
    //Network
    let networkSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    var createUserTask: URLSessionDataTask?
    
    private init() {
        createUser(email: nil, password: nil, token: nil)
    }
    
    func parseJson(anyObj:AnyObject) -> Array<Queue>{
        
        var list:Array<Queue> = []
        
        if  anyObj is Array<AnyObject> {
            
            for json in anyObj as! Array<AnyObject>{
                print (json)
                let q = Queue( qid: (json["qid"] as AnyObject? as? Int) ?? -1,name: (json["name"] as AnyObject? as? String) ?? "", description: (json["description"] as AnyObject? as? String) ?? "", location: (json["address"] as AnyObject? as? String) ?? "", waitingTime: (json["wait_time"] as AnyObject? as? Int) ?? 0, size: (json["number"] as AnyObject? as? Int) ?? 0, forwardMe: (json["in_front"] as AnyObject? as? Int) ?? 0, coords: (json["coords"] as AnyObject? as? String) ?? "", myNumber: (json["number"] as AnyObject? as? Int) ?? 0)
                list.append(q)
            }
        }
        return list
    }
    
    ///// NETWORK
    
    private func createRequest (url: URL, requestMethod: HTTPRequestMethod, contentType: HTTPContentType, requestData: String) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        
        if (requestMethod != HTTPRequestMethod.get){
            request.setValue(contentType.rawValue, forHTTPHeaderField: HTTPRequestField.contentType.rawValue)
            
            let data = requestData.data(using: String.Encoding.ascii, allowLossyConversion: true)
            let dataLength = "\(data?.count)"
            
            request.setValue(dataLength, forHTTPHeaderField: HTTPRequestField.contentLength.rawValue)
            request.httpBody = data
        }
        
        return request
    }
    
    func createUser(email: String?, password: String?, token: String?) {
        
        self.token = KeyChainService.loadToken() as String?
        print("loaded token: \(self.token as String!)")
        if (self.token == nil) {
            
            let post = "email=\(email! as String)&password=\(password! as String)&token=\(token! as String)"
            let url = NSURL(string: "\(URL_BASE)/api/user/create/") as! URL
            let request = createRequest(url: url, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
            print("create user")
            
            let task = networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                do {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                    self.token = (jsonResponse?["body"] as! Dictionary<String, AnyObject>)["token"] as! String?
                
                    print("servers token: \(self.token! as String)")
                    KeyChainService.saveToken(token: (self.token as String!) as NSString)
                    
                    print("loaded from KC token: \(KeyChainService.loadToken() as String?)")
                    
                    let _: NSError?
                    _ = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                } catch let err as NSError {
                    print(err)
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: '\(jsonStr)'")
                }
            })
            task.resume()
        }
    }
    
    ///// NETWORK
    func findQueueById(qid: Int, callBack: QueueCallback) {
        
        let post = "token=\(self.token! as String)&qid=\(qid)"
        let url = NSURL(string: "\(URL_BASE)/api/queue/info-user/") as! URL
        let request = createRequest(url: url, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
        
        let task = networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            callBack.onQueueInfoLoaded(response: jsonResponse!)
        })
        
        task.resume()
    }
    
    ///// NETWORK
    func checkToken() {
        
        let post = "token=\(self.token! as String)"
        let url = NSURL(string: "\(URL_BASE)/api/user/check-token/") as! URL
        
        let request = createRequest(url: url, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
        
        let task = networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                
                print(jsonResponse?["body"] as! String)
                let _: NSError?
                _ = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
            } catch let err as NSError {
                print(err)
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        })
        
        task.resume()
    }
    
    func joinQueue(qid: Int, callBack: JoinCallback) {
        
        let post = "token=\(self.token! as String)&qid=\(qid)"
        let request = createRequest(url: NSURL(string: "\(URL_BASE)/api/queue/join/") as! URL, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
        
        let task = networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                callBack.onJoinResponse(response: jsonResponse!)
            }
        })
        task.resume()
    }
    
    func myQueues(callBack: QueueListCallback) {
        
        let post = "token=\(self.token! as String)"
        let request = createRequest(url: NSURL(string: "\(URL_BASE)/api/queue/in-queue/") as! URL, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
        
        let task = networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let queues = self.parseJson(anyObj: (jsonResponse!["body"] as! Dictionary<String, AnyObject>)["queues"]!)
                
                callBack.onQueueListResponse(response: queues)
            }
        })
        task.resume()
    }
    
    func getNearQueues(coords: String, callBack: QueueListCallback) {
        
        let request = createRequest(url: NSURL(string: "\(URL_BASE)/api/queue/find_near/?coords=\(coords)") as! URL, requestMethod: HTTPRequestMethod.get, contentType: HTTPContentType.none, requestData: "")
        
        let task = networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let queues = self.parseJson(anyObj: (jsonResponse!["body"] as! Dictionary<String, AnyObject>)["queues"]!)
                
                callBack.onQueueListResponse(response: queues)
            }
        })
        task.resume()
    }
}

