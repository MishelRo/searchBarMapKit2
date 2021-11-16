//
//  CGSize.swift
//  moyaTests
//
// Created by User on 08.09.2021.
//

import Foundation

public extension NSObject {
    
    var className: String {
        String(describing: type(of: self))
    }
    
    static var className: String {
        String(describing: self)
    }
    
}
