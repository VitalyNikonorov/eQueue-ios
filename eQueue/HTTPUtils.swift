//
//  HTTPUtils.swift
//  eQueue
//
//  Created by Виталий Никоноров on 24.11.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import Foundation

enum HTTPRequestField: String {

    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    
}

enum HTTPContentType: String {
    
    case urlencoded = "application/x-www-form-urlencoded"
    case json = "application/json"
}

enum HTTPRequestMethod: String {
    case post = "POST"
    case get = "GET"
}
