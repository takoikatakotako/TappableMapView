import SwiftUI
import MapKit
import TappableMapView

struct ContentView: View {
    @State var showingAlert = false
    @State var selectedLocation: CLLocationCoordinate2D?
    
    @State var locations: [CLLocationCoordinate2D] = []
    @State var mapType: MKMapType = .hybrid
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            MapView(locations: $locations, mapType: $mapType) { location in
                self.selectedLocation = location
                self.showingAlert = true
            }
            Button(action: {
                mapType = .satellite
            }){
                Text("ChangeMapType")
                    .padding()
                    .background(Color.gray)
            }
            .padding()
        }
        .onAppear {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(34.6432), longitude: CLLocationDegrees(134.9976))
            locations.append(location)
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(""),
                message: Text("latitude: \(selectedLocation?.latitude ?? -1), longitude: \(selectedLocation?.longitude ?? -1)"),
                primaryButton: .default(Text("OK")) {
                    guard let location = selectedLocation else {
                        return
                    }
                    self.addLocation(location: location)
                }, secondaryButton: .cancel())
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .ignoresSafeArea(.all, edges: .all)
    }
    
    private func addLocation(location: CLLocationCoordinate2D) {
        locations.append(location)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
