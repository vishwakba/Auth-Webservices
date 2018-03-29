//
//  WebService.swift
//  Core
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//
// TODO: retry 3 times if #1 happens
//

import Foundation
import CoreFoundation


open class WebService: NSObject, WebServiceAPI, URLSessionDelegate {
    
    // MARK: - Instance properties
    var session: Foundation.URLSession?
    public private(set) var request: URLRequest
    public var webserviceConfiguration: WebServiceConfig
    open var username: String?
    open var password: String?
    
    
    // MARK: - Initializers
    /**
      Convenience init for a web service call.
      Only requires parameter: 'endpoint'
      This initilizer is used for quickly and 1-time web service call.
     
      - parameters:
        - endpoint: web service endpoint (including domain and port), i.e. www.dtvce.com:8080
        - port: port of the web service end point
        - method: method of the HTTP Request, defaults to GET
        - responeType: expected response type for the web service call, defaults to JSON
        - timeout: how long (in seconds) the web service call should timeout, defaults to 15 seconds
        - additionalHTTPHeaders: a dictionary of additional HTTP Headers if needed, defaults to empty dictionary
     */
    convenience public init(endpoint                : String,
                            method                  : WebServiceHTTPMethod = WebServiceHTTPMethod.GET,
                            requestBodyContentType  : WebServiceRequestBodyContentType = WebServiceRequestBodyContentType.PlainText,
                            responseType            : WebServiceResponseType = WebServiceResponseType.JSON,
                            timeout                 : Double = 15.0,
                            additionalHTTPHeaders   : Dictionary<String, String> = [String: String](),
                            certificate             : String = "",
                            certPassword            : String = "") {
        
        // constructing web service configuration
        let wsconfig = WebServiceConfig(endpoint                : endpoint,
                                        method                  : method,
                                        additionalHTTPHeaders   : additionalHTTPHeaders,
                                        requestBodyContentType  : requestBodyContentType,
                                        expectedResponseType    : responseType,
                                        timeout                 : timeout,
                                        certificate             : certificate,
                                        certPass                : certPassword)
        
        // invoke default initializer
        self.init(config: wsconfig)
    }
    
    
    /**
     Convenience init for a web service call.
     Accepts a WebServiceConfig struct to configure the web service call.
     This initializer is oftem used for calling different services of an endpoint + webservice API.
     
     - parameters:
       - config: the configuration struct to set up the web service call
     */
    convenience public init(config: WebServiceConfig) {
        self.init(config: config, api: nil, params: nil)
    }
    
    
    /**
     Set up a web service call.
     Accepts a WebServiceConfig struct, the web service API, and parameters for the web service call.
     
     - parameters:
        - config:   the configuration struct to set up the web service call
        - api:      web service API, i.e. /devicecapability/account
        - params:   parameters for the individual web service call, i.e. SAToken=0123456789
     */
    public init(config: WebServiceConfig, api: String?, params: Dictionary<String, Any>?) {
        
        webserviceConfiguration = config
        
        // for now assume all the webservice calls are either: http or https
        assert(config.endpoint.lowercased().hasPrefix("http"), "Cannot find prototol HTTP or HTTPS with endpoint '\(config.endpoint)'. Only support HTTP or HTTPS for now.")
        
        let urlStr: String
        if api == nil || (api?.isEmpty)! {
            urlStr = config.endpoint
        } else {
            urlStr = config.endpoint + api! // TODO: make sure there is NO '//' in the url str
        }
        
        // constructing URL
        let url: URL
        if params == nil || (params?.isEmpty)! || config.method == .POST {
            url = URL(string: urlStr)!
        } else {
            url = URL(string: urlStr + "?" + params!.stringFromHttpParameters())!
        }
        
        ATTLogInfo("Constructed WebService with URL:\(url)")
        
        
        // building the request
        request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(config.timeout))
        request.httpMethod = config.method.rawValue
        
