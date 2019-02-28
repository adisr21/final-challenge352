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
    var selectedIndex : IndexPath!
    var section: Int!
    
    var dataTopic = [
        [
            LessonData(title: "Alam", subtitle: "Komodo adalah reptil spesies kadal terbesar di dunia, komodo dewasa di alam bebas pada umumnya memiliki berat 70 kilogram dengan panjang antara 2 sampai 3 meter. Nama dari reptil ini diambil dari nama habitat alaminya yaitu Pulau Komodo yang merupakan bagian dari Provinsi Nusa Tenggara Timur. Pulau Komodo mempunyai luas 390 kilometer persegi dan jumlah populasi lebih dari 2000 jiwa. Di pulau ini terdapat satu dari tujuh Pantai Merah Muda di dunia yang dikenal karena keindahan warna pasirnya yang berwarna merah muda. Pada tahun 1980, Taman Nasional Komodo didirikan dengan tujuan melindungi komodo dari kepunahan sekaligus mencegah habitat alaminya mengalami kerusakan, taman nasional ini mencakup dua pulau besar lainnya yaitu Pulau Rinca dan Pulau Padar. Pada tahun 2011, Taman Nasional Komodo dinobatkan sebagai salah satu dari Tujuh Keajaiban Dunia Baru."),
            LessonData(title: "Kesehatan", subtitle: "Kesehatan fisik merupakan suatu hal yang sangat penting, akan tetapi menjaga kesehatan mental juga merupakan hal yang tidak kalah pentingnya. Kesehatan mental yang buruk seringkali membawa orang ke jurang depresi dan memicu bunuh diri. Pada tahun 2018, Organisasi Kesehatan Dunia memperkirakan bahwa setiap 40 detik, seseorang di dunia mengakhiri hidupnya. Orang yang mengalami depresi sering kali tidak menyadari kemunculan gangguan tersebut. Depresi dapat dicegah dengan menjaga kesehatan mental dengan baik, kesehatan mental dapat dijaga dengan beberapa cara seperti lebih menerima dan menghargai diri, aktif berkegiatan seperti olahraga atau bergabung di suatu komunitas, dan mau membuka diri untuk bercerita pada orang lain."),
            LessonData(title: "", subtitle: "")
        ],
        [
            LessonData(title: "Kesehatan", subtitle: "1. Angka kematian ibu melahirkan di Indonesia. \n 2. Penyebab \n \t a. Kurangnya kualitas pelayanan \n \t b. Hipertensi kehamilan \n \t c. Pernikahan dini \n 3. Solusi \n \t a. Sumber daya manusia di puskesmas \n \t b. Perbaikan edukasi \n \t c. Peran pemerintahan daerah"),
            LessonData(title: "Budaya", subtitle: "1. Tari Saman \n2. Asal \n3. Arti"),
            LessonData(title: "Ekonomi", subtitle: "1. Korupsi \n 2. Penyebab\n\t a. Faktor internal\n\t\t i. Rasa tamak\n\t\t ii. Gaya hidup boros \n\t\t iii. Moral yang lemah \n\t b. Faktor eksternal \n\t\t i. Ketidakpuasan dengan pangkat politik \n\t\t ii. Pendapatan yang dirasa kurang \n\t\t iii. Hukum yang kurang tegas.\n 3. Dampak \n\t a. Kepercayaan masyarakat menurun \n\t b. Pendapatan negara berkurang \n\t c. Pengembangan infrastruktur negara melambat \n\t d. Budaya korupsi berlanjut")
        ],
        
    ]
    
    var topicDetail = [
        [
            LessonData(title: "Alam", subtitle: "Komodo adalah reptil spesies kadal terbesar di dunia, komodo dewasa di alam bebas pada umumnya memiliki berat 70 kilogram dengan panjang antara 2 sampai 3 meter. Nama dari reptil ini diambil dari nama habitat alaminya yaitu Pulau Komodo yang merupakan bagian dari Provinsi Nusa Tenggara Timur. Pulau Komodo mempunyai luas 390 kilometer persegi dan jumlah populasi lebih dari 2000 jiwa. Di pulau ini terdapat satu dari tujuh Pantai Merah Muda di dunia yang dikenal karena keindahan warna pasirnya yang berwarna merah muda. Pada tahun 1980, Taman Nasional Komodo didirikan dengan tujuan melindungi komodo dari kepunahan sekaligus mencegah habitat alaminya mengalami kerusakan, taman nasional ini mencakup dua pulau besar lainnya yaitu Pulau Rinca dan Pulau Padar. Pada tahun 2011, Taman Nasional Komodo dinobatkan sebagai salah satu dari Tujuh Keajaiban Dunia Baru."),
            LessonData(title: "Kesehatan", subtitle: "Kesehatan fisik merupakan suatu hal yang sangat penting, akan tetapi menjaga kesehatan mental juga merupakan hal yang tidak kalah pentingnya. Kesehatan mental yang buruk seringkali membawa orang ke jurang depresi dan memicu bunuh diri. Pada tahun 2018, Organisasi Kesehatan Dunia memperkirakan bahwa setiap 40 detik, seseorang di dunia mengakhiri hidupnya. Orang yang mengalami depresi sering kali tidak menyadari kemunculan gangguan tersebut. Depresi dapat dicegah dengan menjaga kesehatan mental dengan baik, kesehatan mental dapat dijaga dengan beberapa cara seperti lebih menerima dan menghargai diri, aktif berkegiatan seperti olahraga atau bergabung di suatu komunitas, dan mau membuka diri untuk bercerita pada orang lain.")
        
        ],
        [
            LessonData(title: "Kesehatan", subtitle: "1. Angka kematian ibu melahirkan di Indonesia. \n 2. Penyebab \n \t a. Kurangnya kualitas pelayanan \n \t b. Hipertensi kehamilan \n \t c. Pernikahan dini \n 3. Solusi \n \t a. Sumber daya manusia di puskesmas \n \t b. Perbaikan edukasi \n \t c. Peran pemerintahan daerah"),
            LessonData(title: "Budaya", subtitle: "1. Tari Saman \n 2. Asal \n 3. Arti"),
            LessonData(title: "Ekonomi", subtitle: "1. Korupsi \n 2. Penyebab\n\t a. Faktor internal\n\t\t i. Rasa tamak\n\t\t ii. Gaya hidup boros \n\t\t iii. Moral yang lemah \n\t b. Faktor eksternal \n\t\t i. Ketidakpuasan dengan pangkat politik \n\t\t ii. Pendapatan yang dirasa kurang \n\t\t iii. Hukum yang kurang tegas.\n 3. Dampak \n\t a. Kepercayaan masyarakat menurun \n\t b. Pendapatan negara berkurang \n\t c. Pengembangan infrastruktur negara melambat \n\t d. Budaya korupsi berlanjut")
        ],
        [
            LessonData(title: "Kesehatan", subtitle: "1. Aktivitas seperti apa yang anda lakukan untuk menjaga kesehatan tubuh anda? \n 2. Jenis olahraga apa yang paling anda gemari? Mengapa? \n 3. Jika Anda mempunyai kekuatan untuk menghilangkan suatu jenis penyakit di dunia ini, penyakit apakah itu? Mengapa?"),
            LessonData(title: "Sosial", subtitle: "1. Bagaimana Anda menjelaskan pada turis yang tidak mahir berbahasa Indonesia terkait keindahan alam di Indonesia? \n 2. Bayangkan Anda baru saja bergabung di suatu perusahaan dan menjadi anggota baru di suatu tim, bagaimana Anda memperkenalkan diri Anda kepada para anggota lainnya?"),
            LessonData(title: "Dirimu", subtitle: "1. Atribut positif apa yang ada dalam diri Anda yang Anda ingi  orang lain ketahui? \n 2. Apa makanan kesukaan Anda? Mengapa? \n 3. Hal apa yang menjadi hobi/kegemaran Anda? Bagaimana Anda mengajak orang lain untuk mencoba hal yang Anda gemari ini?")
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
        navigationItem.title="Topik"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        let headline = self.dataTopic[indexPath.section][indexPath.row]
        let titleLabel = (cell.viewWithTag(101) as! UILabel)
        let descriptionLabel =  (cell.viewWithTag(102) as! UILabel)
        let backgroundView = UIView()
        titleLabel.text = headline.title
        titleLabel.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        descriptionLabel.text = headline.subtitle
        descriptionLabel.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
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
    
    fileprivate func selectedTopic() {
        let alert = UIAlertController(title: "Konfirmasi", message: "Apakah anda yakin dengan topik yang anda pilih", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { action -> Void in
            self.performSegue(withIdentifier: "recordTopic", sender: self)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
//        self.section = selectedIndex.section
        //selectedTopic()
        self.performSegue(withIdentifier: "recordTopic", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is LatihanTopicVC
        {
            let vc = segue.destination as? LatihanTopicVC
//            if ((vc?.dataTopic = dataTopic) != nil) {
//                vc?.dataTopic[selectedIndex.section][selectedIndex.row] = dataTopic[selectedIndex.section][selectedIndex.row]
            vc?.dataTopic = self.dataTopic
                vc?.selectedIndex = self.selectedIndex
            vc?.section = self.section
            print("prepare section TVC : \(self.section)")
            
//            }
        }
    }
}
