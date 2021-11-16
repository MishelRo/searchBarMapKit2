//
//  CGSize.swift
//  moyaTests
//
// Created by User on 08.09.2021.
//
import UIKit

/// Кастомная вью с инициализацией как у стандартной
open class NibLoadableView: View {
    
    private var view: UIView!
    
    override open func commonInit() {
        backgroundColor = .clear
        removeAllSubviews()
        
        view = loadViewFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillToSuperview()
        viewDidLoad()
    }
    
    private func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: className, bundle: Bundle(for: type(of: self)))
        // swiftlint:disable:next force_cast
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }
    
    /// Will be called after loading view from xib
    open func viewDidLoad() {
        
    }
}


open class NibLoadableControl: Control {
    
    private var view: UIView!
    
    override open func commonInit() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        viewDidLoad()
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: className, bundle: nil)
        // swiftlint:disable:next force_cast
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }
    
    /// Will be called after loading view from xib
    open func viewDidLoad() {
        
    }
}
