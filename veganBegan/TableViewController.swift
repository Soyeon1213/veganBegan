//
//  TableViewController.swift
//  veganBegan
//
//  Created by Release on 2021/06/13.
//  Copyright © 2021 Release. All rights reserved.
//

import SwiftUI

class TableViewController: UITableViewController{
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableview", for: indexpath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        if indexpath.row % 5 == 0{
            label.text = "a"
        }else if indexpath.row % 5 == 1{
            label.text = "b"
        }else if indexpath.row % 5 == 2{
        label.text = "c"
        }else if indexpath.row % 5 == 3{
        label.text = "d"
        }else if indexpath.row % 5 == 4{
            label.text = "e"}
        
        return cell
        }
}
