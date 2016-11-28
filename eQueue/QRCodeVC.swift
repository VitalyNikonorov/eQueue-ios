//
//  QRCodeVC.swift
//  eQueue
//
//  Created by Виталий Никоноров on 28.11.16.
//  Copyright © 2016 Vitaly Nikonorov. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    let BARCODE_PATTERN = "http://equeue/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let input: AnyObject? = try? AVCaptureDeviceInput.init(device: captureDevice)
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        
        let metaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(metaDataOutput)
        metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
        
        captureSession?.startRunning()
        initBorderView()
    }
    
    private func initBorderView(){
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if (metadataObjects == nil || metadataObjects.count == 0){
            qrCodeFrameView?.frame = CGRect.zero
            print("empty data")
            return
        }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if (metaDataObject.type == AVMetadataObjectTypeQRCode) {
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metaDataObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if (metaDataObject.stringValue != nil) {
                if (metaDataObject.stringValue.contains(BARCODE_PATTERN)){
                    let id = metaDataObject.stringValue.substring(from: BARCODE_PATTERN.endIndex)
                    print(id)
                }
            }
        }
        
    }
    
}