        // constructing request body
        if (config.method == .POST || config.method == .PUT) && params != nil {
            switch config.requestBodyContentType {
            case .JSON:
                ATTLogInfo("Constructing WebService Request body as JSON:\n\(CoreJSON.convertToJSONString(params! as AnyObject)!)")
                request.httpBody = CoreJSON.convertToJSONData(params! as AnyObject)! 
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .PlainText:
                ATTLogInfo("Constructing WebService Request body as key=value:\(params!.stringFromHttpParameters())")
                request.httpBody = params!.stringFromHttpParameters().data(using: String.Encoding.utf8)
            }
        }
    }
    
    /**
     Set up a web service call.
     Accepts a WebServiceConfig struct, the web service API, and parameters for the web service call. This method allows for parameters in both the URL and along the POST body.
     
     - parameters:
     - config:     the configuration struct to set up the web service call
     - api:        web service API, i.e. /devicecapability/account
     - urlParams:  parameters for the individual web service call, i.e. SAToken=0123456789. These params will be appended to the url
     - bodyParams:  parameters for the individual web service call, i.e. SAToken=0123456789. These params will be on the HTTP body for POST requests
     */
    
    public init(config: WebServiceConfig, api: String?, urlParams : Dictionary<String, Any>?, bodyParams: Dictionary<String, Any>?) {
        
        webserviceConfiguration = config
        
        // for now assume all the webservice calls are either: http or https
        assert(config.endpoint.lowercased().hasPrefix("http"), "Cannot find prototol HTTP or HTTPS with endpoint '\(config.endpoint)'. Only support HTTP or HTTPS for now.")
        
        let urlStr: String
        if api == nil || (api?.isEmpty)! {
            urlStr = config.endpoint
        } else {
            urlStr = config.endpoint + api! // TODO: make sure there is NO '//' in the url str
        }
        
        // constructing URL
        let url: URL
        if urlParams == nil || (urlParams?.isEmpty)! {
            url = URL(string: urlStr)!
        } else {
            url = URL(string: urlStr + "?" + urlParams!.stringFromHttpParameters())!
        }
        
        ATTLogInfo("Constructed WebService with URL:\(url)")
        
        
        // building the request
        request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(config.timeout))
        request.httpMethod = config.method.rawValue
        
        // constructing request body
        if (config.method == .POST || config.method == .PUT) && bodyParams != nil {
            switch config.requestBodyContentType {
            case .JSON:
                ATTLogInfo("Constructing WebService Request body as JSON:\n\(CoreJSON.convertToJSONString(bodyParams! as AnyObject)!)")
                request.httpBody = CoreJSON.convertToJSONData(bodyParams! as AnyObject)!
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .PlainText:
                ATTLogInfo("Constructing WebService Request body as key=value:\(bodyParams!.stringFromHttpParameters())")
                request.httpBody = bodyParams!.stringFromHttpParameters().data(using: String.Encoding.utf8)
            }
        }
    }
    
    // MARK: - API implementation
    open func execute(successCallback: @escaping WebServiceSuccessHandler, errorCallback: @escaping WebServiceErrorHandler) {

        // make sure all required pre-conditions are met
        assert(request.url != nil, "URL must be constructed before executing for webservice: \(self)")
        
        
        // config the session
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = webserviceConfiguration.additionalHTTPHeaders
        // TODO why this?
        sessionConfig.httpAdditionalHeaders!["Accept"] = webserviceConfiguration.expectedResponseType.rawValue // i.e. "Accept" : "application/json"
        session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        // create task for webservice call
        let task = session!.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, nsError: Error?) in
            
            // if data is nil, then raise an error
            guard data != nil && response != nil else {
                ATTLogError("WebService:\((nsError as! NSError).userInfo[NSURLErrorFailingURLStringErrorKey])\n>>>>Error:\((nsError as! NSError))")

                let wsError = WebServiceError(httpErrorCode: (nsError as! NSError).code, httpResponse: nil, responseBody: nil, error: (nsError as! NSError))
                // invoke callback for error handling
                errorCallback(wsError)
                self.session?.invalidateAndCancel()
                return
            }
            
            
            // "Whenever you make an HTTP request, the NSURLResponse object you get back is actually an instance of the NSHTTPURLResponse class..."
            // Ref: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLResponse_Class/index.html#//apple_ref/occ/cl/NSURLResponse
            let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
            
            // only consider statusCode 2xx as successful, all other cases need to handle as error for webservice call
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300  {
                ATTLogDebug("WebService:\(response!.url!) - HTTPResponse.statusCode:\(httpResponse.statusCode)\nResponse content:\(httpResponse)\n")
                
                // building obj WebServiceResponse
                let res = WebServiceResponse(statusCode: httpResponse.statusCode, url: httpResponse.url, body: data!, httpResponse: response!)
                self.session?.invalidateAndCancel()
                // invoke callback for success handling
                successCallback(res)
            } else {
                ATTLogWarn("Got Non-2xx HTTP Response Status Code. HttpResponse.StatusCode:\(httpResponse.statusCode). WebService:\(response?.url!)")
                ATTLogDebug("Response content:\(httpResponse)\nError:\(nsError)\nWebService:\(response?.url!)")
                let wsError = WebServiceError(httpErrorCode: httpResponse.statusCode, httpResponse: httpResponse, responseBody: data, error: (nsError as? NSError))
                self.session?.invalidateAndCancel()
                // invoke callback for error handling
                errorCallback(wsError)
            }
        }) 
        
        // execute the web service call
        ATTLogInfo("Hitting WebService:\(request.url!)")
        task.resume()
    }
    
    
    /// Cancels all outstanding tasks and then invalidates the session.
    open func abort() -> Void {
        ATTLogInfo("Aborting WebService Call:\(request.url!)")
        session!.invalidateAndCancel()
    }
    
    
    // Mark: - HTTP Authentication Delegate Implementation
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        ATTLogInfo("Got AuthenticationChallenge:\(challenge). WebService:\(request.url!)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            ATTLogDebug("Handling AuthenticationChallenge:\(challenge.protectionSpace.authenticationMethod) with Certificate name:\(webserviceConfiguration.certificateName) and password")
            
            // passing cert name/password to AuthenticationChallenge handler
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,
                              extractIdentity(webserviceConfiguration.certificateName, password: webserviceConfiguration.certificatePassword));
        } else {
            let serverTrust : SecTrust     = challenge.protectionSpace.serverTrust!
            let credential  : URLCredential = URLCredential(trust: serverTrust)
            ATTLogDebug("Handling AuthenticationChallenge:\(challenge.protectionSpace.authenticationMethod) with Credential:\(credential)")
            
            // passing credential to AuthenticationChallenge handler
            challenge.sender?.use(credential,
                                            for  : challenge)
                                            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,
                                                              URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
        
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        ATTLogInfo("Got Session invalidated")
    }
    
    // HTTP Digest access auth challenge
    // Ref: https://tools.ietf.org/html/rfc2617
    open func URLSession(_ session: Foundation.URLSession, task: URLSessionTask, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        ATTLogInfo("Got AuthenticationChallenge:\(challenge) for WebService:\(request.url!)")
        
        if webserviceConfiguration.digestAccessAuthUserId != nil && webserviceConfiguration.digestAccessAuthPassword != nil {
            ATTLogDebug("Handling AuthenticationChallenge:\(challenge.protectionSpace.authenticationMethod) with userid:\(webserviceConfiguration.digestAccessAuthUserId) and password")
            
            // passing userid/password to Digest access auth challenge handler
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,
                              URLCredential.init(
                                user: webserviceConfiguration.digestAccessAuthUserId!,
                                password: webserviceConfiguration.digestAccessAuthPassword!,
                                persistence: URLCredential.Persistence.none))
        } else {
            ATTLogWarn("Not found username / password in the WebServiceConfiguration for WebService:\(request.url!).\nHandling the challenege with empty username/password")
            
            // passing >>empty<< userid/password to Digest access auth challenge handler
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
    }
    
    // Mark: Private methods
    fileprivate func extractIdentity(_ certName: String, password: String) -> URLCredential? {
        let path        : String        = Bundle.main.path(forResource: certName, ofType: "p12")!
        let PKCS12Data  : Data        = try! Data(contentsOf: URL(fileURLWithPath: path))
        let key         : NSString      = kSecImportExportPassphrase as NSString
        let options     : NSDictionary  = [key : password]
        
        var items       : CFArray?
        let securityError: OSStatus     = SecPKCS12Import(PKCS12Data as CFData, options, &items)
        
        if securityError == errSecSuccess {
            let certItems           = items as CFArray!
            let certItemsArray      = certItems as Array!
            let dict: AnyObject?    = certItemsArray!.first
            
            if let certEntry = dict as? Dictionary<String, AnyObject> {
                let identityPointer: AnyObject? = certEntry["identity"];
                let secIdentityRef: SecIdentity = identityPointer as! SecIdentity!;
                
                var certRef : SecCertificate? = nil
                SecIdentityCopyCertificate(secIdentityRef, &certRef)
                
                let credential = URLCredential(identity: secIdentityRef, certificates: [ certRef! ], persistence: .permanent)
                return credential
            }
        }
        
        return nil;
    }
}

// MARK: - Extension
extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}

