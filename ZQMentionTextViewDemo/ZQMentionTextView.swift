//
//  ZQMentionTextView.swift
//  ZQMentionTextViewDemo
//
//  Created by 雷丹 on 2019/4/30.
//  Copyright © 2019 CZQ. All rights reserved.
//

import UIKit
/**加上class采能用weak修饰代理*/
@objc protocol ZQMentionTextViewDelegate:class {
    @objc optional func textViewDidChange(_ textView: ZQMentionTextView)
    @objc optional func textViewDidEndEditing(_ textView: ZQMentionTextView)
    @objc optional func textViewDidBeginEditing(_ textView: ZQMentionTextView)
    @objc optional func textViewDidChangeSelection(_ textView: ZQMentionTextView)
    @objc optional func textViewShouldEndEditing(_ textView: ZQMentionTextView) -> Bool
    @objc optional func textViewShouldBeginEditing(_ textView: ZQMentionTextView) -> Bool
}
class ZQMentionTextView: UITextView {

    // 提示文字
    var placeholderText:String?
    // 提示颜色
    var placeholderColor:UIColor?
    // 代理(划重点！！！外面千万不可使用UITextViewDelegate，否则后果自负)
    weak var ZQDelegate:ZQMentionTextViewDelegate!
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
    }
    /// 视图加载完设置提示文字及颜色
    override func draw(_ rect: CGRect) {
        text = placeholderText ?? ""
        textColor = placeholderColor ?? UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 文本发生改变
    func textViewDidChange(_ textView: UITextView) {
        if (self.ZQDelegate != nil),(self.ZQDelegate!.textViewDidChange != nil){
            self.ZQDelegate.textViewDidChange!(self)
        }
        let selectedRange = textView.markedTextRange
        /// 有联想词时取消遍历查找
        guard let start =  selectedRange?.start else {
            findAllKeywordsChangeColor(textView: textView)
            return
        }
        /// 有联想词时取消遍历查找
        if textView.position(from: start, offset: 0) != nil {
            return
        }
    }
    
    /// 动态修改@和空格中间的字体颜色（本扩展的核心代码）
    ///
    /// - Parameter textView: textView
    func findAllKeywordsChangeColor(textView:UITextView) {
        let string = textView.text
        let rangeDefault = textView.selectedRange
        let attributedString = NSMutableAttributedString(string: string!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: (string?.count)!))
        // 正则匹配
        let reg = try? NSRegularExpression(pattern: "@[^\\s]+", options: [])
        guard let matches = reg?.matches(in: string!, options: [], range: NSRange(location: 0, length: (string?.count)!)) else {
            return
        }
        for result in matches {
            let range = result.range(at: 0)
            let subStr = (attributedString.string as NSString).substring(with: range)
            let length = subStr.count
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: range.location, length: length))
        }
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: (string?.count)!))
        textView.attributedText = attributedString
        let rangeNow = NSRange(location: rangeDefault.location, length: 0)
        // 光标还原
        textView.selectedRange = rangeNow
    }

}
extension ZQMentionTextView:UITextViewDelegate{
    /// 开始输入去掉提示
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == placeholderText else {
            return
        }
        findAllKeywordsChangeColor(textView: textView)
        textView.text = ""
        textView.textColor = .black
    }
    
    /// 开始输入去掉提示
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text == "" else { return}
        textView.text = placeholderText
        textView.textColor = placeholderColor
        if (ZQDelegate != nil)&&(ZQDelegate!.textViewDidEndEditing != nil){
            ZQDelegate.textViewDidEndEditing!(self)
        }
    }
    
    /// 光标移动位置
    func textViewDidChangeSelection(_ textView: UITextView) {
        if (ZQDelegate != nil)&&(ZQDelegate!.textViewDidChangeSelection != nil){
            ZQDelegate.textViewDidChangeSelection!(self)
        }
    }
    
    /// 编辑即将结束
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if (ZQDelegate != nil)&&(ZQDelegate!.textViewShouldEndEditing != nil){
            return ZQDelegate.textViewShouldEndEditing!(self)
        }
        return true
    }
    
    /// 编辑即将开始
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (ZQDelegate != nil)&&(ZQDelegate!.textViewShouldBeginEditing != nil){
            return ZQDelegate.textViewShouldBeginEditing!(self)
        }
        return true
    }
}
