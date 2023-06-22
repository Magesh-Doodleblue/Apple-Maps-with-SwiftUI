//
//  MapViewModel.swift
//  map
//
//  Created by DB-MM-011 on 13/06/23.
//

import SwiftUI
import MapKit
//

struct addressItems: Identifiable, Equatable {
    let id = UUID()
    var address: String
    var lat: String
    var long: String
}

class MapViewModel: ObservableObject {
    @Published var location: String = ""
    @Published var isActive = false
    @Published var latitude: String?
    @Published var longitude : String?
    @Published var allAddresses: [addressItems] = []
    
    var coredatamanager: CoreDataManager
    
    init(coredatamanager: CoreDataManager =  CoreDataManager()) {
        
        self.coredatamanager = coredatamanager
    }
    
    func fetchAllAddresses() {
        let addresses = coredatamanager.fetchAllAddresses()
        allAddresses = addresses.map { address in
            return addressItems(address: address.address ?? "", lat: "\(address.lat)", long: "\(address.long)")
        }
    }
    
    func deleteAddress(_ address: addressItems) {
        guard let index = allAddresses.firstIndex(of: address) else {
            print("Invalid Index")
            return
        }
        
        let coreAddresses = coredatamanager.fetchAllAddresses()
        if let coreAddress = coreAddresses.first(where: { $0.address == address.address }) {
            coredatamanager.deleteAddress(address: coreAddress)
        }
        
        allAddresses.remove(at: index)
    }
    
    func saveNewAddress(){
        if
            let currentLatitude = latitude,
            let currentLongitude = longitude,
            let latitude = Double(currentLatitude),
            let longitude = Double(currentLongitude) {
            coredatamanager.createAddress(address: location, latitude: latitude, longitude: longitude)
        }
    }
    

}
