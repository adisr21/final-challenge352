import UIKit
import CoreData
class HistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    
    let sectionTitles = [" ", "Februari 2019", "Maret 2019"]
    let modelName = "final_challenge"
    let dataHistory = [
        [
            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext"),
            HistoryData(title: "text", detail:"datede1t", subtitle: "textte1xttexttext"),
            HistoryData(title: "te2xt", detail:"date2det", subtitle: "texttexttexttext2")
        ],
        [
            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext"),
            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext"),
            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext")
        ],
        [
            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext"),
            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext"),
//            HistoryData(title: "text", detail:"datedet", subtitle: "texttexttexttext")
        ],
        ]
    
//    var managedObjectContext: NSManagedObjectContext!
    var audios = [Audio]()
    var fetchedResultsController: NSFetchedResultsController<Audio>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.orange]
        navigationController?.navigationBar.tintColor=UIColor.orange
        tabBarController?.tabBar.barTintColor=UIColor.black
        tabBarController?.tabBar.tintColor=UIColor.orange
        self.tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        
    }
    
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
    
    func reloadData(){
        let fetchRequest = NSFetchRequest<Audio>(entityName: "Audio")
        
        let moc = coreDataAudio.managedObjectContext
        do {
//            if let results = try moc.execute(fetchRequest) as? [Audio]{
//                audios = results
//            }
            if let results = try moc.execute(fetchRequest) as? [Audio] {
                audios = results
            }
        } catch {
            fatalError("There was an error fetching the list of devices")
        }
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
//        (view as! UITableViewHeaderFooterView).textLabel?.textColor=UIColor.white
    }
    
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.backgroundColor = UIColor.clear
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles=true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title="Riwayat"
//        reloadData()
        initializeFetchedResultsController()
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellDetail") as! DateTableViewCell
//        cell.dateLabel.text = sectionTitles[section]
////        cell.berapaLabel.text = "\(dataHistory[section].count) rekaman"
//        cell.berapaLabel.text = " "
//        cell.berapaLabel.textColor = .white
//        cell.dateLabel.textColor = .white
//        cell.backgroundColor = UIColor.black
//        
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelTableViewCell
//        let backgroundView = UIView()
//        cell.labelTitle.text=dataHistory[section]
//        let headline = self.dataHistory[indexPath.section][indexPath.row]
//        cell.labelTitle.text = headline.title
//        cell.labelTitle.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//        cell.labelDetail.text = headline.detail
//        cell.labelDetail.textColor=#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        cell.labelSubtitle.text=headline.subtitle
//        cell.labelSubtitle.textColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        cell.backgroundColor = UIColor.clear
//        backgroundView.backgroundColor = .darkGray
//        cell.selectedBackgroundView = backgroundView
        
        
        
        let audio = fetchedResultsController.object(at: indexPath)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let stringDate: String = dateFormatter.string(from: audio.date as! Date)
        
        cell.labelTitle.text = audio.titleRecording
        cell.labelDetail.text = stringDate
        cell.labelSubtitle.text = "durasi : \(audio.durasi) detik "
        
//        if let audioName = audio.value(forKey: "titleRecording") as? String, let dateRecording = audio.value(forKey: "date") as? Date {
//            cell.labelTitle.text = audioName
//            cell.labelSubtitle.text = String(describing: dateRecording)
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        struct Formatter {
            static let formatter : DateFormatter = {
                let fmt = DateFormatter()
                let dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: NSLocale.current)
                fmt.dateFormat = dateFormat
                return fmt
            }()
        }
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return sectionTitles.count
        print("number of Sections \(fetchedResultsController.sections!.count)")
        return (fetchedResultsController.sections!.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataHistory[section].count
        
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        print("number of Rows in Sections \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No selected")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let moc = coreDataAudio.managedObjectContext
        if editingStyle == .delete {


            do {
                self.reloadData()
                let audio = fetchedResultsController.object(at: indexPath)
                moc.delete(audio)

                
                self.initializeFetchedResultsController()
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                try moc.save()
            } catch {
                fatalError("gagal delete")
            }
//            tableView.reloadData()
        }
    }
    
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }

    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    

    
}
