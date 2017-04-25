//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            self.setMenu()
            
            unwrappedBaseView.notesListTableView.delegate = self
            unwrappedBaseView.notesListTableView.dataSource = self
            
            let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotesFeedTableViewCell"
            unwrappedBaseView.notesListTableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
            
            let showCreateNoteSelector =  #selector(PNNotesFeedViewController.showCreateNote)
            let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: showCreateNoteSelector)
            swipeGesture.direction = .left
            unwrappedBaseView.notesListTableView.addGestureRecognizer(swipeGesture)
        }
    }
    
    // MARK: UITableViewDelegate Methods
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell")
        return cell!
    }
    
    func setMenu() {
        self.navigationItem.title = "Pocket Note"
    }
    
    func showCreateNote() {
        self.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }
    
}
