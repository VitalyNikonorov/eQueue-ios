//
//  QueueScreenController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 23.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit
import MapKit

class QueueScreenController : UIViewController, JoinCallback, QueueCallback {
    
    internal func onJoinResponse(response: Dictionary<String, AnyObject>) {
        print(response)
    }
    
    var qid : Int!

    private var queue : Queue!
    let dataSource = DataSource.sharedInstance
    
    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var queueMapView: MKMapView!
    
    @IBOutlet var qWaitingLbl: UILabel!
    @IBOutlet var qInFrontLbl: UILabel!
    @IBOutlet var qSizeLbl: UILabel!
    
    @IBOutlet var tiketImage: UIImageView!
    @IBOutlet var myNumberInQ: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        dataSource.findQueueById(qid: qid, callBack: self)
    }
    
    func onQueueInfoLoaded(response: Queue) {
        self.queue = response
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    private func updateView(){
        qWaitingLbl.text = String(describing: queue.waitingTime)
        qSizeLbl.text = String(describing: queue.size)
        
        if (queue.forwardMe > -1) {
            qInFrontLbl.text = String(describing: queue.forwardMe)
            myNumberInQ.isHidden = false
            myNumberInQ.text = String(describing: queue.myNumber)
            tiketImage.isHidden = false
            joinBtn.isHidden = true
        } else {
            qInFrontLbl.text = "-"
            myNumberInQ.isHidden = true
            tiketImage.isHidden = true
            joinBtn.isHidden = false
        }
        
        title = queue.name
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
