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
    
    
//    /// Handle logic to start a new session
//    /// - Parameter on: The subject to start a new session
//    func startSession(on: String) throws {
//        
//        // Check if the string is valid.
//        //TODO: Make subject data model
//        if on.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            throw SessionError.invalidSubjectName(on)
//        }
//        
//        // Check if subjects Exists via DataManager
//        let subject = dataManager.fileExists(at: (root: .subjects, file: on))
//        
//        if !subject.exists {
//            throw SessionError.subjectNotFound(on)
//        }
//        
//        // Check if activeSession already exist (activeSession is not nil)
//        if let activeSession = try checkSessionStatus() {
//            throw SessionError.sessionAlreadyActive(activeSession)
//        }
//        
//        // Create the activeSession model
//        let newSession = ActiveSession(
//            subject: on,
//            startTime: Date(),
//            pausedAt: nil,
//            totalPausedDuration: .zero,
//            state: .active
//        )
//        
//        // Persit the data
//        try   dataManager.saveActiveSession(session: newSession)
//        
//        
//    }
        
    
    
}
