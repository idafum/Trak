//
//  Pause.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-16.
//

import ArgumentParser
import Foundation
extension Trak.Session {
    struct Pause : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Pause a running session"
        )
        
        func run() throws {
            do {
                guard let session = try TrakApp.sessionManager.pauseSession() else {
                    print ("No session running")
                    throw ExitCode.failure
                }
                print("""
                    
                    Session: \(session.subjectName)
                    State: \(session.state)
                    
                    """)
            }catch let err as StorageError{ //Cant pause a session that does not exist
                print (err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}
