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
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
//    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles=true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title="Pelajaran"
    }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath)
        let headline = self.dataLesson[indexPath.section][indexPath.row]
        let titleLabel = (cell.viewWithTag(101) as! UILabel)
        let descriptionLabel =  (cell.viewWithTag(102) as! UILabel)
        let backgroundView = UIView()
        titleLabel.text = headline.title
        titleLabel.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
  //      titleLabel.tintColor=#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        descriptionLabel.text = headline.subtitle
        descriptionLabel.textColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.backgroundColor = UIColor.clear
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView

        return cell
    }

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
        self.performSegue(withIdentifier: "PromptLesson", sender: self)


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let VC=segue.destination as? TopicViewController
        {
            let headline = self.dataLesson[selectedIndex.section][selectedIndex.row]
            if let dataTopic = dataTopic[headline.title]
            {
                VC.dataTopic = dataTopic
            }
        }
    }
}
