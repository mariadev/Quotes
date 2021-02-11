//
//  CustomFavoritesTableViewCell.swift
//  BaseProjectViewController
//
//  Created by Maria on 09/02/2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var lineLabel = UILabel()
    var scoreLabel = UILabel()
    var emailLabel = UILabel()
    let stackView  = CustomUIView()
    
    func configure(with note: Notes) {
        lineLabel.text = note.line
        scoreLabel.text = note.scoreString()
        emailLabel.text = note.email
        layout() 
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        
        stackView.edgeTo(contentView,
                         constant: 20)
        
        stackView.VStack(lineLabel,
                         scoreLabel,
                         emailLabel,
                         spacing: 8)
        
    }
}

