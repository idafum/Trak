//
//  DataManager.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//

import Foundation

//Ensure my data storage exists before app runs
class DataManager {
    let name = "DataManager"
    let appName: String
    let fileManager: FileManager
    
    let dbRootURL: URL
    let dbSubjectsURL: URL
    let dbSessionsURL: URL
    
    
    /*
     What: DataManager Initializer
     Why: Ensures the data storage for TrakCore is present
     How: It uses the FileManger to access the Application\ Support directory.
     
     ErrorHandling: Throws error of type <storageError> to TrakController
     */
    init(appName: String) throws {
        
        self.appName = appName
        fileManager = FileManager.default
        
        guard let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw StorageError.appSupportDirectoryNotFound
        }
        
        dbRootURL = appSupportURL.appending(path: appName, directoryHint: .isDirectory)
        
        dbSubjectsURL = dbRootURL.appending(path: "Subjects", directoryHint: .isDirectory)
        
        dbSessionsURL = dbRootURL.appending(path: "Sessions", directoryHint: .isDirectory)
        
        

    }
    
    /*
     Why: Ensure User data storage exists
     */
    func setupDataStorage() throws{
        try ensureDirectoryExists(dbRootURL)
        try ensureDirectoryExists(dbSubjectsURL)
        try ensureDirectoryExists(dbSessionsURL)
    }
    
    private func ensureDirectoryExists(_ url: URL) throws {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
        catch {
            throw StorageError.failedToCreateDirectory(url: url, underlying: error)
        }
        
    }
    
    //Maybe I can generalize this function createFile(name:where:)
    func createSubject(fileName: String) throws{
        //Use the filemanager to create a new folder under dbSubjectsURL as "filename"
        /*
         if filename exists, report to user
         if filename does not exist create the file
         */
        let newSubjectURL = dbSubjectsURL.appending(path: fileName, directoryHint: .isDirectory)
        
        if (fileManager.fileExists(atPath: newSubjectURL.path(percentEncoded: false))){
            throw StorageError.fileAlreadyExists(url: newSubjectURL)
        }
        
        do {
            try ensureDirectoryExists(newSubjectURL)
        } catch {
            throw StorageError.failedToCreateDirectory(url: newSubjectURL, underlying: error)
        }
        
    }
    
    
    func listSubjects()throws -> [String] {
        /*
         Return a list
         */
        let subjectURLs : [URL]
        
        do {
            subjectURLs = try fileManager.contentsOfDirectory(at: dbSubjectsURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
        } catch {
            throw StorageError.failedToGetDirectoryContents(url: dbSubjectsURL, underlying: error)
        }
        
        let subjectNames : [String] = subjectURLs.map { $0.lastPathComponent }
    
        return subjectNames
    }
    
    func deleteSubject(subject: String) throws {
        //This will delete a subject from the dbSubjectsURL directore if it exist
        //TODO: Ensure, the dbSubjectsURL exists
        let subjectToDeleteURL: URL = dbSubjectsURL.appending(path: subject, directoryHint:.isDirectory)
        
        do {
            try fileManager.removeItem(at: subjectToDeleteURL)
        }
        catch {
            throw StorageError.failedToDelete(url: subjectToDeleteURL, underlying: error)
        }
        
    }
    
    func renameSubject(oldSubjectName: String, newSubjectName: String) throws {
        let oldSubjectNameURL = dbSubjectsURL.appending(path: oldSubjectName, directoryHint: .isDirectory)
        let newSubjectNameURL = dbSubjectsURL.appending(path: newSubjectName, directoryHint: .isDirectory)
        do {

            try fileManager.moveItem(at: oldSubjectNameURL, to: newSubjectNameURL)
        }
        catch {
            throw StorageError.failedToPerfomRenameOperation(oldURL: oldSubjectNameURL, newURL: newSubjectNameURL, underlying: error)
        }
    }
    
    /*
     What: getSubjects Function
     Why: Get a list of Subject Directory URL
     */
    func getSubjects () throws -> [URL]{
        let subjectURLs = try fileManager.contentsOfDirectory(at: dbSubjectsURL, includingPropertiesForKeys: kCFURLNameKey as? [URLResourceKey])
        
        return subjectURLs
    }
    
    /// Persist a newly created active session
    /// - Parameter session: A new active session
    ///
    func saveActiveSession (session: ActiveSession) throws {
        
        //Initialize and configure a json encoder
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        encoder.dateEncodingStrategy = .iso8601
        
        let activeSessionURL = dbSessionsURL.appending(path: "activeSession.json", directoryHint: .notDirectory)
        
        do {
            let data: Data = try encoder.encode(session)
            
            //Persist the json in a file.
            try data.write(to: activeSessionURL) //TODO: CONCURRENCY???
            
        } catch let error as EncodingError {
            
            throw StorageError.jsonEncodingFailed(data: session, underlying: error)
        } catch {
            throw StorageError.failedToWriteFile(url: activeSessionURL, underlying: error)
        }
        
    }
    
    /// Get the state of the current active session
    /// - Returns: An `ActiveSession` instance, or 'nil' if none exists.
    /// - Throws: `StorageError` if the session state file exists but cannot be read or decoded.
    func getSessionState () throws -> ActiveSession?{
        let file = fileExists(at: (root: .sessions, file: "activeSession.json"))
        
        guard file.exists else {
            return nil
        }
        
        do {
            //Get the file
            let jsonData = try Data(contentsOf: file.url)
            
            //Initialize a JSON Decoder
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            //decode type `ActiveSession` from jsonData
            return try decoder.decode(ActiveSession.self, from: jsonData)

        } catch let decodingError as DecodingError{
            // JSON exists but is invalid or incompatible
            throw StorageError.jsonDecodingFailed(url: file.url, underlying: decodingError)
        } catch {
            // Any other I/O or unexpected error
            throw StorageError.failedToReadFile(url: file.url, underlying: error)
        }
        
    }
    
    /// Checks whether a file exists at a given Trak root directory
    /// - Parameter at: A tuple containing the root directory and the file
    /// - Returns: A bool indicating if file exists at the root directory.
    func fileExists( at: (root: dbRoots, file: String) ) -> (url: URL, exists: Bool){
        
        var fileURL: URL
        
        //switch case for all root directories in trak.
        switch at.root {
        case .sessions:
            fileURL = dbSessionsURL.appending(path: at.file)
        case .subjects:
            fileURL = dbSubjectsURL.appending(path: at.file)
        case .trak:
            fileURL = dbRootURL.appending(path: at.file)
        }
        
        return ( fileURL, fileManager.fileExists(atPath: fileURL.path(percentEncoded: false)) )
    }
}


