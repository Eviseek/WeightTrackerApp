//
//  GoalWeightView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 28.01.2024.
//

import SwiftUI

struct GoalWeightView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var weight = 60
    @State private var offset: CGFloat = 1000
    
    @Binding var isActive: Bool
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    
    var body: some View {
        ZStack {
            
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    isActive = false
                }
            
            VStack {
                Text("Your weight goal")
                    .font(.title3)
                    .bold()
                    .accessibilityIdentifier("GoalDialogTitle")
                
                HStack {
                    Picker("Goal", selection: $weight) {
                        ForEach(50...100, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                 
                    Text("in kilograms")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
                
                Button {
                    weightDataHandler.saveNewGoal(goal: weight.description)
                    isActive = false
                } label: {
                    Text("Done")
                }
                .accessibilityIdentifier("GoalDialogDoneButton")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(.thinMaterial)
                
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 30)
            .padding(50)
        }
        .ignoresSafeArea()
    }
    
}

struct GoalWeightView_Previews: PreviewProvider {
    static var previews: some View {
        GoalWeightView(isActive: .constant(false))
    }
}
