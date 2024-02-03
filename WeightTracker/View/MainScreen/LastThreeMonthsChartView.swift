//
//  LastThreeMonthsChartView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 03.02.2024.
//

import SwiftUI
import Charts

struct LastThreeMonthsChartView: View {
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    @State var rawSelectedDate: String?
    
    var selectedDateValue: String? {
        if let rawSelectedDate {
            if let indexOfDate = weightDataHandler.last3MonthWeightData.firstIndex(where: { $0.date == rawSelectedDate }) {
                return String(weightDataHandler.weightData[indexOfDate].weight)
            }
        } else {
            return nil
        }
        return nil
    }
    
    var body: some View {
        
        Chart {
            ForEach(weightDataHandler.last3MonthWeightData, id: \.date) { dataPoint in
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
            AxisMarks(preset: .extended, position: .leading)
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(Color(.systemGray3))
            }
        }
        .chartYScale(domain: weightDataHandler.chartDomainRange)
       // .chartYScale(domain: 69...71)
        .aspectRatio(contentMode: .fit)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        
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
        LastThreeMonthsChartView(weightDataHandler: WeightDataHandler())
    }
}

