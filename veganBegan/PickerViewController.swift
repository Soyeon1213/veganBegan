//
//  PickerViewController.swift
//  veganBegan
//
//  Created by Release on 2021/06/07.
//  Copyright © 2021 Release. All rights reserved.
//

import UIKit

protocol sendDataDelegate {
    func dataReceived(data: String)
}

class PickerViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var showPicker: UITextField!
    @IBOutlet var here: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        showPicker.tintColor = .clear
        here.tintColor = .clear
        dismissPickerView()
    }
    

   
    let type = ["페스코", "락토오보", "락토", "오보", "비건"]
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showPicker.text = type[row]
    }
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        showPicker.inputView = pickerView
        //here.inputView = pickerView
    }
    func dismissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        showPicker.inputAccessoryView = toolBar
    }
    @objc func action() {
             
    }
    
}
