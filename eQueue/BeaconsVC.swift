//
//  BeaconsVC.swift
//  eQueue
//
//  Created by Виталий Никоноров on 28.11.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class BeaconsVC: UIViewController, BeaconScannerDelegate {
    

    var beaconScanner: BeaconScanner!
    
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
    
    func didFindBeacon(_ beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        print("FIND: %@", beaconInfo.description)
    }
    func didLoseBeacon(_ beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        print("LOST: %@", beaconInfo.description)
    }
    func didUpdateBeacon(_ beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        print("UPDATE: %@", beaconInfo.description)
    }
    func didObserveURLBeacon(_ beaconScanner: BeaconScanner, URL: Foundation.URL, RSSI: Int) {
        print("URL SEEN: %@, RSSI: %d", URL, RSSI)
    }

    

}
