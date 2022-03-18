//
//  LabelEntryView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI

struct LabelEntryView: View {
    @State private var newLabel = String("")
    @ObservedObject var manager: DataManager
    
    init() {
        manager = DataManager.shared
    }
    
    var body: some View {
        HStack {
            TextField("Add a label", text: $newLabel)
                .disableAutocorrection(true)
            Button {
                if (!newLabel.isEmpty && !manager.labels.contains(newLabel)){
                    
                    manager.labels.append(newLabel.lowercased())
                    manager.labels.sort()
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
        LabelEntryView().environmentObject(DataManager())
    }
}
