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
    @IBOutlet weak var countryView: UITextField!
    var outputVC: ViewController!
    var countries: [Country] = []
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
            var currentCountry: Country
            for country in countries {
                if country.fullName == countryView.text{
                    currentCountry = country;
                    currentCountry.addToNote(newNote)
                    newNote.origin = currentCountry
                }
            }
            if newNote.origin == nil {
                currentCountry = Country(context: outputVC.context)
                countries.append(currentCountry)
                currentCountry.fullName = countryView.text
                currentCountry.addToNote(newNote)
                newNote.origin = currentCountry
            }
            
            outputVC.saveChanges()
        }
        outputVC.countries = countries
        self.navigationController?.popViewController(animated: true)
    }

}

