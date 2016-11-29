//
//  GeoSearchViewController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 25.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit
import CoreLocation

class GeoSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, QueueListCallback {
    @IBOutlet var tableView: UITableView!
    var dataSource: DataSource = DataSource.sharedInstance
    var locationManager : CLLocationManager = CLLocationManager()
    var queues : Array<Queue> = []
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        refreshControl.addTarget(self, action: #selector(GeoSearchViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        updateData()
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateData()
    }
    
    func updateData(){
        locationManager.startUpdatingLocation()
    }
    
    func onQueueListResponse(response: Array<Queue>) {
        DispatchQueue.main.async {
            self.queues = response
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (queues.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QueueCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QueueTableCell
        
        cell.queueName.text = queues[indexPath.row].name
        cell.queueDescription.text = queues[indexPath.row].descriprion
        cell.locationLabel.text = queues[indexPath.row].location
        
        cell.forwardMeLabel.text = String(describing: queues[indexPath.row].forwardMe)
        cell.sizeLabel.text = String(describing: queues[indexPath.row].size)
        cell.waitingTimeLabel.text = String(describing: queues[indexPath.row].waitingTime)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQueueSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as? QueueScreenController
                tableView.deselectRow(at: indexPath, animated: true) 
                destinationVC?.qid = queues[indexPath.row].qid
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations.last?.coordinate.latitude)")
        locationManager.stopUpdatingLocation()
        let coords = "\((locations.last?.coordinate.latitude)! as CLLocationDegrees),\((locations.last?.coordinate.longitude)! as CLLocationDegrees)"
        dataSource.getNearQueues(coords: coords, callBack: self)
    }
}
