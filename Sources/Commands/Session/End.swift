//
//  End.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-17.
//

import Foundation
import ArgumentParser

extension Trak.Session {
    struct End : ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "End the current session."
        )
        
        @Flag
        var delete : Bool = false
        
        func run() throws {
            do {
                guard let log = try TrakApp.sessionManager.endSession(delete) else {
                    throw ExitCode.failure
                }
                print ("""
                    \(log.subjectName) session ended
                    
                    Trak time: \(log.trakTimeDisplay)
                    """)
                
                
            } catch let err as SessionError {
                print(err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}
