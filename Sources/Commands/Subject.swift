//
//  Subject.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-03.
//

import ArgumentParser
import Foundation

extension Trak {
    struct Subject : ParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "subject",
            abstract: "Manage your subjects",
            shouldDisplay: true,
            subcommands: [Create.self, List.self, Delete.self, Rename.self]
            
        )
        
        func run() throws {
            print(Subject.helpMessage())
        }
        
    }
}

extension Trak.Subject {
    struct Create : ParsableCommand {
        
        static let configuration = CommandConfiguration(
            abstract: "Create a new subject"
        )
        
        @Argument
        var name: String
        
        func run() throws {
            //Use <dataManger> from <TrakApp> to create a new file with <filename>
            //If file does exitst already, stop creation and inform us that that file already exists. Maybe then show command to List all subjects?
            
            do {
                try TrakApp.dataManager.createSubject(fileName: name)
                print("New subject \(name) created.")
            }
            catch StorageError.fileAlreadyExists(url: let url){
                print("oops '\(url.lastPathComponent)' already exists.")
                print("Use 'trak subject list' to list all subjects.")
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
            //Use <dataManager> from <TrakApp> to list all Subjects
            do {
                let subjects: [String] = try TrakApp.dataManager.listSubjects()
                
                if subjects.isEmpty {
                    print ("...No subjects found...")
                    print ("Use 'trak subject create <name>' to create a new subject.")
                } else {
                    print (subjects)
                }
                
                //TODO: Display strings in a list form for user (Acceptance Criteria)
                //TODO: Add a signal text to start a subject session (Acceptance Criteria)
            }
            catch StorageError.failedToGetDirectoryContents(_: let url, underlying: let underlying){
                print("Error accessing file system at \(url): \(underlying)")
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
