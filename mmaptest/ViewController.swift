//
//  ViewController.swift
//  mmaptest
//
//  Created by KhaleD HuSsien on 04/08/2024.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView! // Connect this outlet if using storyboard
    var lat: Double? = 0.0
    var lng: Double? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.cornerRadius = 20
        let iframeString = "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3456.07369843782!2d31.361734925770104!3d29.9773119217508!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583bde994534dd%3A0xc7a5a8d2d7d23aac!2sMorshedy%20Group%20%7C%20Kattameya%20Gate!5e0!3m2!1sar!2seg!4v1719837836949!5m2!1sar!2seg\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>"
        
        if let range = iframeString.range(of: "https://[^\\\"]*", options: .regularExpression) {
            let extractedUrl = String(iframeString[range])
            print(extractCoordinates(from: extractedUrl))
        }
      
        // Do any additional setup after loading the view.
        let initialLocation = CLLocationCoordinate2D(latitude: self.lat ?? 0.0, longitude: self.lng ?? 0.0) // Example coordinates for San Francisco
        
        // Set region radius (zoom level)
        let regionRadius: CLLocationDistance = 10000 // 10 km radius
        
        // Create a region around the initial location
        let coordinateRegion = MKCoordinateRegion(center: initialLocation,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        // Set the map view's region
        mapView.setRegion(coordinateRegion, animated: true)
        
        // Optional: Add an annotation (marker)
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = "Location Title"
        annotation.subtitle = "Location Subtitle"
        mapView.addAnnotation(annotation)
    }
    
    func extractCoordinates(from urlString: String) -> (latitude: Double?, longitude: Double?) {
        guard let url = URL(string: urlString) else { return (nil, nil) }
        
        // Convert the URL string into components
        let components = urlString.components(separatedBy: "!")

        // Extract latitude and longitude using specific patterns
        var latitude: Double? = nil
        var longitude: Double? = nil
        
        for component in components {
            if component.hasPrefix("3d") {
                // Extract latitude after "3d"
                let latString = component.replacingOccurrences(of: "3d", with: "")
                latitude = Double(latString)
                self.lat = latitude
            } else if component.hasPrefix("2d") {
                // Extract longitude after "2d"
                let lonString = component.replacingOccurrences(of: "2d", with: "")
                longitude = Double(lonString)
                self.lng = longitude
            }
        }
        
        return (latitude, longitude)
    }
    
}




