//
//  ViewController.swift
//  realmTest01
//
//  Created by 佐野正和 on 2015/02/17.
//  Copyright (c) 2015年 furyu. All rights reserved.
//

import UIKit
//import Realm

class ViewController: UIViewController, AddUserViewControllerDelegate {
    
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var nameSearchTextField: UITextField!
    @IBOutlet weak var logTextView: UITextView!

    let realm: RLMRealm = RLMRealm.defaultRealm()
    private var notificationToken : RLMNotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareRealm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - action -
    
    
    /**
    検索ボタン タップ時
    */
    @IBAction func searchBtnTapped(sender: AnyObject) {
        self.searchResultLabel.text = "result :"
        
        var searchStr: String = self.nameSearchTextField.text
        println("serach word : \(searchStr)")
        
        let results = User.objectsWhere("name = '\(searchStr)'")
        for realmUser in results {
            var log = "search -> find user name : \((realmUser as User).name)"
            self.searchResultLabel.text = log
            println(log)
        }
    }
    
    /**
    tempデータ追加ボタン タップ時
    */
    @IBAction func addTempDataBtnTapped(sender: AnyObject) {
        
        // 20件足す
        var n = 1
        while n < 20 {
            // Userオブジェクト生成.
            var user = User()
            user.name   = "sample_user_\(n)"
            user.age    = 3 * n
            user.gender = n % 2 == 0 ? "male" : "female"
            self.addUser(user) // 追加
            n++
        }
        self.showDBLog()
        println("DONE : addTempData")
    }
    
    /**
    ユーザー追加ボタン タップ時
    */
    @IBAction func addUserBtnTapped(sender: AnyObject) {
        // モーダル画面へ
        var storyboard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        var addUserViewController: AddUserViewController = storyboard.instantiateInitialViewController() as AddUserViewController
        addUserViewController.delegate = self
        self.presentViewController(addUserViewController, animated: true, completion: nil)
    }
    
    /**
    全ユーザー削除ボタン タップ時
    */
    @IBAction func deleteAllBtnTapped(sender: AnyObject) {
        realm.beginWriteTransaction()
        self.realm.deleteAllObjects()
        realm.commitWriteTransaction()
        self.showDBLog()
        println("DONE : delleAll")
    }
    
    
    // MARK: - private methods -

    
    /**
    DBログ画面表示
    */
    func showDBLog() {
        var users: RLMResults = User.allObjects() // 全データ取得
        self.logTextView.text = "\(users)"
        for realmUser in users {
//            println("users name : \((realmUser as User).name)")
        }
    }
    
    /**
    realm準備
    */
    func prepareRealm() {
        println("defaultRealmPath: \(RLMRealm.defaultRealmPath())")  // DBファイルの場所を表示
        
        self.notificationToken = realm.addNotificationBlock { note, realm in // 通知センターとの連携 (* この実装は任意でよい)
            println("recieve Notif : \(note)")
        }
        self.showDBLog()
    }
    
    /**
    ユーザーの追加
    */
    func addUser(user: User) {
// 追加 (通常)
//        realm.beginWriteTransaction()
//        realm.addObject(user)
//        realm.commitWriteTransaction()
        
        // 追加 (Blocks)
        self.realm.transactionWithBlock() {
            self.realm.addObject(user)
        }
    }

    
    // MARK: - AddUserViewController Delegate -
    
    
    /**
    追加するユーザーを受け取る
    */
    func recieveNewUser(user: User) {
        println("WILL : add new user")
        self.addUser(user)
        self.showDBLog()
    }
}

