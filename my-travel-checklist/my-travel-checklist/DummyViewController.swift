//
//  DummyViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/12/22.
//

import UIKit

class DummyViewController: UIViewController, CustomToolBarDelegate {
    

    let textField = UITextField()
    
    let datey = CustomDatePicker()
    let toolbar = CustomToolBar()
    
    
    let centerView = UIStackView()
    let label = UILabel()
    let progressBar = UIProgressView()
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        style()
        layout()
        
        toolbar.customButtonsDelegate = self
        
    }
    
    
    //style
    func style() {
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.backgroundColor = .gray
        centerView.axis = .vertical
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Congrats"
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .green
        progressBar.progress = 0.4
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Click me", for: .normal)
        button.addTarget(nil, action: #selector(shakeButton), for: .allEvents)
        //textField.placeholder = "John"
        //textField.borderStyle = .roundedRect
        //textField.inputView = datey
        //textField.inputAccessoryView = toolbar
        //textField.textAlignment = NSTextAlignment.center
        
        
        
        
        
    }
    
    //layout
    func layout() {
        view.addSubview(centerView)
        centerView.addArrangedSubview(progressBar)
        centerView.addArrangedSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            //centerView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            centerView.widthAnchor.constraint(equalToConstant: 300),
            centerView.heightAnchor.constraint(equalToConstant: 300),
            centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            //button
            button.topAnchor.constraint(equalToSystemSpacingBelow: centerView.bottomAnchor, multiplier: 3),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
        
        
        
        /*view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])*/
    }

}

extension DummyViewController {
    
    @objc private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "opacity"
        animation.values = [0,0.4,0.9]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4

        animation.isAdditive = true
        progressBar.layer.add(animation, forKey:"Shake")
    }
    
    func doneButtonPressed() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        textField.text = dateFormatter1.string(from: datey.date)
        view.endEditing(true)
        print("done button pressed")
    }
    
    func cancelButtonPressed() {
        view.endEditing(true)
        print("Cancel button pressed")
    }
}
