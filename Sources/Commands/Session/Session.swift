//
//  Session.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-10.
//

import Foundation
import ArgumentParser
extension Trak {
            
    struct Session : ParsableCommand {
         
        static let configuration = CommandConfiguration(
            abstract: "Manage session",
            subcommands: [Status.self, Start.self, Pause.self, Resume.self]
        )
        
        func run() throws {
            print(Session.helpMessage())
            throw ExitCode.success
        }
    }
}

