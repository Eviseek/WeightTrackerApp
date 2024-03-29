//
//  LastThreeMonthsChartView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 03.02.2024.
//

import SwiftUI
import Charts

struct LastThreeMonthsChartView: View {
    
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    @State var rawSelectedDate: String?
    
    @State private var showPopover = false
    
    var selectedDateValue: String? {
        if let rawSelectedDate {
            if let indexOfDate = weightDataHandler.last3MonthsWeightData.firstIndex(where: { $0.date == rawSelectedDate }) {
                return String(weightDataHandler.last3MonthsWeightData[indexOfDate].weight)
            }
        } else {
            return nil
        }
        return nil
    }
    
    var toDate: String? {
        return weightDataHandler.last3MonthsWeightData.last?.date
    }
    
    var fromDate: String? {
        return weightDataHandler.last3MonthsWeightData.first?.date
    }
    
    var body: some View {
        VStack {
            
            if let fromDate, let toDate {
                HStack(spacing: 4) {
                    Text("\(fromDate)")
                    Text("to")
                    Text("\(toDate)")
                    Button {
                        showPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundStyle(.blue)
                            .padding(.leading, 5)
                    }
                    .popover(isPresented: $showPopover, attachmentAnchor: .point(.center)) {
                        Text("Wondering why the date is not the whole month? That's because we count only the days that you actually entered your weight.")
                            .padding()
                            .frame(minWidth: 100)
                            .frame(height: 100)
                            .background(.white)
                            .presentationCompactAdaptation(.popover)
                    }
                }
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.bottom, 10)
                .padding(.top, 5)
            }
            
            if weightDataHandler.last3MonthsWeightData.count == 0 {
                Spacer()
                VStack {
                    Image(systemName: "chart.bar.xaxis.ascending")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("This chart has no data.")
                        .font(.subheadline)
                        .bold()
                        .padding(.top, 5)
                }
                .padding(.vertical, 15)
                .foregroundStyle(.blue)
                Spacer()
            } else {
                Spacer()
                Chart {
                    ForEach(weightDataHandler.last3MonthsWeightData, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Weight", dataPoint.weight)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(.init(lineWidth: 2))
                        .interpolationMethod(.catmullRom)
                        .symbol {
                            ZStack {
                                Circle()
                                    .fill(.blue)
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
                    AxisMarks(preset: .extended, position: .leading, values: .stride(by: weightDataHandler.last3MonthsChartData.stride))
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisGridLine().foregroundStyle(Color(.systemGray3))
                    }
                }
                .chartYScale(domain: weightDataHandler.last3MonthsChartData.range)
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 10)
                Spacer()
            }
        }
        .frame(minHeight: 450, alignment: .top)
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

struct LastThreeMonthsChartView_Previews: PreviewProvider {
    static var previews: some View {
        LastThreeMonthsChartView().environmentObject(WeightDataHandler())
    }
}

