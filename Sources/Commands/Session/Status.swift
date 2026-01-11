//
//  Status.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-10.
//

import Foundation
import ArgumentParser
extension Trak.Session {
    
    struct Status : ParsableCommand {
        
        static let configuratiion = CommandConfiguration(
            abstract: "Show the current status of the session."
        )
        
        func run() throws {
            //Connects with the session Manager
            do {
                let activeSession = try TrakApp.sessionManager.getState()
                if activeSession == nil {
                    print("""
                        
                        No active session.
                        Start a session: trak session start <subject>
                        
                        """)
                }
            } catch {
                
            }
        }
    }
}
