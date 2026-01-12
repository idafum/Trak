//
//  Start.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-11.
//
import Foundation
import ArgumentParser

extension Trak.Session {
    struct Start : ParsableCommand {
        
        static let configuration = CommandConfiguration (
            abstract: "Start a new session"
        )
        
        @Argument(help: "The subject of the session")
        var subject: String
        
        func run() throws {
            //tell session manager, User wishes to start a sesison on subject
            do {
                try TrakApp.sessionManager.startSession(on: subject)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
