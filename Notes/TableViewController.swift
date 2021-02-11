//
//  CollectionView.swift
//  Stackview
//
//  Created by Maria on 12/01/2021.
//

//
//  ViewController.swift
//  sectionOne
//
//  Created by Maria on 04/12/2020.
//

import UIKit
import RealmSwift

class TableViewController : UIViewController {
    
    var tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
    
    let customeTableViewCell = "CustomeTableViewCell"
    
    var notes : Results<Notes>!
    
    var notificationToken: NotificationToken?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Quotes"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmService.shared.realm
        notes = realm.objects(Notes.self)
        
        notificationToken = realm.observe{ (notification, realm) in
            self.tableView.reloadData()
        }
        
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            //handle error
            print(error ?? "no error detected")
        }
        
        setupNavBar()
        appyTheme()
        setupLayout ()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: customeTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }
    
    @objc func onAddTapped() {
        AlertService.addAlert(in: self) { (line, score, email) in
            let newNote = Notes(line: line, score: score, email: email)
            RealmService.shared.create(newNote)
        }
    }
    
    fileprivate func setupNavBar() {
        let goToGetViewControllerBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,  target: self, action: #selector(onAddTapped))
        navigationItem.setRightBarButton(goToGetViewControllerBarButtonItem, animated: true)
    }
    
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        AlertService.updateAlert(in: self, notes: note) { (line, score, email) in
            let dict: [String: Any?] = ["line": line,
                                        "score": score,
                                        "email": email]
            
            RealmService.shared.update(note, with: dict)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let note = notes[indexPath.row]
        
        RealmService.shared.delete(note)
    }
}

// MARK: - Table view data source

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customeTableViewCell , for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        let note = notes[indexPath.row]
        cell.configure(with: note)
        return cell
    }
}

//MARK: Set Up Layout

extension TableViewController {
    
    func setupLayout () {
        view.addSubview(tableView)
    }
    
    func appyTheme() {
        view.backgroundColor = .white
        
    }
    
}


