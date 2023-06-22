//
//  ContentView.swift
//  map
//
//  Created by DB-MM-011 on 13/06/23.
//
//
import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = MapViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Location Finder")
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .font(.system(size: 26))
                    .onLongPressGesture {
                        print("text is hold")
                    }

                HStack(spacing: 20){
                    TextField("Enter location", text: $viewModel.location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.blue)
                        .font(.body)
                        .cornerRadius(6)
                    .padding()
                   
                    Button(action: {
                        viewModel.saveNewAddress()
                        print("Address saved successfully in database")
                    })
                    {
                                        Text("Save")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 80, height: 30)
                                            .background(Color.blue)
                                            .cornerRadius(5.0)
                                    }
                                    .padding()
                }

                MapView()
                    .environmentObject(viewModel)
                    .frame(height: 450)
                
                NavigationLink(
                    destination: FavLocationView(),
                    isActive: $viewModel.isActive,
                    label: {
                        Text("View Saved address")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 230, height: 50)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    })
                    .padding()
                }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
