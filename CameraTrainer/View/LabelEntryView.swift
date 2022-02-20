//
//  LabelEntryView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI

struct LabelEntryView: View {
    @State private var newLabel = String("")
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            TextField("Add a label", text: $newLabel)
                .disableAutocorrection(true)
            Button {
                if (!newLabel.isEmpty && !modelData.labels.contains(newLabel)){
                    modelData.labels.append(newLabel.lowercased())
                    modelData.labels.sort()
                    newLabel = ""
                }
            } label: {
                Label("Add Label", systemImage:"plus")
                    .labelStyle(.iconOnly)
            }
        }
        .padding()
    }
}

struct LabelEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LabelEntryView()
    }
}
