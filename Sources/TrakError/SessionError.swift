//
//  sessionError.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-11.
//
import Foundation

/// Errors related to session workflow and session state transition in Trak.
enum SessionError: Error {
    /// The user provided an invalid subject string (empty, whitespace, etc)
    case invalidSubjectName(String)
    
    /// The subject does not exist in storage.
    case subjectNotFound(String)
    
    /// The user attempts to start a session when an Active session exists
    case sessionAlreadyActive(SessionData)
    
    case noActiveSession
    
    case sessionIsAlreadyPaused
    
    
}

extension SessionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidSubjectName(let name):
            return "Invalid subject name: '\(name)'."
        case .subjectNotFound(let name):
            return "Subject not found: '\(name)'."
        case .sessionAlreadyActive(let session):
            return """
                
                '\(session.subjectName)' session in progress...
                See session: trak session status 
                
                """
        case .noActiveSession:
            return "No active session."
            
        case .sessionIsAlreadyPaused:
            return """
                The current session is already paused
                See session: trak session status
                """
        
        }
    }
}

extension SessionError {
    /// exit codes for CLI usage.
    
    var exitCode: Int {
        switch self {
        case .invalidSubjectName:
            return 2
        case .subjectNotFound:
            return 2
        case .sessionAlreadyActive:
            return 3
        case .noActiveSession:
            return 3
        case .sessionIsAlreadyPaused:
            return 3
            
        }
    
    }
}
