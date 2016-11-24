//
//  SearchByIdController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 24.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class SearchByIdController : UIViewController, QueueCallback {
    
    @IBOutlet var idTextField: UITextField!
    
    override func viewDidLoad() {
        self.idTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    internal func onQueueInfoLoaded(response: Dictionary<String, AnyObject>) {
        
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "QueueController") as? QueueScreenController else {
            print("Could not instantiate view controller with identifier of type SecondViewController")
            return
        }
        
        let bodyJson = response["body"] as! Dictionary<String, AnyObject>
        
        let q = Queue( qid: (bodyJson["qid"] as AnyObject? as? Int) ?? -1, name: (bodyJson["name"] as AnyObject? as? String) ?? "", description: (bodyJson["description"] as AnyObject? as? String) ?? "", location: (bodyJson["address"] as AnyObject? as? String) ?? "", waitingTime: (bodyJson["wait_time"] as AnyObject? as? Int) ?? 0, size: (bodyJson["number"] as AnyObject? as? Int) ?? 0, forwardMe: (bodyJson["in_front"] as AnyObject? as? Int) ?? 0, coords: (bodyJson["coords"] as AnyObject? as? String) ?? "")
        
        
        vc.queue = q
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }


    let dataSource: DataSource = DataSource.sharedInstance
    @IBAction func findBtnClick(_ sender: Any) {
        dataSource.findQueueById(qid: 1, callBack: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQueueSegue"{
            let destinationVC = segue.destination as? QueueScreenController
            destinationVC?.queue = dataSource.getMyQueues()[0]
        }
    }
    
}

protocol QueueCallback {
    func onQueueInfoLoaded(response: Dictionary<String, AnyObject>);
}
