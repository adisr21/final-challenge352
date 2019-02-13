//
//  HasilViewController.swift
//  final challenge
//
//  Created by andry martin on 07/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class HasilViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var viewHasil: UIView!
    @IBOutlet weak var viewRecording: UIView!
    @IBOutlet weak var kontenHasil: UITextView!
    
    var selectedIndexPath: IndexPath!
    var audioData: Data!
    var valueWpm: Float!
    var durasiAudio: Float!
    
    fileprivate func setupReview() {
        if valueWpm >= 200 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(self.valueWpm) kata per menit.\n\nKecepatan bicara ini tergolong terlalu cepat untuk presentasi pada umumnya, jika tidak diperlambat, pendengar akan merasa sangat kesulitan mengikuti alur pembicaraanmu. Kecepatan ini pada umumnya hanya digunakan oleh juru lelang yang ingin menciptakan rasa mendesak pada para pendengarnya."} else
            if valueWpm >= 150 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(self.valueWpm) kata per menit.\n\nKecepatan bicara ini tergolong cepat untuk presentasi pada umumnya, jika tidak diperlambat, pendengar akan merasa kesulitan mengikuti alur pembicaraanmu. Kecepatan ini sebaiknya digunakan untuk menyampaikan poin-poin yang bersemangat atau antusiasme yang kuat."} else
                if valueWpm >= 120 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(self.valueWpm) kata per menit.\n\nKecepatan bicara anda sangat baik untuk presentasi pada umumnya, kecepatan ini membuat pendengar merasa sedang diajak dalam percakapan sehari-hari."} else
                    if valueWpm < 120 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(self.valueWpm) kata per menit.\n\nKecepatan bicara ini tergolong lambat untuk presentasi pada umumnya, jika tidak dipercepat, pendengar dapat merasa bosan bahkan mengantuk. Kecepatan ini sebaiknya digunakan untuk menyampaikan poin-poin krusial yang perlu dipahami dengan dalam oleh pendengar."} else
                    {kontenHasil.text = "Unidentified."}
    }
    
    var fetchedResultsController: NSFetchedResultsController<Audio>!
    
    let coreDataAudio = CoreDataAudio(modelName: "final_challenge")
    
    func initializeFetchedResultsController(){
        let request = NSFetchRequest<Audio>(entityName: "Audio")
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [dateSort]
        
        let moc = coreDataAudio.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHasil.layer.borderWidth = 2
        viewHasil.layer.borderColor = UIColor.orange.cgColor
        viewHasil.clipsToBounds = true
        viewHasil.layer.cornerRadius = 10.0
        
        viewRecording.layer.borderWidth = 2
        viewRecording.layer.borderColor = UIColor.orange.cgColor
        viewRecording.clipsToBounds = true
        viewRecording.layer.cornerRadius = 10.0
        kontenHasil.isEditable = false
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.initializeFetchedResultsController()
        self.setupData()
        self.setupReview()
    }
    
    func setupData(){
        print("indexPath : \(self.selectedIndexPath)")
        let audio = fetchedResultsController.object(at: self.selectedIndexPath)
        
        valueWpm = audio.wpm
        print("nilai wpm: \(valueWpm)")
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
