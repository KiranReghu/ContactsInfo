//
//  ContactCollectionViewCell.swift
//  Contacts
//
//  Created by Harikrishnan S R on 23/09/21.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    private let utility = Utility()
    
    var imageView: UIImageView!
    
    var name: UILabel!
    
    var phoneNumber: UILabel!
    
    var mail: UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- View
extension ContactCollectionViewCell {
    
    private func setView() {
        
        backgroundColor = .white
        
        self.addShadow(offset: .zero, color: Utility.baseColor, radius: 3, opacity: 0.5)
        
        let horizontalStackView = utility.getStackView(axis: .horizontal, alignment: .fill, distribution: .fillProportionally, spacing: 10)
        
        imageView = nameLogoView()
        
        horizontalStackView.addArrangedSubview(imageView)
        
        let verticalStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fillProportionally, spacing: 0)
        
        name = utility.getLabel( UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        
        phoneNumber = utility.getLabel( UIFont.systemFont(ofSize: 13, weight: .regular), color: .darkGray)
        
        mail = utility.getLabel( UIFont.systemFont(ofSize: 13, weight: .regular), color: .darkGray)
        
        verticalStackView.addArrangedSubview(name)
        verticalStackView.addArrangedSubview(phoneNumber)
        
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        constrainView(horizontalStackView)
        
    }
    
    private func nameLogoView() -> UIImageView {
        
        imageView = UIImageView(image: UIImage(named: "dummy")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }
   
    private func constrainView(_ stackView: UIStackView) {
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        
        ])
        
    }
    
}
