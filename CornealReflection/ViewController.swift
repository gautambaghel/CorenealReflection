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
    
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIView!
    
    let stillImageOutput = AVCaptureStillImageOutput()
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        imageView.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        
        let captureSession = AVCaptureSession()
    
        let devices = AVCaptureDevice.devices().filter{ ($0 as AnyObject).hasMediaType(AVMediaTypeVideo) && ($0 as AnyObject).position == AVCaptureDevicePosition.front }
        
            if let captureDevice = devices.first as? AVCaptureDevice{
            
                do {
                    try
                    
                    captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                    captureSession.sessionPreset = AVCaptureSessionPresetPhoto
                    captureSession.startRunning()
                    stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                    if captureSession.canAddOutput(stillImageOutput) {
                        captureSession.addOutput(stillImageOutput)
                    }
                    
                    if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                        previewLayer.bounds = view.bounds
                        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                        let cameraPreview = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: view.bounds.size.width, height: view.bounds.size.height)))
                        cameraPreview.layer.addSublayer(previewLayer)
                        view.addSubview(cameraPreview)
                        
                        let image = #imageLiteral(resourceName: "Image")
                        let imageView = UIImageView(image: image)
                        
                        imageView.frame = CGRect(x: 0, y: 0, width: 1000, height: 2000)
                        view.addSubview(imageView)
                        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
                    }
                    
                } catch {
                    print("some error")
                }
                
        }
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer?) {
        
        // Take a picture from front camera
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
            }
            
        }
        
    }
    
}

