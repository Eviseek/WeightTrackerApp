//
//  WeightTrackerApp.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import SwiftUI

@main
struct WeightTrackerApp: App {
    
    @StateObject var healthManager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
        }
    }
}
