//
//  ViewController.swift
//  SentimentAnalysisApp
//
//  Created by Marek Sadowski on 10/14/17.
//  Copyright © 2017 Marek Sadowski. All rights reserved.
//

import UIKit
import NaturalLanguageUnderstandingV1

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textStatusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        NSLog(textField.text!)
        //checking sentiment
        let username = "<username>"
        let password = "<password>"
        let version = "2017-02-27" // use today's date for the most recent version
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)
        
        let urlToAnalyze = textField.text //"www.wsj.com/news/markets"
        let features = Features(sentiment: SentimentOptions(document: true))
        let parameters = Parameters(features: features, url: urlToAnalyze, returnAnalyzedText: true ) //check url
        //let parameters = Parameters(features: features, text: urlToAnalyze, returnAnalyzedText: false) //check text
        let failure = { (error: Error) in print(error) }
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
            results in
            
            let score = results.sentiment?.document?.score
            var sentimentValue = "positive"
            if (score! < 0.0) {
                sentimentValue = "negative"
            } else if (score! == 0.0) {
                sentimentValue = "neutral"
            }
            NSLog("!!!!!!!!!!!!!! result: " + results.sentiment.debugDescription)
            DispatchQueue.main.async {
                // Update UI in the main thread
                self.textStatusLabel.text = "analyzed text score " + sentimentValue
            }
        }
    }
}

