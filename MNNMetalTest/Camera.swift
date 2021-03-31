import AVFoundation
import AppKit

struct Camera {

    // MARK: - Properties

    var session = AVCaptureSession()

    fileprivate var sessionPreset = AVCaptureSession.Preset.high

    fileprivate var sessionInput: AVCaptureDeviceInput! = {
        let device = AVCaptureDevice.default(for: .video)
        return try? AVCaptureDeviceInput(device: device!)
    }()

    fileprivate var sessionOutput: AVCaptureVideoDataOutput! = {
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as AnyHashable: kCVPixelFormatType_32BGRA] as! [String : Any]
        //output.alwaysDiscardsLateVideoFrames = false
        return output
    }()

     var preview: AVCaptureVideoPreviewLayer!

    // MARK: - Initializer

    init(_ superview: NSView, delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = superview.bounds
        preview.videoGravity = .resize
        superview.layer = preview

        session.beginConfiguration()
        if session.canAddInput(sessionInput) {
            session.addInput(sessionInput)
        }
        if session.canAddOutput(sessionOutput) {
            sessionOutput?.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "cam.session", attributes: []))
            session.addOutput(sessionOutput)
        }
        if session.canSetSessionPreset(sessionPreset) {
            session.sessionPreset = sessionPreset
        }
        session.commitConfiguration()
    }
}
