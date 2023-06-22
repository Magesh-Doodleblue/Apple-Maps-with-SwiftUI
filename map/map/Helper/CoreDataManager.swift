//
//  CoreDataManager.swift
//  map
//
//  Created by DB-MM-011 on 15/06/23.
//
//
//

import CoreData

// MARK: - Core Data Manager
class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
     init() {
         persistentContainer = NSPersistentContainer(name: "Address")
         persistentContainer.loadPersistentStores{(_, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         }
         
     }
    
    // MARK: - Core Data stack
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
 
    
    // MARK: - Add Address in db
    func createAddress(address: String, latitude: Double, longitude: Double) {
        let newAddress = Address(context: viewContext)
        newAddress.address = address
        newAddress.lat = latitude
        newAddress.long = longitude
        
        saveContext()
    }
    // MARK: - Fetch Address
    func fetchAllAddresses() -> [Address] {
        let fetchRequest: NSFetchRequest<Address> = Address.fetchRequest()
        
        do {
            let addresses = try viewContext.fetch(fetchRequest)
            return addresses
        } catch {
            print("Failed to fetch addresses: \(error)")
            return []
        }
    }
    // MARK: - Update Address
//    (Not used)
    func updateAddress(address: Address, newAddress: String, newLatitude: Double, newLongitude: Double) {
        address.address = newAddress
        address.lat = newLatitude
        address.long = newLongitude
        
        saveContext()
    }
    // MARK: - Delete Address
    func deleteAddress(address: Address) {
        viewContext.delete(address)
        
        saveContext()
    }
    
    // MARK: - Save Address
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
