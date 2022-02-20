//
//  CredentialEntryView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/20/22.
//

import SwiftUI

struct CredentialEntryView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Spacer()
            List {
                TextField("User name", text:$modelData.userName)
                TextField("Key", text:$modelData.userKey)
            }
            CommitButton() {
                modelData.fetchLabels()
                dismiss()
            }
            Spacer()
        }
    }
}

struct CredentialEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialEntryView()
    }
}
