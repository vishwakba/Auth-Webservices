//
//  WebServiceEndPoints.swift
//  Core
//
///  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation

public struct WebServiceEndPoints {
    
    //# MARK: Computed Properties
    public let endPoints: Dictionary<String, Any>
    
    //# MARK: Global Gateway EndPoints & Flags
    public func globalAPIGatewayEndPoint() throws -> String {
        guard
            let endPointGlobals = self.endPoints["globals"] as? [String: Any],
            let endPoint = endPointGlobals["apiGateway"] as? String else {
            throw WebServiceEndPointsError.emptyOrCorruptGlobalAPIGatewayEndPoint
        }
        
//        guard let endPoint = self.endPoints["globals"]?["apiGateway"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptGlobalAPIGatewayEndPoint
//        }
        return endPoint
    }
    
    public func useGlobalGatewayEndPoint() throws -> Bool {
        guard let flag = self.endPoints["useGlobalGatewayEndPoint"] as? Bool else {
            throw WebServiceEndPointsError.emptyOrCorruptUseGlobalGatewayEndPointFlag
        }
        return flag
    }
    
    //# MARK: Individual AuthN EndPoints & API
    
    //# MARK: Individual EndPoints
    public func authNTokenEndPoint() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let api = authentication["authNToken"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNNewTokenEndPoint
        }
//        guard let point = (self.endPoints["authentication"]?["authNToken"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNNewTokenEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endPoint
        } catch let error{
            throw error
        }
    }
    
    public func authNRefreshEndPoint() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let api = authentication["authNRefresh"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNRefreshTokenEndPoint
        }
//        guard let point = (self.endPoints["authentication"]?["authNRefresh"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNRefreshTokenEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endPoint
        } catch let error{
            throw error
        }
    }
    
    public func authNAccessEndPoint() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let api = authentication["authNAccess"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNAccessEndPoint
        }
        
//        guard let point = (self.endPoints["authentication"]?["authNAccess"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNAccessEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endPoint
        } catch let error{
            throw error
        }
    }
    
    public func authNLogoutEndPoint() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let api = authentication["authNLogout"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNLogoutEndPoint
        }
        
//        guard let point = (self.endPoints["authentication"]?["authNLogout"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNLogoutEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endPoint
        } catch let error{
            throw error
        }
    }
    
    //# MARK: Individual API Points
    public func authNTokenAPI() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let service = authentication["authNToken"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNNewTokenAPI
        }
        
//        guard let api = (self.endPoints["authentication"]?["authNToken"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNNewTokenAPI
//        }
        return api
    }
    
    public func authNRefreshAPI() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let service = authentication["authNRefresh"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNRefreshTokenAPI
        }
        
//        guard let api = (self.endPoints["authentication"]?["authNRefresh"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNRefreshTokenAPI
//        }
        return api
    }
    
    public func authNAccessAPI() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let service = authentication["authNAccess"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNAccessAPI
        }
        
//        guard let api = (self.endPoints["authentication"]?["authNAccess"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNAccessAPI
//        }
        return api
    }
    
    public func authNLogoutAPI() throws -> String {
        guard
            let authentication = self.endPoints["authentication"] as? [String: Any],
            let service = authentication["authNLogout"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthNLogoutAPI
        }
        
//        guard let api = (self.endPoints["authentication"]?["authNLogout"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthNLogoutAPI
//        }
        return api
    }
    
    //# MARK: Individual AuthZ Endpoints & API
    
    //# MARK: Individual Endpoints
    public func authZChannelEndPoint() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let api = authorization["channel"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZChannelEndpoint
        }
        
//        guard let point = (self.endPoints["authorization"]?["channel"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthZChannelEndpoint
//        }
        
        do {
            let endpoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endpoint
        } catch let error {
            throw error
        }
    }
    
    public func authZContentEndPoint() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let api = authorization["content"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZContentEndpoint
        }
        
//        guard let point = (self.endPoints["authorization"]?["content"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthZContentEndpoint
//        }
        
        do {
            let endpoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endpoint
        } catch let error {
            throw error
        }
    }
    
    public func authZHeartBeatEndPoint() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let api = authorization["heartbeat"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZHeartBeatEndpoint
        }
        
        //        guard let point = (self.endPoints["authorization"]?["channel"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
        //            throw WebServiceEndPointsError.emptyOrCorruptAuthZChannelEndpoint
        //        }
        
        do {
            let endpoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endpoint
        } catch let error {
            throw error
        }
    }
    
    
    public func authZHeartBeatAPI() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let service = authorization["heartbeat"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZHeartBeatAPI
        }
        
        //        guard let api = (self.endPoints["authorization"]?["channel"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
        //            throw WebServiceEndPointsError.emptyOrCorruptAuthZChannelAPI
        //        }
        return api
    }
    public func authZSubscriptionEndPoint() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let api = authorization["subscription"] as? [String: Any],
            let point = api["host"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZSubscriptionEndpoint
        }

        
//        guard let point = (self.endPoints["authorization"]?["subscription"] as? Dictionary<String, AnyObject>)?["host"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthZSubscriptionEndpoint
//        }
        
        do {
            let endpoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : point
            return endpoint
        } catch let error {
            throw error
        }
    }
    
    //# MARK: Individual API Points
    public func authZChannelAPI() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let service = authorization["channel"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZChannelAPI
        }
        
//        guard let api = (self.endPoints["authorization"]?["channel"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthZChannelAPI
//        }
        return api
    }
    
    public func authZContentAPI() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let service = authorization["content"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZContentAPI
        }
        
