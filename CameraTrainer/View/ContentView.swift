//
//  ContentView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/18/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: DataManager
    @State private var isShowingCredentialSheet = false
    
    var body: some View {
        NavigationView{
            if manager.uncategorized.count > 0 {
                LabelingView(event: $manager.uncategorized[0])
            }
            else {
                Text("Loading")
            }
        }
        .onAppear {
            isShowingCredentialSheet = manager.authenticationNeeded
        }
        .sheet(isPresented: $isShowingCredentialSheet) {
            CredentialEntryView()
        }
        .task {
            do {
                let response = try await manager.fetch(url: DataManager.uncategorizedURL)
                switch response {
                case .failure(let error):
                    manager.authenticationNeeded = true
                    print(error)
                case .success(let data):
                    manager.authenticationNeeded = false
                    manager.uncategorized = DataManager.decode(data)
                }
            }
            catch {
                print(error)
            }
            isShowingCredentialSheet = manager.authenticationNeeded
        }
        .task {
            do {
                let response = try await manager.fetch(url: DataManager.labelsURL)
                switch response {
                case .failure(let error):
                    manager.authenticationNeeded = true
                    print(error)
                case .success(let data):
                    manager.authenticationNeeded = false
                    manager.labels = DataManager.decode(data)
                }
            }
            catch {
                print(error)
            }
            isShowingCredentialSheet = manager.authenticationNeeded
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView().environmentObject(DataManager())
    }
}
