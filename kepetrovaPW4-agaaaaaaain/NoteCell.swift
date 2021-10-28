//
//  NoteCell.swift
//  kepetrovaPW4-agaaaaaaain
//
//  Created by Ksenia Petrova on 27.10.2021.
//

import UIKit
class NoteCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier:
                                                "NoteCell", for: indexPath) as! NoteCell
        cell.titleLabel.text = "Yeah"
        cell.descriptionLabel.text = "That's greate"
        cell.countryLabel.text = "Whole world"
        return cell
    }
}
