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
    
    @IBOutlet weak var nameSearchTextField: UITextField!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var serachTypeSeg: UISegmentedControl!

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
        
        var searchStr: String = self.nameSearchTextField.text
        println("serach word : \(searchStr)")
        
//        if searchStr.utf16Count != 0 {
        if count(searchStr) != 0 {
        
            // 検索条件の用意
            var searchType: String = self.sortSearchType(self.serachTypeSeg.selectedSegmentIndex) // 検索対象
            var query: String = searchType == "age" ? "\(searchType) = \(searchStr)" : "\(searchType) = '\(searchStr)'"  // （ageのみintなので）queryを調整
            
            // 検索スタート
            let results = User.objectsWhere(query)
            var log = "\n"
            for realmUser in results {
                log = log + "find user : \((realmUser as! User).name)\n"
            }
            self.showSearchResult(log) // 結果表示
        }
    }
    
    func sortSearchType(segtype: Int) -> String {
        var str: String = ""
        switch segtype {
            case 0:
                str = "name"
            case 1:
                str = "age"
            case 2:
                str = "gender"
            default:
                break
        }
        return str
    }
    
    func showSearchResult(var result: String) {
        result = result == "\n" ? "N/A" : result
        
        var alertController = UIAlertController(title: "search result", message: result, preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in println("alert close")
        }
        alertController.addAction(otherAction)
        presentViewController(alertController, animated: true, completion: nil)
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
        var addUserViewController: AddUserViewController = storyboard.instantiateInitialViewController() as! AddUserViewController
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

