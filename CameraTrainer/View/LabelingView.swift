//
//  LabelingView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/19/22.
//

import SwiftUI

struct LabelingView: View {
    let index: Int
    @State var event: EventObservation
    
    var body: some View {
        VStack {
            VideoView(videoURL: event.url)
            HStack(alignment: .top) {
                Text("\(event.id)")
                Spacer()
                Text(event.capture_time)
                Spacer()
                Text(event.scene_name)
            }
            .font(.footnote)
            .multilineTextAlignment(.leading)
            .foregroundColor(.gray)
            .padding(.horizontal)
            LabelEntryView()
            LabelSelectionView(event:$event)

        }
        .onDisappear {
            DataManager.shared.updateCategorizationAt(index: index, event: event)
        }
    }
    
}

struct LabelingView_Previews: PreviewProvider {
    
    static var previews: some View {
        LabelingView(index: 0, event: EventObservation.sampleData[0]).environmentObject(DataManager.shared)
    }
}
