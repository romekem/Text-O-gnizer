//
//  ViewController.swift
//  Text-O-gnizer
//
//  Created by Roman Matusewicz on 24/02/2020.
//  Copyright © 2020 Roman Matusewicz. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraPicker: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    private var scores:[String] = [String]()
    let imagePicker = UIImagePickerController()
    let request = VNRecognizeTextRequest()
    let ai = UIActivityIndicatorView()
    private var isFinished:Bool = false {
        willSet {
            if newValue {
                finishedDetecting()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false

        activityIndicatorSettings()
        requestSettings()
        
        checkButton.isHidden = true

    }

    @IBAction func libraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        if scores.count > 0 {
            scores.removeAll()
        }
    }
    
    @IBAction func checkBtnPressed(_ sender: UIButton) {
        if scores.count > 0 {
            performSegue(withIdentifier: "goToTextVC", sender: self)
        } else {
            presentAlert(message: "Try again")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTextVC" {
            let destination = segue.destination as! TextViewController
            for index in scores {
                destination.textArray.append(index)
            }
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        if scores.count > 0 {
            scores.removeAll()
        }
    }
    
    func requestSettings(){
        request.recognitionLevel = .accurate
    }
    
    func activityIndicatorSettings(){
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.color = UIColor.gray
        self.view.addSubview(ai)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           cameraPicker.image = userPickedImage
            guard let cgimage = userPickedImage.cgImage else {
                fatalError("Could not convert to CGImage")
            }
            detect(image: cgimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CGImage){
        self.checkButton.isHidden = true
        ai.startAnimating()
        let requests = [request]
        
        DispatchQueue.global(qos: .userInitiated).async  {
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform(requests)
            
            guard let observations = self.request.results as? [VNRecognizedTextObservation] else {
                fatalError("Received invalid observations")
            }

            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("No candidate")
                    continue
                }
                print("Found this candidate: \(bestCandidate.string)")
                self.scores.append(bestCandidate.string)
            }
            self.isFinished = true
        }
    }
    
    func finishedDetecting() {
        DispatchQueue.main.async {
            self.ai.stopAnimating()
            self.isFinished = false
            self.checkButton.isHidden = false
            
        }
    }
    
    fileprivate func presentAlert(message: String) {
        let title = "Message:"
         let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
         controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(controller, animated: true, completion: nil)
     }
}


