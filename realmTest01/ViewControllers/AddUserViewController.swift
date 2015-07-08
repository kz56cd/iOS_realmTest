//
//  AddUserViewController.swift
//  realmTest01
//
//  Created by 佐野正和 on 2015/02/18.
//  Copyright (c) 2015年 furyu. All rights reserved.
//

import UIKit

protocol AddUserViewControllerDelegate {
    func recieveNewUser(user: User)
}

class AddUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageSlider: UISlider!
    
    var delegate: AddUserViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - action -
    
    /**
    バックボタン タップ時
    */
    @IBAction func backBtnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    追加ボタン タップ時
    */
    @IBAction func addBtnTapped(sender: AnyObject) {
        self.createNewAddUser()
    }
    
    @IBAction func ageSliderChanged(sender: AnyObject) {
        var slider: UISlider = sender as! UISlider
        self.ageLabel.text   = "\(roundf(slider.value))".stringByReplacingOccurrencesOfString(".0", withString: "", options: nil, range: nil) // 少数以下は四捨五入のち除外
    }
    
    // MARK: - private methods -
    
    
    /**
    入力内容より新規ユーザー作成
    */
    func createNewAddUser() {
        
        // バリデートチェック
        if self.doPoorValidate() {
            var user = User()
            user.name   = self.nameTextField.text
            var age: String = self.ageLabel.text!
            user.age    = age.toInt()!
            user.gender = self.genderSeg.selectedSegmentIndex == 0 ? "male" : "female"
            self.delegate.recieveNewUser(user) // delegateで作成Userをパス
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
        // エラー
            println("validate error.")
            self.showErrorAlert() // アラート表示
        }
    }
    
    /**
    *  簡素なバリデーション
    */
    func doPoorValidate() -> Bool {

        // 未入力チェックのみ
        if let str = self.nameTextField.text {
            return count(str) != 0
        }
        return false
    }
    
    /**
    エラーアラート表示
    */
    func showErrorAlert() {
        var alertController = UIAlertController(title: "validate error", message: "check inputs", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "yes", style: .Default) {
            action in println("pushed yes.")
        }
        alertController.addAction(otherAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}