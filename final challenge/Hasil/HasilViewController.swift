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

class HasilViewController: UIViewController, NSFetchedResultsControllerDelegate, AVAudioPlayerDelegate {
    
    
    @IBOutlet weak var progressBarHasil: UIProgressView!
    @IBOutlet weak var end_label: UILabel!
    @IBOutlet weak var start_label: UILabel!
    @IBOutlet weak var viewHasil: UIView!
    @IBOutlet weak var viewRecording: UIView!
    @IBOutlet weak var kontenHasil: UITextView!
    @IBOutlet weak var play_btn: UIButton!
    
    
    var selectedIndexPath: IndexPath!
    var audioData: Data!
    var valueWpm: Float!
    var durasiAudio: Float!
    var isPlaying = false
    var timer: Timer!
    var audioPlayer: AVAudioPlayer!
    
    
    fileprivate func setupReview() {
        if valueWpm >= 200 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(Int(self.valueWpm)) kata per menit.\n\nKecepatan bicara ini tergolong terlalu cepat untuk presentasi pada umumnya, jika tidak diperlambat, pendengar akan merasa sangat kesulitan mengikuti alur pembicaraanmu. Kecepatan ini pada umumnya hanya digunakan oleh juru lelang yang ingin menciptakan rasa mendesak pada para pendengarnya."} else
            if valueWpm >= 150 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(Int(self.valueWpm)) kata per menit.\n\nKecepatan bicara ini tergolong cepat untuk presentasi pada umumnya, jika tidak diperlambat, pendengar akan merasa kesulitan mengikuti alur pembicaraanmu. Kecepatan ini sebaiknya digunakan untuk menyampaikan poin-poin yang bersemangat atau antusiasme yang kuat."} else
                if valueWpm >= 120 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(Int(self.valueWpm)) kata per menit.\n\nKecepatan bicara anda sangat baik untuk presentasi pada umumnya, kecepatan ini membuat pendengar merasa sedang diajak dalam percakapan sehari-hari."} else
                    if valueWpm < 120 { kontenHasil.text = "Rata-rata kecepatan bicaramu adalah \(Int(self.valueWpm)) kata per menit.\n\nKecepatan bicara ini tergolong lambat untuk presentasi pada umumnya, jika tidak dipercepat, pendengar dapat merasa bosan bahkan mengantuk. Kecepatan ini sebaiknya digunakan untuk menyampaikan poin-poin krusial yang perlu dipahami dengan dalam oleh pendengar."} else
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
        
        self.initializeFetchedResultsController()
        self.setupData()
        self.setupReview()
        self.setupAudio()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupData(){
        print("indexPath : \(self.selectedIndexPath)")
        let audio = fetchedResultsController.object(at: self.selectedIndexPath)
        
        valueWpm = audio.wpm
        print("nilai wpm: \(valueWpm)")
        end_label.text = getCurrentTimeAsString(angka: Int(audio.durasi))
        
    }
    
    func setupAudio() {
        let audio = fetchedResultsController.object(at: self.selectedIndexPath)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default)
            try session.setActive(true)
            
            print("url AB:\(audio.urlAudio)")
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: audio.urlAudio, fileTypeHint: AVFileType.m4a.rawValue)
            audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            
            
        } catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }
    }
    func play(){
        if isPlaying == false {
            audioPlayer.play()
        }
    }
    
    func stop() {
        if isPlaying == true {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
    }
    func pause() {
        if isPlaying == true {
            audioPlayer.pause()
        }
    }
    
    func getCurrentTimeAsString(angka: Int) -> String {
        var seconds = 0
        var minutes = 0
        
            seconds = Int(angka) % 60
            minutes = (Int(angka) / 60) % 60
        
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func getCurrentTimeAsString() -> String {
        var seconds = 0
        var minutes = 0
        if let time = audioPlayer?.currentTime {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func getProgress() -> Float {
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = audioPlayer?.currentTime, let duration = audioPlayer?.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateViewsWithTimer(theTimer:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewsWithTimer(theTimer: Timer) {
        updateView()
    }
    
    func updateView() {
        start_label.text = self.getCurrentTimeAsString()
        let progress = self.getProgress()
        progressBarHasil.progress = progress
    }
    
    @IBAction func playAudio(_ sender: Any){
        if isPlaying {
//            self.audioPlayer.pause()
            if audioPlayer != nil {
                audioPlayer.stop()
            } else {
                // do nothing
            }
            self.play_btn.setImage(UIImage(imageLiteralResourceName: "PLAY BUTTON with shadow"), for: .normal)
            timer.invalidate()
            progressBarHasil.progress = 0.0
            isPlaying = false
        } else {
            if audioPlayer != nil {
                audioPlayer.play()
            } else {
                
            }
            self.play_btn.setImage(UIImage(imageLiteralResourceName: "pause button"), for: .normal)
            isPlaying = true
            startTimer()
            
        }
    }
    
    

}
