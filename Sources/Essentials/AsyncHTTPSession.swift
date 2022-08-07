//
//  File.swift
//  
//
//  Created by Praanto Samadder on 21/07/2022.
//

import Foundation


@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public struct AsyncHTTPSession: NetworkPacket {
    
    /// Creates an instance of `AsyncHTTPSession` with an URL object.
    ///
    /// Method is set to a GET request.
    ///
    /// *Last updated on 22 July at 09:07.*
    mutating func with(url: URL) -> JSONHTTPSession {
        return JSONHTTPSession(url: url, method: .get)
    }
    
    /// Creates an instance of `AsyncHTTPSession` with an URL object and a HTTP method.
    ///
    /// *Last updated on 22 July at 23:07.*
    static func with(url: URL, _ httpMethod: HTTPMethod) -> JSONHTTPSession {
        return JSONHTTPSession(url: url, method: httpMethod)
    }
    
    /// Creates an instance of `AsyncHTTPSession` with a URL string and a HTTP method.
    ///
    /// - Parameters:
    ///   - location: URL to your destination but as a string.
    ///   - httpMethod: HTTP method that should be used (e.g. `.get`, `.put`, etc)
    ///
    /// This function throws! If the `URL` object you provided is `.nil`,
    /// then this function will throw `URLError`
    ///
    /// If you don't want to do error-handling, might I suggest that you pass in a `URL`
    /// object instead.
    ///
    /// *Last updated on 22 July at 23:07.*
    static func with(location: String, _ httpMethod: HTTPMethod) throws -> JSONHTTPSession {
        guard let url = URL(string: location) else {
            throw HTTPError.URLError
        }
        return JSONHTTPSession(url: url, method: .get)
    }
    
    static func with(urlComponents: URLComponents, _ httpMethod: HTTPMethod) -> ParamHTTPSession {
        return ParamHTTPSession()
    }
}


/**
 * A list of common https methods.
 *
 * *Last updated on 22 July 2022 at 22:56.*
 */

public enum HTTPMethod: String {
    case get        = "GET"
    case put        = "PUT"
    case delete     = "DELETE"
    case update     = "UPDATE"
    case push       = "PUSH"
    case patch      = "PATCH"
    case copy       = "COPY"
    case link       = "LINK"
    case unlink     = "UNLINK"
    case head       = "HEAD"
    case options    = "OPTIONS"
    case purge      = "PURGE"
    case lock       = "LOCK"
    case unlock     = "UNLOCK"
    case view       = "VIEW"
    case propfind   = "PROPFIND"
}

public struct JSONBodyHTTPSession {
    
}

public protocol NetworkPacket {
    
}

@available(macOS 10.15.0, *)
@available(iOS 13.0.0, *)
struct JSONHTTPSession {
    private var request: URLRequest
    private var httpMethod: HTTPMethod
    
    init(url: URL, method: HTTPMethod) {
        self.request = URLRequest(url: url)
        self.httpMethod = method
        self.request.httpMethod = self.httpMethod.rawValue
        self.request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
    }
    
    mutating func body<T: Codable>(_ data: T) async throws -> JSONHTTPSession {
        do {
            self.request.httpBody = try JSONEncoder().encode(data)
        } catch {
            print("Failed to encode data into request body.")
            throw HTTPError.JSONEncodeError
        }
        return self
    }
    
    func send<T: Codable>(_ expect: T?) async throws -> (status: Int, result: T?) {
        var ret: (status: Int, result: T?) = (0, nil)
        guard let expect = expect else {
            return (500, nil)
        }
        return ret
    }
}

struct GETRequestHTTPSession: NetworkPacket {
    
}

struct ParamHTTPSession {
    var urlComponents: URLComponents?
    var method: HTTPMethod?
}

enum HTTPError: Error {
    case NetworkError
    case URLError
    case JSONEncodeError
    case JSONDecodeError
}
