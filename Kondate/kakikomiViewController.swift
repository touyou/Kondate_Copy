//
//  kakikomiViewController.swift
//  Kondate
//
//  Created by 藤井陽介 on 2016/12/07.
//  Copyright © 2016年 ryusei wakasa. All rights reserved.
//

import UIKit
import CoreData

class kakikomiViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var asacameraImageView: UIImageView!
    @IBOutlet var hirucameraImageView: UIImageView!
    @IBOutlet var yorucameraImageView: UIImageView!
    
    @IBOutlet var asatuikaLabel: UILabel!
    @IBOutlet var hirutuikaLabel: UILabel!
    @IBOutlet var yorutuikaLabel: UILabel!
    
    //@IBOutlet var asabatuButton: UIButton!
    //@IBOutlet var hirubatuButton: UIButton!
    //@IBOutlet var yorubatuButton: UIButton!
    
    
    // 撮った写真の最初の状態を保持
    
    var sikibetunumber : Int = 0
    
    
    
    
    @IBOutlet var asagohanTextField: UITextField!
    @IBOutlet var hirugohanTextField: UITextField!
    @IBOutlet var yorugohanTextField: UITextField!
    
    
    var date: Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        asacameraImageView.tag = 100
        asacameraImageView.isUserInteractionEnabled  = true
        
        hirucameraImageView.tag = 101
        hirucameraImageView.isUserInteractionEnabled  = true
        
        yorucameraImageView.tag = 102
        yorucameraImageView.isUserInteractionEnabled  = true
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Kondate> = Kondate.fetchRequest()
        
        
        let calendar = Calendar(identifier: .gregorian)
        let target = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        
        // dateで指定した日の0時0分0秒から23時59分59秒の間にあるかどうかという検索条件
        query.predicate = NSPredicate(format: "SELF.date BETWEEN {%@, %@}",
                                      argumentArray: [target, Date(timeInterval: 24*60*60-1, since: target)])
        let fetchData = try! viewContext.fetch(query)
        
        // 一日の記事は一個だけなので最初をとってきてあればUIに反映する
        if let data = fetchData.first {
            asagohanTextField.text = data.asagohan
            hirugohanTextField.text = data.hirugohan
            yorugohanTextField.text = data.yorugohan
            asacameraImageView.image = UIImage(data: data.asagohanimage as? Data ?? Data())
            hirucameraImageView.image = UIImage(data: data.hirugohanimage as? Data ?? Data())
            yorucameraImageView.image = UIImage(data: data.yorugohanimage as? Data ?? Data())
            
        }
        /*if asacameraImageView.image == nil {
         asabatuButton.isHidden = true
         }
         if hirucameraImageView.image == nil {
         hirubatuButton.isHidden = true
         }
         if yorucameraImageView.image == nil {
         yorubatuButton.isHidden = true
         }*/
        
        if asacameraImageView.image != nil {
            asatuikaLabel.isHidden = true
        }
        if hirucameraImageView.image != nil {
            hirutuikaLabel.isHidden = true
        }
        if yorucameraImageView.image != nil {
            yorutuikaLabel.isHidden = true
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view?.tag == asacameraImageView.tag {
            print("朝ごはんの画像がタップされました")
            let actionSheet = UIAlertController(title: "メディアの選択", message: "どのアプリのメディアを使いますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
            sikibetunumber = 0
            let action1 = UIAlertAction(title: "カメラで撮る", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション１をタップした時の処理")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    // カメラを起動する
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerControllerSourceType.camera
                    picker.delegate = self
                    
                    // カメラを自由な形に開きたい時（特に正方形）
                    picker.allowsEditing = true
                    
                    self.present(picker, animated: true, completion: nil)
                } else {
                    // カメラが利用できないときはerrorがコンソールに表示される
                    print("error")
                }
            })
            
            let action2 = UIAlertAction(title: "写真から選ぶ", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション２をタップした時の処理")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    // カメラを自由な形に開きたい時（今回は正方形）
                    picker.allowsEditing = true
                    
                    // アプリ画面へ戻る
                    self.present(picker, animated: true, completion: nil)
                }
            })
            
            let action3 = UIAlertAction(title: "画像を削除", style: UIAlertActionStyle.destructive, handler: {
                (action: UIAlertAction!) in
                print("アクション３をタップした時の処理")
                let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
                
                let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
                    (action: UIAlertAction!) in
                    print("削除が押されました")
                    self.asacameraImageView.image = nil
                    //self.asabatuButton.isHidden = true
                    self.asatuikaLabel.isHidden = false
                })
                
                
                
                let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                    (action: UIAlertAction!) in
                    print("キャンセルをタップした時の処理")
                })
                
                alert.addAction(action1)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
                
            })
            
            
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) in
                print("キャンセルをタップした時の処理")
            })
            
            actionSheet.addAction(action1)
            actionSheet.addAction(action2)
            actionSheet.addAction(cancel)
            if asacameraImageView.image != nil {
                actionSheet.addAction(action3)
            }
            
            self.present(actionSheet, animated: true, completion: nil)
            
            
        }
        
        
        
        if touch?.view?.tag == hirucameraImageView.tag {
            
            print("昼ごはんの画像がタップされました")
            let actionSheet = UIAlertController(title: "メディアの選択", message: "どのアプリのメディアを使いますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
            sikibetunumber = 1
            let action1 = UIAlertAction(title: "カメラで撮る", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション１をタップした時の処理")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    // カメラを起動する
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerControllerSourceType.camera
                    picker.delegate = self
                    
                    // カメラを自由な形に開きたい時（特に正方形）
                    picker.allowsEditing = true
                    
                    self.present(picker, animated: true, completion: nil)
                } else {
                    // カメラが利用できないときはerrorがコンソールに表示される
                    print("error")
                }
            })
            
            let action2 = UIAlertAction(title: "写真から選ぶ", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション２をタップした時の処理")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    // カメラを自由な形に開きたい時（今回は正方形）
                    picker.allowsEditing = true
                    
                    // アプリ画面へ戻る
                    self.present(picker, animated: true, completion: nil)
                }
            })
            
            let action3 = UIAlertAction(title: "画像を削除", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション３をタップした時の処理")
                let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
                
                let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
                    (action: UIAlertAction!) in
                    print("削除が押されました")
                    self.hirucameraImageView.image = nil
                    //self.asabatuButton.isHidden = true
                    self.hirutuikaLabel.isHidden = false
                })
                
                
                
                let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                    (action: UIAlertAction!) in
                    print("キャンセルをタップした時の処理")
                })
                
                alert.addAction(action1)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
                
            })
            
            
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) in
                print("キャンセルをタップした時の処理")
            })
            
            actionSheet.addAction(action1)
            actionSheet.addAction(action2)
            actionSheet.addAction(cancel)
            if hirucameraImageView.image != nil {
                actionSheet.addAction(action3)
            }
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
        if touch?.view?.tag == yorucameraImageView.tag {
            print("夜ごはんの画像がタップされました")
            let actionSheet = UIAlertController(title: "メディアの選択", message: "どのアプリのメディアを使いますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
            sikibetunumber = 2
            let action1 = UIAlertAction(title: "カメラで撮る", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション１をタップした時の処理")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    // カメラを起動する
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerControllerSourceType.camera
                    picker.delegate = self
                    
                    // カメラを自由な形に開きたい時（特に正方形）
                    picker.allowsEditing = true
                    
                    self.present(picker, animated: true, completion: nil)
                } else {
                    // カメラが利用できないときはerrorがコンソールに表示される
                    print("error")
                }
            })
            
            let action2 = UIAlertAction(title: "写真から選ぶ", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション２をタップした時の処理")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    // カメラを自由な形に開きたい時（今回は正方形）
                    picker.allowsEditing = true
                    
                    // アプリ画面へ戻る
                    self.present(picker, animated: true, completion: nil)
                }
            })
            
            let action3 = UIAlertAction(title: "画像を削除", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション３をタップした時の処理")
                let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
                
                let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
                    (action: UIAlertAction!) in
                    print("削除が押されました")
                    self.yorucameraImageView.image = nil
                    //self.asabatuButton.isHidden = true
                    self.yorutuikaLabel.isHidden = false
                })
                
                
                
                let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                    (action: UIAlertAction!) in
                    print("キャンセルをタップした時の処理")
                })
                
                alert.addAction(action1)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
                
            })
            
            
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) in
                print("キャンセルをタップした時の処理")
            })
            
            actionSheet.addAction(action1)
            actionSheet.addAction(action2)
            actionSheet.addAction(cancel)
            if yorucameraImageView.image != nil {
                actionSheet.addAction(action3)
            }
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMemo() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Kondate> = Kondate.fetchRequest()
        
        let calendar = Calendar(identifier: .gregorian)
        let target = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        
        // dateで指定した日の0時0分0秒から23時59分59秒の間にあるかどうかという検索条件
        query.predicate = NSPredicate(format: "SELF.date BETWEEN {%@, %@}",
                                      argumentArray: [target, Date(timeInterval: 24*60*60-1, since: target)])
        let fetchData = try! viewContext.fetch(query)
        
        
        
        if !fetchData.isEmpty {
            // 検索してあれば見つかった最初のデータを今のデータで更新
            // fetchDataの0番目のasagohanにasagohanTextFieldに入力されている内容を入れる
            fetchData[0].asagohan = asagohanTextField.text
            fetchData[0].hirugohan = hirugohanTextField.text
            fetchData[0].yorugohan = yorugohanTextField.text
            fetchData[0].asagohanimage = UIImagePNGRepresentation(asacameraImageView.image ?? UIImage()) as? NSData
            fetchData[0].hirugohanimage = UIImagePNGRepresentation(hirucameraImageView.image ?? UIImage()) as? NSData
            fetchData[0].yorugohanimage = UIImagePNGRepresentation(yorucameraImageView.image ?? UIImage())  as? NSData
        } else {
            // 無ければつくる
            let kondate = Kondate(context: viewContext)
            kondate.asagohan = asagohanTextField.text
            kondate.hirugohan = hirugohanTextField.text
            kondate.yorugohan = yorugohanTextField.text
            kondate.date = date as NSDate
            kondate.asagohanimage = UIImagePNGRepresentation(asacameraImageView.image ?? UIImage()) as? NSData
            kondate.hirugohanimage = UIImagePNGRepresentation(hirucameraImageView.image ?? UIImage()) as? NSData
            kondate.yorugohanimage = UIImagePNGRepresentation(yorucameraImageView.image ?? UIImage()) as? NSData
            kondate.asalike = 0
            kondate.hirulike = 0
            kondate.yorulike = 0
        }
        // 最後にセーブ処理
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        
        
        
        
        /*let flag = true
         do {
         let fetchResults = try viewContext.fetch(query)
         for result: AnyObject in fetchResults {
         let date: Date? = result.value(forKey: "date") as? Date
         // dateが同じだったらデータをアップデートする
         }
         } catch {
         }
         if flag {
         let kondate = NSEntityDescription.entity(forEntityName: "Kondate", in: viewContext)
         let newRecord = NSManagedObject(entity: kondate!, insertInto: viewContext)
         
         newRecord.setValue(asagohanTextField.text, forKey: "asagohan") //値を代入
         newRecord.setValue(hirugohanTextField.text, forKey: "hirugohan") //値を代入
         newRecord.setValue(yorugohanTextField.text, forKey: "yorugohan") //値を代入
         newRecord.setValue(Date(), forKey: "date")//値を代入
         
         }
         
         
         
         saveData.set(asagohanTextField.text, forKey: "asagohantitle")
         saveData.set(hirugohanTextField.text, forKey: "hirugohantitle")
         saveData.set(yorugohanTextField.text, forKey: "yorugohantitle")
         saveData.synchronize()*/
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "メディアの選択", message: "どのアプリのメディアを使いますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
        sikibetunumber = sender.tag
        let action1 = UIAlertAction(title: "カメラで撮る", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション１をタップした時の処理")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                // カメラを起動する
                let picker = UIImagePickerController()
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.delegate = self
                
                // カメラを自由な形に開きたい時（特に正方形）
                picker.allowsEditing = true
                
                self.present(picker, animated: true, completion: nil)
            } else {
                // カメラが利用できないときはerrorがコンソールに表示される
                print("error")
            }
        })
        
        let action2 = UIAlertAction(title: "写真から選ぶ", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション２をタップした時の処理")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                // カメラを自由な形に開きたい時（今回は正方形）
                picker.allowsEditing = true
                
                // アプリ画面へ戻る
                self.present(picker, animated: true, completion: nil)
            }
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセルをタップした時の処理")
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /*@IBAction func asabatu() {
     // asacameraImageViewのimageをnilにする
     // ボタンを非表示にする
     
     let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
     
     let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
     (action: UIAlertAction!) in
     print("アクション１をタップした時の処理")
     self.asacameraImageView.image = nil
     //self.asabatuButton.isHidden = true
     })
     
     
     
     let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
     (action: UIAlertAction!) in
     print("キャンセルをタップした時の処理")
     })
     
     alert.addAction(action1)
     alert.addAction(cancel)
     
     self.present(alert, animated: true, completion: nil)
     
     
     
     }
     @IBAction func hirubatu() {
     let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
     
     let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
     (action: UIAlertAction!) in
     print("アクション１をタップした時の処理")
     self.hirucameraImageView.image = nil
     //self.hirubatuButton.isHidden = true
     })
     
     
     
     let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
     (action: UIAlertAction!) in
     print("キャンセルをタップした時の処理")
     })
     
     alert.addAction(action1)
     alert.addAction(cancel)
     
     self.present(alert, animated: true, completion: nil)
     
     }
     @IBAction func yorubatu() {
     let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
     
     let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
     (action: UIAlertAction!) in
     print("アクション１をタップした時の処理")
     self.yorucameraImageView.image = nil
     //self.yorubatuButton.isHidden = true
     })
     
     
     
     let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
     (action: UIAlertAction!) in
     print("キャンセルをタップした時の処理")
     })
     
     alert.addAction(action1)
     alert.addAction(cancel)
     
     self.present(alert, animated: true, completion: nil)
     
     }*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 撮った写真を最初の画像として記憶しておく
        if sikibetunumber == 0 {
            //asabatuButton.isHidden = false
            asatuikaLabel.isHidden = true
            asacameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
            
        }else if sikibetunumber == 1 {
            //hirubatuButton.isHidden = false
            hirutuikaLabel.isHidden = true
            hirucameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        }else if sikibetunumber == 2 {
            //yorubatuButton.isHidden = false
            yorutuikaLabel.isHidden = true
            yorucameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        }
        
        
        
        dismiss(animated: true, completion: nil)    // アプリ画面へ戻る
    }
    
    
    
    
}

extension UIScrollView {
    override open func  touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
    }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


