//
//  QueueScreenController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 23.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit
import MapKit

class QueueScreenController : UIViewController {

    var queue : Queue!
    
    @IBOutlet var queueMapView: MKMapView!
    @IBOutlet var queueSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        queueSizeLabel.text = String(describing: queue.size)
        title = queue.name
//        let geocoder = CLGeocoder()
        let annotation = MKPointAnnotation()
        let coordArray = queue.coords?.components(separatedBy: ",")
        if (coordArray?.count)! > 1{
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double((coordArray?[0])!)!, longitude: Double((coordArray?[1])!)!)
        }
        queueMapView.showAnnotations([annotation], animated: true)
        
    }
}
