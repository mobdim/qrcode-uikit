# QR Code Scanner App

*A simple and intuitive QR code scanner with history management.*

---

## Project Description

QR Code Scanner is an iOS application designed to scan QR codes using the device's camera, save their content, and manage a history of scanned codes. The app leverages modern technologies such as Core Data for data persistence and Metal for video processing.

### Key Features:
- Real-time QR code scanning.
- Save and manage a history of scanned QR codes.
- View details of each QR code (content, associated image).
- Camera permission handling.
- Clean architecture for scalability and maintainability.

---

## Usage

### Scanning a QR Code
1. Launch the app.
2. Grant camera permissions when prompted.
3. Point the camera at a QR code to scan it.
4. The app will display the scanned content and save it to the history.

### Viewing History
1. Navigate to the "History" screen.
2. View a list of all previously scanned QR codes.
3. Tap on a QR code to see its details (content and associated image).

### Permissions
- The app requires access to the camera. If permissions are denied, you can enable them in **Settings > Privacy > Camera**.

---

## Code Structure

The project follows the **Clean Architecture** principles, separating concerns into distinct layers:

### 1. **Presentation Layer**
- Contains UI-related components such as `ViewController`, `ViewModel`, and `Coordinator`.
- Handles user interactions and updates the UI.

### 2. **Domain Layer**
- Defines use cases (e.g., `SaveQRCodeUseCase`, `FetchQRCodeHistoryUseCase`) and models (e.g., `QRCode`).
- Acts as the business logic layer.

### 3. **Data Layer**
- Manages data persistence using Core Data.
- Includes repositories (e.g., `QRCodeRepository`) and data sources (e.g., `QRCodeDataSource`).

### 4. **Core Components**
- `CoreDataStack`: Manages Core Data setup and persistence.
- `AVCaptureSession`: Handles camera functionality.
- `ImageStorageService`: Saves and retrieves images associated with QR codes.

---

## Dependencies

This project uses the following native iOS frameworks:
- **Core Data**: For data persistence.
- **AVFoundation**: For camera and video capture.
- **Metal**: For rendering camera previews.
- **UIKit**: For building the user interface.

No third-party libraries are used, ensuring minimal overhead and better performance.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Inspired by modern iOS development practices.
- Built using Apple's native frameworks for maximum performance and compatibility.
