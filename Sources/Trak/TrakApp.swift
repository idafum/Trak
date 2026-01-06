//
//  TrakApp.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//

//This enum is being used as a namespace. It cannot be instantiated.
import Foundation

enum TrakApp {
    static let appName = "Trak"
    
    nonisolated(unsafe) static let dataManager = {
        do {
            return try DataManager(appName: appName)
        }
        catch{
            fatalError("Failed to initialize DataManager: \(error)")
        }
    }()
    
}
