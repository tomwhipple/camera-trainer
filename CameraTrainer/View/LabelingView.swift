//
//  LabelingView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/19/22.
//

import SwiftUI

struct LabelingView: View {
    @Binding var event: EventObservation
    @EnvironmentObject var manager: DataManager
    
//    var obsIdx: Int {
//        modelData.uncategorized.firstIndex(where:{ $0.id == event.id })!
//    }
        
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
            Button {
                Task {
                    if event.labels.count > 0 {
                        let classification = Classification(event)
                        do {
                            let data = try JSONEncoder().encode(classification)
                            await manager.post(url:DataManager.classifyURL,data:data)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            } label: {
                    Text("Commit")
                        .frame(maxWidth:.infinity)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .background(.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()

        }
    }
}

struct LabelingView_Previews: PreviewProvider {
    
    static var previews: some View {
        LabelingView(event: .constant(EventObservation.sampleData[0])).environmentObject(DataManager())
    }
}
