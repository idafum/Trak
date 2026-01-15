//
//  Delete.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//

import Foundation
import ArgumentParser

extension Trak.Subject {
    struct Delete : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Delete a subject"
        )
        
        @Argument(help: "The name of the subject to delete")
        var name: String
        
        func run () throws {
            do {
                try TrakApp.subjectManager.deleteSubject(name)
                print ("'\(name)' deleted!")
            }
            catch let err as StorageError{
                print(err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}
