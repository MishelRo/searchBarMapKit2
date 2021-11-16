//
//  UiScreen.swift
//  Metronome
//
//  Created by User on 10.10.2021.
//

import UIKit
extension UIScreen {
    public class func isPhone7() -> Bool {
        return UIScreen.main.bounds.size.height <= 568
    }
    
    public class func isPhone8() -> Bool {
        return UIScreen.main.bounds.size.height == 667
    }
    
    public class func isPhone6Plus() -> Bool {
        return UIScreen.main.bounds.size.height == 736
    }
    

}
