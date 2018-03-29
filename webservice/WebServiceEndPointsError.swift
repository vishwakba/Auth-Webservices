//
//  WebServiceEndPointsError.swift
//  Core
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation

enum WebServiceEndPointsError: Error, CustomStringConvertible {
    
    case emptyOrCorruptGuidedChannelsAPI
    case emptyOrCorruptProgramDetailsAPI
    case emptyOrCorruptOnAirProgramByChannelAPI
    case emptyOrCorruptLastLiveStreamingChannelWatchedAPI
    case emptyOrCorruptGenericItemsAPI
    case emptyOrCorruptContinueWatchingAPI
    case emptyOrCorruptLiveStreamingChannelsAPI
    case emptyOrCorruptMetadataEndPoint
    case emptyOrCorruptMetadataAPI
    case emptyOrCorruptSearchEndPoint
    case emptyOrCorruptSearchAPI
    case emptyOrCorruptCollectionEndPoint
    case emptyOrCorruptCollectionAPI
    case emptyOrCorruptGlobalAPIGatewayEndPoint
    case emptyOrCorruptUseGlobalGatewayEndPointFlag
    case emptyOrCorruptAuthNNewTokenEndPoint
    case emptyOrCorruptAuthNRefreshTokenEndPoint
    case emptyOrCorruptAuthNAccessEndPoint
    case emptyOrCorruptAuthNLogoutEndPoint
    case emptyOrCorruptAuthNNewTokenAPI
    case emptyOrCorruptAuthNRefreshTokenAPI
    case emptyOrCorruptAuthNAccessAPI
    case emptyOrCorruptAuthNLogoutAPI
    case emptyOrCorruptAuthZChannelEndpoint
    case emptyOrCorruptAuthZContentEndpoint
    case emptyOrCorruptAuthZHeartBeatEndpoint
    case emptyOrCorruptAuthZSubscriptionEndpoint
    case emptyOrCorruptAuthZChannelAPI
    case emptyOrCorruptAuthZHeartBeatAPI
    case emptyOrCorruptAuthZContentAPI
    case emptyOrCorruptAuthZSubscriptionAPI
    case emptyOrCorruptPausePointAPI
    case emptyOrCorruptDeviceManagementServiceAPI
    
    var description: String {
        switch self {
        case .emptyOrCorruptSearchAPI: return "Empty or Corrupt Search API or JSON in App Config"
        case .emptyOrCorruptLiveStreamingChannelsAPI: return "Empty or Corrupt LiveStreamingChannels API or JSON in App Config"
        case .emptyOrCorruptContinueWatchingAPI: return "Empty or Corrupt ContinueWatching API or JSON in App Config"
        case .emptyOrCorruptGuidedChannelsAPI: return "Empty or Corrupt GuidedChannels API or JSON in App Config"
        case .emptyOrCorruptProgramDetailsAPI: return "Empty or Corrupt ProgramDetails API or JSON in App Config"
        case .emptyOrCorruptOnAirProgramByChannelAPI: return "Empty or Corrupt On Air Program By Channel API or JSON in App Config"
        case .emptyOrCorruptLastLiveStreamingChannelWatchedAPI: return "Empty or Corrupt LastLiveStreamingChannelWatched API or JSON in App Config"
        case .emptyOrCorruptGenericItemsAPI: return "Empty or Corrupt GenericItems API or JSON in AppConfig"
        case .emptyOrCorruptMetadataEndPoint: return "Empty or Corrupt Metadata Endpoint or JSON in AppConfig"
        case .emptyOrCorruptMetadataAPI: return "Empty or Corrupt Metadata API or JSON in AppConfig"
        case .emptyOrCorruptSearchEndPoint: return "Empty or Corrupt Search Endpoint or JSON in AppConfig"
        case .emptyOrCorruptCollectionEndPoint: return "Empty or Corrupt Collection Endpoint or JSON in AppConfig"
        case .emptyOrCorruptCollectionAPI: return "Empty or Corrupt Collection API or JSON in AppConfig"
        case .emptyOrCorruptGlobalAPIGatewayEndPoint: return "Empty or Corrupt Globals API Gateway EndPoint JSON."
        case .emptyOrCorruptUseGlobalGatewayEndPointFlag: return "Empty or Corrupt useGlobalGatewayEndPoint flag in JSON."
        case .emptyOrCorruptAuthNNewTokenEndPoint: return "Empty or Corrupt AuthNToken EndPoint JSON."
        case .emptyOrCorruptAuthNRefreshTokenEndPoint: return "Empty or Corrupt AuthNRefreshToken EndPoint JSON."
        case .emptyOrCorruptAuthNAccessEndPoint: return "Empty or Corrupt AuthNAccess EndPoint JSON."
        case .emptyOrCorruptAuthNLogoutEndPoint: return "Empty or Corrupt AuthNLogout EndPoint JSON."
        case .emptyOrCorruptAuthNNewTokenAPI: return "Empty or Corrupt AuthNToken API JSON."
        case .emptyOrCorruptAuthNRefreshTokenAPI: return "Empty or Corrupt AuthNRefreshToken API JSON."
        
        case .emptyOrCorruptAuthNAccessAPI: return "Empty or Corrupt AuthNAccess API JSON."
        case .emptyOrCorruptAuthNLogoutAPI: return "Empty or Corrupt AuthNLogout API JSON."
        case .emptyOrCorruptAuthZChannelEndpoint: return "Empty or Corrupt AuthZChannel EndPoint JSON"
        case .emptyOrCorruptAuthZHeartBeatEndpoint: return "Empty or Corrupt AuthZHearBeat EndPoint JSON"
        case .emptyOrCorruptAuthZContentEndpoint: return "Empty or Corrupt AuthZContent EndPoint JSON"
        case .emptyOrCorruptAuthZSubscriptionEndpoint: return "Empty or Corrupt AuthZSubscription EndPoint JSON"
        case .emptyOrCorruptAuthZChannelAPI: return "Empty or Corrupt AuthZChannel API JSON"
        case .emptyOrCorruptAuthZContentAPI: return "Empty or Corrupt AuthZContent API JSON"
        case .emptyOrCorruptAuthZHeartBeatAPI: return "Empty or Corrupt AuthZHearBeat API JSON"
        case .emptyOrCorruptAuthZSubscriptionAPI: return "Empty or Corrup AuthZSubscriptiobn API JSON"
        case .emptyOrCorruptPausePointAPI: return "Empty or Corrupt PausePointUpdate API JSON."
        case .emptyOrCorruptDeviceManagementServiceAPI: return "Empty or Corrupt Device Management Service API JSON."
        }
    }
}
