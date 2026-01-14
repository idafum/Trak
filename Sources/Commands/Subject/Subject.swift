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
    
    /// Create a new subject
    struct Create : ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new subject"
        )
        
        @Argument(help: "The name of the subject")
        var name: String
        
        /// Execute the create command
        func run() throws {
            do {
                try TrakApp.subjectManager.createSubject(name: name)
                print("New subject \(name) created.")
            } catch let err as StorageError{
                print (err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}

extension Trak.Subject {
    struct List : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "List all subjects"
        )
        
        func run() throws {
            do {
                let subjects: [SubjectData] = try TrakApp.subjectManager.listSubjects()
                
                if subjects.isEmpty {
                    print ("""
                        No subjects found
                        Use: `trak subject create <name>` to create a new subject.
                        """)
                } else {
                    print (subjects.map(\.name).joined(separator: "\n"))
                }
                
                //TODO: Display strings in a list form for user (Acceptance Criteria)
                //TODO: Add a signal text to start a subject session (Acceptance Criteria)
            }
            catch let err as StorageError{
                print (err.localizedDescription)
                throw ExitCode.failure
            }
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
            // Use <dataManager from <TrakApp> to delete a subject
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

extension Trak.Subject {
    
    struct Rename: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Rename a subject"
        )
        
        @Argument(help: "The old name")
        var oldName: String
        
        @Argument(help: "The new name")
        var newName: String
        
        func run () throws {
            //use the <data manager> from <Trak>
            do {
                try TrakApp.dataManager.renameSubject(oldSubjectName: oldName, newSubjectName: newName)
                print("Renamed '\(oldName)' to '\(newName)'")
            } catch let err as StorageError {
                print (err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}
