//
//  ErrorHandler.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import Alamofire

public protocol ErrorHandlerProtocol {
    
//    static func errorHandle(_ result:Result<T>)
    
}

class ErrorHandler<T> {
    
//    public let result: Result<Value>
    
    static func errorHandle(_ result:Result<T>, afterHandle block:((String)->Void)? = nil){
        guard case let .failure(error) = result else { return }
        
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            }
            
            print("Underlying error: \(String(describing: error.underlyingError))")
            
            block!(error.localizedDescription)
            
        } else if let error = error as? URLError {
            print("URLError occurred: \(error)")
            block!(error.localizedDescription)
        } else {
            print("Unknown error: \(error)")
            block!(error.localizedDescription)
        }
    }

    
}

