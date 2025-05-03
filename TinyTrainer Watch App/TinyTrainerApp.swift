//
//  TinyTrainerApp.swift
//  TinyTrainer Watch App
//
//  Created by Nena O'Driscoll on 01.05.2025.
//

import SwiftUI


@main
struct TinyTrainer_Watch_AppApp: App {
    @StateObject private var healthManager = HealthManager()
        
        var body: some Scene {
            WindowGroup {
                ContentView().environmentObject(healthManager)
            }
        }
}


