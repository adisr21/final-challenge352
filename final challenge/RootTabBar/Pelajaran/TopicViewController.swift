//
//  TopicViewController.swift
//  spiki
//
//  Created by Alva Wijaya on 04/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit

class TopicViewController: UITableViewController {

    let sectionTitles = ["Membaca Teks"]
    
    var dataTopic = [
        [
            LessonData(title: "", subtitle: ""),
            LessonData(title: "", subtitle: ""),
            LessonData(title: "", subtitle: "")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.tintColor=UIColor.orange
        tabBarController?.tabBar.barTintColor=UIColor.black
        tabBarController?.tabBar.tintColor=UIColor.orange
        self.tableView.backgroundColor = .black
        
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor=UIColor.white
    }
    
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.backgroundColor = UIColor.clear
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles=false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title="Topic"
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        let headline = self.dataTopic[indexPath.section][indexPath.row]
        let titleLabel = (cell.viewWithTag(101) as! UILabel)
        //let descriptionLabel =  (cell.viewWithTag(102) as! UILabel)
        let backgroundView = UIView()
        titleLabel.text = headline.title
        titleLabel.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        //descriptionLabel.text = headline.subtitle
        //descriptionLabel.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        cell.backgroundColor = UIColor.clear
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTopic[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.headerView(forSection: section)?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Konfirmasi", message: "Apakah anda yakin dengan topik yang anda pilih", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: nil/*{ action in
            self.performSegue(withIdentifier: "PromptLesson", sender: self)
        }*/))
        alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}
