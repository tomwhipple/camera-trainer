//
//  ContentView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI
import Combine

@MainActor
struct ContentView: View {
    @State private var isShowingCredentialSheet = false
    @ObservedObject var manager: DataManager
    
    init() {
        manager = DataManager.shared
    }
    
    var body: some View {
        VStack{
            if DataManager.shared.uncategorized.count > 0 {
                    PageView()
            }
            else {
                    Text("Loading")
                    Button("Retry") {
                        Task {
                            await DataManager.shared.updateAll()
                        }
                    }
            }
            
        }
        .frame(alignment: .top)
        .sheet(isPresented: $isShowingCredentialSheet) {
            CredentialEntryView()
        }
        .task {
            isShowingCredentialSheet = DataManager.shared.authenticationNeeded
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {

    init() {
        DataManager.shared.authenticationNeeded = false
    }
    
    static var previews: some View {
        ContentView()
    }
}
