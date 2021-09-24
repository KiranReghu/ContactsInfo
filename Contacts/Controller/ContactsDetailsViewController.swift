//
//  ContactsDetailsViewController.swift
//  Contacts
//
//  Created by Harikrishnan S R on 23/09/21.
//

import UIKit

class ContactsDetailsViewController: UIViewController {

    private let ContactDetails: Contact
    
    private let utility: IUtility
    
    private var imageView: UIImageView!
    
    private var primaryView: UIView!
    
    private var companyDetailsView: UIView!
    
    private var addressDetailsView: UIView!
    
    init(details: Contact,  utility: IUtility) {
        
        self.ContactDetails = details
        self.utility = utility
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        setupView()
        
    }
    
    deinit {
        print("ContactsDetailsViewController Deinited")
    }

}

//MARK:- View
extension ContactsDetailsViewController {
    
    private func setupView() {
   
        view.backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 246/255, alpha: 1)
        
        getPrimaryDetailsView()

        getSecondaryDetailsView()
        
        setupBackButton()
        
    }
    
    private func setupBackButton() {
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonImage = (UIImage(named: "back")!).resizeImage(targetSize: CGSize(width: 30, height: 30))
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(didTapBack(button:)), for: .touchUpInside)
        
        primaryView.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            button.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 20),
            button.safeAreaLayoutGuide.topAnchor.constraint(equalTo: primaryView.safeAreaLayoutGuide.topAnchor, constant: 30)
            
        ])
        
    }

    private func getSecondaryDetailsView() {
        
        setupCompanyDetailView()
        
        setupAddressDetailView()
        
    }
    
    private func getImageView(_ image: UIImage) -> UIImageView{
        
        imageView = UIImageView(image: image)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
        
    }
    
    private func getBadgeView(_ name: String, imageName: String, isImageLeftAligned: Bool = true) -> UIView {
        
        let badgeView = UIView(frame: .zero)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = UIColor(red:0.49, green:0.49, blue:1.00, alpha: 1)
        let badgeContent = utility.getIconWithLabelView(UIFont.systemFont(ofSize: 15, weight: .semibold), color: .white, iconName: imageName, labelName: name, size: 20, isImageLeftAligned: isImageLeftAligned)
        badgeView.layer.masksToBounds = true
        badgeView.layer.cornerRadius = 15
        badgeView.addSubview(badgeContent)
        
        NSLayoutConstraint.activate([
        
            badgeView.widthAnchor.constraint(equalToConstant: 120),
            badgeView.heightAnchor.constraint(equalToConstant: 30),
            badgeContent.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeContent.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor)

        ])
        
        badgeView.addShadow(offset: .zero, color: .darkGray, radius: 2, opacity: 1)
       
        return badgeView
    }
    
}

//MARK:- Targets
extension ContactsDetailsViewController {
    
    @objc private func didTapBack(button: UIButton) {
       
        dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK:- Primary View
extension ContactsDetailsViewController {
    
    private func getPrimaryDetailsView()  {
        
        primaryView = UIView(frame: .zero)
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        primaryView.backgroundColor = Utility.baseColor
        primaryView.layer.cornerRadius = 30
        conatrainPrimaryView()
        
        primaryView.addShadow(offset: .zero, color: .black, radius: 4, opacity: 0.5)
        
        constrainPrimaryImageView()
        
        constrainPrimaryLabelViews()
        
    }
    
    private func constrainPrimaryLabelViews() {
     
        let subView = getPrimaryLabelView()
        
        primaryView.addSubview(subView)
        
        NSLayoutConstraint.activate([
        
            subView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            subView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),

        ])
        
    }
    
    private func getPrimaryLabelView() -> UIStackView{
        
        let name = utility.getLabel(UIFont.systemFont(ofSize: 20, weight: .bold), color: .white, numberOfLines: 0)
        
        name.text = ContactDetails.name
        
        let phone = utility.getIconWithLabelView(UIFont.systemFont(ofSize: 13, weight: .regular), color: .white, iconName: "phone", labelName: ContactDetails.phone, size: 20, isImageLeftAligned: true)
        
        let email =  utility.getIconWithLabelView(UIFont.systemFont(ofSize: 13, weight: .regular), color: .white, iconName: "email", labelName: ContactDetails.email, size: 20, isImageLeftAligned: true)
        
        let verticalStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
        
        verticalStackView.addArrangedSubview(name)
        verticalStackView.addArrangedSubview(phone)
        verticalStackView.addArrangedSubview(email)
        
        return verticalStackView
        
    }
    
    private func conatrainPrimaryView() {
        
        view.addSubview(primaryView)
        
        NSLayoutConstraint.activate([
        
            primaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            primaryView.topAnchor.constraint(equalTo: view.topAnchor, constant: -30),
            primaryView.heightAnchor.constraint(equalToConstant: view.frame.height/3 )
            
        ])
       
    }
    
    private func constrainPrimaryImageView() {
        
        primaryView.addSubview(getprimaryImageView())
        
        NSLayoutConstraint.activate([
        
            imageView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 20),
          
        ])
    }
    
    private func getprimaryImageView() -> UIImageView {
        
        let nameFirstLetter = String((ContactDetails.name.first ?? "a").lowercased())
        
        imageView = UIImageView(image: UIImage(systemName: "\(nameFirstLetter).square.fill")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        NSLayoutConstraint.activate([
            
            imageView.heightAnchor.constraint(equalToConstant: 130),
            imageView.widthAnchor.constraint(equalToConstant: 130)
            
        ])
        
        return imageView
        
    }
    
}

//MARK:- Secondary View
extension ContactsDetailsViewController {
    
