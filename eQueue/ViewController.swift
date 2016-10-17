//
//  ViewController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 09.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var array = ["Queue1", "Queue2"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    };
    
    func tableView(_ tableView:  UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QueueCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "queue_icon")
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

