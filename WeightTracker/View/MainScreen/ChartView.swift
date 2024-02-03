//
//  ChartView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    @State private var rawSelectedDate: String? = nil
    @State private var selectedTimeInterval = TimeInterval.month
    
    @State private var calendarSelectedDate: Date = Date()
    
    enum TimeInterval: String, CaseIterable, Identifiable {
        case month = "Month"
        case month3 = "3 Months"
        case custom = "Custom"
        
        var id: Self { return self }
    }
    
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
                    MonthChartView(weightDataHandler: weightDataHandler)
                case .month3:
                    LastThreeMonthsChartView(weightDataHandler: weightDataHandler)
                case .custom:
                    CustomDurationChartView(weightDataHandler: weightDataHandler)
                }
            }

            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 50)
    
    }
    

}

struct MonthChartView: View {
    
    @ObservedObject var weightDataHandler: WeightDataHandler
    @State var rawSelectedDate: String?
    
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
    
    var body: some View {
        
        Chart {
            ForEach(weightDataHandler.lastMonthWeightData, id: \.date) { dataPoint in
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
        ChartView(weightDataHandler: WeightDataHandler())
    }
}
