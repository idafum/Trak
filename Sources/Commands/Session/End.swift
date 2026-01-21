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
                CLI.printHeader("End Session")
                guard let log = try TrakApp.sessionManager.endSession(delete) else {
                    CLI.printInfo("No active session.")
                    throw ExitCode.failure
                }
                CLI.printSuccess("Ended '\(log.subjectName)'.")
                CLI.printKeyValue("Trak time", String(format: "%.0f", log.trakTime), unit: "seconds")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to end session.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}
