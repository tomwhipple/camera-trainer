//
//  SwiftUIView.swift
//  CameraTrainer
//
//  Created by Tom Whipple on 3/27/22.
//

import SwiftUI

struct ErrorView: View {
    let errors: [String]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Section(header: Text("Errors occured:")){
                ForEach(errors, id: \.self) { text in
                    Text(text)
                }
            }
            Button {
                dismiss()
            } label: {
                Text("acknowledge").fontWeight(.bold).multilineTextAlignment(.center)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errors: ["Some network error", "some other network error"])
    }
}
