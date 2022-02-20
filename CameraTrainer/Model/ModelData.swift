//
//  ModelData.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    private let baseURLString = "https://home.tomwhipple.com/watcher"

    
    @Published var applicationURL = URL(string:"https://home.tomwhipple.com/watcher")
    
    @Published var uncategorized: [EventObservation] = load("empty_event_observations_array.json")
//    @Published var labels: [String] = load("labels.json")
    
    @Published var labels: [String] = []
    
    @Published var userName = ""
    @Published var userKey = ""
    
    @Published var isAuthenticated = false
    
    func fetchLabels() {
        let labelsURLString = baseURLString + "/labels"
        
        fetch(URL(string:labelsURLString)!) {rawLabels in
            self.labels = decode(rawLabels)
        }
    }
    
    func fetchUncategorized() {
        let uncategorizedURLString = baseURLString + "/uncategorized"
    }
    
    func fetch(_ url: URL, action: @escaping(Data) -> Void) {
        let authdata = "\(userName):\(userKey)".data(using: String.Encoding.utf8)!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(authdata.base64EncodedString())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { inputdata, response, taskerror in
            
            if let httpResponse = response as? HTTPURLResponse{
                guard (httpResponse.statusCode != 401) else {
                    print("not authenticated")
                    self.isAuthenticated = false
                    return
                }
            }
            

            
            if let data = inputdata {
//                do {
//                    let observations = try eventObservationDecoder.decode([EventObservation].self, from: data)
//        //            print(observations)
//                } catch {
//                    print(error.localizedDescription ?? "no error")
//        //            print(String(data:inputdata ?? Data(), encoding:String.Encoding.utf8) ?? "")
//                    print(response.debugDescription ?? "no response")
//                    print(taskerror ?? "no task error")
//                }
            
                action(data)
            } else if let taskerror = taskerror {
                print("task error: \(taskerror.localizedDescription)")
            }
            

        }
        task.resume()
    }
    
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    return decode(data)
}

func decode<T: Decodable>(_ inputdata: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: inputdata)
    } catch {
        fatalError("Couldn't parse data as \(T.self):\n\(error)")
    }
}
