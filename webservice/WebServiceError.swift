//
//  WebServiceError.swift
//  Core
//
//  //  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation

/**
 * Error object for a WebService call
 * HTTP Response statusCode, Response instance, and Error of the WebService call are availble from this object
 */
open class WebServiceError: CustomStringConvertible {
    open let httpErrorCode: Int
    open let httpResponse : HTTPURLResponse?
    open let responseBody : Data?
    open let error        : NSError?
    
    public init(httpErrorCode: Int, httpResponse: HTTPURLResponse?, responseBody: Data?, error: NSError?) {
        self.httpErrorCode = httpErrorCode
        self.httpResponse  = httpResponse
        self.responseBody  = responseBody
        self.error         = error
    }
    
    open var description: String {
        return "WebServiceError(httpErrorCode:\(httpErrorCode), httpResponse:\(httpResponse), error:\(error))"
    }
    
}
