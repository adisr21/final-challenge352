//
//  LatihanTopicVC.swift
//  final challenge
//
//  Created by Adi Sukarno Rachman on 08/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Speech
import Foundation


class LatihanTopicVC: UIViewController, AVAudioRecorderDelegate, NSFetchedResultsControllerDelegate, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate{
    
    var dataTopic = [
        [
            LessonData(title: "Alam", subtitle: "Komodo adalah reptil spesies kadal terbesar di dunia, komodo dewasa di alam bebas pada umumnya memiliki berat 70 kilogram dengan panjang antara 2 sampai 3 meter. Nama dari reptil ini diambil dari nama habitat alaminya yaitu Pulau Komodo yang merupakan bagian dari Provinsi Nusa Tenggara Timur. Pulau Komodo mempunyai luas 390 kilometer persegi dan jumlah populasi lebih dari 2000 jiwa. Di pulau ini terdapat satu dari tujuh Pantai Merah Muda di dunia yang dikenal karena keindahan warna pasirnya yang berwarna merah muda. Pada tahun 1980, Taman Nasional Komodo didirikan dengan tujuan melindungi komodo dari kepunahan sekaligus mencegah habitat alaminya mengalami kerusakan, taman nasional ini mencakup dua pulau besar lainnya yaitu Pulau Rinca dan Pulau Padar. Pada tahun 2011, Taman Nasional Komodo dinobatkan sebagai salah satu dari Tujuh Keajaiban Dunia Baru."),
            LessonData(title: "Kesehatan", subtitle: "Kesehatan fisik merupakan suatu hal yang sangat penting, akan tetapi menjaga kesehatan mental juga merupakan hal yang tidak kalah pentingnya. Kesehatan mental yang buruk seringkali membawa orang ke jurang depresi dan memicu bunuh diri. Pada tahun 2018, Organisasi Kesehatan Dunia memperkirakan bahwa setiap 40 detik, seseorang di dunia mengakhiri hidupnya. Orang yang mengalami depresi sering kali tidak menyadari kemunculan gangguan tersebut. Depresi dapat dicegah dengan menjaga kesehatan mental dengan baik, kesehatan mental dapat dijaga dengan beberapa cara seperti lebih menerima dan menghargai diri, aktif berkegiatan seperti olahraga atau bergabung di suatu komunitas, dan mau membuka diri untuk bercerita pada orang lain."),
            LessonData(title: "", subtitle: "")
        ]
    ]
    var selectedIndex: IndexPath!
    
    
    let visualizerAnimationDuration = 0.15
    var lowPassReslts: Float = 0.0
    var lowPassReslts1: Float = 0.0
    
    // draw circle
    var midViewX: CGFloat!
    var midViewY: CGFloat!
    
    let animateDuration = 0.30
    let visualizerColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var barsNumber = 0
    let barWidth = 4 // width of bar
    let radius: CGFloat = 40
    
    var radians = [CGFloat]()
    var barPoints = [CGPoint]()
    
    private var rectArray = [UIView]()
    private var waveFormArray = [Int]()
    private var initialBarHeight: CGFloat = 0.0
    
    // atribut recording
    @IBOutlet weak var text_Topic: UITextView!
    @IBOutlet weak var view_text_topic: UIView!
    @IBOutlet weak var record_btn_ref: UIButton!
    @IBOutlet weak var record_TimeLabel: UILabel!
//    @IBOutlet var play_btn_ref: UIButton!
//    @IBOutlet var background_text: UIView!
//    @IBOutlet var text_semangat: UILabel!
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
    
