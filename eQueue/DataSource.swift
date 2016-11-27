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
    
    /**
     * Dispatch queue for handling network request preparing in concurrent queue, 
     * but first reqest - token request if it needs works with barrier and syncronous!!!
     */
    private let concurrentRequestQueue = DispatchQueue(label: "org.eQueue.ios.RequestQueue", attributes: .concurrent)
    
    /**
     * DataSource - is singlethon object
     */
    static let sharedInstance: DataSource = {
        let instance = DataSource()
        return instance
    }()
    
    let networkSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    private init() {
        createUser(email: "", password: "", token: "")
    }
    
    /**
     * Method for parsing server answer with list of queues
     */
    func parseJson(anyObj:AnyObject) -> Array<Queue>{
        var list:Array<Queue> = []
        
        if  anyObj is Array<AnyObject> {
            
            for json in anyObj as! Array<AnyObject>{
                let q = Queue( qid: (json["qid"] as AnyObject? as? Int) ?? -1,name: (json["name"] as AnyObject? as? String) ?? "", description: (json["description"] as AnyObject? as? String) ?? "", location: (json["address"] as AnyObject? as? String) ?? "", waitingTime: (json["wait_time"] as AnyObject? as? Int) ?? 0, size: (json["number"] as AnyObject? as? Int) ?? 0, forwardMe: (json["in_front"] as AnyObject? as? Int) ?? 0, coords: (json["coords"] as AnyObject? as? String) ?? "", myNumber: (json["number"] as AnyObject? as? Int) ?? 0)
                list.append(q)
            }
        }
        return list
    }
    
    
    /**
     * Main method for generating request object for URLSession
     */
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
    
    /**
     * Function for creating user
     * As it described higher - this function is syncronous
     * Works in custom concurrent queue but with barrier!!!
     */
    func createUser(email: String?, password: String?, token: String?) {
        
        concurrentRequestQueue.async(flags: .barrier){

            self.token = KeyChainService.loadToken() as String?
        
            if (self.token == nil) {
                let post = "{\"email\":\"\(email)\", \"password\":\"\(password)\", \"token\":\"\(token)\"}"
                let url = NSURL(string: "\(self.URL_BASE)/api/user/create/") as! URL
                let request = self.createRequest(url: url, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
                
                let semaphore = DispatchSemaphore(value: 0)
            
                let task = self.networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    print("Response: \(response)")
                    do {
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        print(jsonResponse!)
                        self.token = (jsonResponse?["body"] as! Dictionary<String, AnyObject>)["token"] as! String?
                
                        print("servers token: \(self.token! as String)")
                        KeyChainService.saveToken(token: (self.token as String!) as NSString)
                    
                        print("loaded from KC token: \(KeyChainService.loadToken() as String?)")
                                    semaphore.signal()
                    
                        let _: NSError?
                        _ = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                    } catch let err as NSError {
                        print(err)
                        semaphore.signal()
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                })
                task.resume()

                semaphore.wait(timeout: DispatchTime.distantFuture)
            }
        }
    }
    

    /**
     * Function for requesting queue by it id
     */
    func findQueueById(qid: Int, callBack: QueueCallback) {
        
        concurrentRequestQueue.async{
        
            let post = "token=\(self.token! as String)&qid=\(qid)"
            let url = NSURL(string: "\(self.URL_BASE)/api/queue/info-user/") as! URL
            let request = self.createRequest(url: url, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
            
            let task = self.networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let bodyJson = jsonResponse?["body"] as! Dictionary<String, AnyObject>
                
                let q = Queue( qid: (bodyJson["qid"] as AnyObject? as? Int) ?? -1, name: (bodyJson["name"] as AnyObject? as? String) ?? "", description: (bodyJson["description"] as AnyObject? as? String) ?? "", location: (bodyJson["address"] as AnyObject? as? String) ?? "", waitingTime: (bodyJson["wait_time"] as AnyObject? as? Int) ?? 0, size: (bodyJson["number"] as AnyObject? as? Int) ?? 0, forwardMe: (bodyJson["in_front"] as AnyObject? as? Int) ?? 0, coords: (bodyJson["coords"] as AnyObject? as? String) ?? "", myNumber: (bodyJson["number"] as AnyObject? as? Int) ?? 0)
                
                callBack.onQueueInfoLoaded(response: q)
            })
            
            task.resume()
        }
    }
    
    /**
     * Function for checking is current token alive
     */
    func checkToken() {
        concurrentRequestQueue.async{
            let post = "token=\(self.token! as String)"
            let url = NSURL(string: "\(self.URL_BASE)/api/user/check-token/") as! URL
            
            let request = self.createRequest(url: url, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
            
            let task = self.networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
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
    }
    
    /**
     * Function for joining to selected queue
     */
    func joinQueue(qid: Int, callBack: JoinCallback) {
        
        concurrentRequestQueue.async{
            let post = "token=\(self.token! as String)&qid=\(qid)"
            let request = self.createRequest(url: NSURL(string: "\(self.URL_BASE)/api/queue/join/") as! URL, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
            
            let task = self.networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                do {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    callBack.onJoinResponse(response: jsonResponse!)
                }
            })
            task.resume()
        }
    }
    
    /**
     * Function for requesting user's list of queues
     */
    func getMyQueues(callBack: QueueListCallback) {
        concurrentRequestQueue.async{
            let post = "token=\(self.token! as String)"
            let request = self.createRequest(url: NSURL(string: "\(self.URL_BASE)/api/queue/in-queue/") as! URL, requestMethod: HTTPRequestMethod.post, contentType: HTTPContentType.urlencoded, requestData: post)
            
            let task = self.networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                do {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    let queues = self.parseJson(anyObj: (jsonResponse!["body"] as! Dictionary<String, AnyObject>)["queues"]!)
                    
                    callBack.onQueueListResponse(response: queues)
                }
            })
            task.resume()
        }
    }
    
    /**
     * Function for requesting near list of queues by location
     */
    func getNearQueues(coords: String, callBack: QueueListCallback) {
        concurrentRequestQueue.async{
            let request = self.createRequest(url: NSURL(string: "\(self.URL_BASE)/api/queue/find_near/?coords=\(coords)") as! URL, requestMethod: HTTPRequestMethod.get, contentType: HTTPContentType.none, requestData: "")
            
            let task = self.networkSession.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                do {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    let queues = self.parseJson(anyObj: (jsonResponse!["body"] as! Dictionary<String, AnyObject>)["queues"]!)
                    
                    callBack.onQueueListResponse(response: queues)
                }
            })
            task.resume()
        }
    }
}
