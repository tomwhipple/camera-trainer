//
//  CommitButton.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 2/20/22.
//

import SwiftUI

struct CommitButton: View {
    var action: ()->Void
    
    var body: some View {
        Button {
            action()
            } label: {
                Text("Commit")
                    .frame(maxWidth:.infinity)
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
    }
}

struct CommitButton_Previews: PreviewProvider {
    static var previews: some View {
        CommitButton(action: {})
    }
}
