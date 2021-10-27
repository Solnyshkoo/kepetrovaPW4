//
//  NoteViewController.swift
//  kepetrovaPW4-agaaaaaaain
//
//  Created by Ksenia Petrova on 28.10.2021.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    var outputVC: ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    navigationItem.rightBarButtonItem =
    UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
    #selector(didTapSaveNote(button:)))
        
    }
    @objc func didTapSaveNote(button: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let description = textView.text ?? ""
        if !title.isEmpty{
            let newNote = Note(context: outputVC.context)
            //newNote.setValue(title, forKey: "title")
            newNote.title = title
            //newNote.setValue(description, forKey: "descriptionText")
            newNote.descriptionText = description
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            let today: Date? = Calendar.current.date(from: dateComponents)
            //newNote.setValue(today, forKey: "creationDate")
            newNote.creationDate = today!
            
            
            outputVC.saveChanges()
        }
        self.navigationController?.popViewController(animated: true)
    }

}

