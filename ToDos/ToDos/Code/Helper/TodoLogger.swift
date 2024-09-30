//
//  TodoLogger.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Foundation
import os

/// Small logger helper convenience 
final class TodoLogger {
    
    static let shared = TodoLogger()
    
    public let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.phiandco.Todo", category: "Operations")

}
