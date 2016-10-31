//
//  SearchByIdController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 24.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class SearchByIdController : UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQueueSegue"{
            let dataSource: DataSource = DataSource.sharedInstance
            let destinationVC = segue.destination as? QueueScreenController
            destinationVC?.queue = dataSource.getMyQueues()[0]
        }
    }
    
}
