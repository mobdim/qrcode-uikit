//
//  ScannerViewController.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import UIKit
import AVFoundation

final class ScannerViewController: UIViewController {
    private var viewModel: ScannerViewModelProtocol
    
    // MARK: - UI Components
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Failed to access camera"
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let photoOutput = AVCapturePhotoOutput()
    private var isPhotoCaptured = false
    
    private var currentContent: String?
    
    // MARK: - Initialization
    init(viewModel: ScannerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        checkCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCaptureSession()
    }
    
    // MARK: - Camera Permission
    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestCameraPermission()
        case .authorized:
            DispatchQueue.main.async {
                self.setupCamera()
            }
        case .denied, .restricted:
            showError(message: "Camera access is denied. Please enable it in Settings.")
        @unknown default:
            showError(message: "Unknown camera authorization status.")
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.setupCamera()
                } else {
                    self?.showError(message: "Camera access is denied. Please enable it in Settings.")
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Добавление элементов на экран
        view.addSubview(previewView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        // Настройка constraints
        NSLayoutConstraint.activate([
            // previewView
            previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            previewView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            
            // errorLabel
            errorLabel.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.delegate = self
        viewModel.onShowHistory = { [weak self] in
            self?.viewModel.showHistory()
        }
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            showError(message: "No camera available")
            return
        }
        
        captureSession.beginConfiguration()
        
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                print("Не удалось добавить входной поток")
                return
            }
                        
            let output = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128, .upce, .code39]
            } else {
                print("Не удалось добавить выходной поток")
                return
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = previewView.bounds
            previewView.layer.addSublayer(previewLayer!)
            
            captureSession.commitConfiguration()
        } catch {
            showError(message: "Failed to setup camera")
        }
    }
    
    private func startCaptureSession() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    private func stopCaptureSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    private func snapshot(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func captureImage() {
        
        guard !isPhotoCaptured else { return }
        isPhotoCaptured = true
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let content = metadataObject.stringValue else {
            return
        }
        
        currentContent = content
        captureImage()
        
//        let image = snapshot(from: previewView)
//        stopCaptureSession()
//        viewModel.saveQRCode(content: content, image: image)
    }
}

// MARK: - ScannerViewModelDelegate
extension ScannerViewController: ScannerViewModelDelegate {
    func didSaveQRCodeSuccessfully() {
        let alert = UIAlertController(title: "Success", message: "QR code saved successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToHistory() {
        // Обработка перехода к истории
    }
}

extension ScannerViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to capture image")
            return
        }
        
        stopCaptureSession()
        
        guard let currentContent else { assert(false) }
        
        
        viewModel.saveQRCode(content: currentContent, image: image)
    }
}