    let audioEngine = AVAudioEngine()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))  //1
    
    
    let coreDataAudio = CoreDataAudio(modelName: "final_challenge")
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    func removeAnimateCircleAndRadarLayer() {
        self.radarLayer.removeAllAnimations()
        //        setupCircular()
    }
    
    
    func setupRecord() {
        
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSession.Category.record, mode: .measurement)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
            let getURL = self.getFileUrl()
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
        let radarPath = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        
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
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.fadedBlue.cgColor
        circleView.layer.addSublayer(circleLayer)
        
        
        // Draw Bars
        rectArray = [UIView]()
        
        for i in 0..<barsNumber {
            let angle = ((360 / barsNumber) * i) - 90
            let point = calculatePoints(angle: angle, radius: radius)
            let radian = angle.degreesToRadians
            radians.append(radian)
            barPoints.append(point)
            
            let rectangle = UIView(frame: CGRect(x: barPoints[i].x, y: barPoints[i].y, width: CGFloat(barWidth), height: CGFloat(barWidth)))
            
            initialBarHeight = CGFloat(self.barWidth)
            print("BEFORE : width: \(rectangle.frame.width), height: \(rectangle.frame.height)")
            rectangle.setAnchorPoint(anchorPoint: CGPoint.zero)
            let rotationAngle = (CGFloat(( 360/barsNumber) * i)).degreesToRadians + 180.degreesToRadians
            
            rectangle.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            print("AFTER : width: \(rectangle.frame.width), height: \(rectangle.frame.height)")
            rectangle.backgroundColor = visualizerColor
            rectangle.layer.cornerRadius = CGFloat(rectangle.bounds.width / 2)
            rectangle.tag = i
            self.circleView.addSubview(rectangle)
//            self.addSubview(rectangle)
            rectArray.append(rectangle)
            
            var values = [5, 10, 15, 10, 5, 1]
            waveFormArray = [Int]()
            var j: Int = 0
            for _ in 0..<barsNumber {
                waveFormArray.append(values[j])
                j += 1
                if j == values.count {
                    j = 0
                }
            }
        }
    }
    
    func animateAudioVisualizerWithChannel(level0: Float, level1: Float ) {
        DispatchQueue.main.async {
            UIView.animateKeyframes(withDuration: self.animateDuration, delay: 0, options: .beginFromCurrentState, animations: {
                
                for i in 0..<self.barsNumber {
                    let channelValue: Int = Int(arc4random_uniform(2))
                    
                    let wavePeak: Int = Int(arc4random_uniform(UInt32(self.waveFormArray[i])))
                    let barViewUn: UIView = self.rectArray[i]
                    
                    let barH = (self.circleView.frame.height / 2 ) - self.radius
                    let scaled0 = (CGFloat(level0) * barH) / 60
                    let scaled1 = (CGFloat(level1) * barH) / 60
                    let calc0 = barH - scaled0
                    let calc1 = barH - scaled1
                    
                    if channelValue == 0 {
                        barViewUn.bounds.size.height = calc0
                    } else {
                        barViewUn.bounds.size.height = calc1
                    }
                    
                    if barViewUn.bounds.height < CGFloat(4) || barViewUn.bounds.height > ((self.circleView.bounds.size.height / 2) - self.radius) {
                        barViewUn.bounds.size.height = self.initialBarHeight + CGFloat(wavePeak)
                    }
                }
                
            }, completion: nil)
        }
    }
    
    
    func stop() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.animateDuration, delay: 0, options: .beginFromCurrentState, animations: {
                for i in 0..<self.barsNumber {
                    let barView = self.rectArray[i]
                    barView.bounds.size.height = self.initialBarHeight
                    barView.bounds.origin.y = 120 - barView.bounds.size.height
                }
            }, completion: nil)
        }
    }
    
    func calculatePoints(angle: Int, radius: CGFloat) -> CGPoint {
        let barX = midViewX + cos((angle).degreesToRadians) * radius
        let barY = midViewY + sin((angle).degreesToRadians) * radius
        
        return CGPoint(x: barX, y: barY)
    }
    
    func setupCircular() {
//        setupRadarLayer()
        setupCircleLayer()
        
        
    }
    
    @objc func animateCircle(from lastValue: CGFloat, to value: CGFloat){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        
        animation.fromValue = lastValue
        animation.toValue = value
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        
        radarLayer.add(animation, forKey: "pulsating")
        
    }
    
    fileprivate func setupTopic() {
        
        
        self.defineTopic()
        self.text_Topic.text = self.dataTopic[selectedIndex.section][selectedIndex.row].subtitle
        print(self.text_Topic.text)
        self.text_Topic.isEditable = false
        self.text_Topic.isScrollEnabled = true
    }
    
    fileprivate func defineTopic(){
        self.dataTopic = [
            [
                LessonData(title: "Alam", subtitle: "Komodo adalah reptil spesies kadal terbesar di dunia, komodo dewasa di alam bebas pada umumnya memiliki berat 70 kilogram dengan panjang antara 2 sampai 3 meter. Nama dari reptil ini diambil dari nama habitat alaminya yaitu Pulau Komodo yang merupakan bagian dari Provinsi Nusa Tenggara Timur. Pulau Komodo mempunyai luas 390 kilometer persegi dan jumlah populasi lebih dari 2000 jiwa. Di pulau ini terdapat satu dari tujuh Pantai Merah Muda di dunia yang dikenal karena keindahan warna pasirnya yang berwarna merah muda. Pada tahun 1980, Taman Nasional Komodo didirikan dengan tujuan melindungi komodo dari kepunahan sekaligus mencegah habitat alaminya mengalami kerusakan, taman nasional ini mencakup dua pulau besar lainnya yaitu Pulau Rinca dan Pulau Padar. Pada tahun 2011, Taman Nasional Komodo dinobatkan sebagai salah satu dari Tujuh Keajaiban Dunia Baru."),
                LessonData(title: "Kesehatan", subtitle: "Kesehatan fisik merupakan suatu hal yang sangat penting, akan tetapi menjaga kesehatan mental juga merupakan hal yang tidak kalah pentingnya. Kesehatan mental yang buruk seringkali membawa orang ke jurang depresi dan memicu bunuh diri. Pada tahun 2018, Organisasi Kesehatan Dunia memperkirakan bahwa setiap 40 detik, seseorang di dunia mengakhiri hidupnya. Orang yang mengalami depresi sering kali tidak menyadari kemunculan gangguan tersebut. Depresi dapat dicegah dengan menjaga kesehatan mental dengan baik, kesehatan mental dapat dijaga dengan beberapa cara seperti lebih menerima dan menghargai diri, aktif berkegiatan seperti olahraga atau bergabung di suatu komunitas, dan mau membuka diri untuk bercerita pada orang lain."),
                LessonData(title: "", subtitle: "")
            ]
        ]
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
        newRec.titleRecording = self.titleRecordings
        newRec.konten = self.konten
        newRec.wpm = self.nilaiWPM
        guard let getURL = self.urlTemp else {
            return
        }
        newRec.urlAudio = getURL
        
        
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
    
    func getFileUrl() -> URL {
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
//            self.text_Topic.text = tempResult
            self.konten = tempResult
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
        
        if (wpm < 120){
            self.my_range_wpm.text = "Ayo Semangat dong"
            self.animateCircle(from: 0.6,to: 0.1)
        } else if((wpm > 120 || wpm < 150)  ) {
            self.my_range_wpm.text = "Sudah Pas! Pertahankan!"
            self.animateCircle(from: 0.6,to: 1.4)
        } else if ( wpm > 150){
            self.my_range_wpm.text = "Woah... Rileks.. Atur Nafasmu"
            self.animateCircle(from: 0.6,to: 1.4)
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
        record_TimeLabel.text = totalTimeString
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
    override func viewWillAppear(_ animated: Bool) {
        view_text_topic.layer.borderWidth = 2
        view_text_topic.layer.borderColor = UIColor.orange.cgColor
        view_text_topic.clipsToBounds = true
        view_text_topic.layer.cornerRadius = 10.0
        
        self.check_record_permission()
        setupTopic()
        self.my_range_wpm.text = "Silahkan baca teks dibawah"
        self.my_range_wpm.textColor = UIColor.orangeS
        self.konten = ""
        self.durationRecording = 0
        self.midViewX = self.view.frame.maxX / 2
        self.midViewY = view.frame.maxY - 600
        self.circleView = UIView(frame: CGRect(x: midViewX, y: midViewY, width: 300, height: 300))
//        self.radarView = UIView(frame: CGRect(x: view.frame.maxX - 50, y: view.frame.maxY - 250, width: 300, height: 300))
        self.view.addSubview(circleView)
//        self.view.addSubview(radarView)
        self.setupCircular()
        
        
    }
    @IBAction func startSpeech(_ sender: UIButton)
    {
        if(audioEngine.isRunning)
        {
            stopRecognitionSpeech()
            meterTimer.invalidate()
//            removeAnimateCircleAndRadarLayer()
            addTitleRecording()
            
            record_btn_ref.setImage(UIImage(named: "record-1"), for: .normal)
            record_btn_ref.isEnabled = false
            self.record_TimeLabel.text = "00:00"
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        switch segue.identifier {
//        case "latihanHasil":
//
//            if let indexPat = self.circleView.indexPathForSelectedRow {
//
//                let controller = segue.destination as! HasilViewController
//                controller.selectedIndexPath = indexPat
//            }
//        default:
//            print("failed segue")
//        }
//
//
//    }
}

