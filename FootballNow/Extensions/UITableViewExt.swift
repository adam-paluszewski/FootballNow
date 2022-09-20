//
//  UITableViewExt.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 04/09/2022.
//

import UIKit


extension UITableView {
    
    func prepareForDynamicHeight() {
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
    }
   
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
