//
//  SubjectManager.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-12.
//

import Foundation
class SubjectManager {
    let dataManager: DataManager
    
    init (dataManager: DataManager){
        self.dataManager = dataManager
    }
    
    /// Task the persistence layer to create a new subject
    /// - Parameter name: The name of the new subject
    func createSubject(name: String) throws {
        let normalizedName = NameNormalizer.normalize(name)
        
        if normalizedName.isEmpty{
            throw StorageError.invalidSubjectName(name)
        }
    
        //Create a new subject model.
        let newSubject = SubjectData(name: normalizedName, dateCreated: Date())
        
        //Persist
        try dataManager.createSubjectRecord(newSubject)
        
    }
    
    /// Task the persistence layer to return a list of all subjects
    ///
    func listSubjects() throws -> [SubjectData]{
        try dataManager.getSubjects()
    }
    
    /// Task the persistence layer to rename a subject
    ///
    func renameSubject(_ oldname: String, _ newName: String) throws {
        // Normalize the subject name
        let normalizedOldName = NameNormalizer.normalize(oldname)
        let normalizedNewName = NameNormalizer.normalize(newName)
        
        if normalizedNewName.isEmpty {
            throw StorageError.invalidSubjectName(oldname)
        }
        if normalizedNewName.isEmpty {
            throw StorageError.invalidSubjectName(newName)
        }
        
        //Persist
        try dataManager.renameSubjectRecord(normalizedOldName, normalizedNewName)
    }
    
    /// Task the persistence layer to delete a subject
    ///
    func deleteSubject(_ name: String) throws {
        //Normalize the subject name
        let normalizedName = NameNormalizer.normalize(name)
        
        if normalizedName.isEmpty {
            throw StorageError.invalidSubjectName(name)
        }
        //Task the data manager
        try dataManager.deleteSubject(normalizedName)
    }
}
