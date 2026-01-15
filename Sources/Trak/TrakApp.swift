//
//  TrakApp.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//


import Foundation

/// TrakApp serves as the application context. It holds Managers and meta data about trak
enum TrakApp {
    static let appName = "Trak"
    
    nonisolated(unsafe) static var dataManager: DataManager = {
        DataManager(appName: appName)
    }()
    
    nonisolated(unsafe) static var subjectManager: SubjectManager = {
        SubjectManager(dataManager: dataManager)
    }()
    
    nonisolated(unsafe) static var sessionManager: SessionManager = {
            SessionManager(dataManager: dataManager)
        }()

    
    
}
