//
//  AuthorizationService.swift
//  AccountsManagement
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation
import AccountsManagement

#if os(tvOS)
    import CoreTV
#endif

#if os(iOS)
    import Core
#endif

public enum FetchResult {
    case success(AuthorizationResponseResult)
    case failure(AuthorizationError)
    case cancelled
}

open class AuthorizationService {
    
    fileprivate let endPoints: WebServiceEndPoints
    fileprivate var webService: WebServiceAPI?
    
    public init(endPoints: WebServiceEndPoints) {
        self.endPoints = endPoints
    }
    
    public init(endPoints: WebServiceEndPoints, mockWebService: MockWebService) {
        self.endPoints = endPoints
        self.webService = mockWebService
    }

    fileprivate func fetchDataFromApi (_ host: String, api: String, params: [String:String]?, httpHeaders: [String: String]?, completion: @escaping (FetchResult) -> Void) {
        
        if webService == nil  {
            var additionalHTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
            
            if let httpHeaders = httpHeaders  {
                // add a dictionary's elements to another dictionary.
                httpHeaders.forEach { additionalHTTPHeaders[$0] = $1 }
            }
            
            
            let webserviceConfig = WebServiceConfig(endpoint               : host,
                                                    method                 : .GET,
                                                    additionalHTTPHeaders  : additionalHTTPHeaders,
                                                    requestBodyContentType : .PlainText,
                                                    expectedResponseType   : .JSON)
            
            webService = AuthWebService(config : webserviceConfig,
                                               api    : api,
                                               params : params as Dictionary<String, AnyObject>?)
        }
        
        webService!.execute(
            successCallback: {
                (response: WebServiceResponse) -> Void in
                
                let httpUrlResponse = response.httpResponse as! HTTPURLResponse
                if let contentLength = httpUrlResponse.allHeaderFields["Content-Length"] as? String, contentLength == "0"{
                    let data: [String: AnyObject] = [:]
                    let authResult = AuthorizationResponseResult(data: data)
                    completion(FetchResult.success(authResult))
                }
                else {
                    guard let jsonResult = CoreJSON.parseToDictionary(response.body) else {
                        let authError = AuthorizationError(responseData: ["code": -1000 as AnyObject, "message": "Error while parsing data" as AnyObject], error: nil)
                        completion(FetchResult.failure(authError))
                        return
                    }
                    
                    let authResult = AuthorizationResponseResult(data: jsonResult)
                    completion(FetchResult.success(authResult))
                }
                
                self.webService = nil
            },
            errorCallback: {
                (error: WebServiceError?) -> Void in
                
                if let responseBody = error?.responseBody {
                    
                    guard let jsonResult = CoreJSON.parseToDictionary(responseBody) else {
                        let authError = AuthorizationError(responseData: ["code": -1000 as AnyObject, "message": "Error while parsing data" as AnyObject], error: nil)
                        completion(FetchResult.failure(authError))
                        return
                    }
                    
                    let authError = AuthorizationError(responseData: jsonResult, error: error)
                    completion(FetchResult.failure(authError))
                    
                }
                else {
                    let authError = AuthorizationError(responseData: ["code": 0001 as AnyObject, "message": "No Response Body" as AnyObject], error: nil)
                    completion(FetchResult.failure(authError))
                    
                    ATTLogError("Fail to request Authorization")
                }
                
                self.webService = nil
            }
        )
    }
    
    /**
     Fetch user subscribtion Authorization
     
     - Parameter serviceId: service Id.
     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
     - Returns: Void
     */
    open func fetchSubscriptionAuthorization(_ serviceId: String, completion: @escaping (FetchResult) -> Void) throws -> Void {
        do {
            let endpoint = try self.endPoints.authZSubscriptionEndPoint()
            let api = try self.endPoints.authZSubscriptionAPI()
            
            let params = ["serviceId": serviceId]
            fetchDataFromApi(endpoint, api: api, params: params, httpHeaders: nil, completion: completion)
        } catch let error {
            throw error
        }
    }
    
    /**
     Fetch user channel Authorization
     
     - Parameter channelId: a string channel Id.
     - Parameter accessToken: a string user access Token.
     - Parameter inHome: a Bool indicating if user is in/out home.
     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
     - Returns: Void
     */
    open func fetchChannelAuthorization(_ channelId: String, accessToken: String, inHome: Bool, completion: @escaping (FetchResult) -> Void) throws -> Void {
        do {
            let endpoint = try self.endPoints.authZChannelEndPoint()
            let api = try self.endPoints.authZChannelAPI()
            
            var params: [String: String] = createAuthorizationContext(inHome)
            params["ccid"] = channelId
            
            let httpHeaders = ["Authorization": "Bearer \(accessToken)"]
            
            fetchDataFromApi(endpoint, api: api, params: params, httpHeaders: httpHeaders, completion: completion)
        } catch let error {
            throw error
        }
    }
    
