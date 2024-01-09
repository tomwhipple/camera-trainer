//
//  EventObservation.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import Foundation

struct EventObservation: Hashable, Codable, Identifiable {
    private var event_observation_id: Int
    var capture_time: Date
    var scene_name: String
    private var video_file: String
    private var video_url: String
    var labels: [String] = []
    
    var id: Int {event_observation_id}
    
    var url: URL? {
        URL(string:video_url)
    }
    
    mutating func insertLabel(_ labelText: String) {
        labels.append(labelText)
    }

    mutating func removeLabel(_ labelText: String) {
        if let lblIdx = labels.firstIndex(of: labelText) {
            labels.remove(at: lblIdx)
        }
    }
}

struct Classification: Codable {
    var labels: [String]
    var event_observation_id: Int
    
    init(_ eventObservation: EventObservation) {
        labels = eventObservation.labels
        event_observation_id = eventObservation.id
    }
}

extension EventObservation {
    static let sampleData: [EventObservation] = load("uncategorized.json")
}
