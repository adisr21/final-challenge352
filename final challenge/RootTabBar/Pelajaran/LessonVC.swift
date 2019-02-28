//
//  LessonVC.swift
//  Sepiki
//
//  Created by Alva Wijaya on 28/01/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit

class LessonVC: UITableViewController {


    
    var selectedIndex : IndexPath!
    let sectionTitles = ["Kecepatan Berbicara"]

    let dataLesson = [
        [
            LessonData(title: "Membaca Teks", subtitle: "Melatih pelafalan tiap kata"),
            LessonData(title: "Menghubungkan Fakta", subtitle: "Melatih penggunanaan kata sambung"),
            LessonData(title: "Pertanyaan Pemicu", subtitle: "Berlatih dengan bantuan pertanyaan")
        ]
//        [LessonData(title: "text", subtitle: "texttexttexttexttexttexttext"),
//         LessonData(title: "text", subtitle: "texttexttexttexttexttexttext")
//        ],
//        [LessonData(title: "text", subtitle: "texttexttexttexttexttexttext"),
//         LessonData(title: "text", subtitle: "texttexttexttexttexttexttext"),
//         LessonData(title: "text", subtitle: "texttexttexttexttexttexttext")]
    ]


    let dataTopic = [
        "Membaca Teks" : [
            [
                LessonData(title: "Alam", subtitle: ""),
                LessonData(title: "Kesehatan", subtitle: ""),
                LessonData(title: "Sosial", subtitle: "")
            ]
        ],
        "Menghubungkan Fakta" : [
            [
                LessonData(title: "Kesehatan", subtitle: ""),
                LessonData(title: "Budaya", subtitle: ""),
                LessonData(title: "Ekonomi", subtitle: "")
            ]
        ],
        "Pertanyaan Pemicu" : [
            [
                LessonData(title: "Kesehatan", subtitle: ""),
                LessonData(title: "Sosial", subtitle: ""),
                LessonData(title: "Dirimu", subtitle: "")
            ]
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.orange]
        navigationController?.navigationBar.tintColor = UIColor.orange
        tabBarController?.tabBar.barTintColor = UIColor.black
        tabBarController?.tabBar.tintColor = UIColor.orange
        self.tableView.backgroundColor = .black

    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor=UIColor.white
    }
    


    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles=true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title="Pelajaran"
        
    }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath)
        let headline = self.dataLesson[indexPath.section][indexPath.row]
        let backgroundView = UIView()
        let titleLabel = (cell.viewWithTag(101) as! UILabel)
        let descriptionLabel =  (cell.viewWithTag(102) as! UILabel)
        let viewBeautifikasi=(cell.viewWithTag(103) as! UIView)
        viewBeautifikasi.layer.borderWidth = 2
        viewBeautifikasi.layer.backgroundColor=#colorLiteral(red: 0.1481781304, green: 0.1530496776, blue: 0.1572969854, alpha: 1)
        viewBeautifikasi.clipsToBounds = true
        viewBeautifikasi.layer.cornerRadius = 10.0
        viewBeautifikasi.layer.borderColor = UIColor.clear.cgColor
        titleLabel.text = headline.title
        titleLabel.textColor = .orange
        descriptionLabel.text = headline.subtitle
        descriptionLabel.textColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.backgroundColor = UIColor.clear
        
        cell.selectionStyle = .none
        
        //backgroundView.backgroundColor = .red
        //cell.selectedBackgroundView?.backgroundColor = .red
        //cell.tintColor = .red
//        let img = UIImage(named: "right-arrow")!
//        let imgView:UIImageView = UIImageView()
//        imgView.contentMode = UIView.ContentMode.scaleAspectFill
//        imgView.frame.size.width = 10.0
//        imgView.frame.size.height = 10.0
//        imgView.image = img
//        imgView.image = imgView.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //imgView.tintColor = UIColor.orange
        //cell.accessoryView = imgView

//        if(cell.isSelected){
//            viewBeautifikasi.layer.backgroundColor = UIColor.red.cgColor
//            cell.backgroundColor=UIColor.red
//        }else{
//            cell.backgroundColor = UIColor.clear
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        let viewBeautifikasi=(cell?.viewWithTag(103) as! UIView)
        //cell!.contentView.backgroundColor = .red
        viewBeautifikasi.layer.backgroundColor=UIColor.orange.cgColor
    }

    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
        let viewBeautifikasi=(cell?.viewWithTag(103) as! UIView)
        viewBeautifikasi.layer.backgroundColor=#colorLiteral(red: 0.1481781304, green: 0.1530496776, blue: 0.1572969854, alpha: 1)
        
    }
    
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath as IndexPath)!
//        cellToDeSelect.contentView.backgroundColor = UIColor.blue
//    }
    
    
    //colorForCellUnselected is just a var in my class
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLesson[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.headerView(forSection: section)?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex=indexPath
        self.performSegue(withIdentifier: "TopicVC", sender: self)
        var selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.red
        //selectedCell.accessoryView?.tintColor = UIColor.red

    }
    var section: Int!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let VC=segue.destination as? TopicViewController
        {
            let headline = self.dataLesson[selectedIndex.section][selectedIndex.row]
            if let dataTopic = dataTopic[headline.title]
            {
                VC.dataTopic = dataTopic
                VC.section = selectedIndex.row
            }
        }
    }
}
