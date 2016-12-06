//
//  MyQueuesVC.swift
//  eQueue
//
//  Created by Виталий Никоноров on 09.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class MyQueuesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkRequestCallback {
    @IBOutlet var tableView: UITableView!
    
    var dataSource: DataSource = DataSource.sharedInstance
    private var myQueues: Array<Queue> = []
    
    let refreshControl = UIRefreshControl()
    
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        refreshControl.addTarget(self, action: #selector(MyQueuesVC.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        updateData()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl){
        updateData()
    }
    
    func updateData(){
        if (dataSource.isTokenOK()){
            dataSource.getMyQueues(callBack: self)
        } else {
            self.refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQueueSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
                let destinationVC = segue.destination as? QueueScreenController
                destinationVC?.qid = myQueues[indexPath.row].qid
            }
        }
    }
    
    func onSucces(response: Any, type: RequestType) {
        
        switch type {
        case .queueList:
            if let resp = response as? Array<Queue>{
                DispatchQueue.main.async {
                    self.myQueues = resp
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        case .queue: break
        case .joinQueue: break
        }
    }

    func onError(error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

