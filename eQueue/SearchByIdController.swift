//
//  SearchByIdController.swift
//  eQueue
//
//  Created by Виталий Никоноров on 24.10.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit

class SearchByIdController : UIViewController {
    
    @IBOutlet var idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchByIdController.dismissKeyboard))
        view.addGestureRecognizer(tapOutside)
        
        self.idTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    let dataSource: DataSource = DataSource.sharedInstance
    @IBAction func findBtnClick(_ sender: Any) {
        
        let id = Int(idTextField.text!)
        
        if(id != nil){
            guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "QueueController") as? QueueScreenController else {
                print("Could not instantiate view controller with identifier of type SecondViewController")
                return
            }
            
            vc.qid = Int(id!)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated:true)
            }
        } else {
            self.showAlert(message: "Значение id должно быть числом!")
        }
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Недопустимое значение", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
