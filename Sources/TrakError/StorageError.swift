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
    case NoSuchFile(String)
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
        case .failedToCreateDirectory(let url, _):
            return "Failed to create directory: \(url.path)"
        case .fileAlreadyExists(let url):
            return "File already exists: \(url.lastPathComponent)"
        case .NoSuchFile(let name):
            return "No such file: \(name)"
        case .failedToGetDirectoryContents(let url, _):
            return "Failed to list directory contents: \(url.path)"
        case .failedToDelete(let url, _):
            return "Failed to delete: \(url.lastPathComponent)"
        case .failedToPerfomRenameOperation(let oldURL, let newURL, _):
            return "Failed to rename '\(oldURL.lastPathComponent)' to '\(newURL.lastPathComponent)'"
        case .invalidSubjectName(let name):
            return "Invalid subject name: '\(name)'"
        case .jsonDecodingFailed:
            return "Failed to decode JSON data."
        case .jsonEncodingFailed:
            return "Failed to encode JSON data."
        case .failedToReadFile(let url, _):
            return "Failed to read file: \(url.lastPathComponent)"
        case .failedToWriteFile(let url, _):
            return "Failed to write file: \(url.lastPathComponent)"
        }
    }
}
