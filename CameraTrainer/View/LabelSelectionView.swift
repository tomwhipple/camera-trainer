//
//  LabelSelectionView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/22/22.
//

import SwiftUI

struct LabelSelectionView: View {
    @Binding var event: EventObservation
    @EnvironmentObject var manager: DataManager
    
    var body: some View {
        List {
            ForEach(manager.labels, id: \.self) { labelText in
                let isSet = event.labels.contains(labelText) 
                Button {
                    if isSet {
                        event.removeLabel(labelText)
                    }
                    else {
                        event.insertLabel(labelText)
                    }
                } label: {
                    Label(labelText, systemImage:isSet ?"checkmark.circle.fill":"circle")
                        .foregroundColor(isSet ? .green : .gray)
                }
            }

        }
    }
}

struct LabelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LabelSelectionView(event:.constant(EventObservation.sampleData[0])).environmentObject(DataManager())
    }
}
