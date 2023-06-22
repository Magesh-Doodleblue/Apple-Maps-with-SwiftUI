//
//  favLocationView.swift
//  map
//
//  Created by DB-MM-011 on 14/06/23.
//

import SwiftUI
import CoreData

struct FavLocationView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.allAddresses, id: \.address) { address in
                HStack (spacing: 120){
                    
                    VStack(alignment: .leading) {
                        Text(address.address)
                            .font(.headline)
                        Text("Latitude: \(address.lat)")
                        Text("Longitude: \(address.long)")
                    }
                    Button(action: {
                        do{   try viewModel.deleteAddress(address)
                            print("successfully Deleted")
                        }
                        catch{
                            print("Failed to delete item")
                        }
                    }) {
                                        Text("Delete")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(height: 30)
                                            .background(Color.blue)
                                            .cornerRadius(5.0)
                                    }
                               
                }
            }
            .navigationTitle("Saved Address")
            .onAppear {
                viewModel.fetchAllAddresses()
            }
        }
    }
}

struct FavLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FavLocationView()
    }
}




