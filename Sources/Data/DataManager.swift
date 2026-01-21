//
//  DataManager.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//

import Foundation

/// Provides file management service and persistence for Trak
class DataManager {
    let name = "DataManager"
    let appName: String
    let fileManager: FileManager
    
    let dbRootURL: URL
    let dbSubjectsURL: URL
    let dbSessionsURL: URL
    
    
    /// Initializes a `DataManager` by setting up Trak required directories
    /// - Parameter appName: The name `Trak`
    init(appName: String){
        
        self.appName = appName
        fileManager = FileManager.default
        
        let appSupportDirectoryURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        dbRootURL = appSupportDirectoryURL.appending(path: appName, directoryHint: .isDirectory)
        
        dbSubjectsURL = dbRootURL.appending(path: "Subjects", directoryHint: .isDirectory)
        
        dbSessionsURL = dbRootURL.appending(path: "Sessions", directoryHint: .isDirectory)
    }
    

    /// Setup data storage by ensuring required directories exists.
    /// This function uses the helper ensureDirectoryExists(_ url: URL)
    ///
    ///- Throws: `StorageError`
    func setupDataStorage() throws{
        try ensureDirectoryExists(dbRootURL)
        try ensureDirectoryExists(dbSubjectsURL)
        try ensureDirectoryExists(dbSessionsURL)
    }
    
    /// Check if directory exist.
    /// - Parameter url: The directory URL
    /// - Throws: `StorageError.failedToCreateDirectory(URL, Error)`
    private func ensureDirectoryExists(_ url: URL) throws {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
        catch {
            throw StorageError.failedToCreateDirectory(url, error)
        }
    }
    
