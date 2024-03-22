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
    case unexpectedHTTPStatus(Int)
    case emptyHTTPBody
    case unknownResponse
    case unknownStateThatShouldNotHappen
}

@MainActor
class DataManager: ObservableObject {
    @Published var uncategorized: [EventObservation] = []
    @Published var labels: [String] = []
    @Published var networkErrors: [String] = []
    @Published var networkErrorsArePresent = false
    
    @AppStorage("apiAuthenticated") var authenticationNeeded = true
    @AppStorage("apiUser") var apiUser = ""
    @AppStorage("apiKey") var apiKey = ""
    
    let tempdir: URL = FileManager().temporaryDirectory
    static let shared = DataManager()
    init() {
        Task {
            await self.updateAll()
        }
        do {
            try FileManager().createDirectory(at: tempdir, withIntermediateDirectories: true)
        } catch {
            print("Failed to create tempdir: \(error)")
        }
    }
    
    static let baseURLString = "http://mira.local/watcher"
//    static let baseURLString = "http://mira.local:5000"

    static var labelsURL: URL {
        URL(string: baseURLString + "/labels")!
    }
    
    static var uncategorizedURL: URL {
        URL(string: baseURLString + "/uncategorized")!
    }

    static var classifyURL: URL {
        URL(string: baseURLString + "/classify")!
    }
    
    private var authString: String {
        "\(apiUser):\(apiKey)".data(using: String.Encoding.utf8)?.base64EncodedString() ??  ""
    }
    
    func uncateogorizedEventAt(index: Int) -> EventObservation? {
        guard index < uncategorized.count && index >= 0 else {
            return nil
        }
        return uncategorized[index]
    }
    
    func fetchArray<T:Decodable>(url: URL) async throws -> ([T]) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print("requesting array \(request.url?.absoluteString ?? "<empty>")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DataFetchError.unknownResponse
        }
        switch httpResponse.statusCode {
        case 200:
            self.authenticationNeeded = false
            // success!!
            guard !data.isEmpty else {
                throw DataFetchError.emptyHTTPBody
            }
            
            self.objectWillChange.send()
            return Self.decode(data)
        case 401:
            self.authenticationNeeded = true
            throw DataFetchError.authenticationFailed
        default:
            throw DataFetchError.unexpectedHTTPStatus(httpResponse.statusCode)
        }
    }
    
    func getVideo(from url: URL, completion: @Sendable @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func updateEvents() async {
        guard var components = URLComponents(url: Self.uncategorizedURL, resolvingAgainstBaseURL: false) else {
            fatalError("invalid application base URL")
        }
        do {
            if let oldestEvent = self.uncategorized.min(by:{$0.capture_time < $1.capture_time}) {
                let query = [URLQueryItem(name: "before", value: oldestEvent.capture_time.ISO8601Format())]
                components.queryItems = query
            }
            
            let newUncategorized : [EventObservation] = try await fetchArray(url:components.url!)
            for event in newUncategorized {
                getVideo(from: event.url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    let filename = response?.suggestedFilename ?? event.url!.lastPathComponent
                    print("Downloaded \(filename)")
                    
                    // always update the UI from the main thread
                    
                    // note that we're now only adding the event to the main uncategorized list *after* the video finishes download.
                    DispatchQueue.main.async() { [weak self] in
                        let fileurl = self!.tempdir.appendingPathComponent(filename)
                        FileManager().createFile(atPath: fileurl.path, contents: data)
                        var newevent = event
                        newevent.setCacheFile(fileurl)
                        self?.uncategorized.append(newevent)
                    }
                }
            }
        }
        catch {
            print("problem while fetching events \(error)")
        }
    }

    func updateLabels() async {
        do {
            self.labels = try await fetchArray(url: Self.labelsURL).sorted()
        }
        catch {
            print("problem while fetching labels \(error)")
        }
    }
    
    func updateAll() async {
        await self.updateLabels()
        await self.updateEvents()
    }
    
    func updateCategorizationAt(index: Int, event: EventObservation) {
        guard !event.labels.isEmpty && index >= 0 && index < uncategorized.count  else {
            return
        }
        guard uncategorized[index].id == event.id else {
            fatalError("guard failed: update event id mismatch")
        }
        
        uncategorized[index].labels.append(contentsOf: event.labels)
        Task {
            if event.labels.count > 0 {
                let classification = Classification(event)
                do {
                    let data = try JSONEncoder().encode(classification)
                    await post(url:DataManager.classifyURL,data:data)
                }
                catch {
                    print(error)
                }
            }
        }
    }

        
    func post(url: URL, data: Data) async {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        print("posting to \(request.url?.absoluteString ?? "<empty>")")
        
//        let task = URLSession.shared.uploadTask(with: request, from: data)
//        task.resume()
        
        do {
            let (_, response) = try await URLSession.shared.upload(for: request, from: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw DataFetchError.unknownResponse
            }
            switch httpResponse.statusCode {
            case 200, 201:
                self.authenticationNeeded = false
                // success!!
                return
            case 401:
                self.authenticationNeeded = true
                throw DataFetchError.authenticationFailed
            default:
                throw DataFetchError.unexpectedHTTPStatus(httpResponse.statusCode)
            }
        }
        catch {
            print (error)
            self.networkErrorsArePresent = true
            self.networkErrors.append(error.localizedDescription)
            self.objectWillChange.send()
        }
    }
        
    static func decode<T: Decodable>(_ inputdata: Data) -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(T.self, from: inputdata)
        } catch {
            fatalError("Couldn't parse data as \(T.self):\n\(error)")
        }
    }
}
