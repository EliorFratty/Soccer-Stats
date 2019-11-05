//
//  PlayerStatsVC.swift
//  Soccer
//
//  Created by User on 09/10/2019.
//  Copyright © 2019 User. All rights reserved.
//


import UIKit

class PlayerStatsVC: UIViewController {
    
    // MARK:- Proproties
    var player: Player!
    var user: User!
    
     private let textDesign = TextDesign()
    
    var playerLabelPropArr = [UILabel]()
    var playerAddButtons = [UIButton]()
    var playerRankButtons = [UIStackView]()
    var playerProgressView = [UIProgressView]()
    var plyerStackView = [UIStackView]()
    
    let profileImageViewHeight: CGFloat = 150
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.loadImageUsingCatchWithUrlString(URLString: user.profileImageUrl)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = profileImageViewHeight/2
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    lazy var playerNamelabel: UILabel = {
        
        let label = UILabel()
        label.text = user.fullName
        label.textAlignment = .center
        
        return label
        
    }()
    
    let doneRankButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        button.tintColor = .white
        button.isHidden = true
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneRankingPlayer), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
      
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 40
        button.clipsToBounds = true

       //if !player.didManager { button.isHidden = true  }
        button.addTarget(self, action: #selector(editAndDone), for: .touchUpInside)
        return button
    }()
    
    // MARK:- View Cycle
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        view.addSubviews(playerNamelabel, profileImageView, doneRankButton, editButton)
        
        createLabelsForPlayerProp()
        setLabelsAnchors()
        configurateNavigationBar()
        createProgressViews()
        setTextToLabels()
        
    }
    
    // MARK:- ProgressViews
    
    private func createProgressView() -> UIProgressView{
        let progressView = UIProgressView()
        
        progressView.progress = 0.0
        
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 10
        progressView.subviews[1].clipsToBounds = true
        
        progressView.trackTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        progressView.progressTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        return progressView
    }
    
    func createProgressViews(){
        
        for _ in 0...5 {
        
            let progressView = createProgressView()
            
            playerProgressView.append(progressView)
            view.addSubview(progressView)
        }
        
        for index in 0...5 {
            playerProgressView[index].anchor(top: playerLabelPropArr[index + 6].topAnchor, leading: playerLabelPropArr[index + 6].trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0), size: CGSize(width: 180, height: 30))
            
        }
        
        createRankStackViews()
    }
    
    func createRankStackViews(){
        
        //create stackviews
        
        for tag in 0...5 {
            let stackView = UIStackView()
            stackView.spacing = 1
            stackView.distribution = .fillProportionally
            stackView.isHidden = true
            
            for num in 0...4 {
                let numButton = UIButton(type: .system)
                numButton.setTitle(String(num + 1), for: .normal)
                numButton.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                numButton.tag = tag * 5 + num
                numButton.tintColor = .white
                
                numButton.addTarget(self, action: #selector(rankProp(sender:)), for: .touchUpInside)
                numButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                stackView.addArrangedSubview(numButton)
            }
            
            view.addSubview(stackView)
            playerRankButtons.append(stackView)
        }
        
        //set anchors
        
        for index in 0...5 {
            playerRankButtons[index].anchor(top: playerLabelPropArr[index + 6].topAnchor, leading: playerLabelPropArr[index + 6].trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0), size: CGSize(width: 180, height: 30))
            
        }
        
        doneRankButton.centerInXPositionSuperview(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, size: CGSize(width: 100, height: 40))
    }
    
    var newRankedPlayer: [Double] = [0, 0, 0, 0, 0, 0]
    
    @objc func rankProp(sender: UIButton){
        let rawNum = sender.tag / 5
        playerRankButtons[rawNum].subviews.forEach({ (view) in
            view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        })
        sender.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        newRankedPlayer[rawNum] = Double(sender.currentTitle!)!
        
        let statsNotRanked = newRankedPlayer.filter{ $0 == 0 }.count
        
        if statsNotRanked == 0 { doneRankButton.isEnabled = true }
        
    }
    
    // MARK:- LabelsForPlayerProp
    func createLabelsForPlayerProp(){
        for _ in 0..<12 {
            let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            view.addSubview(label)
            playerLabelPropArr.append(label)
        }
        
        var cnt = 0
        
        for _ in 0...11 {
            let addButton = UIButton(type: .system)
            
            addButton.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)
            
            if cnt % 2 == 0 {
                addButton.setTitle("+",for: .normal)
                addButton.backgroundColor = .green
            } else {
                addButton.setTitle("-",for: .normal)
                addButton.backgroundColor = .red
            }
            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            addButton.tag = cnt
            
            cnt += 1
            addButton.isHidden = true
            view.addSubview(addButton)
            playerAddButtons.append(addButton)
        }
        
        cnt = 0
        for index in 0...5 {
            
            let stackView = UIStackView()
            stackView.spacing = 1
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(playerAddButtons[cnt])
            stackView.addArrangedSubview(playerLabelPropArr[index])
            stackView.addArrangedSubview(playerAddButtons[cnt + 1])
            
            cnt += 2
            view.addSubview(stackView)
            plyerStackView.append(stackView)
        }
        
        editButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0), size: CGSize(width: 80, height: 80))
    }
    
    func setLabelsAnchors(){
        
        let sizeHeight: CGFloat = 40
        var marginLeft: CGFloat = 0
        let viewWidth = view.frame.width
        
        profileImageView.centerInXPositionSuperview(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: profileImageViewHeight, height: profileImageViewHeight))
        
        playerNamelabel.centerInXPositionSuperview(top: profileImageView.bottomAnchor, bottom: nil, size: CGSize(width: viewWidth , height: sizeHeight))
        
        plyerStackView[0].centerInXPositionSuperview(top: playerNamelabel.bottomAnchor, bottom: nil, size: CGSize(width: viewWidth/3 + 10 , height: sizeHeight))
        
        for index in 1...3 {
            plyerStackView[index].anchor(top: plyerStackView[0].bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: marginLeft, bottom: 0, right: 0), size: CGSize(width: viewWidth/3 , height: sizeHeight))
            
            marginLeft += viewWidth/3
        }
        
        marginLeft = 30
        
        for index in 4...5 {
            plyerStackView[index].anchor(top: playerLabelPropArr[3].bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: marginLeft, bottom: 0, right: 0), size: CGSize(width: viewWidth/3 + 10, height: sizeHeight))
            
            marginLeft += viewWidth/2
        }
        
        marginLeft = 0
        var marginTop: CGFloat = 30
        
        for index in 6...11 {
            playerLabelPropArr[index].anchor(top: plyerStackView[4].bottomAnchor, leading: plyerStackView[4].leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: marginTop, left: 0, bottom: 0, right: 0), size: CGSize(width: viewWidth/3 , height: sizeHeight))
            
            playerLabelPropArr[index].textAlignment = .left
            
            marginTop += sizeHeight + 5
        }
    }
    
    func setTextToLabels(){
        playerLabelPropArr[0].text = "game: \(player.games)"
        playerLabelPropArr[4].text = "goals: \(player.goals)"
        playerLabelPropArr[5].text = "asists: \(player.asists)"
        playerLabelPropArr[1].text = "wins: \(player.wins)"
        playerLabelPropArr[3].text = "lose: \(player.lose)"
        playerLabelPropArr[2].text = "tie: \(player.tie)"
        
        playerLabelPropArr[6].text = "speed: \(player.speed)"
        playerLabelPropArr[7].text = "shoot: \(player.shoot)"
        playerLabelPropArr[8].text = "drible: \(player.drible)"
        playerLabelPropArr[9].text = "tackle: \(player.tackle)"
        playerLabelPropArr[10].text = "pass: \(player.pass)"
        playerLabelPropArr[11].text = "goalKeeper: \(player.goalKeeper)"
        
        playerProgressView[0].setProgress(Float(player.speed/5), animated: true)
        playerProgressView[1].setProgress(Float(player.shoot/5), animated: true)
        playerProgressView[2].setProgress(Float(player.drible/5), animated: true)
        playerProgressView[3].setProgress(Float(player.tackle/5), animated: true)
        playerProgressView[4].setProgress(Float(player.pass/5), animated: true)
        playerProgressView[5].setProgress(Float(player.goalKeeper/5), animated: true)
        
    }
    
    @objc func add(sender: UIButton){
        switch sender.tag {
        case 0:
            player.games += 1;
        case 1:
            player.games -= 1;
        case 2:
            player.wins += 1;
        case 3:
            player.wins -= 1;
        case 4:
            player.tie += 1;
        case 5:
            player.tie -= 1;
        case 6:
            player.lose += 1;
        case 7:
            player.lose -= 1;
        case 8:
            player.goals += 1;
        case 9:
            player.goals -= 1;
        case 10:
            player.asists += 1;
        case 11:
            player.asists -= 1;
            
        default:
            break
        }
        
        updateDB()
        setTextToLabels()
    }
    
    @objc func doneRankingPlayer(){
        playerProgressView.forEach{ $0.isHidden = false }
        playerRankButtons.forEach{ $0.isHidden = true }
        doneRankButton.isHidden = true
        
        clacNewPlayerRank()
        player.didRank = true
        navigationItem.rightBarButtonItem!.isEnabled = false
        
        setTextToLabels()
        
    }
    
    func clacNewPlayerRank() {
        
        let allPlayersRanked = player.allPlayersRanked + 1
        DBService.shared.players.child(user.fullName).updateChildValues(["allPlayersRanked": allPlayersRanked])
        
        player.speed      = (player.speed + newRankedPlayer[0]) / allPlayersRanked
        player.shoot      = (player.shoot + newRankedPlayer[1]) / allPlayersRanked
        player.drible     = (player.drible + newRankedPlayer[2]) / allPlayersRanked
        player.tackle     = (player.tackle + newRankedPlayer[3]) / allPlayersRanked
        player.pass       = (player.pass + newRankedPlayer[4]) / allPlayersRanked
        player.goalKeeper = (player.goalKeeper + newRankedPlayer[5]) / allPlayersRanked
        
        updateDB()
    }
    
    func updateDB(){
        
        DBService.shared.players.child(user.fullName).updateChildValues(["speed": player.speed])
        DBService.shared.players.child(user.fullName).updateChildValues(["shoot": player.shoot ])
        DBService.shared.players.child(user.fullName).updateChildValues(["drible": player.drible ])
        DBService.shared.players.child(user.fullName).updateChildValues(["tackle": player.tackle ])
        DBService.shared.players.child(user.fullName).updateChildValues(["pass": player.pass ])
        DBService.shared.players.child(user.fullName).updateChildValues(["goalKeeper": player.goalKeeper ])
        DBService.shared.players.child(user.fullName).updateChildValues(["didRank": "true" ])
        
        DBService.shared.players.child(user.fullName).updateChildValues(["games": player.games ])
        DBService.shared.players.child(user.fullName).updateChildValues(["goals": player.goals ])
        DBService.shared.players.child(user.fullName).updateChildValues(["asists": player.asists ])
        DBService.shared.players.child(user.fullName).updateChildValues(["wins": player.wins ])
        DBService.shared.players.child(user.fullName).updateChildValues(["lose": player.lose ])
        DBService.shared.players.child(user.fullName).updateChildValues(["tie": player.tie ])

    }
    
    // MARK:- Navigation Bar
    
    func makeNavBar() {
        

        let rankButton =  UIBarButtonItem(title: "Rank", style: .plain, target: self, action: #selector(rank))
        navigationItem.leftBarButtonItem = rankButton
        
        if player.didRank { navigationItem.leftBarButtonItem!.isEnabled = false }
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAndDone))
        navigationItem.rightBarButtonItem = editButton
        
        if !player.didManager { navigationItem.rightBarButtonItem!.isEnabled = false }
        
        
    }
    
    func configurateNavigationBar() {
        
        self.title = "Player"
        
        let rankButton =  UIBarButtonItem(title: "Rank", style: .plain, target: self, action: #selector(rank))
        rankButton.setTitleTextAttributes(textDesign.navigationBarButtonItemAtrr, for: .normal)
        navigationItem.rightBarButtonItem = rankButton
        if player.didRank { navigationItem.rightBarButtonItem!.isEnabled = false }
        
        let goBackToHome = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToHomeController))
        goBackToHome.setTitleTextAttributes(textDesign.navigationBarButtonItemAtrr, for: .normal)
        navigationItem.leftBarButtonItem = goBackToHome
        
    }
    
    @objc func rank(){
        playerProgressView.forEach{ $0.isHidden = true }
        playerRankButtons.forEach{ $0.isHidden = false }
        doneRankButton.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    @objc func goBackToHomeController(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editAndDone(){
        
        if editButton.titleLabel?.text == "Edit" {
            playerAddButtons.forEach{ $0.isHidden = false }
            editButton.setTitle("Done", for: .normal)
        } else {
            playerAddButtons.forEach{ $0.isHidden = true }
            editButton.setTitle("Edit", for: .normal)
        }
    }
}

