//
//  ViewController.swift
//  SettingsTemplate
//
//  Created by User on 15/11/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "SettingsCell"

class SettingVC: UIViewController {
    
    // MARK: - Properties
    
    var userInfoHeader: UserInfoHeader!
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = 60
        tb.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tb.tableHeaderView = userInfoHeader
        tb.frame = view.frame
        tb.tableFooterView = UIView()
        
        return tb
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        
        //tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        view.addSubview(tableView)
       // tableView.tableHeaderView = userInfoHeader
       // tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let goBackToHome = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToHomeController))
        goBackToHome.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.leftBarButtonItem = goBackToHome
        navigationItem.title = "Settings"
        
    }
    
    @objc func goBackToHomeController(){
        navigationController?.popViewController(animated: true)
    }

}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Social: return SocialOptions.allCases.count
        case .Communications: return CommunicationOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Communications:
            let communications = CommunicationOptions(rawValue: indexPath.row)
            cell.sectionType = communications
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Social:
            if SocialOptions(rawValue: indexPath.row)?.description ?? "nil" == "Log Out" {
                logout()
            } else {
                print(SocialOptions(rawValue: indexPath.row)?.description ?? "nil")
            }

        case .Communications:
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func logout(){
        try! Auth.auth().signOut()
        let viewCntroller = LogInViewController()
        self.present(viewCntroller, animated: true, completion: nil)
    }
}