    private func setupCompanyDetailView() {
        
        companyDetailsView = UIView(frame: .zero)
        companyDetailsView.translatesAutoresizingMaskIntoConstraints = false
        companyDetailsView.backgroundColor = .white
        companyDetailsView.layer.cornerRadius = 10
        view.addSubview(companyDetailsView)
        
        NSLayoutConstraint.activate([
            
            companyDetailsView.heightAnchor.constraint(equalToConstant: 120),
            companyDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            companyDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            companyDetailsView.topAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: 50)
            
        ])
        
        companyDetailsView.addShadow(offset: .zero, color:  Utility.baseColor, radius: 3, opacity: 0.5)
        
        let verticalStackView =  utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
        
        let comapnyName = utility.getLabel(UIFont.systemFont(ofSize: 18, weight: .bold), color: .black, numberOfLines: 0)
        comapnyName.text = ContactDetails.company?.name
        
        let catchPraseHorizontalView = utility.getStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
        
        let catchPhrase = utility.getLabel(UIFont.systemFont(ofSize: 15, weight: .semibold), color: .darkGray, numberOfLines: 0)
        catchPhrase.text = ContactDetails.company?.catchPhrase
        
        let catchPhraseImageView = UIImageView(image: UIImage(named: "quote")!)
        catchPhraseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        catchPhraseImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        catchPhraseImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        catchPraseHorizontalView.addArrangedSubview(catchPhrase)
        
        catchPraseHorizontalView.addArrangedSubview(catchPhraseImageView)
        
        let bs = utility.getLabel(UIFont.systemFont(ofSize: 15, weight: .regular), color: .darkGray, numberOfLines: 0)
        bs.text = ContactDetails.company?.bs
        
        verticalStackView.addArrangedSubview(comapnyName)
        verticalStackView.addArrangedSubview(catchPraseHorizontalView)
        verticalStackView.addArrangedSubview(bs)
        
        companyDetailsView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
        
            verticalStackView.leadingAnchor.constraint(equalTo: companyDetailsView.leadingAnchor, constant: 15),
            verticalStackView.trailingAnchor.constraint(equalTo: companyDetailsView.trailingAnchor, constant: -15),
            verticalStackView.topAnchor.constraint(equalTo: companyDetailsView.topAnchor, constant: 15),
            verticalStackView.bottomAnchor.constraint(equalTo: companyDetailsView.bottomAnchor, constant: -15)
            
        ])
        
        let badge = getBadgeView("Company", imageName: "company", isImageLeftAligned: false)
    
        companyDetailsView.addSubview(badge)
        
        NSLayoutConstraint.activate([
        
            badge.trailingAnchor.constraint(equalTo: companyDetailsView.trailingAnchor, constant: -5),
            badge.bottomAnchor.constraint(equalTo: companyDetailsView.topAnchor, constant: 15)
            
        ])
        
    }
    
    private func setupAddressDetailView() {
        
        addressDetailsView = UIView(frame: .zero)
        addressDetailsView.translatesAutoresizingMaskIntoConstraints = false
        addressDetailsView.backgroundColor = .white
        addressDetailsView.layer.cornerRadius = 10
        view.addSubview(addressDetailsView)
        
        NSLayoutConstraint.activate([
            
            addressDetailsView.heightAnchor.constraint(equalToConstant: 120),
            addressDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addressDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addressDetailsView.topAnchor.constraint(equalTo: self.companyDetailsView.bottomAnchor, constant: 50)
            
        ])
       
        addressDetailsView.addShadow(offset: .zero, color: Utility.baseColor, radius: 3, opacity: 0.5)
        
        let horizontalStackView =  utility.getStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
        let addressContent = utility.getLabel(UIFont.systemFont(ofSize: 15, weight: .semibold), color: .darkGray, numberOfLines: 0)
      
        addressContent.text = "\(ContactDetails.address?.street ?? ""), \(ContactDetails.address?.suite ?? ""), \(ContactDetails.address?.city ?? ""), \(ContactDetails.address?.zipcode ?? "")"
        
        let addressImage = UIImage(named: "addressLocation")!
        let addressImageView = UIImageView(image: addressImage)
        addressImageView.translatesAutoresizingMaskIntoConstraints = false
        addressImageView.layer.cornerRadius = 15
        
        addressImageView.contentMode = .scaleAspectFit
        
        horizontalStackView.addArrangedSubview(addressContent)
        horizontalStackView.addArrangedSubview(addressImageView)
        
        addressDetailsView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
        
            addressImageView.heightAnchor.constraint(equalToConstant: 60),
            addressImageView.widthAnchor.constraint(equalToConstant: 60),
            horizontalStackView.leadingAnchor.constraint(equalTo: addressDetailsView.leadingAnchor, constant: 15),
            horizontalStackView.trailingAnchor.constraint(equalTo: addressDetailsView.trailingAnchor, constant: -15),
            horizontalStackView.topAnchor.constraint(equalTo: addressDetailsView.topAnchor, constant: 15),
            horizontalStackView.bottomAnchor.constraint(equalTo: addressDetailsView.bottomAnchor, constant: -15)
            
        ])
        
        let badge = getBadgeView("Address", imageName: "address")
        
        addressDetailsView.addSubview(badge)
        
        NSLayoutConstraint.activate([
        
            badge.leadingAnchor.constraint(equalTo: addressDetailsView.leadingAnchor, constant: 5),
            badge.bottomAnchor.constraint(equalTo: addressDetailsView.topAnchor, constant: 15)
            
        ])

    }
    
}


