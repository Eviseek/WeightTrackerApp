//
//  ContentView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import SwiftUI
import Charts

struct ContentView: View {
    
   // @State private var toggleCheckButton = false
    
    
    @StateObject private var weightDataHandler = WeightDataHandler()
    
    enum Field: Hashable {
        case myField
    }
    
    @FocusState private var focusedField: Field?
    
    private var maxMinHelper: Double = 0.5
    
    var body: some View {
        //Vstack
        VStack(spacing: -10) {
            WeightInputView(weightDataHandler: weightDataHandler)
            
            ChartView(weightDataHandler: weightDataHandler)
            
            WeightGoalView(weightDataHandler: weightDataHandler)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}


struct WeightInputView: View {
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    @State private var weight = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                TextField("", text: $weight, prompt: Text("0.0"))
                    .foregroundStyle(.black)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Text("in kilograms")
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .padding(.leading, 3)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 10)
            .padding(.vertical, 10)
            .padding(.trailing, 10)
            
            if weight.count > 0 {
                Button {
                    weightDataHandler.saveNewWeight(weight)
                    weight = ""
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                }
                .padding(.trailing, 15)
                .padding(.top, 5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color.white)
        .padding(.horizontal, 10)
    }
}

struct WeightGoalView: View {
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    @State private var showingSheet = false
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            VStack {
                Text("Goal")
                    .font(.headline)
                    .bold()
                HStack(spacing: 3) {
                    Text(weightDataHandler.weightGoal)
                        .font(.subheadline)
                        .bold()
                    Text("kg")
                        .font(.subheadline)
                }
                HStack(spacing: 3) {
                    Text(weightDataHandler.weightToGoal)
                        .font(.caption)
                        .bold()
                    Text("kgs to go")
                        .font(.caption)
                }
            }
            .sheet(isPresented: $showingSheet, content: {
                GoalWeightView(weightDataHandler: weightDataHandler)
            })
            .foregroundColor(.black)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .background(.white)
            .padding(.horizontal, 10)
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
