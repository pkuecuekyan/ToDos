//
//  TodoEnvironmentVariables.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/28/24.
//

import SwiftUI

extension EnvironmentValues {
    var shouldImportContent: Bool {
        get { self[ImportContentKey.self] }
        set { self[ImportContentKey.self] = newValue }
    }
}

