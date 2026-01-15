//
//  Subject.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-03.
//

import ArgumentParser
import Foundation

/// Trak extension implementing command for managing subjects
extension Trak {
    
    /// Manage subjects in trak
    ///
    /// This command can be used to  create, list, rename operation on a subject in trak
    struct Subject : ParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "subject",
            abstract: "Manage your subjects",
            shouldDisplay: true,
            subcommands: [Create.self, List.self, Delete.self, Rename.self]
        )
        
        /// Execute the subject command
        func run() throws {
            print(Subject.helpMessage())
        }
    }
}


extension Trak.Subject {
    struct Delete : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Delete a subject"
        )
        
        @Argument(help: "The name of the subject to delete")
        var name: String
        
        func run () throws {
            do {
                try TrakApp.dataManager.deleteSubject(subject: name)
                print ("'\(name)' deleted!")
            }
            catch let err as StorageError{
                print(err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}


