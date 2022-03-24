//
//  LabelEntryView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI

struct LabelEntryView: View {
    @State private var newLabel = String("")
    @EnvironmentObject var manager: DataManager
    
    func submit() {
        if (!newLabel.isEmpty && !manager.labels.contains(newLabel)){
            
            newLabel = newLabel.replacingOccurrences(of: " ", with: "-")
            while newLabel.last == "-" {
                newLabel.removeLast()
            }
            
            manager.labels.append(newLabel.lowercased())
            manager.labels.sort()
            
            newLabel = ""
        }
    }
    
    var body: some View {
        HStack {
            TextField("Add a label", text: $newLabel)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .submitLabel(.done)
                .onSubmit {
                    submit()
                }
            Button {
                submit()
            } label: {
                Label("Add Label", systemImage:"plus")
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.horizontal)
    }
}

struct LabelEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LabelEntryView().environmentObject(DataManager())
    }
}
