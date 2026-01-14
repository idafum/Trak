//
//  storageError.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//
import Foundation
enum StorageError: Error {
    case failedToCreateDirectory(URL, Error)
    case fileAlreadyExists(url: URL)
    case failedToGetDirectoryContents(url: URL, underlying: Error)
    case failedToDelete(url: URL, underlying: Error)
    case failedToPerfomRenameOperation(oldURL: URL, newURL: URL, underlying: Error)
    
    case invalidSubjectName(String)
    
    case jsonDecodingFailed(underlying: Error)
    case jsonEncodingFailed(underlying: Error)
    case failedToReadFile(url: URL, underlying: Error)
    case failedToWriteFile(url: URL, underlying: Error)
}

extension StorageError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .invalidSubjectName(let name):
            return "Invalid name: \(name)"
        case .failedToCreateDirectory(let at, let underlying):
            return """
                
                Failed to create Directory at:
                \(at.lastPathComponent)
                
                Reason: \(underlying.localizedDescription)
                """
        case .fileAlreadyExists(url: let url):
            return "File already exists at \(url.path())"
            
        case .failedToGetDirectoryContents(url: let url, underlying: let underlying):
            return "Failed to get directory contents at \(url.path()): \(underlying.localizedDescription)"
            
        case .failedToDelete(url: let url, underlying: let underlying):
            return "Failed to delete file '\(url.lastPathComponent)': \(underlying.localizedDescription)"
            
        case .failedToPerfomRenameOperation(oldURL: let oldURL, newURL: let newURL, underlying: let underlying):
            return "Failed to rename file from '\(oldURL.lastPathComponent)' to '\(newURL.lastPathComponent),  \(underlying.localizedDescription)"
            
        
            
        case .failedToReadFile(url: let url, underlying: let underlying):
            return "Failed to read file at \(url.path()): \(underlying.localizedDescription)"
            
        case .failedToWriteFile(url: let url, underlying: let underlying):
            return "Failed to write file at \(url.path()): \(underlying.localizedDescription)"
            
        case .jsonEncodingFailed(underlying: let underlying):
            return "Failed to encode data to JSON: \(underlying.localizedDescription)"
            
        case .jsonDecodingFailed(underlying: let underlying):
            return "Failed to decode JSON from \(underlying.localizedDescription)"
        }
    }
}
