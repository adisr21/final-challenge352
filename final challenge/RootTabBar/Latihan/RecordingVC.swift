//
//  RecordingVC.swift
//  spiki
//
//  Created by Adi Sukarno Rachman on 01/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Speech
import Foundation


class RecordingVC: UIViewController, AVAudioRecorderDelegate, NSFetchedResultsControllerDelegate, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate{
    
    // atribut recording
    @IBOutlet var recording_TimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    @IBOutlet var background_text: UIView!
    @IBOutlet var text_semangat: UILabel!
    @IBOutlet var my_range_wpm: UILabel!
    @IBOutlet var titleNavBar: UINavigationItem!
    
    let radarLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var meterTimer: Timer!
    var currentTime = 0
    var jedaWaktu = 0
    var jeda: Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var durationRecording: Int!
    var circleView: UIView!
    var radarView:UIView!
    var konten: String!
    var titleRecordings: String!
    var nilaiWPM: Float!
    var urlTemp: URL?
    
    var audios = [Audio]()
    var fetchedResultsController: NSFetchedResultsController<Audio>!
    
    let audioEngine = AVAudioEngine()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))  //1
    
    
    let coreDataAudio = CoreDataAudio(modelName: "final_challenge")
    
    func initializeFetchedResultsController(){
        let request = NSFetchRequest<Audio>(entityName: "Audio")
        let dateSort = NSSortDescriptor(key: "id", ascending: true)
        
        
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
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.tintColor=UIColor.orange
        // Do any additional setup after loading the view.
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                //                self.microphoneButton.isEnabled = isButtonEnabled
                self.record_btn_ref.isEnabled = isButtonEnabled
            }
        }
    }
    
    @IBAction func startSpeech(_ sender: UIButton)
    {
        if(audioEngine.isRunning)
        {
            stopRecognitionSpeech()
            meterTimer.invalidate()
            removeAnimateCircleAndRadarLayer()
            addTitleRecording()
            
            record_btn_ref.setImage(UIImage(named: "record-1"), for: .normal)
            record_btn_ref.isEnabled = false
            self.recording_TimeLabel.text = "00:00"
//            isRecording = false
        }
        else
        {
            startRecognitionSpeech()
            setupRecord()
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            record_btn_ref.setImage(UIImage(named: "stop-1"), for: .normal)
//            isRecording = true
        }
    }
    
    func removeAnimateCircleAndRadarLayer() {
        self.radarLayer.removeAllAnimations()
//        setupCircular()
    }
    
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    
    func setupRecord() {
        
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .measurement)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            guard let getURL = self.getFileUrl() else {
                return
            }
            self.urlTemp = getURL
            
            guard let urlTemp = self.urlTemp else {
                return
            }
            audioRecorder = try AVAudioRecorder(url: urlTemp, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
        }
        catch let error {
//            display_alert(msg_title: "Error", msg_desc:error.localizedDescription, action_title: "OK")
            print(error.localizedDescription)
        }

        
    }
    
    
    func stopRecognitionSpeech() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    fileprivate func setupRadarLayer() {
        //setup radar layer
        //        let center = CGPoint(x: 185.0, y: 545.0)
        let radarPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        
        radarLayer.path = radarPath.cgPath
        radarLayer.strokeColor = UIColor.white.cgColor
        radarLayer.lineWidth = 10
        radarLayer.fillColor = UIColor.clear.cgColor
        radarView.layer.addSublayer(radarLayer)
    }
    
    fileprivate func setupCircleLayer() {
        //setup circle layer
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.lineWidth = 10
        circleLayer.fillColor = UIColor.orangeS.cgColor
        circleLayer.strokeColor = UIColor.clear.cgColor
        circleView.layer.addSublayer(circleLayer)
    }
    
    func setupCircular() {
        setupRadarLayer()
        setupCircleLayer()
        
        // add tap gesture
        //        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateCircle)))
    }
    
    @objc func animateCircle(from lastValue: CGFloat, to value: CGFloat){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        
        animation.fromValue = lastValue
        animation.toValue = value
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
//        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
//        scaleAnimation.fromValue = 0
//        scaleAnimation.toValue = 1
//
//        let alphaAnimation = CABasicAnimation(keyPath: "transform.scale")
//        alphaAnimation.fromValue = 1
//        alphaAnimation.toValue = 0
//
//        let animations = CAAnimationGroup()
//        animations.duration = 5.0
//        animations.repeatCount = Float.infinity
        
//        animations.animations = [scaleAnimation]
        
//        circleLayer.add(animations, forKey: "scale")
//        radarLayer.add(animations, forKey: "scale radar")
        radarLayer.add(animation, forKey: "pulsating")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.check_record_permission()
        self.titleNavBar.title = "Latihan"
//        self.background_text.addRoundedBorder(ofWidth: 1, radius: 11, color: UIColor.orangeS.cgColor)
//        self.background_text.shapedBackground()
//        self.text_semangat.text = "Try to keep your speed within your range goal!"
        self.my_range_wpm.text = "Yoyoyo Ganbatte!"
        self.my_range_wpm.textColor = UIColor.orangeS
        self.konten = ""
        self.durationRecording = 0
        self.circleView = UIView(frame: CGRect(x: 185.0, y: 300.0, width: 300, height: 300))
        self.radarView = UIView(frame: CGRect(x: 185.0, y: 300.0, width: 300, height: 300))
        self.view.addSubview(circleView)
        self.view.addSubview(radarView)
        self.setupCircular()
        
        
    }
    
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
            } catch {
                print("Error...")
            }
            var audioTrack: Data?
            
            do {
                audioTrack = try Data(contentsOf: audioRecorder.url)
            } catch {
                print("Error...")
            }
            
            
            
            addMediaCaptureToDB(audioTrack!, mediaType: "Recording")
            
            audioRecorder.stop()
            audioRecorder = nil
            print("recorded successfully.")
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    
    func addMediaCaptureToDB(_ mediaData: Data, mediaType: String)
    {
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        
        //        let coreDataManager = NSPersistentContainer(name: "RecordingData")
        
        
//        let context = appDelegate.persistentContainer.viewContext
        let moc = coreDataAudio.managedObjectContext
        
        guard let newRec = NSEntityDescription.insertNewObject(forEntityName: "Audio", into: moc) as? Audio else
        {
            print("Error add media to DB")
            return
        }
        //        let uuid = UUID().uuid
        newRec.id = UUID()
        newRec.audio = mediaData as NSData
        newRec.date = NSDate()
        newRec.durasi = Int16(durationRecording)
        newRec.titleRecording = self.titleRecordings!
        newRec.konten = self.konten
        newRec.wpm = self.nilaiWPM!
        guard let getURL = self.urlTemp else {
            return
        }
        newRec.urlAudio = getURL
        
        
        //        newRec.speech = mediaData.description
        // Save the new MediaCapture record to the database
        
//        let userentity = NSEntityDescription.entity(forEntityName: "Audio", in: moc)
        
        
        
//        let newRec1 = NSManagedObject(entity: userentity!, insertInto: moc)
//        newRec1.setValue(newRec.date, forKey: "date")
//        newRec1.setValue(newRec.titleRecording, forKey: "titleRecording")
//        newRec1.setValue(newRec.audio, forKey: "audio")
//        newRec1.setValue(newRec.durasi, forKey: "durasi")
//        newRec1.setValue(newRec.konten, forKey: "konten")
        //        newRec1.setValue(newRec.speech, forKey: "speech")
        //        newRec1.setValue(newRec.id, forKey: "id")
        
        
        
        do {
            try moc.save()
            print("Sukses save di core data gan!")
            
            //print
            
            //            print("Audio: \(String(describing: newRec.audio))")
            print("Created at: \(String(describing: newRec.date))")
            //            print("Speecj: \(String(describing: newRec.speech))")
            print("Title: \(String(describing: newRec.titleRecording))")
            print("Durasi: \(String(describing: newRec.durasi))")
            print("ID: \(String(describing: newRec.id))")
            print("konten: \(String(describing: newRec.konten))")
            
            
        } catch {
            print("Error save media to DB")
        }
        
        self.recording_TimeLabel.text = "00:00"

    }
    
    
    func check_record_permission(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL? {
//        guard let titleRecording = self.titleRecordings else {
//            return nil
//        }
        let filename = "\(UUID().uuidString).m4a"
        self.titleRecordings = filename
        let filepath = getDocumentsDirectory().appendingPathComponent(filename)
        return filepath
    }
    
    
    func startRecognitionSpeech() {
        self.currentTime = 0
        startRecording()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if audioEngine.isRunning {
            stopRecognitionSpeech()
            self.text_semangat.text = tempResult
            audioEngine.inputNode.removeTap(onBus: 0)
            jeda = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(jedaToRelaunch), userInfo: nil, repeats: true)
        }
    }
    
    @objc func jedaToRelaunch() {
        jedaWaktu += 1
        if jedaWaktu == 3 {
            startRecognitionSpeech()
        }
        if jedaWaktu > 3 {
            jedaWaktu = 0
            jeda.invalidate()
        }
    }
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.record, mode: .measurement, options: .defaultToSpeaker)
            try session.setActive(true, options: .notifyOthersOnDeactivation)

        }
        catch let error {
//            display_alert(msg_title: "Error", msg_desc:error.localizedDescription, action_title: "OK")
            print(error.localizedDescription)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                
                
                guard let result_ = result?.bestTranscription.formattedString else {
                    return
                }
                self.konten = self.tempResult+" "+result_
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                
                self.record_btn_ref.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        
//        text_semangat.text = "Say something, I'm listening"
        
        
    }
    
    func getWordsCount(kntn: String){
        
        let komponen = kntn.components(separatedBy: .whitespaces)
        let jumlah_kata = komponen.filter { !$0.isEmpty }
        
        print("jumlah kata \(jumlah_kata.count)")
        print("WPM : \(getWPM(words: jumlah_kata.count))")
    }
    
    func getWPM(words: Int) -> Float {
        let minutes = Float(Float(durationRecording) / 60.0)
        let word = Float(words)
        let wpm = Float(word / minutes)
        
        self.nilaiWPM = wpm 
        if (wpm < 120 ){
            self.my_range_wpm.text = "Ayo Semangat dong"
            self.animateCircle(from: 0.4,to: 0.1)
        } else if((wpm > 120 || wpm < 150)) {
            self.my_range_wpm.text = "Sudah Pas! Pertahankan!"
            self.animateCircle(from: 0.6,to: 1.4)
        } else if (wpm > 150){
            self.my_range_wpm.text = "Woah... Rileks.. Atur Nafasmu"
            self.animateCircle(from: 1.4,to: 2.0)
        }
        
        return wpm
    }
    
    func isPassingTime() -> Bool {
        if self.durationRecording > 15 {
            return true
        } else {
            return false
        }
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        self.currentTime += 1
        updateTimerLabel()
        if self.currentTime == 60 {
            self.tempResult = self.konten
            audioEngine.inputNode.removeTap(onBus: 0)
            stopRecognitionSpeech()
        } else if self.currentTime == 63{
            startRecognitionSpeech()
        }
    }
    
    func updateTimerLabel() {
        
        self.getWordsCount(kntn: self.konten)
//                    let hr = Int((audioRecorder.currentTime / 60) / 60)
        let min = Int(audioRecorder.currentTime / 60)
        let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        recording_TimeLabel.text = totalTimeString
        self.durationRecording = Int(audioRecorder.currentTime)
        audioRecorder.updateMeters()
    }
    var tempResult: String = ""
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    func addTitleRecording() {
        
        let alertController = UIAlertController(title: "Nama Rekaman", message: "Isi nama rekaman Anda", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Nama Rekamaan"
//            self.titleRecordings = textField.text
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            print("Current title recording \(String(describing: textField.text))")
            self.titleRecordings = textField.text
            //compare the current password and do action here
            self.finishAudioRecording(success: true)
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
