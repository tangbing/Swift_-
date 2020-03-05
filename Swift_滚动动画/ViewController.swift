//
//  ViewController.swift
//  Swift_滚动动画
//
//  Created by Tb on 2020/3/4.
//  Copyright © 2020 Tb. All rights reserved.
//

import UIKit

let TOP_HEIGHT: CGFloat = UIDevice.current.isiPhoneXMore() ? 88 : 64

class ViewController: UIViewController {
    static let cellId = "cellId"
    static let kHeight: CGFloat = 250
    private var navBarAlpha: Void?

    let topImageVie: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        //imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "taylor_swift_bad_blood")
        return imageView
    }()
    
    let backGroudView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let tableview : UITableView = {
       let talbeView = UITableView()
        talbeView.contentInset = UIEdgeInsets(top: kHeight, left: 0, bottom: 0, right: 0)
        talbeView.bounces = false
        talbeView.register(type(of: UITableViewCell()), forCellReuseIdentifier: cellId)
        return talbeView
        
    }()
    override func viewWillAppear(_ animated: Bool) {
          // 导航栏完全透明
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "滚动效果"
        if #available(iOS 11.0, *){
            tableview.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

         tableview.dataSource = self
         tableview.delegate = self
         self.view.addSubview(tableview)
         tableview.frame = self.view.bounds;
        
        backGroudView.addSubview(topImageVie)
        topImageVie.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: ViewController.kHeight)
        tableview.backgroundView = backGroudView
        
        tableview.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
       
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let changeVlaue = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            let alpha = (250 - abs(changeVlaue.y)) / (250 - TOP_HEIGHT);
            print("alpha:\(alpha)")
            navBarBackgroundAlpha = alpha
            
        }
    }
    
    deinit {
        tableview.removeObserver(self, forKeyPath: "contentOffset")
    }
}
extension UINavigationController{
    
     func setBackgroundAlpha(alpha:CGFloat){
        if let barBackgroundView = navigationBar.subviews.first{
            if #available(iOS 11.0, *){
                if navigationBar.isTranslucent{
                    for view in barBackgroundView.subviews {
                        view.alpha = alpha
                    }
                }else{
                    barBackgroundView.alpha = alpha
                }
            } else {
                barBackgroundView.alpha = alpha
            }
        }
    }
}
private var navBarAlpha: Void?

extension UIViewController{
    // navigationBar _UIBarBackground alpha
    var navBarBackgroundAlpha:CGFloat {
        get {
            guard let barBackgroundAlpha = objc_getAssociatedObject(self, &navBarAlpha) as? CGFloat else {
                return 1.0
            }
            return barBackgroundAlpha
        }
        set {
            objc_setAssociatedObject(self, &navBarAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.navigationController?.setBackgroundAlpha(alpha: newValue)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellId)!
        
        cell.textLabel?.text = "这是\(indexPath.row)行"
        return cell
        
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}


extension UIDevice {
    public func isiPhoneXMore() -> Bool {
        var isMore:Bool = false
        if #available(iOS 11.0, *) {
            if let  more = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                isMore = more > 0.0
            }
        }
        return isMore
    }
}
