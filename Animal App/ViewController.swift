//
//  ViewController.swift
//  Animal App
//
//  Created by Diya Sreedhar on 8/26/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var buttonMain: UIButton!
    @IBOutlet weak var Result1: UIImageView!
    @IBOutlet weak var Result2: UIImageView!
    var APIResult1: String?
    var APIResult2: String?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //buttonMain.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        //buttonMain.backgroundColor = UIColor.blue
        buttonMain.layer.cornerRadius = 25.0
        buttonMain.tintColor = UIColor.white
    }


    @IBAction func buttonPressed(_ sender: Any) {
        print("Button pressed")
        let vc = UIImagePickerController()
        //vc.sourceType = .camera
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        answerLabel.text = "Getting Image..."
        buttonMain.isHidden = true
    }
    
    
    //
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("An error occured: no image found")
            return
        }

        // print out the image size as a test
        imageMain.image = image
        print(image.size)
        answerLabel.text = "Checking..."
        let imageJPG = image.jpegData(compressionQuality: 0.0034)
        processAPI1(image:imageJPG!)
        //processAPI2(image:imageJPG!)
        //buttonMain.isHidden = false
        //buttonSecond.isHidden = false
        
    }
    
    func say(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    
    func processAPI1(image: Data) {
        let imageB64 = Data(image).base64EncodedData()
        //let uploadURL = "https://3h6ys7t373.execute-api.us-east-1.amazonaws.com/Predict/03378121-5f5b-4e24-8b5b-7a029003f2a4"
        //let uploadURL = "https://svexr6i4fi.execute-api.us-east-1.amazonaws.com/Predict/93396303-c75a-49d0-9736-c540ca073768"
        let uploadURL = "https://askai.aiclub.world/7e4c02bb-b102-4d19-b2ee-37fe26b92e68"
        
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            
            debugPrint(response)
            switch response.result {
               case .success(let responseJsonStr):
                   print("\n\n Success value and JSON: \(responseJsonStr)")
                   let myJson = JSON(responseJsonStr)
                   let predictedValue = myJson["predicted_label"].string
                   print("Saw predicted value \(String(describing: predictedValue))")
                   let predictionMessage = "Animal Name: " + predictedValue!
                   self.answerLabel.text=predictionMessage
                self.say(string: predictionMessage)

               case .failure(let error):
                   print("\n\n Request failed with error: \(error)")
              

               }
            self.buttonMain.isHidden = false
            }
            
        }
        
        
        
        
        func processAPI2(image: Data) {
            let imageB64 = Data(image).base64EncodedData()
            //let uploadURL = "https://3h6ys7t373.execute-api.us-east-1.amazonaws.com/Predict/03378121-5f5b-4e24-8b5b-7a029003f2a4"
            //let uploadURL = "https://svexr6i4fi.execute-api.us-east-1.amazonaws.com/Predict/93396303-c75a-49d0-9736-c540ca073768"
            let uploadURL = "https://askai.aiclub.world/7e4c02bb-b102-4d19-b2ee-37fe26b92e68"
            
            AF.upload(imageB64, to: uploadURL).responseJSON { response in
                
                debugPrint(response)
                switch response.result {
                   case .success(let responseJsonStr):
                       print("\n\n Success value and JSON: \(responseJsonStr)")
                       let myJson = JSON(responseJsonStr)
                       let predictedValue = myJson["predicted_label"].string
                       print("Saw predicted value \(String(describing: predictedValue))")
                       let predictionMessage = "Animal Name: " + predictedValue!
                       self.answerLabel.text=predictionMessage
                    self.say(string: predictionMessage)

                   case .failure(let error):
                       print("\n\n Request failed with error: \(error)")
                  

                   }
                self.buttonMain.isHidden = false
            }
        }
}

