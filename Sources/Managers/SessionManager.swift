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
    
    /// Task the persistence layer to pause the current session
    /// - Returns: The current session or `nil` if there are no active session
    func pauseSession() throws -> SessionData?{
        //Ask data if session Exists
        guard var activeSession = try dataManager.getSessionState() else {
            throw SessionError.noActiveSession
        }
        
        //There is an active session
        //Check if session state is paused.
        if activeSession.state == .paused {
            throw SessionError.sessionIsAlreadyPaused
        } else {
            //set the session state
            activeSession.pausedAt = Date() //Current time
            activeSession.state = .paused
            
            return try dataManager.setActiveSession(activeSession)
        }
    }
    
    func resumeSession() throws -> SessionData? {
        //Ask data if a paused Session Exists
        guard var activeSession = try dataManager.getSessionState() else {
            throw SessionError.noActiveSession
        }
        
        if activeSession.state == .active { throw SessionError.sessionIsAlreadyActive }
        
        else {
            //Calculate the paused duration
            let pausedDuration = Date().timeIntervalSince(activeSession.pausedAt!)
            
            //Update the totalPausedTime
            activeSession.totalPausedDuration += pausedDuration
            
            //Reset the session Paused at
            activeSession.pausedAt = nil
            
            activeSession.state = .active
            
            //Pass this modified active session to data.
            return try dataManager.setActiveSession(activeSession)
        }
        
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
