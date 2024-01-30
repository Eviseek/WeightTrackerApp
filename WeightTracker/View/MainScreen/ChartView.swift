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
    
    @State var rawSelectedDate: String? = nil
    
    enum TimeInterval: String, CaseIterable, Identifiable {
        case month = "Month"
        case month3 = "3 Months"
        case year = "Year"
        
        var id: Self { return self }
        
    }
    
    @State private var selectedTimeInterval = TimeInterval.month
    
    var selectedDateValue: String? {
        if let rawSelectedDate {
            if let indexOfDate = weightDataHandler.weightData.firstIndex(where: { $0.date == rawSelectedDate }) {
                return String(weightDataHandler.weightData[indexOfDate].weight)
            }
        } else {
            return nil
        }
        return nil
    }

//    var selectedDate: String? {
//      guard let rawSelectedDate else { return nil }
//        return weightDataHandler.weightData.first?.weight.first(where: {
//            let endOfDay = endOfDay(for: $0)
//            return ($0.day ... endOfDay).contains(rawSelectedDate)
//      })?.day
//    }
    
    var body: some View {
        //vstack with graph
        VStack() {
            
            Picker(selection: $selectedTimeInterval) {
                ForEach(TimeInterval.allCases) { interval in
                    Text(interval.rawValue)
                }
            } label: {
                Text("Time Interval for chart")
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 10)

            
            Group {
                switch selectedTimeInterval {
                case .month:
                    Text("")
                case .month3:
                    Text("")
                case .year:
                    Text("")
                }
            }
            
            HStack { //TODO: delete hstack
                
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
                ForEach(weightDataHandler.weightData, id: \.date) { dataPoint in
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
                if let rawSelectedDate {
                    RuleMark(x: .value("Date", rawSelectedDate))
                        .foregroundStyle(.black)
                        .offset(yStart: -10)
                        .zIndex(5)
                        .lineStyle(StrokeStyle(lineWidth: 0.5, dash: [5]))
                        .annotation(position: .trailing, alignment: .leading, spacing: 10, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                            selectionPopover
                        }
                }
            }
            .chartXSelection(value: $rawSelectedDate)
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading)
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisGridLine().foregroundStyle(Color(.systemGray3))
                }
            }
            .chartYScale(domain: weightDataHandler.chartDomainRange)
            .aspectRatio(contentMode: .fit)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 50)
    
    }
    
    @ViewBuilder
    var selectionPopover: some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 35)
                .foregroundColor(Color(.systemGray5).opacity(0.8))
            VStack {
                if let rawSelectedDate {
                    Text(rawSelectedDate.description)
                        .font(.caption)
                }
                if let selectedDateValue {
                    Text("\(selectedDateValue) kg")
                        .bold()
                        .font(.caption)
                }
            }
        }
    }
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(toggleCheckButton: .constant(false), weight: .constant(""), weightDataHandler: WeightDataHandler(), rawSelectedDate: "")
    }
}
