//
//  AppError.swift
//  Weather
//
//  Created by Amar Sawant on 21/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

enum AppError: Error {
    case httpUnknownError
    case httpInvalidCredentials
    case httpInvalidRequest
    case httpNotFound
    case appNoInputData
    
    static func code(_ errorCode: Int) -> AppError {
        switch errorCode {
        case 400:
            return .httpInvalidRequest
        case 401:
            return .httpInvalidCredentials
        case 404:
            return .httpNotFound
        default:
            return .httpUnknownError
        }
    }
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .httpUnknownError:return "HTTP Unknown Error"
        case .httpInvalidCredentials: return "401 Unauthorized, The request requires user authentication"
        case .httpInvalidRequest: return "400 Bad Rrequest, The request could not be understood by the server"
        case .httpNotFound: return "404 Not Found, The server has not found anything matching the Request-URI"
        case .appNoInputData: return "data not found for request input"
        }
    }
}