    /**
     Fetch user content Authorization
     
     - Parameter contentId: a string content Id.
     - Parameter accessToken: a string user access Token.
     - Parameter inHome: a Bool indicating if user is in/out home.
     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
     - Returns: Void
     */
    open func fetchContentAuthorization(_ contentId: String, accessToken: String, inHome: Bool, completion: @escaping (FetchResult) -> Void) throws -> Void {
        do {
            let endpoint = try self.endPoints.authZContentEndPoint()
            let api = try self.endPoints.authZContentAPI()
            
            var params: [String: String] = createAuthorizationContext(inHome)
            params["contentid"] = contentId
            
            let httpHeaders = ["Authorization": "Bearer \(accessToken)"]
            
            fetchDataFromApi(endpoint, api: api, params: params, httpHeaders: httpHeaders, completion: completion)
        } catch let error {
            throw error
        }
    }
    
    open func fetchHeartBeatAuthorization(_ channelId: String, accessToken: String, inHome: Bool, completion: @escaping (FetchResult) -> Void) throws -> Void {
        do {
            let endpoint = try self.endPoints.authZHeartBeatEndPoint()
            let api = try self.endPoints.authZHeartBeatAPI()
            
            var params: [String: String] = createAuthorizationContext(inHome)
            params["ccid"] = channelId
            
            let httpHeaders = ["Authorization": "Bearer \(accessToken)"]
            
            fetchDataFromApi(endpoint, api: api, params: params, httpHeaders: httpHeaders, completion: completion)
        } catch let error {
            throw error
        }
    }
    
    open func createAuthorizationContext(_ inHome: Bool) ->  [String: String] {
        let locationServices = LocationServices.sharedInstance
        let latitude = locationServices.currentLocationLatitude()
        let longitude = locationServices.currentLocationLongitude()
        
        let params: [String: String] = ["proximity":"\((inHome ? "I" : "O"))",
                                           "latlong": "\(latitude),\(longitude)"]
        
        return params;
    }
    
//    /**
//     Fetch user Device Concurrency
//
//     - Parameter programId: device Id.
//     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
//     - Returns: Void
//     */
//    public func fetchDeviceConcurrency(deviceId: String, completion: (FetchResult) -> Void) {
//        let params = ["deviceId":deviceId]
//
//        fetchDataFromApi(self.endPoints.fetchSubscriptionAPI, params: params, httpHeaders:nil, completion:completion)
//    }
//
//    /**
//     Fetch user Program Concurrency
//
//     - Parameter programId: String program Id.
//     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
//     - Returns: Void
//     */
//    public func fetchProgramConcurrency(programId: String, completion: (FetchResult) -> Void) {
//        let params = ["programId":programId]
//
//        fetchDataFromApi(self.endPoints.fetchSubscriptionAPI, params: params, httpHeaders:nil, completion:completion)
//    }
//
//    public func fetchThirdpartyappConcurrency(appId: String, completion: (FetchResult) -> Void) {
//        let params = ["appId":appId]
//
//        fetchDataFromApi(self.endPoints.fetchSubscriptionAPI, params: params, httpHeaders:nil, completion:completion)
//    }
//    
//    /**
//     Fetch Entitlements
//     
//     - Parameter accountId: user account Id.
//     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
//     - Returns: Void
//     */
//    public func fetchEntitlements(accountId: String, completion: (FetchResult) -> Void) {
//        let params = ["accountId":accountId]
//        
//        fetchDataFromApi(self.endPoints.fetchSubscriptionAPI, params: params, httpHeaders:nil, completion:completion)
//    }
//    
//    /**
//     Fetch User Type
//     
//     - Parameter accountId: user account Id.
//     - Parameter completion: a closure, with FetchResult enum as param, called by the method when processing is finished.
//     - Returns: Void
//     */
//    public func fetchUserType(accountId: String, completion: (FetchResult) -> Void) {
//        let params = ["accountId":accountId]
//        
//        fetchDataFromApi(self.endPoints.fetchSubscriptionAPI, params: params, httpHeaders:nil, completion:completion)
//    }
    
    /**
     Abort Fetch
    */
    open func abortFetch() {
        if let ws = webService {
            ws.abort()
        }
    }
}
