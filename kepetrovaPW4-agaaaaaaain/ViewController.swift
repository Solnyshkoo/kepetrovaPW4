//
//  ViewController.swift
//  kepetrovaPW4-agaaaaaaain
//
//  Created by Ksenia Petrova on 27.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier:
                                                "NoteCell", for: indexPath) as! NoteCell
        
        let note: Note
        if isFilterOn {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        
        
        let nsString = (note.title ?? "") as NSString
        cell.titleLabel.text = nsString.substring(with: NSRange(location: 0, length: nsString.length > 10 ? 10 : nsString.length))
        
        
        let date = note.creationDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        
        let nsStringdescription = (note.descriptionText ?? "") as NSString
        let firstLine = nsStringdescription.substring(with: NSRange(location: 0, length: nsStringdescription.length > 10 ? 10 : nsStringdescription.length))
        let secondLine = nsStringdescription.substring(with: NSRange(location: (nsStringdescription.length > 10 ? 10 : 0), length: (nsStringdescription.length > 20 ? 10 : 0)))
        
        cell.descriptionLabel.text =  dateFormatter.string(from: date!) + "\n" + firstLine + "\n" + secondLine
        
        let nsStringCountry = (note.origin?.fullName ?? "") as NSString
        cell.countryLabel.text =  nsStringCountry.substring(with: NSRange(location: 0, length: nsStringCountry.length > 10 ? 10 : nsStringCountry.length))
        return cell
    }
    
    var notes: [Note] = [] {
        didSet {
            emptyCollectionLabel.isHidden = notes.count != 0
            notesCollectionView.reloadData()
        }
    }
    
    var filteredNotes: [Note] = []
    
    var countries: [Country] = [] {
        didSet {
            emptyCollectionLabel.isHidden = notes.count != 0
            notesCollectionView.reloadData()
        }
    }
    
    let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "CoreDataNotes")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Container loading failed")
            }
        }
        return container.viewContext
    }()
    
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    @IBOutlet weak var notesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action:
                                #selector(createNote(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain , target: self, action: #selector(filter(sender:)))
        
        
    }
    @objc func createNote(sender: UIBarButtonItem) {
        guard let vc =
                storyboard?.instantiateViewController(withIdentifier:
                                                        "NoteViewController") as? NoteViewController else {
            return
        }
        vc.outputVC = self
        vc.countries = countries;
        
        navigationController?.pushViewController(vc, animated: true)
    }
    private var buttonCount = 0
    private var isFilterOn = false
    
    @objc func filter(sender: UIBarButtonItem) {
        buttonCount += 1
        switch buttonCount {
        case 2:
            isFilterOn = false
            saveChanges()
            
        case 1:
            filteredNotes = notes.sorted { (channel1, channel2) -> Bool in
                let name1 = channel1.origin?.fullName
                let name2 = channel2.origin?.fullName
                return (name1?.localizedCaseInsensitiveCompare(name2!) == .orderedAscending)}
            saveChanges()
            isFilterOn = true
        default:
            buttonCount = 0
        }
    }
    
    
    func saveChanges() {
        if context.hasChanges {
            try? context.save()
        }
        if let note = try? context.fetch(Note.fetchRequest()) {
            self.notes = (note as? [Note] ?? [])
            self.filteredNotes = (note as? [Note] ?? []).sorted { (channel1, channel2) -> Bool in
                let name1 = channel1.origin?.fullName
                let name2 = channel2.origin?.fullName
                return (name1?.localizedCaseInsensitiveCompare(name2!) == .orderedAscending)}
        } else {
            self.notes = []
            self.filteredNotes = []
        }
    }
    
    func loadData() {
        if let notes = try? context.fetch(Note.fetchRequest()) {
            self.notes = (notes as? [Note])!
            self.filteredNotes = (notes as? [Note])!.sorted { (channel1, channel2) -> Bool in
                let name1 = channel1.origin?.fullName
                let name2 = channel2.origin?.fullName
                return (name1?.localizedCaseInsensitiveCompare(name2!) == .orderedAscending)}
        } else {
            self.notes = []
            self.filteredNotes = []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath, point:
                            CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        return UIContextMenuConfiguration(identifier: identifier,
                                          previewProvider: .none) { _ in
            let deleteAction = UIAction(title: "Delete", image:
                                            UIImage(systemName: "trash"), attributes:
                                                UIMenuElement.Attributes.destructive) { value in
                self.notes[indexPath.row].origin?.removeFromNote(self.notes[indexPath.row])
                
                self.context.delete(self.notes[indexPath.row])
                self.saveChanges()
            }
                                            return UIMenu(title: "", image: nil, children: [deleteAction])
            
        }
        
    }
    
}

