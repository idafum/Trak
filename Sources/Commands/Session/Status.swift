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
            abstract: "Show the current active session."
        )
        
        func run() throws {
            do {
                let sessionData : SessionData? = try TrakApp.sessionManager.getSession()

                guard let session = sessionData else {
                    print("""
                        No active session.
                        Start a session: trak session start <subject>
                        """)
                    throw ExitCode.success
                }
                print (session)
            } catch {
                
            }
        }
    }
}
