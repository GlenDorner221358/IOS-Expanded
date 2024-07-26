//
//  LocationView.swift
//  class-demo
//
//  Created by OW on 2024/07/17.
//

import SwiftUI

//location framework
import CoreLocation
import CoreLocationUI

//managing our location calling
class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    //variable is what will show our coordinates - public state var, that can be accessed outside the class
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    //this checks if we have the required permission
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error fetching location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if locations.first != nil {
            location = locations.first?.coordinate
            print(location?.latitude ?? "none")
        }
    }
    
}



struct LocationView: View {
    
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {

        VStack{
            
            if let location = locationManager.location {
                Text("Long: \(location.longitude)")
                Text("Lat: \(location.latitude)")
            }
            
            
            LocationButton(.sendMyCurrentLocation){
                //call the location permission
                locationManager.requestLocation()
            }
            .foregroundStyle(.white)
        
        }
    }
}

#Preview {
    LocationView()
}
