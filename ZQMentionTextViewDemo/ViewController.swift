//
//  ViewController.swift
//  ZQMentionTextViewDemo
//
//  Created by ZQ on 2019/4/30.
//  Copyright © 2019 CZQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 15, y:100, width: view.frame.width-30, height: view.frame.height-150)
        let textView  = ZQMentionTextView(frame: frame)
        textView.placeholderText = "加个话题，更能被注意哦"
        textView.placeholderColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(textView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

