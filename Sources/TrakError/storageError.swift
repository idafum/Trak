//
//  storageError.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//
import Foundation
enum StorageError: Error {
    case appSupportDirectoryNotFound
    case failedToCreateDirectory(url: URL, underlying: Error)
    case fileAlreadyExists(url: URL)
    case failedToGetDirectoryContents(url: URL, underlying: Error)
    case failedToDelete(url: URL, underlying: Error)
}

extension StorageError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .appSupportDirectoryNotFound:
            return "Could not locate the Application Support Directory"
        case .failedToCreateDirectory(url: let url, underlying: let underlying):
            return """
                Failed to create Diretory at:
                \(url.path())
                
                Reason: \(underlying.localizedDescription)
                """
        case .fileAlreadyExists(url: let url):
            return "File already exists at \(url.path())"
            
        case .failedToGetDirectoryContents(url: let url, underlying: let underlying):
            return "Failed to get directory contents at \(url.path()): \(underlying.localizedDescription)"
            
        case .failedToDelete(url: let url, underlying: let underlying):
            return "Failed to delete file '\(url.lastPathComponent)': \(underlying.localizedDescription)"
        }
    }
}
