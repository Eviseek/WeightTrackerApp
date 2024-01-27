//
//  ChartView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @Binding var toggleCheckButton: Bool
    @Binding var weight: String
    
    @Observable
    
    var body: some View {
        //vstack with graph
        VStack() {
            HStack {
                Text("Last 3 Months")
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, 5)
                
                Spacer()
                
                if toggleCheckButton == true {
                    Button {
                        weightDataHandler.saveNewWeight(weight: weight)
                        toggleCheckButton.toggle()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 25, height: 25)
                            .scaledToFit()
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                }
            }
            Chart {
                ForEach(weightDataHandler.data) { dataPoint in
                    LineMark(x: .value("Date", dataPoint.date), y: .value("Weight", dataPoint.weight))
                        .foregroundStyle(.pink)
                        .lineStyle(.init(lineWidth: 2))
                        .interpolationMethod(.cardinal)
                        .symbol {
                            Circle()
                                .fill(.pink)
                                .frame(width: 8, height: 8)
                        }
                }
            }
            
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading, values: .stride(by: 0.7))
            }
            .chartYScale(domain: (67.1-0.7)...(69.8+0.7))
            .chartXAxis(.hidden)
            .frame(height: 350)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.purple)
            .padding(.horizontal, 10)
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(toggleCheckButton: .constant(false), weight: .constant(""))
    }
}
