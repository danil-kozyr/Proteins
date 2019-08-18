# Proteins

An elegant iOS molecular visualization application with 3D rendering, biometric security, and intuitive design, showcasing modern Swift development practices.

## 📖 About

Proteins is a native iOS application that provides interactive 3D visualization of chemical ligands and molecular structures. Built with Swift and featuring SceneKit-powered 3D graphics with secure biometric authentication and smooth animations.

## 🚀 Features

- **3D Molecular Visualization**: Interactive SceneKit-based rendering of protein ligands
- **Biometric Security**: TouchID/FaceID authentication for secure access
- **Atomic Detail View**: Tap any atom to view detailed chemical information
- **Real-time Data**: Live molecular data from RCSB Protein Data Bank
- **Smart Search**: Comprehensive ligand database with real-time filtering
- **Share Functionality**: Export and share 3D molecular visualizations
- **Responsive Design**: Adaptive orientation handling and smooth transitions
- **Background Protection**: Automatic re-authentication when returning from background

## 🔧 Build Instructions

### Prerequisites

- iOS 12.0+
- Xcode 11.0+
- Swift 5.0+
- CocoaPods dependency manager

### Setup

```bash
# Clone the repository
git clone https://github.com/danil-kozyr/Proteins.git
cd Proteins

# Install dependencies
pod install

# Open workspace in Xcode
open proteins.xcworkspace
```

### API Configuration

The app uses RCSB Protein Data Bank API for molecular data:

```swift
// RCSBDownloader.swift
private let url = "https://files.rcsb.org/ligands/view/"
private let urlExtension = "_ideal.pdb"
```

## 📝 Usage

### Access the Application

1. Build and run the project in Xcode or iOS Simulator
2. Authenticate using TouchID or FaceID

### Molecular Exploration Process

1. Launch the application and authenticate
2. Browse or search for ligands in the database
3. Select a ligand to view in 3D
4. Interact with the 3D model using gestures
5. Tap atoms to view detailed chemical information
6. Share molecular visualizations

## 🎬 Demonstration

<p align="center">
<img src="https://github.com/danilkozyr/iOS-Portfolio/blob/master/gifs/proteins.gif" height=600>
</p>

## 🔍 Implementation Details

### Architecture

- **Pattern**: Model-View-Controller (MVC)
- **Language**: Swift 5.0
- **Framework**: UIKit with SceneKit for 3D rendering
- **Networking**: Asynchronous API calls with completion handlers
- **Security**: LocalAuthentication framework for biometric access
- **UI**: Custom gradient backgrounds and smooth 3D animations

### Key Components

- **HomeVC**: Authentication controller with biometric integration
- **ProteinsVC**: Main browser with search and ligand selection
- **ProteinSceneVC**: 3D visualization controller with SceneKit
- **RCSBDownloader**: Service for fetching molecular data from RCSB PDB
- **JSONParser**: Local periodic table data parsing for element information
- **Models**: Data structures for Atom, Connections, and ChemicalElement

## 🔗 Dependencies

### Third-party Libraries

- **Alamofire**: HTTP networking for RCSB Protein Data Bank API
- **SwiftyJSON**: JSON parsing and manipulation for chemical data

### System Frameworks

- **UIKit**: User interface framework
- **SceneKit**: 3D graphics rendering and scene management
- **LocalAuthentication**: Biometric authentication (TouchID/FaceID)
- **Foundation**: Core system functionality

---

_Native iOS application demonstrating advanced 3D graphics programming, biometric security, API integration, and professional molecular visualization architecture._
