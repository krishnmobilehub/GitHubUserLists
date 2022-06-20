//
//  CoreDatamanager.swift
//  GithubUserList
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Core Data stack
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: Constants.CoreData.dbName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(Constants.CoreData.dbName).sqlite")
        var failureReason = Constants.Message.failureReason
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = Constants.Message.dictSavedFailed as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            print("\(Constants.Message.unresolvedError) \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            
            managedObjectContext = self.persistentContainer.viewContext
        }
        else{
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
        }
        return managedObjectContext!
    }()
    
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.CoreData.dbName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("\(Constants.Message.unresolvedError) \(error), \(error.userInfo)")
                fatalError("\(Constants.Message.unresolvedError) \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getManagedContext () -> NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            return self.persistentContainer.viewContext
        }
        else {
            return self.managedObjectContext
        }
    }
    
    // MARK: - Core Data Saving Support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                print("\(Constants.Message.unresolvedError) \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Core Data Fetch Support
    func fetch(entityName: NSString) -> [NSManagedObject] {
        var managedObjects: [NSManagedObject] = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName as String)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            managedObjects = try getManagedContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("\(Constants.Message.couldFetch) \(error), \(error.userInfo)")
        }
        
        return managedObjects
    }
    
    func fetchWithPredicate(entityName: NSString, predicate: NSPredicate) -> [NSManagedObject] {
        var managedObjects: [NSManagedObject] = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName as String)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        do {
            managedObjects = try getManagedContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("\(Constants.Message.couldFetch) \(error), \(error.userInfo)")
        }
        
        return managedObjects
    }
    
    func deleteWithPrediecate(entityName: NSString, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName as String)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        do {
            if let fetchResults = try getManagedContext().fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject] {
                for managedObject in fetchResults  {
                    getManagedContext().delete(managedObject)
                }
                try getManagedContext().save()
            }
        } catch let error as NSError {
            print("\(Constants.Message.couldFetch) \(error), \(error.userInfo)")
        }
    }
    
    func deleteEntity(entityName: NSString) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName as String)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            if let fetchResults = try getManagedContext().fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject] {
                for managedObject in fetchResults  {
                    getManagedContext().delete(managedObject)
                }
                try getManagedContext().save()
            }
        } catch let error as NSError {
            print("\(Constants.Message.couldFetch) \(error), \(error.userInfo)")
        }
    }
}
