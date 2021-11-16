//
//  CoreDataManager.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit
import CoreData
enum coreDataEntity {
    case dataCD
    case newPointCD
}


class CoreDataManager {
    
    static  var shared = CoreDataManager()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadData(complession: @escaping(Data)->(), entity: coreDataEntity, errors: @escaping()->()) {
        switch entity {
        case .dataCD:
            var savedData = Data()
            do{
                let photoArray = try self.context.fetch(DataCD.fetchRequest())
                for item in photoArray {
                    savedData = item.data!
                }
            } catch {
                errors()
                print(error.localizedDescription)
            }
            complession(savedData)
        case .newPointCD:
            print("")
        }
        
    }
    
    func saveToCD(data: Data, completion: @escaping()->()) {
        let contexts = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        contexts.automaticallyMergesChangesFromParent = true
        context.perform {
            do {
                let entity = DataCD(context : self.context)
                entity.data = data
                try? self.context.save()
                completion()
                try self.context.save()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func saveCDNewPoint(data: Model, completion: @escaping()->()) {
        let contexts = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        contexts.automaticallyMergesChangesFromParent = true
        context.perform {
            do {
                let entity = NewPointsCD(context : self.context)
                entity.lat = data.lat
                entity.long = data.lon
                entity.state = Int64(data.state)
                entity.heading = Int64(data.heading)
                print(data.id)
                entity.ids = Int64(data.id) ?? 0
                try? self.context.save()
                completion()
                try self.context.save()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadOnePoint(complession: @escaping(Model)->()) {
        var model: Model!
        do{
            let photoArray = try self.context.fetch(NewPointsCD.fetchRequest())
            for item in photoArray {
                model = Model(id: "\(Int(Float(item.long - item.lat) * 100000))",
                              lat: item.lat,
                              lon: item.long,
                              state: Int(item.state),
                              heading: Int(item.heading))
                complession(model)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewPointsCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
    }
    
    private init() {}
    
}
