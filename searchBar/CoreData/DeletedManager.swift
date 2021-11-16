//
//  DeletedManager.swift
//  TestMarsSwinJectProject
//
//  Created by User on 06.03.2021.
//

import Foundation
class DeletedManager{
    
    
    func arrayOfDeletedIds()->[Int]{
        UserDefaults.standard.object(forKey: "DeletedKey") as? [Int] ?? [Int]()
    }
    
    func addToIgnore(id: Int){
        var array = arrayOfDeletedIds()
        array.append(id)
        UserDefaults.standard.set(array, forKey: "DeletedKey")
    }
    
    
}
