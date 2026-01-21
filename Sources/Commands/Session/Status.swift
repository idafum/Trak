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
                CLI.printHeader("Session Status")
                let sessionData: SessionData? = try TrakApp.sessionManager.getSession()
                guard let session = sessionData else {
                    CLI.printInfo("No active session. Start a session: trak session start <subject>")
                    throw ExitCode.success
                }
                CLI.printKeyValue("Subject", session.subjectName)
                CLI.printKeyValue("Elapsed", session.elapsedDisplay)
                CLI.printKeyValue("State", String(describing: session.state))
                CLI.printSuccess("Status displayed.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to get session status.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}
