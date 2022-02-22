//
//  DataManager.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/22/22.
//

import Foundation
import SwiftUI

enum DataFetchError: Error {
    case authenticationFailed
    case unknownHTTPStatus(Int)
    case emptyHTTPBody
    case unknownStateThatShouldNotHappen
}


class DataManager: ObservableObject {
    @Published var uncategorized: [EventObservation] = []
    @Published var labels: [String] = []
    
    @AppStorage("apiAuthenticated") var authenticationNeeded = true
    @AppStorage("apiUser") var apiUser = ""
    @AppStorage("apiKey") var apiKey = ""
    
    static let baseURLString = "https://home.tomwhipple.com/watcher"
    
    static var labelsURL: URL {
        URL(string: baseURLString + "/labels")!
    }
    
    static var uncategorizedURL: URL {
        URL(string: baseURLString + "/uncategorized")!
    }
    
    func fetch(url: URL) async throws -> Result<Data, Error> {
        try await withCheckedThrowingContinuation { continuation in
            let authdata = "\(apiUser):\(apiKey)".data(using: String.Encoding.utf8)!
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Basic \(authdata.base64EncodedString())", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            print("requesting \(request.url?.absoluteString ?? "<empty>")")
            
            let task = URLSession.shared.dataTask(with: request) { inputdata, response, taskerror in
                if let httpResponse = response as? HTTPURLResponse{
                    switch httpResponse.statusCode {
                    case 200, 201:
                        print("successful response")
                        if let inputdata = inputdata {
                            continuation.resume(returning:.success(inputdata))
                        }
                        else {
                            continuation.resume(throwing: DataFetchError.emptyHTTPBody)
                        }
                    case 401:
                        print("not authenticated")
                        continuation.resume(returning:.failure(DataFetchError.authenticationFailed))
                    default:
                        let errstr = "unknown response status: \(httpResponse.statusCode)"
                        print(errstr)
                        continuation.resume(throwing: DataFetchError.unknownHTTPStatus(httpResponse.statusCode))
                    }
                }
                else {
                    continuation.resume(throwing: taskerror ?? DataFetchError.unknownStateThatShouldNotHappen)
                }
            }
            task.resume()
        }
}
    
    static func decode<T: Decodable>(_ inputdata: Data) -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: inputdata)
        } catch {
            fatalError("Couldn't parse data as \(T.self):\n\(error)")
        }
    }
}
