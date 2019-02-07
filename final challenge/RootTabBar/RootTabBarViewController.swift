//
//  RootTabBarViewController.swift
//  final challenge
//
//  Created by Alva Wijaya on 07/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.tabBarController?.toolbarItems?[0].image = #imageLiteral(resourceName: "record")
        self.tabBarItem.image = #imageLiteral(resourceName: "stop")
        
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
