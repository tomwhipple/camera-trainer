//
//  VideoView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var videoURL: URL? = nil
    
    private var player: AVPlayer? = nil
    
    init(videoURL: URL?) {
        // is there a better way to do this??
        if videoURL == nil {
            return
        }
        self.videoURL = videoURL
        self.player = AVPlayer(url: self.videoURL!)
    }
    
     var body: some View {
         if player != nil {
             VideoPlayer(player: player)
                     .aspectRatio(1.7, contentMode:ContentMode.fit)
                     .onAppear { player?.play() }
         }
         else {
             Text("Video not available")
         }
     }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(videoURL: Bundle.main.url(forResource: "1641406851_6-140069_wellerDriveway_278-196-313-253_135_246", withExtension: "mp4")!)
    }
}
