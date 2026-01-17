//
//  Resume.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-17.
//

import Foundation
import ArgumentParser

extension Trak.Session {
    struct Resume : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Resume a paused session."
        )
        
        func run() throws {
            do {
                let session = try TrakApp.sessionManager.resumeSession()
            } catch let err as SessionError{
                print (err.localizedDescription)
            } catch let err as StorageError {
                print (err.localizedDescription)
            }
        }
    }
}
