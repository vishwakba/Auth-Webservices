//
//  MockWebService.swift
//  Core
//
//  Created by Vishwak on 7/15/16.
//  Copyright © 2016 AEG. All rights reserved.
//

import UIKit

open class MockWebService: NSObject, WebServiceAPI {

    var successResponse: WebServiceResponse?
    var errorResponse: WebServiceError?
    
    public init(statusCode: Int, url: URL?, body: Data, httpResponse: URLResponse) {
        super.init()
        
        self.successResponse = WebServiceResponse(statusCode: statusCode, url: url, body: body, httpResponse: httpResponse)
    }
    
    public init(httpErrorCode: Int, httpResponse: HTTPURLResponse, responseBody: Data?, error: NSError?) {
        super.init()
        
        self.errorResponse = WebServiceError(httpErrorCode: httpErrorCode, httpResponse: httpResponse, responseBody: responseBody, error: error)
    }
    
    open func execute(successCallback callback: @escaping WebServiceSuccessHandler, errorCallback: @escaping WebServiceErrorHandler) {
        if successResponse != nil {
            callback(successResponse!)
        }
        if errorResponse != nil {
            errorCallback(errorResponse)
        }
    }
    
    open func abort() {
        
    }
}
