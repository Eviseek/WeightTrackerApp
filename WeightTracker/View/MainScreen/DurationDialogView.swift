//
//  DurationDialogView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 03.02.2024.
//

import SwiftUI

struct DurationDialogView: View {
    
    private let title: String = "Choose the duration"
    private let buttonTitle: String = "Done"
    
    @Binding var isActive: Bool
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    
    @State private var fromSelectedDate = Date()
    @State private var toSelectedDate = Date()
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    isActive = false
                }
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Group {
                    DatePicker("Starting date", selection: $fromSelectedDate, displayedComponents: .date)
                    DatePicker("Ending date", selection: $toSelectedDate, displayedComponents: .date)
                }
                .padding(.horizontal, 10)

                
                Button {
                    print("button clicked")
                    weightDataHandler.saveCustomDuration(from: fromSelectedDate, to: toSelectedDate)
                    isActive = false
                } label: {
                    Text("Done")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.thickMaterial)
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 30)
            .padding(50)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    DurationDialogView(isActive: .constant(false))
}
