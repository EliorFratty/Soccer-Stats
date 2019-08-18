//
//  ViewController.swift
//  KaduregelStats
//
//  Created by User on 30/07/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class MainUICVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categoryCellID = "categoryCell"
    let optionsCellID = "optionsCell"
    
    static var team : Team!
    
    let categories: [Category] = {
        var catg = [Category]()
        catg.append(Category(name: "Stats", image: #imageLiteral(resourceName: "statsImage")))
        catg.append(Category(name: "Players", image: #imageLiteral(resourceName: "playersImage")))
        catg.append(Category(name: "Games", image: #imageLiteral(resourceName: "GamesImage")))
        catg.append(Category(name: "Payment", image: #imageLiteral(resourceName: "paymentImage")))
        return catg
    }()
    
    let options: [Option] = {
        var opt = [Option]()
        opt.append(Option(name: "Change team", icon: #imageLiteral(resourceName: "changeTeamIcon")))
        opt.append(Option(name: "Managers", icon: #imageLiteral(resourceName: "menajersIcon")))
        opt.append(Option(name: "Rules", icon: #imageLiteral(resourceName: "RulesIcone")))
        opt.append(Option(name: "Weather", icon: #imageLiteral(resourceName: "WeatherIcone")))
        opt.append(Option(name: "Setting", icon: #imageLiteral(resourceName: "SettingIcone")))
        opt.append(Option(name: "Contact Us", icon: #imageLiteral(resourceName: "ContactUsIcon")))
        return opt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellID)
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: optionsCellID)
        
        collectionView.allowsSelection = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            cell.category = categories[indexPath.row]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: optionsCellID, for: indexPath) as! OptionsCell
        cell.option = options[indexPath.row]
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return categories.count
        }
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width / 2 - 15, height: 150)
        }
        
        return CGSize(width: view.frame.width - 20 , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.catrgoryImageview.transform = .init(scaleX: 0.95, y: 0.95)
                cell.nameLabel.transform = .init(scaleX: 0.95, y: 0.95)
                
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                
            }
        }
        
        if indexPath.section != 0 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.gray.cgColor
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.catrgoryImageview.transform = .identity
                cell.nameLabel.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
        
        if indexPath.section != 0 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
            cell?.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            markOption(at: indexPath)
            let option = options[indexPath.row]
            popupOption(name: option.name)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            demarkOption(at: indexPath)
        }
    }
    
    func popupOption(name: String){
        switch name {
        case "Contact Us":
            view.addSubview(ContactUsPopUpView(frame: UIScreen.main.bounds))
            break
        case "Managers":
            view.addSubview(ManagersPopUpView(frame: UIScreen.main.bounds))
            break
        default:
            break
        }
    }
    
    func markOption(at indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.gray.cgColor
    }
    
    func demarkOption(at indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
}

//  MARK:- OptionCell Class

class OptionsCell: UICollectionViewCell {
    override init(frame: CGRect){
        super.init(frame:frame)
        setupView()
    }
    
    var option: Option?{
        didSet{
            nameLabel.text = option?.name
            optionIconview.image = option?.icon
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let viewSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        return view
    }()
    
    let optionIconview: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    func setupView(){
        backgroundColor = #colorLiteral(red: 0.9046169519, green: 0.9447903037, blue: 0.9739736915, alpha: 1)
        layer.masksToBounds = true
        layer.cornerRadius = 5
        
        addSubviews(optionIconview, nameLabel, viewSeperator)
        
        optionIconview.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 3, bottom: 0, right: 0), size: CGSize(width: 30, height: frame.height - 10))
        
        viewSeperator.anchor(top: topAnchor, leading: optionIconview.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 15), size: CGSize(width: 1, height: frame.height - 10))
        
        nameLabel.anchor(top: topAnchor, leading: viewSeperator.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: frame.width, height: frame.height))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//  MARK:- CategoryCell Class
class CategoryCell: UICollectionViewCell {
    
    override init(frame: CGRect){
        super.init(frame:frame)
        setupView()
        setupShadow()
        backgroundColor = #colorLiteral(red: 0.9046169519, green: 0.9447903037, blue: 0.9739736915, alpha: 1)
    }
    
    var category: Category?{
        didSet{
            nameLabel.text = category?.name
            catrgoryImageview.image = category?.image
        }
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.3
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.0288759172, green: 0.8338691592, blue: 0.9850193858, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let catrgoryImageview: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    
    func setupView(){
        addSubviews(catrgoryImageview, nameLabel)
        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: frame.width, height: frame.height/3))
        catrgoryImageview.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Category {
    let name: String
    let image: UIImage
}

struct Option {
    let name: String
    let icon: UIImage
}


