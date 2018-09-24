//
//  ViewController.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/19.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enter(_ sender: UIButton) {
        let type = PhotoListType(rawValue: sender.titleLabel?.text ?? "")
        
        let vc = ListViewController(nibName: "ListViewController", bundle: nil)
        vc.bind(type: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

