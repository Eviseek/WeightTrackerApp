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
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    
    @Binding var rawSelectedDate: String?
    
    var body: some View {
        //vstack with graph
        VStack() {
            HStack {
                Text("Last 3 Months")
                    .font(.subheadline)
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 5)
                
                Spacer()
                
                //                if toggleCheckButton == true {
                //                    Button {
                //                        weightDataHandler.saveNewWeight(weight: weight)
                //                        print("toggle")
                //                        toggleCheckButton.toggle()
                //                    } label: {
                //                        Image(systemName: "checkmark.circle.fill")
                //                            .resizable()
                //                            .foregroundColor(.green)
                //                            .frame(width: 25, height: 25)
                //                            .scaledToFit()
                //                    }
                //                    .padding(.trailing, 10)
                //                    .padding(.top, 5)
                //                }
            }
            Chart {
                ForEach(weightDataHandler.weightData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Weight", dataPoint.weight)
                    )
                    .foregroundStyle(.pink)
                    .lineStyle(.init(lineWidth: 2))
                    .interpolationMethod(.catmullRom)
                    .symbol {
                        ZStack {
                            Circle()
                                .fill(.pink)
                                .frame(width: 8, height: 8)
                            Circle()
                                .fill(.white)
                                .frame(width: 4, height: 4)
                        }
                    }
                }
                RuleMark(x: .value("Date", "1.1.2023"))
                            .foregroundStyle(.gray)
                            .offset(yStart: -10)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                            .annotation(position: .trailing, alignment: .leading) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 35)
                                        .foregroundColor(Color(.systemGray5).opacity(0.5))
                                    VStack {
                                        Text("1.1.2023")
                                            .font(.caption)
                                        Text("68 kg")
                                            .bold()
                                            .font(.caption)
                                    }
                                }
                            }
            }
            .chartScrollableAxes(.horizontal)
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading)
            }
            .chartYScale(domain: weightDataHandler.chartDomainRange)
           // .chartXAxis(.hidden)
            .frame(height: 350)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .padding(.horizontal, 10)
    
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(toggleCheckButton: .constant(false), weight: .constant(""), weightDataHandler: WeightDataHandler(), rawSelectedDate: .constant(""))
    }
}
