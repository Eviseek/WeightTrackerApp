//
//  LoadingView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 17.02.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
             .progressViewStyle(CircularProgressViewStyle(tint: .blue))
             //.scaleEffect(2.0, anchor: .center) // Makes the spinner larger
             .onAppear {
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                 // Simulates a delay in content loading
                 // Perform transition to the next view here
               }
             }
    }
}

#Preview {
    LoadingView()
}
