//
//  CredentialEntryView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/20/22.
//

import SwiftUI

struct CredentialEntryView: View {
    @State private var userName = ""
    @State private var userKey = ""
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Text("API credentials")
                .font(.headline)
                .padding()
            Spacer()
            List {
                TextField("User name", text:$userName)
                TextField("Key", text:$userKey)
            }
            CommitButton() {
                manager.apiUser = userName
                manager.apiKey = userKey
                                
                dismiss()
            }
            Spacer()
        }
        .onAppear {
            userName = manager.apiUser
            userKey = manager.apiKey
        }
    }
}

struct CredentialEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialEntryView().environmentObject(DataManager())
    }
}
