//
//  QueueScreenController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 23.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit
import MapKit

class QueueScreenController : UIViewController, JoinCallback {
    
    internal func onJoinResponse(response: Dictionary<String, AnyObject>) {
        print(response)
    }


    var queue : Queue!
    let dataSource = DataSource.sharedInstance
    
    @IBOutlet var queueMapView: MKMapView!
    
    @IBOutlet var qWaitingLbl: UILabel!
    @IBOutlet var qInFrontLbl: UILabel!
    @IBOutlet var qSizeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        qWaitingLbl.text = String(describing: queue.waitingTime)
        qSizeLbl.text = String(describing: queue.size)
        
        qInFrontLbl.text = ( (queue.forwardMe > -1) ? String(describing: queue.forwardMe) : "-")
        
        title = queue.name
//        let geocoder = CLGeocoder()
        let annotation = MKPointAnnotation()
        let coordArray = queue.coords?.components(separatedBy: ",")
        if (coordArray?.count)! > 1{
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double((coordArray?[0])!)!, longitude: Double((coordArray?[1])!)!)
        }
        queueMapView.showAnnotations([annotation], animated: true)
        
    }
    @IBAction func joinBtnTaped(_ sender: Any) {
        dataSource.joinQueue(qid: queue.qid, callBack: self)
    }
}
