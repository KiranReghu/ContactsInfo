//
//  ViewController.swift
//  Contacts
//
//  Created by Harikrishnan S R on 23/09/21.
//

import UIKit
import CoreData

class ContactsListViewController: UIViewController {
   
    var contactCollectionView: UICollectionView!
    
    var contactsDataSource: [Contact] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkMonitor.shared.startMonitoring()
        
        setupView()
      
        loadContacts()
        
    }

    deinit {
        
        print("ContactsListViewController Deinited")
        NetworkMonitor.shared.stopMonitoring()
        
    }
    
}

//MARK:- View
extension ContactsListViewController {
    
    private func setupView() {
          
        view.backgroundColor =  UIColor(red: 246/255, green: 248/255, blue: 252/255, alpha: 1)
        
        setUpNavigationBar()
        
        setupCollectionView()
        
    }
    
    private func setUpNavigationBar() {
        
        self.navigationController?.navigationBar.barTintColor =  Utility.baseColor
        
        self.navigationController?.navigationBar.alpha = 1
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Utility.baseColor
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            
        }
        
    }
    
    private func setupCollectionView() {
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 20
        
        contactCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        contactCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contactCollectionView.backgroundColor = UIColor(red: 246/255, green: 248/255, blue: 252/255, alpha: 1)
        
        contactCollectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contactCollectionView.dataSource = self
        contactCollectionView.delegate = self
        
        self.view.addSubview(contactCollectionView)
        
        setCollectionViewConstrain()
        
    }
    
    private func setCollectionViewConstrain() {
        
        NSLayoutConstraint.activate([
            
            contactCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contactCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            contactCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            contactCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
        
    }
    
}

//MARK:- Collection view protocol implementation
extension ContactsListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contactsDataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = contactCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContactCollectionViewCell
        
        cell.layer.cornerRadius = 10
        
        let name = contactsDataSource[indexPath.row].name
        
        let nameFirstLetter = String((name.first ?? "a").lowercased())
        
        cell.imageView.image = UIImage(systemName: "\(nameFirstLetter).square.fill")
        
        cell.imageView.tintColor =  Utility.baseColor
        
        cell.name.text = contactsDataSource[indexPath.row].name
        
        cell.phoneNumber.text = contactsDataSource[indexPath.row].phone
        
        cell.mail.text = contactsDataSource[indexPath.row].email
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ContactsDetailsViewController(details: contactsDataSource[indexPath.row], utility: Utility())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width - 70
        let height = self.view.frame.height/12
        
       return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
    }
    
}

//MARK:- Private methods
extension ContactsListViewController {
    
    private func loadContacts() {
        
        guard  NetworkMonitor.shared.isReachable || NetworkMonitor.shared.isReachableOnCellular else {
            
            contactsDataSource = self.fetchContact() ?? []
            return
            
        }
        
        deleteAllContacts()
        
        getContacts { [weak self] response in

            switch response {

            case .failure(let error):
                print(error)
                break

            case .success(let contacts):

                DispatchQueue.main.async {

                    self?.contactsDataSource.append(contentsOf: contacts)
                    self?.contactCollectionView.reloadData()

                }

                break

            }

        }
        
    }
    
}
    
//MARK:- APIs
extension ContactsListViewController {
    
    private func getContacts( completion : @escaping ((Result<[Contact], Error>) -> ())) {
       
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let contactsInDataFormat = data else {
                completion(.failure(NetworkErrors.wrongUrl))
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    
                    let context = delegate?.persistentContainer.viewContext
                    
                    let decoder = JSONDecoder()
                    
                    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
                    
                    let datSource = try decoder.decode([Contact].self, from: contactsInDataFormat)
                    
                    try context?.save()
                    
                    
                    self?.contactsDataSource = self?.fetchContact() ?? []
                    
                    completion(.success(datSource))
                    
                    
                }
                catch let error {
                    
                    completion(.failure(error))
                    
                }
                
            }
            
        }.resume()
      
    }
    
}

//MARK:- CoreData
extension ContactsListViewController {
    
    func fetchContact() ->  [Contact]?{
         
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = delegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
            
            let entities =  try context?.fetch(request)
            
            try context?.save()
            
            return entities
            
        } catch let error {
            
            print(error)
            
        }
        
        return nil
        
     }
    
    func deleteAllContacts() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = (delegate?.persistentContainer.viewContext)!
        let storeCordinator = delegate?.persistentContainer.persistentStoreCoordinator
        
        let fetchContactRequest: NSFetchRequest<NSFetchRequestResult> = Contact.fetchRequest()
        let fetchCompanyRequest: NSFetchRequest<NSFetchRequestResult> = Company.fetchRequest()
        let fetchAddressRequest: NSFetchRequest<NSFetchRequestResult> = Address.fetchRequest()
        let fetchGeoRequest: NSFetchRequest<NSFetchRequestResult> = Geo.fetchRequest()
        
        let ContactDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchContactRequest)
        let CompanyDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchCompanyRequest)
        let AddresstDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchAddressRequest)
        let GeoDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchGeoRequest)
        
        do {
            
            try storeCordinator?.execute(ContactDeleteRequest, with: context)
            try storeCordinator?.execute(CompanyDeleteRequest, with: context)
            try storeCordinator?.execute(AddresstDeleteRequest, with: context)
            try storeCordinator?.execute(GeoDeleteRequest, with: context)
            try context.save()
            
        } catch let error as NSError {
            
            print(error)
            
        }
        
    }
    
}

