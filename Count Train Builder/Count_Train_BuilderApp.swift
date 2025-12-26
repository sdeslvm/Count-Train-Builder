//
//  Count_Train_BuilderApp.swift
//  Count Train Builder
//


import SwiftUI

@main
struct Count_Train_BuilderApp: App {
    
    
    
    
    
    
    @UIApplicationDelegateAdaptor(CountTrainAppDelegate.self) private var appDelegate
    
    
    
    
    
    var body: some Scene {
        WindowGroup {
            CountTrainGameInitialView()
        }
    }
}
