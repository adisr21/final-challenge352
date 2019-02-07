import UIKit

class HistoryViewController: UITableViewController {
    
    let sectionTitles = ["date", "date", "date"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.orange]
        navigationController?.navigationBar.tintColor=UIColor.orange
        tabBarController?.tabBar.barTintColor=UIColor.black
        tabBarController?.tabBar.tintColor=UIColor.orange
        self.tableView.backgroundColor = .black
        
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
        navigationItem.title="History"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellDetail") as! DateTableViewCell
        cell.dateLabel.text = sectionTitles[section]
        cell.berapaLabel.text = "\(dataHistory[section].count) rekaman"
        cell.berapaLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.backgroundColor=UIColor.black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelTableViewCell
        let backgroundView = UIView()
//        cell.labelTitle.text=dataHistory[section]
        let headline = self.dataHistory[indexPath.section][indexPath.row]
        cell.labelTitle.text = headline.title
        cell.labelTitle.textColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        cell.labelDetail.text = headline.detail
        cell.labelDetail.textColor=#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.labelSubtitle.text=headline.subtitle
        cell.labelSubtitle.textColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.backgroundColor = UIColor.clear
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistory[section].count
    }
    
    
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    

    
}
