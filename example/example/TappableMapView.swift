import SwiftUI
import MapKit
import UIKit

public protocol TapplableMapViewDelegate: AnyObject {
    func mapViewDidTap(location: CLLocationCoordinate2D)
}

public class TapplableMapView: UIView {
    public lazy var mapView = MKMapView()
    weak public var delegate: TapplableMapViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(onTap(sender:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        mapView.mapType = .hybrid
        addSubview(mapView)
    }
    
    public override func layoutSubviews() {
        mapView.frame =  CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: mapView)
        let location = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        delegate?.mapViewDidTap(location: location)
    }
    
    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }
}

@available(iOS 13.0, *)
public struct MapView: UIViewRepresentable {
    @Binding public var locations: [CLLocationCoordinate2D]
    @Binding public var mapType: MKMapType
    
    let mapViewDidTap: (_ location: CLLocationCoordinate2D) -> Void
    final public class Coordinator: NSObject, TapplableMapViewDelegate {
        private var mapView: MapView
        let mapViewDidTap: (_ location: CLLocationCoordinate2D) -> Void
        
        init(_ mapView: MapView, mapViewDidTap: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
            self.mapView = mapView
            self.mapViewDidTap = mapViewDidTap
        }
        
        public func mapViewDidTap(location: CLLocationCoordinate2D) {
            mapViewDidTap(location)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, mapViewDidTap: mapViewDidTap)
    }
    
    public func makeUIView(context: Context) -> TapplableMapView {
        let mapView = TapplableMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: TapplableMapView, context: Context) {
        for location in locations {
            let annotation = MKPointAnnotation()
            let centerCoordinate = location
            annotation.coordinate = centerCoordinate
            annotation.title = "latitude: \(location.latitude), longitude: \(location.longitude)"
            uiView.addAnnotation(annotation)
        }
        uiView.mapView.mapType = mapType
    }
}
