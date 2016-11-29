//
//  BeaconsVC.swift
//  eQueue
//
//  Created by Виталий Никоноров on 28.11.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class BeaconsVC: UIViewController, BeaconScannerDelegate, QueueCallback, UITableViewDataSource, UITableViewDelegate {
    

    var beaconScanner: BeaconScanner!
    let URL_PATTERN = "http://equeue/"
    var dataSet = Set<Int>()
    
    var dataSource: DataSource = DataSource.sharedInstance
    private var beaconQueues: Array<Queue> = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconScanner = BeaconScanner()
        self.beaconScanner!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.beaconScanner!.startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.beaconScanner.stopScanning()
    }
    
    func onQueueInfoLoaded(response: Queue) {
        DispatchQueue.main.async {
            print("loaded \(response.qid)")
            self.beaconQueues.append(response)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (beaconQueues.count)
    };
    
    func tableView(_ tableView:  UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QueueCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QueueTableCell
        
        cell.queueName.text = beaconQueues[indexPath.row].name
        cell.queueDescription.text = beaconQueues[indexPath.row].descriprion
        cell.locationLabel.text = beaconQueues[indexPath.row].location
        
        cell.forwardMeLabel.text = String(describing: beaconQueues[indexPath.row].forwardMe)
        cell.sizeLabel.text = String(describing: beaconQueues[indexPath.row].size)
        cell.waitingTimeLabel.text = String(describing: beaconQueues[indexPath.row].waitingTime)
        
        return cell
    }
    
    func didFindBeacon(_ beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        //print("FIND: %@", beaconInfo.description)
    }
    func didLoseBeacon(_ beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        //print("LOST: %@", beaconInfo.description)
    }
    func didUpdateBeacon(_ beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        //print("UPDATE: %@", beaconInfo.description)
    }
    func didObserveURLBeacon(_ beaconScanner: BeaconScanner, URL: Foundation.URL, RSSI: Int) {
        //print("URL SEEN: %@, RSSI: %d", URL, RSSI)
        
        if (URL.absoluteString.contains(URL_PATTERN)){
            
            let id = Int(URL.absoluteString.substring(from: URL_PATTERN.endIndex))
            
            guard id != nil else {
                print("id is nil")
                return
            }
            
            guard !dataSet.contains(id!) else {
                print("id = \(id) contains")
                return
            }
        
            dataSet.insert(id!)
            dataSource.findQueueById(qid: id!, callBack: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQueueSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as? QueueScreenController
                tableView.deselectRow(at: indexPath, animated: true)
                destinationVC?.qid = beaconQueues[indexPath.row].qid
            }
        }
    }
    
}
