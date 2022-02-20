//
//  ContentView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        LabelingView(event:modelData.uncategorized[0])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
