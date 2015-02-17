//
//  ViewController.swift
//  realmTest01
//
//  Created by 佐野正和 on 2015/02/17.
//  Copyright (c) 2015年 furyu. All rights reserved.
//

import UIKit
//import Realm

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nameSearchTextField: UITextField!
    @IBOutlet weak var logTextView: UITextView!
    let realm: RLMRealm = RLMRealm.defaultRealm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realmTest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func realmTest() {
        
//        let realm = RLMRealm.defaultRealm()
        println("defaultRealmPath: \(RLMRealm.defaultRealmPath())")  // DBファイルの場所

        // Bookオブジェクト生成.
//        let book = Book()
//        book.isbn = "999999"
//        book.name = "realm sample"
//        book.price = 100
//        
//        // Bookオブジェクトを保存.
//        realm.beginWriteTransaction()
//        realm.addObject(book)
//        realm.commitWriteTransaction()
//
//        let book2 = Book()
//        book2.isbn = "999998"
//        book2.name = "realm tutorial 1"
//        book2.price = 1000
//
//        // Blockでの保存の仕方.
//        realm.transactionWithBlock() {
//            realm.addObject(book2)
//        }
        
        
        // ------------------------------- //
        // 20件足す
        
//        var n = 1
//        while n < 20 {
//            // Bookオブジェクト生成.
//            var book = Book()
//            book.isbn = "\(111119 + n)"
//            book.name = "realm sample_\(n)"
//            book.price = 100
//            
//            // Bookオブジェクトを保存.
//            realm.beginWriteTransaction()
//            realm.addObject(book)
//            realm.commitWriteTransaction()
//            n++
//        }
        
        var books: RLMResults = Book.allObjects()
//        println(books)
        
        self.logTextView.text = "\(books)"
        
        for realmBook in books {
            println("book name:\((realmBook as Book).name)")
        }
    }
    
    
    @IBAction func searchBtnTapped(sender: AnyObject) {
        var searchStr: String = self.nameSearchTextField.text
        
        println("検索キー:\(searchStr)")
        
        //
        let results = Book.objectsWhere("name = '\(searchStr)'")
        for realmBook in results {
            println("search -> find book name:\((realmBook as Book).name)")
        }
        
        
//        // NSPredicate検索 -> 成功
//        let results2 = Book.objectsWithPredicate(NSPredicate(format: "name = %@", "\(searchStr)"))
//        for realmBook in results2 {
//            // book name:realm tutorial 1
//            println("book name:\((realmBook as Book).name)")
//        }
    }


}

