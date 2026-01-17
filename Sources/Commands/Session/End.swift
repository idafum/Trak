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
                try TrakApp.sessionManager.EndSession(delete)
            } catch let err as SessionError {
                print(err.localizedDescription)
                ExitCode.failure
            }
        }
    }
}
