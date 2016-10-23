//
//  ViewController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 09.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataSource: DataSource = DataSource()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource.getMyQueues().count)
    };
    
    func tableView(_ tableView:  UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QueueCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QueueTableCell
        
        cell.queueName.text = dataSource.getMyQueues()[indexPath.row].name
        cell.queueDescription.text = dataSource.getMyQueues()[indexPath.row].descriprion
        cell.locationLabel.text = dataSource.getMyQueues()[indexPath.row].location
        
        cell.forwardMeLabel.text = String(describing: dataSource.getMyQueues()[indexPath.row].forwardMe)
        cell.sizeLabel.text = String(describing: dataSource.getMyQueues()[indexPath.row].size)
        cell.waitingTimeLabel.text = String(describing: dataSource.getMyQueues()[indexPath.row].waitingTime)
        
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

