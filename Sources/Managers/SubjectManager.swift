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
        let normalizedName = normalizeSubjectName(name)
        
        if normalizedName.isEmpty{
            throw StorageError.invalidSubjectName(normalizedName)
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
    
    /// Normalize subject names
    /// - Parameter inputName: The subject name given by the user
    private func normalizeSubjectName (_ inputName: String) -> String {
        //Normalize the subject name
        return inputName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)

    }
}
