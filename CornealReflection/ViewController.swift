//
//  ViewController.swift
//  CornealReflection
//
//  Created by Gautam on 10/18/17.
//  Copyright © 2017 Gautam. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let imageToBeSaved = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        }
        else if let imageToBeSaved = info[UIImagePickerControllerEditedImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        }
        else{
            print("Something went wrong")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

