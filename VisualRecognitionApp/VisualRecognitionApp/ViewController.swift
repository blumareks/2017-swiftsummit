//
//  ViewController.swift
//  VisualRecognitionApp
//
//  Created by Marek Sadowski on 10/13/17.
//  Copyright © 2017 Marek Sadowski. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController {

    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var analysisTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func analysisButtonPressed(_ sender: Any) {
        NSLog("button pressed")
        NSLog("url: "+urlText.text!)
        analysisTextLabel.text = urlText.text!
        var status = "waiting for Watson processing the URL : " + urlText.text!
        
        //call service
        //Adding Watson Visual Recognition - based on the example from WDC sdk iOS
        let apiKey = "<apikey>"
        let version = "2016-11-04" // use today's date for the most recent version
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        let url = urlText.text!
        let failure = { (error: Error) in print(error) }
        visualRecognition.classify(image: url, failure: failure) { classifiedImages in
            //print(classifiedImages)
            status = "visual status ::::::::::::: " + (classifiedImages.images.description)
            
            //detecting classification
            if (!classifiedImages.images.isEmpty && !classifiedImages.images[0].classifiers.isEmpty &&
                !classifiedImages.images[0].classifiers[0].classes.isEmpty) {
                status = status + "######## classification : " + classifiedImages.images[0].classifiers[0].classes[0].classification
                
                //detecting faces on the pictures with people
              if (!classifiedImages.images[0].classifiers[0].classes[0].classification.isEmpty &&
                    classifiedImages.images.description.contains("person")) {
                
                    DispatchQueue.main.async {
                        // Update UI in the main thread
                        self.analysisTextLabel.text = status + " ##########  person found ###########"
                    }

                    visualRecognition.detectFaces(inImage: url, failure: failure) { imagesWithFaces in
                        //print(imagesWithFaces)
                        if (!imagesWithFaces.images[0].faces.isEmpty) {
                            status = status + " ###### the person's age max : " + (imagesWithFaces.images[0].faces[0].age.max?.description)!
                            status = status + " age min : " + (imagesWithFaces.images[0].faces[0].age.min?.description)!
                            status = status + " person's gender : " + imagesWithFaces.images[0].faces[0].gender.gender
                            NSLog("faces :::::::::::::: ")
                            DispatchQueue.main.async {
                                // Update UI in the main thread
                                self.analysisTextLabel.text = "3 : " + status
                            }
                            
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                // Update UI in the main thread
                //setting feedback on analysis
                self.analysisTextLabel.text = "2 : " + status
            }
        }
        //setting feedback on analysis
        self.analysisTextLabel.text = "1 : " + status
    }
}

