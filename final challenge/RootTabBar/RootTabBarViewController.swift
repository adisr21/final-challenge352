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

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.items?[0].image = #imageLiteral(resourceName: "Lesson active")
        self.tabBar.items?[0].title = "Pelajaran"
        
        self.tabBar.items?[1].image = #imageLiteral(resourceName: "practice active")
        self.tabBar.items?[1].title = "Latihan"
        
        self.tabBar.items?[2].image = #imageLiteral(resourceName: "history active")
        self.tabBar.items?[2].title = "Riwayat"
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
