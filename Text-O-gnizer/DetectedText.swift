//
//  DetectedText.swift
//  Text-O-gnizer
//
//  Created by Roman Matusewicz on 03/03/2020.
//  Copyright © 2020 Roman Matusewicz. All rights reserved.
//

import UIKit

struct DetectedText {
    private let url = "http://www.google.com/search?q="
    private var finalUrl:String? = nil
    var text:String? = nil
    
    mutating func getSelectedText(_ selectedText: String){
        self.text = selectedText
    }
    
    mutating func searchInGoogle(){
        if var tmpText = text {
            if tmpText.last == " "{
                tmpText.removeLast()
            }
            if tmpText.contains(" ") == true {
                let urlText = tmpText.replacingOccurrences(of: " ", with: "+")
                self.finalUrl = url + urlText
            }else{
                self.finalUrl = url+tmpText
            }
            if let url = URL(string: finalUrl!){
                UIApplication.shared.open(url)
            }
        }
    }
}
