//
//  HomeController.swift
//  Soccer
//
//  Created by User on 08/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class HomeController: UIViewController {
    
    //MARK: - Properties

    static var userAsPlayer = Player()
    
    var delegate: HomeControllerDelegate?
    
    private var myTeams = [Team]()
    private let cellID = "myTeamCell"

    private var imgArr = [  UIImage(named:"soccer-image-1"),
                    UIImage(named:"soccer-image-2") ,
                    UIImage(named:"soccer-image-3") ,
                    UIImage(named:"soccer-image-4") ,
                    UIImage(named:"soccer-image-5") ,
                    UIImage(named:"soccer-image-6")
    ]
    
    private var counter = 0
    private var timer = Timer()
    
    lazy var pageView : UIPageControl = {
        let pv = UIPageControl()
        pv.numberOfPages = imgArr.count
        pv.currentPage = 0
        
        return pv
        
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(imageSlidesCell.self, forCellWithReuseIdentifier: "cell")
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = false
        
        
        return cv
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        
        tv.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)
        tv.keyboardDismissMode = .onDrag
        tv.separatorStyle = .none
        
        return tv
    }()
    
    private let activityIndic: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.startAnimating()
        
        return ai
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubviews(tableView, collectionView)

        configurateNavigationBar()
        configurateTableView()
        checkIfUserIsLoggedIn()
 
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlayerAsUserDetailes()
        reciveTeamsFromDB()
        
        DispatchQueue.main.async {
            self.counter = self.imgArr.count
            self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    @objc func changeImage() {
        
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }

    
    //MARK: - Configurations
    
    func configurateTableView() {
        
        let tableViewHeight = view.frame.height/3
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: tableViewHeight))
        
        collectionView.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        view.addSubview(pageView)
        pageView.anchor(top: nil, leading: collectionView.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: collectionView.trailingAnchor, size: CGSize(width: 0, height: 20))
        view.bringSubviewToFront(pageView)
        
        tableView.addSubview(activityIndic)
        activityIndic.centerInSuperview(size: CGSize(width: 50, height: 50))

    }
    
    func configurateNavigationBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(handleMenuToggle))
        profileButton.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.leftBarButtonItem = profileButton
        
        let searchTeamButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchTeamFromAllUsers))
        searchTeamButton.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.rightBarButtonItem = searchTeamButton
        
    }

    //MARK: - Handlers
    
    @objc func searchTeamFromAllUsers(){
        
        let searchTeamTableTableViewController = SearchTeamTableTableViewController()
        let navController = UINavigationController(rootViewController: searchTeamTableTableViewController)
        navController.navigationBar.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }

    // MARK: - Service
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let viewCntroller = LogInViewController()
            self.present(viewCntroller, animated: true, completion: nil)
        }
    }
    
    func getPlayerAsUserDetailes() {
        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
       
        DBService.shared.users.child(uid).observeSingleEvent(of:.value) { [self] (snapshot) in
           
            if let dict = snapshot.value as? [String:Any] {
                
                let player = Player(id: snapshot.key, dict: dict)
                self.navigationItem.title = "Hello \(player.fullName)"
                HomeController.userAsPlayer = player
                self.enabledNavigationBarButtonsStopIndic()
                
            }
        }
    }
    
    func reciveTeamsFromDB() {
        disableNavigationBarButtons()

        guard let uid = Auth.auth().currentUser?.uid else {print("Error to get uid") ; return }

        myTeams.removeAll()
        DBService.shared.teamOfUser.child(uid).observeSingleEvent(of: .value) { [self] (snapshot) in
            
            if let teamsName = snapshot.value as? [String:Any] {

                for teamName in teamsName {
                    self.getUserTeamDetailesFromDB(teamName: teamName.key)
                }
            }
        }
    }
    
    func getUserTeamDetailesFromDB(teamName: String ) {
        
        DBService.shared.allTeams.child(teamName).observe(.value, with: { (snapshot) in
            self.activityIndic.stopAnimating()

            guard let snapDict = snapshot.value as? [String : Any] else {return}
                        
            let team = Team(snapDict: snapDict)
            
            self.myTeams.append(team)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func enabledNavigationBarButtonsStopIndic(){
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.activityIndic.stopAnimating()
    }
    
    func disableNavigationBarButtons(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

// MARK: - TableView Functions

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Teams"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChooseTeamCell
        
        cell.team = myTeams[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else { print("cant find the uid"); return}
        guard let teamToRemove = myTeams[indexPath.row].name else { print("cant find the team name"); return}
        
        myTeams.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        
       
        DBService.shared.teamOfUser.child(uid).child(teamToRemove).removeValue()
        DBService.shared.playersInTeam.child(teamToRemove).child(uid).removeValue()
        
    }
    
    func deleteTeamFromTeams(teamToDelete: String) {
        
        myTeams = myTeams.filter({$0.name != teamToDelete})
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TeamViewController.team = myTeams[indexPath.row]
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let teamViewController = TeamViewController(collectionViewLayout: flowLayout)
        navigationController?.pushViewController(teamViewController, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

// MARK: - CollectionView Delegate

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imageSlidesCell
        cell.slideImage = imgArr[indexPath.row]
        return cell
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

class imageSlidesCell: UICollectionViewCell {
    override init(frame: CGRect){
        super.init(frame:frame)
        setupView()
        backgroundColor = #colorLiteral(red: 0.9046169519, green: 0.9447903037, blue: 0.9739736915, alpha: 1)
    }
    
    var slideImage: UIImage? {
          didSet{
            imageView.image = slideImage
        }
    }
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    func setupView(){
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
