//
//  WebServiceResponse.swift
//  Core
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.

import Foundation

/**
  Response object for a WebService call.
  HTTP Response statusCode, Response Body, and URL of the WebService call are availble from this object.
 */
open class WebServiceResponse: CustomStringConvertible, CustomDebugStringConvertible {
    open let statusCode   : Int
    open let body         : Data // data from http response
    open let url          : URL?
    
    /**
      Convenient acces to the http response obj in case needed
     */
    open let httpResponse : URLResponse
    
    public init(statusCode: Int, url: URL?, body: Data, httpResponse: URLResponse) {
        self.statusCode   = statusCode
        self.body         = body
        self.url          = url
        self.httpResponse = httpResponse
    }
    
    open var description: String {
        return "WebServiceResponse(statusCode:\(statusCode), url:\(url))"
    }
    
    open var debugDescription: String {
        return "WebServiceResponse(statusCode:\(statusCode), url:\(url), body: \(String(data: body, encoding: String.Encoding.utf8)))"
        
        // TODO if body is application/json => pretty print json
//        if self.httpResponse.MIMEType == "application/json" {
//            try {
//                if let data: NSData? = NSJSONSerialization.dataWithJSONObject(body, options: ) {
//                    return "WebServiceResponse(statusCode:\(statusCode), url:\(url), body: \(data!))"
//                }
//            } catch let error {
//                
//            }
//            
//            
//        } else {
//            return "WebServiceResponse(statusCode:\(statusCode), url:\(url), body: \(String(data: body, encoding: NSUTF8StringEncoding)))"
//        }
        
    }
}
