//
//  ChartView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    
   // @ObservedObject var weightDataHandler: WeightDataHandler
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    @Binding var isDurationDialogActive: Bool
    
    @State private var rawSelectedDate: String? = nil
    @State private var selectedTimeInterval = TimeInterval.month
    
    @State private var calendarSelectedDate: Date = Date()
    
    enum TimeInterval: String, CaseIterable, Identifiable {
        case month = "Last month"
        case month3 = "Last 3 months"
        case custom = "Custom"
        
        var id: Self { return self }
    }
    
    var body: some View {
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
                    MonthChartView()
                case .month3:
                    LastThreeMonthsChartView()
                case .custom:
                    CustomDurationChartView(isDurationDialogActive: $isDurationDialogActive)
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .padding(.horizontal, 10)
    
    }
    

}

struct MonthChartView: View {
    
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    @State var rawSelectedDate: String?
    
    @State private var showPopover = false
    
  //  @ObservedObject var chartViewModel: ChartViewModel //TODO: how to call this with params
    
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
    
    var toDate: String? {
        return weightDataHandler.lastMonthWeightData.last?.date
    }
    
    var fromDate: String? {
        return weightDataHandler.lastMonthWeightData.first?.date
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
                        Text("Wondering why the date is not the whole month? That's because we count only the days, in the last month, that you actually entered your weight.")
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
            }
            
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
                AxisMarks(preset: .extended, position: .leading, values: .stride(by: 1))
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
        ChartView(isDurationDialogActive: .constant(false)).environmentObject(WeightDataHandler())
    }
}
