//
//  CameraTrainerApp.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI

@main
struct CameraTrainerApp: App {
    
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
