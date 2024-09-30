//
//  Bool+Comparable.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Foundation

extension Bool: Comparable {
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
