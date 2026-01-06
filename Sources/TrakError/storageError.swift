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
        }
    }
}
