//
//  MyQueuesVC.swift
//  eQueue
//
//  Created by Виталий Никоноров on 09.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class MyQueuesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, QueueListCallback {
    @IBOutlet var tableView: UITableView!
    
    var dataSource: DataSource = DataSource.sharedInstance
    private var myQueues: Array<Queue> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (myQueues.count)
    };
    
    func tableView(_ tableView:  UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QueueCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QueueTableCell
        
        cell.queueName.text = myQueues[indexPath.row].name
        cell.queueDescription.text = myQueues[indexPath.row].descriprion
        cell.locationLabel.text = myQueues[indexPath.row].location
        
        cell.forwardMeLabel.text = String(describing: myQueues[indexPath.row].forwardMe)
        cell.sizeLabel.text = String(describing: myQueues[indexPath.row].size)
        cell.waitingTimeLabel.text = String(describing: myQueues[indexPath.row].waitingTime)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.myQueues(callBack: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQueueSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as? QueueScreenController
                destinationVC?.qid = myQueues[indexPath.row].qid
            }
        }
    }
    
    func onQueueListResponse(response: Array<Queue>) {
        DispatchQueue.main.async {
            self.myQueues = response
            self.tableView.reloadData()
        }
    }

}