//        guard let api = (self.endPoints["authorization"]?["content"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthZContentAPI
//        }
        return api
    }
    
    public func authZSubscriptionAPI() throws -> String {
        guard
            let authorization = self.endPoints["authorization"] as? [String: Any],
            let service = authorization["subscription"] as? [String: Any],
            let api = service["api"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptAuthZSubscriptionAPI
        }
        
//        guard let api = (self.endPoints["authorization"]?["subscription"] as? Dictionary<String, AnyObject>)?["api"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptAuthZSubscriptionAPI
//        }
        return api
    }
    
    
    //MARK: - XCMS Host EndPoints
    public func xcmsHostCollection() throws -> String{
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let hosts = xcms["host"] as? [String: Any],
            let host = hosts["collection"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptCollectionEndPoint
        }

        
//        guard let host = (self.endPoints["xcms"]?["host"] as? Dictionary<String, AnyObject>)?["collection"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptCollectionEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : host
            return endPoint
        } catch let error{
            throw error
        }
    }
  
    public func xcmsHostSearch() throws -> String{
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let hosts = xcms["host"] as? [String: Any],
            let host = hosts["search"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchEndPoint
        }
        
//        guard let host = (self.endPoints["xcms"]?["host"] as? Dictionary<String, AnyObject>)?["search"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptSearchEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : host
            return endPoint
        } catch let error{
            throw error
        }
    }
    
    public func xcmsHostMetadata() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let hosts = xcms["host"] as? [String: Any],
            let host = hosts["metadata"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptMetadataEndPoint
        }
        
//        guard let host = (self.endPoints["xcms"]?["host"] as? Dictionary<String, AnyObject>)?["metadata"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptMetadataEndPoint
//        }
        
        do {
            let endPoint = try useGlobalGatewayEndPoint() ? globalAPIGatewayEndPoint() : host
            return endPoint
        } catch let error{
            throw error
        }
    }
    
    //MARK: - XCMS API Points
    public func xcmsAPIGenericItems() throws -> String{
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["genericItems"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptGenericItemsAPI
        }
        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["genericItems"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptGenericItemsAPI
//        }
        return api
    }
    
    
    public func xcmsAPIContinueWatching() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["continueWatching"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptContinueWatchingAPI
        }

        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["continueWatching"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptContinueWatchingAPI
//        }
        return api
    }
  
    
    public func xcmsAPILiveStreamingChannels() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["liveStreamingChannels"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptLiveStreamingChannelsAPI
        }
        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["liveStreamingChannels"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptLiveStreamingChannelsAPI
//        }
        return api
    }
    
    public func xcmsAPISearch() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["search"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
        }
        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["search"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
//        }
        return api
    }
    
    public func xcmsAPILastLiveStreamingChannelWatched() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["lastLiveStreamingChannelWatched"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptLastLiveStreamingChannelWatchedAPI
        }
        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["lastLiveStreamingChannelWatched"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptLastLiveStreamingChannelWatchedAPI
//        }
        return api
    }
    
    
    public func xcmsAPIProgramDetails() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["programDetails"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptProgramDetailsAPI
        }
        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["programDetails"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptProgramDetailsAPI
//        }
        return api
    }
    
    public func xcmsAPIOnAirProgramByChannel() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["onAirProgramByChannel"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptOnAirProgramByChannelAPI
        }
        
//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["onAirProgramByChannel"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptOnAirProgramByChannelAPI
//        }
        return api
    }
    
    public func xcmsAPIGuideChannels() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["guideChannels"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptGuidedChannelsAPI
        }

//        guard let api = (self.endPoints["xcms"]?["api"] as? Dictionary<String, AnyObject>)?["guideChannels"] as? String else {
//            throw WebServiceEndPointsError.emptyOrCorruptGuidedChannelsAPI
//        }
        return api
    }
    
    public func xcmsAPIPausePoint() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["pausePoint"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptPausePointAPI
        }
        return api
    }
  
    public func deviceLookUpEndPoint() throws -> String {
      guard
          let dms = self.endPoints["dms"] as? [String: Any],
          let apis = dms["deviceLookup"] as? [String: Any],
          let api = apis["api"] as? String else {
              throw WebServiceEndPointsError.emptyOrCorruptDeviceManagementServiceAPI
      }
      return api
    }
  
    public func xcmsUserProfileEndPoint() throws -> String{
      guard
        let xcms = self.endPoints["xcms"] as? [String: Any],
        let hosts = xcms["host"] as? [String: Any],
        let host = hosts["userProfile"] as? String else {
          throw WebServiceEndPointsError.emptyOrCorruptSearchEndPoint
      }
      return host
    }
  
    public func xcmsUserProfileAPI() throws -> String{
      guard
        let xcms = self.endPoints["xcms"] as? [String: Any],
        let hosts = xcms["api"] as? [String: Any],
        let host = hosts["profileSearchService"] as? String else {
          throw WebServiceEndPointsError.emptyOrCorruptSearchEndPoint
      }
      return host
    }
  
    public func xcmsAPIGuideSchedule() throws -> String {
        guard
            let xcms = self.endPoints["xcms"] as? [String: Any],
            let apis = xcms["api"] as? [String: Any],
            let api = apis["guideSchedule"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptDeviceManagementServiceAPI
        }
        return api
    }
    
    //# MARK: Private Init Method
    public init(endPoints: Dictionary<String, Any>) {
        self.endPoints = endPoints
    }
    
}
