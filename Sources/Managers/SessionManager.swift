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
    
    /// Task the persistence layer to get the current session
    /// - Returns: Session or `nil` if there is no active session
    func getSession() throws -> SessionData? {
        try dataManager.getSessionState()
    }
    

    
    /// Task the persistence to save and log a session on subject
    /// - Parameter on: The subject to start a new session
    func startSession(on: String) throws {
        //Normalize the string
        let normalizedName = NameNormalizer.normalize(on)
        
        //check for error
        if normalizedName.isEmpty {
            throw SessionError.invalidSubjectName(on)
        }
        //Check if a Session already exist (activeSession is not nil)
        if let activeSession = try getSession() {
            throw SessionError.sessionAlreadyActive(activeSession)
        }
        
        let newSession = SessionData(
            subjectName: normalizedName,
            startTime: Date(),
            pausedAt: nil,
            totalPausedDuration: .zero,
            state: .active
        )
        try dataManager.createSession(newSession)
    }
        
    
    
}
