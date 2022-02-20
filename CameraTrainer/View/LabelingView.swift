//
//  LabelingView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/19/22.
//

import SwiftUI

struct LabelingView: View {
    @EnvironmentObject var modelData: ModelData
    var event: EventObservation
    
    var obsIdx: Int {
        modelData.uncategorized.firstIndex(where:{ $0.id == event.id })!
    }
        
    var body: some View {
        VStack {
            VideoView(videoURL: event.url)
            LabelEntryView()
            List {
                ForEach(modelData.labels, id: \.self) { labelText in
                    let isSet = event.labels?.contains(labelText) ?? false
                    Button {
                        if isSet {
                            modelData.uncategorized[obsIdx].removeLabel(labelText)
                        }
                        else {
                            modelData.uncategorized[obsIdx].insertLabel(labelText)
                        }
                        
                    } label: {
                        Label(labelText, systemImage:isSet ?"checkmark.circle.fill":"circle")
                            .foregroundColor(isSet ? .green : .gray)
                    }
                }

            }

            Button {
                    
                } label: {
                    Text("Commit")
                        .frame(maxWidth:.infinity)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .background(.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()

            Spacer()
        }
    }
}

struct LabelingView_Previews: PreviewProvider {
    static var modelData = ModelData()
    
    static var previews: some View {
        LabelingView(event: modelData.uncategorized[0]).environmentObject(modelData)
    }
}
