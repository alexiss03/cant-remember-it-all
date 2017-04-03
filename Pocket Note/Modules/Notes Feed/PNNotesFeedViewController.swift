//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Hanet on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    let v: PNNotesFeedView = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as! PNNotesFeedView
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.v.frame = self.view.frame
        self.view = self.v
        
        self.setMenu()
        
        self.v.notesListTableView.delegate = self
        self.v.notesListTableView.dataSource = self
        //self.v.notesListCollectionView.delegate = self
        //self.v.notesListCollectionView.dataSource = self
        
        self.v.notesListTableView.register(UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PNNotesFeedTableViewCell")
        
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(PNNotesFeedViewController.showCreateNote))
        swipeGesture.direction = .left
        self.v.notesListTableView.addGestureRecognizer(swipeGesture)
        
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
    
    
//    // MARK: UICollectionViewDelegate Methods
//    
//    // MARK: UICollectionViewDataSource Methods
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PNNotesFeedCollectionViewCell", for: indexPath)
//        return cell
//    }
//    
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//    }
    
    func setMenu() {
        self.navigationItem.title = "Pocket Note"
    }
    
    
    func showCreateNote(){
        self.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }
    
}
