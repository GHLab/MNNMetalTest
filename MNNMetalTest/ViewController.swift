//
//  ViewController.swift
//  MNNMetalTest
//
//  Created by GHLab on 2021/03/30.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
	var camera: Camera!
	var ultraFace: UltraFaceWrapper? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let ultraFaceModelPath = Bundle.main.path(forResource: "slim-320", ofType: "mnn")
		
		ultraFace = UltraFaceWrapper(modelPath: ultraFaceModelPath)
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		let cameraMediaType = AVMediaType.video
		let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
		
		switch cameraAuthorizationStatus {
		case .denied: break
		case .authorized:
			camera = Camera(self.view, delegate: self)
			camera.session.startRunning()
			break
		case .restricted: break

		case .notDetermined:
			// Prompting user for the permission to use the camera.
			AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
				if granted {
					DispatchQueue.main.async {
						self.camera = Camera(self.view, delegate: self)
						self.camera.session.startRunning()
					}
				} else {
					print("Denied access to \(cameraMediaType)")
				}
			}
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

		guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
		
		ultraFace?.detect(pixelBuffer)
		
		/*let faceCount = faceInfoResult.faceCount;
		
		if faceCount == 0 {
			return
		}*/
		
		/*DispatchQueue.main.async {
			guard let layer = self.view.layer else { return }
			layer.isGeometryFlipped = true
			
			let xScale = self.view.bounds.size.width / CGFloat(width)
			let yScale = self.view.bounds.size.height / CGFloat(height)
			
			layer.sublayers?.forEach {
				if let shapeLayer = $0 as? CAShapeLayer {
					shapeLayer.removeFromSuperlayer()
				}
				
				if let textLayer = $0 as? CATextLayer {
					textLayer.removeFromSuperlayer()
				}
			}
			
			guard let faceInfo = faceInfoResult.faceInfo?[0] else { return }
			
			let faceRect = faceInfo.faceRect
			
			let rect = CGRect(x: CGFloat(faceRect.x) * xScale, y: CGFloat(faceRect.y) * yScale, width: CGFloat(faceRect.width) * xScale, height: CGFloat(faceRect.height) * yScale)
			
			let rectLayer = CAShapeLayer()
			rectLayer.path = NSBezierPath(rect: rect).cgPath
			rectLayer.strokeColor = NSColor.red.cgColor
			rectLayer.fillColor = NSColor.white.withAlphaComponent(0.0).cgColor
			rectLayer.isGeometryFlipped = false
			layer.addSublayer(rectLayer)
			
			for j in 0 ..< kNeuralLineLandmarkResultSize {
				guard let landmarkX = faceInfo.landmarks?[Int(j * 2)] else { continue }
				guard let landmarkY = faceInfo.landmarks?[Int(j * 2 + 1)] else { continue }
				
				let circleLayer = CAShapeLayer()
				circleLayer.path = NSBezierPath(ovalIn: CGRect(x: CGFloat(landmarkX) * xScale, y: CGFloat(landmarkY) * yScale, width: 1, height: 1)).cgPath
				circleLayer.strokeColor = NSColor.green.cgColor
				circleLayer.fillColor = NSColor.white.withAlphaComponent(0.0).cgColor
				self.view.layer?.addSublayer(circleLayer)
			}
			
			let textLayer = CATextLayer();
			textLayer.frame = CGRect(x: 20, y: 20, width: self.view.bounds.width - 20, height: self.view.bounds.height)
			textLayer.fontSize = 15.0
			textLayer.foregroundColor = NSColor.yellow.cgColor
			textLayer.string = "faceAction : \(faceInfo.faceAction), yaw : \(Int(faceInfo.yaw)), pitch : \(Int(faceInfo.pitch)), roll : \(Int(faceInfo.roll)), time : \(self.avgRunningTime) ms";
			layer.addSublayer(textLayer)
		}*/
	}
}

extension NSBezierPath {

	public var cgPath: CGPath {
		let path = CGMutablePath()
		var points = [CGPoint](repeating: .zero, count: 3)

		for i in 0 ..< self.elementCount {
			let type = self.element(at: i, associatedPoints: &points)
			switch type {
			case .moveTo:
				path.move(to: points[0])
			case .lineTo:
				path.addLine(to: points[0])
			case .curveTo:
				path.addCurve(to: points[2], control1: points[0], control2: points[1])
			case .closePath:
				path.closeSubpath()
			}
		}

		return path
	}
}
