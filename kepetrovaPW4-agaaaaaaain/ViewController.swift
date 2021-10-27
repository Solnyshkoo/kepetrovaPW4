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
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        
        cell.descriptionLabel.text! += "\n"
        let date = note.creationDate

        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"

       
        // Convert Date to String
        cell.descriptionLabel.text =  dateFormatter.string(from: date) + "\n" + note.descriptionText!
//        cell.descriptionLabel.numberOfLines = 3
//        //cell.descriptionLabel.text! +=
        return cell
    }
    
    var notes: [Note] = [] {
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
        
      
        
    }
    @objc func createNote(sender: UIBarButtonItem) {
        guard let vc =
                storyboard?.instantiateViewController(withIdentifier:
                                                        "NoteViewController") as? NoteViewController else {
            return
        }
        vc.outputVC = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveChanges() {
        if context.hasChanges {
            try? context.save()
        }
        if let note = try? context.fetch(Note.fetchRequest()) {
            self.notes = (note as? [Note] ?? [])
        } else {
            self.notes = []
        }
    }
    
    func loadData() {
        if let notes = try? context.fetch(Note.fetchRequest()) {
            self.notes = (notes as? [Note])!
        } else {
            self.notes = []
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
                self.context.delete(self.notes[indexPath.row])
                self.saveChanges()
            }
            return UIMenu(title: "", image: nil, children: [deleteAction])
            
        }
        
    }

}

