//
//  EventObservation.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import Foundation

struct EventObservation: Hashable, Codable, Identifiable {
    private var event_observation_id: Int
    var capture_time: String
    var scene_name: String
    private var video_file: String
    private var video_url: String
    
    var id: Int {event_observation_id}
    
    var url: URL? {
        URL(string:video_url)
    }
    
    var labels: [String]? = [String]()
    
    mutating func insertLabel(_ labelText: String) {
        labels?.append(labelText)
    }

    mutating func removeLabel(_ labelText: String) {
        if let lblIdx = labels?.firstIndex(of: labelText) {
            labels?.remove(at: lblIdx)
        }
    }
}
