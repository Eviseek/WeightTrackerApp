//
//  ContentView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @State private var weight = ""
    @State private var toggleCheckButton = false
    
    enum Field: Hashable {
        case myField
    }
    
    @FocusState private var focusedField: Field?
    
    private var maxMinHelper: Double = 0.5
    
    var body: some View {
        //Vstack
        VStack {
            //hstack with edit box
            HStack {
                VStack(alignment: .trailing, spacing: 2) {
                    TextField("", text: $weight, prompt: Text("0.0"))
                        .focused($focusedField, equals: .myField)
                        .font(.title)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)

//                        .onTapGesture {
//                            focusedField = nil
//                            toggleCheckButton.toggle()
//                        }
                    Text("kg")
                        .font(.caption)
                }
                .frame(width: 150)
                // .background(.blue)
                .padding(.vertical, 10)
                .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(Color.red)
            .padding(.horizontal, 10)
            
            ChartView(toggleCheckButton: $toggleCheckButton, weight: $weight)
            
            VStack {
                Text("Goal")
                    .font(.headline)
                    .bold()
                HStack(spacing: 3) {
                    Text("68")
                        .font(.subheadline)
                        .bold()
                    Text("kg")
                        .font(.subheadline)
                }
                HStack(spacing: 3) {
                    Text("0.1")
                        .font(.caption)
                        .bold()
                    Text("kgs to go")
                        .font(.caption)
                }
            }
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .background(.red)
            .padding(.horizontal, 10)
            
          //  Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}