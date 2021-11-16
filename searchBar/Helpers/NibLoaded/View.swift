//
//  CGSize.swift
//  moyaTests
//
// Created by User on 08.09.2021.
//
import UIKit

/// Базовая вью.
open class View: UIView {
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Настройка после инициализации.
    open func commonInit() {}
}

/// Basic control
open class Control: UIControl {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Настройка после инициализации.
    open func commonInit() {}
}
