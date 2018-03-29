//
//  AuthorizationResponseResult.swift
//  AccountsManagement
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.

import Foundation

public struct AuthorizationResponseResult {
    let responseData: [String: AnyObject]
    
    public var authorized : Bool {
        get {
            return self.responseData["authorized"] as? Bool ?? false
        }
    }
    
    public var duration : NSNumber {
        get {
            return self.responseData["duration"] as? NSNumber ?? -1
        }
    }
    
    public var cTicket : String {
        get {
            return self.responseData["concurrency"]?["cTicket"] as? String ?? ""
        }
    }
    
    public var policyRewind : Bool {
        get {
            return self.responseData["policy"]?["rewind"] as? Bool ?? false
        }
    }
    
    public var policyFastForwardSpeeds : [NSNumber] {
        get {
            return self.responseData["policy"]?["fastForwardSpeeds"] as? [NSNumber] ?? []
        }
    }
    
    public var playToken : String {
        get {
            return self.responseData["dRights"]?["playToken"] as? String ?? ""
        }
    }
    
    public init(data: [String: AnyObject]) {
        self.responseData = data
    }
}
