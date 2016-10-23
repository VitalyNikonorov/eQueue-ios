//
//  QueueScreenController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 23.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class QueueScreenController : UIViewController {

    var queue : Queue!
    
    @IBOutlet var queueSizeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        queueSizeLabel.text = String(describing: queue.size)
        title = queue.name
    }
}