    /// Task the `FileManager` to create a new subject
    /// - Parameter subjectName: The name of the subject
    /// - Throws: `StorageError`
    func createSubjectRecord(_ newSubject: SubjectData) throws{
        let subjectFileName = "\(newSubject.name).json"
        
        //Build the file target adn check existence
        let record = fileExists(at: (root: .subjects, file: subjectFileName))
        
        if record.exists {
            throw StorageError.fileAlreadyExists(url: record.url)
        }
        
        //Encode the SubjectData to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(newSubject)
            try data.write(to: record.url, options: .atomic)
        }
        catch let err as EncodingError {
            throw StorageError.jsonEncodingFailed(underlying: err)
        }
        catch {
            throw StorageError.failedToWriteFile(url: record.url, underlying: error)
        }
        
    }
    
    /// Retrive a list of all user subjects
    func getSubjects()throws -> [SubjectData] {
        
        var subjects : [SubjectData] = []
        // Get all subject json files
        let subjectURLs : [URL]
        
        do {
            subjectURLs = try fileManager.contentsOfDirectory(at: dbSubjectsURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
        } catch {
            throw StorageError.failedToGetDirectoryContents(url: dbSubjectsURL, underlying: error)
        }
        
        //Ensure we have only json files
        let jsonSubjectURL : [URL] = subjectURLs.filter { $0.pathExtension == "json" }
        
        
        // Decode jsonFiles into SubjectData
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        for url in jsonSubjectURL {
            
            do {
                let subjectByteBuffer = try Data(contentsOf: url)
                let subjectData : SubjectData = try decoder.decode(SubjectData.self, from:subjectByteBuffer)
                
                subjects.append(subjectData)
            }
            catch let err as DecodingError {
                throw StorageError.jsonDecodingFailed(underlying: err)
            }
            catch {
                throw StorageError.failedToReadFile(url: url, underlying: error)
            }
        }
        
        return subjects
    }
    
    /// Delete a subject by name
    func deleteSubject(_ name: String) throws {
        let subjectFileName = "\(name).json"
        
        //Check if the subjectFileName Exists
        let subjectFile = fileExists(at: (root: .subjects, file: subjectFileName))
        
        //throw StorageError is file to be deleted does not exist
        guard subjectFile.exists else {throw StorageError.NoSuchFile(name)}
        
        //Now we know the file exists.
        //We need to remove the file
        do {
            try fileManager.removeItem(at: subjectFile.url)
        } catch {
            throw StorageError.failedToDelete(url: subjectFile.url, underlying: error)
        }
    }
    
    /// Rename a subject
    func renameSubjectRecord(_ oldName: String, _ newName: String) throws {
        let oldSubjectName = "\(oldName).json"
        let newSubjectName = "\(newName).json"
        
        //Check if file under the oldName exists under subjects
        let oldSubject = fileExists(at: (root: .subjects, file: oldSubjectName))
        let newSubject = fileExists(at: (root: .subjects, file: newSubjectName))
        
        guard oldSubject.exists else { throw StorageError.NoSuchFile(oldName) }
        
        //Chech if newSubjects already exists.
        if newSubject.exists {
            throw StorageError.fileAlreadyExists(url: newSubject.url)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            //read from disk and decode
            let oldBytes = try Data(contentsOf: oldSubject.url)
            var subject = try decoder.decode(SubjectData.self, from: oldBytes)
            
            //update the name
            subject.name = newName
            
            //encode to JSON and write to disk
            let newBytes = try encoder.encode(subject)
            try newBytes.write(to: newSubject.url, options: .atomic)
            
            // Remove old file after successful write
            try fileManager.removeItem(at: oldSubject.url)
        }
        catch let err as DecodingError {
            throw StorageError.jsonDecodingFailed(underlying: err)
        }
        catch let err as EncodingError{
            throw StorageError.jsonEncodingFailed(underlying: err)
        }
        
    }
    
    func createSession (_ session: SessionData) throws {
        //Check if the subject with name exist
        let subjectJsonFile = "\(session.subjectName).json"
        
        let subjectFile = fileExists(at: (root:.subjects, file: subjectJsonFile))
        
        guard subjectFile.exists else { throw StorageError.NoSuchFile(subjectJsonFile)}
        
        //Create the new session
        //Create a new sessionfile.json
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        encoder.dateEncodingStrategy = .iso8601
        
        //Create the activeSessionfile
        let activeSessionURL = dbSessionsURL.appending(path: "activeSession.json", directoryHint: .notDirectory)
        
        do {
            let data = try encoder.encode(session)
            
            //write the encoded sessionData to disk
            try data.write(to: activeSessionURL)
        }
        catch let error as EncodingError {
    
            throw StorageError.jsonEncodingFailed(underlying: error)
        } catch {
            throw StorageError.failedToWriteFile(url: activeSessionURL, underlying: error)
        }
    
    }
    
    /// Get the state of the current active session
    /// - Returns: An `SessionData` instance, or 'nil' if none exists.
    /// - Throws: `StorageError` if the session state file exists but cannot be read or decoded.
    /// - Refactor: getActiveSession(
    func getSessionState () throws -> SessionData?{
        let sessionFile = fileExists(at: (root: .sessions, file: "activeSession.json"))
        
        // return nil if no session file exist
        guard sessionFile.exists else { return nil }
        
        do {
            //Get the file
            let sessionFileBytes = try Data(contentsOf: sessionFile.url)
            
            //Initialize a JSON Decoder
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            //decode type `SessionData` from jsonData
            return try decoder.decode(SessionData.self, from: sessionFileBytes)

        } catch let decodingError as DecodingError{
            // JSON exists but is invalid or incompatible
            throw StorageError.jsonDecodingFailed(underlying: decodingError)
        } catch {
            // Any other I/O or unexpected error
            throw StorageError.failedToReadFile(url: sessionFile.url, underlying: error)
        }
        
    }
    
    func setActiveSession(_ session: SessionData) throws -> SessionData {
        // Someone has the intent to persist this session data in my memory
        // locate the active session
        let activeSession = fileExists(at: (root: dbRoots.sessions, file: "activeSession.json"))
        
        //TODO: Extra security check to see if active Session exist
        guard activeSession.exists else { throw SessionError.noActiveSession }
        
        //ActiveSession exists!
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let dataToWrite = try encoder.encode(session)
            
            //should we ensure directory exists here??
            try dataToWrite.write(to: activeSession.url, options: .atomic)
            
            return session //This is the session I saved
        }catch let err as EncodingError{
            throw StorageError.jsonEncodingFailed(underlying: err)
        }catch {
            throw StorageError.failedToWriteFile(url: activeSession.url, underlying: error)
        }
    }
    
    func appendSessionLog(_ sessionLogData: SessionLogData) throws -> SessionLogData? {
        if try clearActiveSession() {
            //appendDataLog
            
            // Find existing log files for the subject with pattern "<SubjectName>-#N.json"
            let existingLogs = try fileManager.contentsOfDirectory(at: dbSessionsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                .filter { url in
                    let filename = url.deletingPathExtension().lastPathComponent
                    return filename.hasPrefix("\(sessionLogData.subjectName)-#")
                }
            
            // Extract numbers N from filenames
            let usedNumbers = existingLogs.compactMap { url -> Int? in
                let filename = url.deletingPathExtension().lastPathComponent
                // filename format: "<SubjectName>-#N"
                // Extract substring after "\(subjectName)-#"
                guard let range = filename.range(of: "-#") else { return nil }
                let numberString = filename[range.upperBound...]
                return Int(numberString)
            }
            
            // Determine next available number
            let nextNumber = (usedNumbers.max() ?? 0) + 1
            
            // Create new log file name
            let logName = "\(sessionLogData.subjectName)-#\(nextNumber).json"
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            //Encode the data
            do {
                let dataToWrite = try encoder.encode(sessionLogData)
                
                let path = dbSessionsURL.appending(path: logName, directoryHint: .notDirectory).path(percentEncoded: false)
                if fileManager.createFile(atPath: path, contents: dataToWrite) {
                    return sessionLogData
                }
                else {
                    return nil
                }
            } catch let err as EncodingError {
                throw StorageError.jsonEncodingFailed(underlying: err)
            }
           
        } else {
            return nil
        }
    }
    
    private func makeTimestamp (_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return formatter.string(from: date)
    }
    
    /// Delete an active session
    func clearActiveSession() throws -> Bool{
        //Check is there is an active session
        let activeSession = fileExists(at: (root: .sessions, file: "activeSession.json"))
        
        guard activeSession.exists else { throw SessionError.noActiveSession }
        
        //Active Session exists.
        //No we need to just delete it from memory
        do {
            try fileManager.removeItem(at: activeSession.url)
            return true
        } catch {
            throw StorageError.failedToDelete(url: activeSession.url, underlying: error)
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

extension DataManager {
    ///Check if Trak has been initialized.
    static func isInitialized (appName: String) -> Bool {
        let fm = FileManager.default
        
        guard let appSupport = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                    return false
                }

                let root = appSupport.appending(path: appName, directoryHint: .isDirectory)
                let subjects = root.appending(path: "Subjects", directoryHint: .isDirectory)
                let sessions = root.appending(path: "Sessions", directoryHint: .isDirectory)

                return fm.fileExists(atPath: root.path(percentEncoded: false)) &&
                       fm.fileExists(atPath: subjects.path(percentEncoded: false)) &&
                       fm.fileExists(atPath: sessions.path(percentEncoded: false))
    }
}


