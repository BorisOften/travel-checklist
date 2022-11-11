//
//  AlertViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/3/22.
//

import UIKit

class AlertViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBOutlet weak var backgroundView: UIView!
    
    var datePick = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        backgroundView.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
        datePick.preferredDatePickerStyle = .wheels
        textField.inputView = datePick
        
    }
    
    

    @IBAction func buttonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
