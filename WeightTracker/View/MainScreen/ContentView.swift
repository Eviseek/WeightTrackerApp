//
//  ContentView.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//


//TODO: export data to health app

import SwiftUI
import Charts

struct ContentView: View {
    
//    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
//    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @EnvironmentObject var healthManager: HealthManager
    
    @StateObject private var weightDataHandler = WeightDataHandler()
    
    @State private var isGoalDialogActive = false
    @State private var isDurationDialogActive = false
    
    var body: some View {
        //Vstack
        ZStack {
            VStack(spacing: 10) {
                Spacer()
                WeightInputView()
                
                ChartView(isDurationDialogActive: $isDurationDialogActive)
                
                WeightGoalView(isGoalDialogActive: $isGoalDialogActive)
                
                HealthAppSyncView()
                
                Spacer()
            }
            .background(Color(.systemGray6))
            
            if isGoalDialogActive {
                GoalWeightView(isActive: $isGoalDialogActive)
            }
            
            if isDurationDialogActive {
                DurationDialogView(isActive: $isDurationDialogActive)
            }
        }
        .environmentObject(weightDataHandler)
    }
}


struct WeightInputView: View {
    
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    @EnvironmentObject var healthManager: HealthManager
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
                    weightDataHandler.saveNewWeight(weight, withHealth: healthManager)
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
    
    @EnvironmentObject var weightDataHandler: WeightDataHandler
    @Binding var isGoalDialogActive: Bool
    
    var body: some View {
        Button {
            isGoalDialogActive.toggle()
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
            .foregroundColor(.black)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .background(.white)
            .padding(.horizontal, 10)
        }
        .accessibilityIdentifier("goalView")
    }
    
}

struct HealthAppSyncView: View {
    
    //@State private var shouldSyncWithHealth = false
    @State private var inProgress = false
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        HStack {
            Image(systemName: "heart.text.square")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 100)
            Text("Synchronize with Health")
                .font(.system(size: 14))
                .bold()
                .frame(width: 200, alignment: .leading)
            Spacer()

            if healthManager.shouldSync && !healthManager.isAuthorized {
                    Button {
                        inProgress = true
                        Task {
                            await healthManager.askForAuthorization()
                        }
                    } label: {
                        if !inProgress {
                            Text("Set up")
                        } else {
                            LoadingView()
                                .padding(.trailing, 15)
                        }
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(.blue)
            } else {
                Toggle("", isOn: $healthManager.shouldSync)
                    .tint(.blue)
            }
            

        }
        .padding(.top, -15)
        .padding(.bottom, -15)
        .padding(.horizontal, 15)
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .background(.white)
        .padding(.horizontal, 10)
    }
    
    
//    func askHealthManagerForAuth() -> some View {
//        healthManager.askForAuthorization()
//        return Text("")
//    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HealthManager())
            .previewDevice("iPhone 15 Pro")
    }
    
}
