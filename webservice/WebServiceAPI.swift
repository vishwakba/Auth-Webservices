//
//  WebServiceAPI.swift
//  Core
//
//  Provide infrastructure for web service calls.
//  There are only primitive operations in this API.
//  More complex API can be built on top of this infrastructure.
//
// //  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation

public typealias WebServiceSuccessHandler = (_ response: WebServiceResponse) -> Void
public typealias WebServiceErrorHandler   = (_ error: WebServiceError?) -> Void

/**
  Public API for WebService
 */
public protocol WebServiceAPI {
    
    /**
      Execute web service call
     
      - parameters:
        - successCallback: a closure to be executed when the web service call returns successfully
        - errorCallback: a closure to be executed when there are issues finishing the web service call
     */
    func execute(successCallback callback: @escaping WebServiceSuccessHandler, errorCallback: @escaping WebServiceErrorHandler) -> Void
    
    /**
      Abort web service call even if when it is started
     */
    func abort() -> Void
}


/**
  Enum for HTTP methods for WebService
 */
public enum WebServiceHTTPMethod: String {
    case POST   = "POST"
    case GET    = "GET"
    case PUT    = "PUT"
    case DELETE = "DELETE"
}


/**
  Enum for Response Types
  
  - note:
  Right now only using application/json.
  Add more response type when the needs expand.
 */
public enum WebServiceResponseType: String {
    case JSON       = "application/json"
}

// TODO @anhho should we only have a combined WebServiceContentType instead of WebServiceResponseType and WebServiceRequestBodyType ?
public enum WebServiceRequestBodyContentType: String {
    case JSON       = "application/json"
    case PlainText  = "text/plain"
}



/**
  WebServiceConfig describe the configuration details such as endpoint, HTTP method, additional headers, etc. for a web service call
 */
public struct WebServiceConfig: CustomStringConvertible {
    
    // MARK: Public configs ready to use
    /**
      A convenient pre-defined WebServiceConfig for DeviceCapabilities web service
     */    
    public static let ProgramsWSConfig              = WebServiceConfig(endpoint                 : "https://api-dev.aeg.cloud",
                                                                       method                   : .POST,
                                                                       additionalHTTPHeaders    : ["Content-Type" : "application/json"],
                                                                       requestBodyContentType   : .JSON,
                                                                       expectedResponseType     : .JSON,
                                                                       timeout                  : 20.0)
    
    
    // MARK: instance properties
    let endpoint                : String
    let method                  : WebServiceHTTPMethod       // i.e. "POST"
    let expectedResponseType    : WebServiceResponseType     // i.e. "application/json"
    var additionalHTTPHeaders   : Dictionary<String, String> // i.e. ["Content-Type" : "application/x-www-form-urlencoded"]
    let timeout                 : Double                     // in seconds
    let certificateName         : String
    let certificatePassword     : String
    let requestBodyContentType  : WebServiceRequestBodyContentType  // i.e. "application/json"
    
    // Digest Access Authentication 
    // Ref: https://tools.ietf.org/html/rfc2617
    public var digestAccessAuthUserId   : String?
    public var digestAccessAuthPassword : String?
    
    // MARK: - Initializers
    public init(endpoint: String, method: WebServiceHTTPMethod = .GET, requestBodyContentType: WebServiceRequestBodyContentType = .PlainText, expectedResponseType: WebServiceResponseType = .JSON, timeout: Double = 15.0, certificate:String = "", certPass:String = "") {
        
        // pass params to defaul initializer
        self.init(endpoint                  : endpoint,
                  method                    : method,
                  additionalHTTPHeaders     : [:],
                  requestBodyContentType    : requestBodyContentType,
                  expectedResponseType      : expectedResponseType,
                  timeout                   : timeout,
                  certificate               : certificate,
                  certPass                  : certPass)
        
    }
    
    
    /*
     * TODO: what should be default time out duration ?
     * Note: default timeout is 15 seconds
     */
    public init(endpoint: String, method: WebServiceHTTPMethod, additionalHTTPHeaders: Dictionary<String, String>, requestBodyContentType: WebServiceRequestBodyContentType, expectedResponseType: WebServiceResponseType, timeout: Double = 15.0, certificate:String = "", certPass:String = "") {
        self.endpoint                   = endpoint
        self.method                     = method
        self.additionalHTTPHeaders      = additionalHTTPHeaders
        self.requestBodyContentType     = requestBodyContentType
        self.expectedResponseType       = expectedResponseType
        self.timeout                    = timeout
        
        // TODO: @anhho refactor certificate so it's consistent with setting up digest access
        self.certificateName            = certificate
        self.certificatePassword        = certPass
        
        // Populate these 2 fields when you need to handle digest acess authentication
        // i.e. pulling Playlist from STB will need to handle digest acess authentication challenge
        self.digestAccessAuthUserId     = nil
        self.digestAccessAuthPassword   = nil
    }
    
    // MARK: - Public Methods
    public mutating func updateAdditionalHTTPHeaders(with dictionary: Dictionary<String, String>) {
        dictionary.forEach { self.additionalHTTPHeaders.updateValue($1, forKey: $0) }
    }
    
    
    public var description : String {
        return "WebServiceConfig(endpoint:\(endpoint), method:\(method), additionalHTTPHeaders:\(additionalHTTPHeaders), requestBodyContentType: \(requestBodyContentType), expectedResponseType:\(expectedResponseType), timeout:\(timeout), certificate:\(certificateName), certificate password:\(certificatePassword))"
    }
}
