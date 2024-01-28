//
//  GoalWeightView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 28.01.2024.
//

import SwiftUI

struct GoalWeightView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var goal = ""
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    
    var body: some View {
        VStack {
            
            
            Text("Set up your goal")
                .font(.title)
                .padding(.top, 50)
            
            HStack {
                
                TextField("", text: $goal, prompt: Text("60.0"))
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1.5))
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .keyboardType(.decimalPad)
                
                Spacer()
                
                Button {
                    weightDataHandler.saveNewGoal(goal: goal)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
                
            }
            .padding(.horizontal, 10)

            
            Spacer()
            
        }
    }
}

struct GoalWeightView_Previews: PreviewProvider {
    static var previews: some View {
        GoalWeightView(weightDataHandler: WeightDataHandler())
    }
}
