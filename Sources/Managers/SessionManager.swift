//
//  SessionManager.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-10.
//

import Foundation

//SessionManager has mutable state.
final class SessionManager {
    let dataManager: DataManager
    
    init (dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func getState() throws -> ActiveSession? {
        //contact the dataManager to get session State.
        do {
            return try dataManager.getSessionState()
        } catch {
            throw error
        }
        
    }
        
    
    
}
