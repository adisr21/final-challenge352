//
//  LatihanTopicVC.swift
//  final challenge
//
//  Created by Adi Sukarno Rachman on 08/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit

class LatihanTopicVC: UIViewController {

    @IBOutlet weak var viewTextTopic: UIView!
    @IBOutlet weak var text_topic: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewTextTopic.layer.borderWidth = 2
        viewTextTopic.layer.borderColor = UIColor.orange.cgColor
        viewTextTopic.clipsToBounds = true
        
        viewTextTopic.layer.cornerRadius = 10.0
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
