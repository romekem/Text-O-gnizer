//
//  TextViewController.swift
//  Text-O-gnizer
//
//  Created by Roman Matusewicz on 29/02/2020.
//  Copyright © 2020 Roman Matusewicz. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    var textArray:[String] = [String]()
    private var displayedText:String = ""
    private var selectedText = DetectedText()

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Results: \(textArray)")
        displayText()
    }
    
    @IBAction func copyButtonPassed(_ sender: UIBarButtonItem) {
        UIPasteboard.general.string = textView.text
    }
    
    @IBAction func googleButtonPressed(_ sender: UIBarButtonItem) {
        if let range = textView.selectedTextRange {
            if let selectedTxt = textView.text(in: range){
                if selectedTxt != " " && selectedTxt != "" {
                    selectedText.getSelectedText(selectedTxt)
                    selectedText.searchInGoogle()
                } else {
                    presentAlert(message: "Select text")
                }
               
            }
        }
    }
    
     func displayText(){
        textView.isEditable = false
        if textArray.count > 0 {
            for words in textArray {
                displayedText = displayedText + words + " "
            }
            textView.text = displayedText
        } else {
            textView.text = ""
        }
    }
    
    fileprivate func presentAlert(message: String) {
        let title = "Text"
         let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
         controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(controller, animated: true, completion: nil)
     }
}
