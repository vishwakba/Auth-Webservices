//
//  AuthorizationError.swift
//  AccountsManagement
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation
#if os(tvOS)
    import CoreTV
#endif

#if os(iOS)
    import Core
#endif

public struct AuthorizationError {
    public let responseData : [String: AnyObject]
    public let error: WebServiceError?
    
    public var errorCode: NSNumber {
        get {
            return responseData["code"] as? NSNumber ?? 0000
        }
    }
    
    
    public var errorType: AuthZErrorCodeType {
        get {
            return bindErrorCode()
        }
    }
    
    public var errorDescription: String {
        get {
            return responseData["message"] as? String ?? ""
        }
    }
    
    public var duration : NSNumber {
        get {
            return responseData["duration"] as? NSNumber ?? -1
        }
    }
    
    public init(responseData: [String: AnyObject], error: WebServiceError?) {
        self.responseData = responseData
        self.error = error
    }
    
    fileprivate func bindErrorCode() -> AuthZErrorCodeType {
        var type: AuthZErrorCodeType
        
        switch errorCode {
        case 0001 :
            type = .systemError
        case 0002 :
            type = .invalidSubscription
        case 0003 :
            type = .invalidUserType
        case 0004 :
            type = .invalidDeviceType
        case 0005 :
            type = .providerLevelConcurrency
        case 0006 :
            type = .accountLevelConcurrency
        case 0007 :
            type = .contentLevelConcurrency
        case -1000:
            type = .parsingJSONDataError
        default:
            type = .systemError
        }
        
        return type
    }
}

public enum AuthZErrorCodeType: Equatable {
    case systemError
    case invalidSubscription
    case invalidUserType
    case invalidDeviceType
    case providerLevelConcurrency
    case accountLevelConcurrency
    case contentLevelConcurrency
    case parsingJSONDataError
    
}
