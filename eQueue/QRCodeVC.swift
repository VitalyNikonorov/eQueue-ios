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
        
        initBorderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        qrCodeFrameView?.frame = CGRect.zero
        captureSession?.startRunning()
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
                    captureSession?.stopRunning()
                    let id = Int(metaDataObject.stringValue.substring(from: BARCODE_PATTERN.endIndex))
                    
                    guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "QueueController") as? QueueScreenController else {
                        print("Could not instantiate view controller with identifier of type SecondViewController")
                        return
                    }
                    
                    vc.qid = Int(id!)
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated:true)
                    }
                }
            }
        }
        
    }
    
}
