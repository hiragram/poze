import XCTest
import SnapshotTesting

public enum SnapshotConfig {
    public enum DeviceName: String, CaseIterable {
        case iPhoneSe = "iPhone-SE"
        case iPhone8 = "iPhone-8"
        case iPhoneX = "iPhone-X"
        case iPhoneXsMax = "iPhone-Xs-Max"
        case fullScreen = "fullScreen"
    }
    
}
extension SnapshotConfig.DeviceName {
    public var viewImageConfig: ViewImageConfig {
        switch self {
        case .iPhoneSe:
            return .iPhoneSe
        case .iPhone8:
            return .iPhone8
        case .iPhoneX:
            return .iPhoneX
        case .iPhoneXsMax:
            return .iPhoneXsMax
        case .fullScreen:
            return .fullScreen
            
        }
    }
}

extension ViewImageConfig {
    
    public static let fullScreen = ViewImageConfig.fullScreen(.portrait)
    
    public static func fullScreen(_ orientation: Orientation) -> ViewImageConfig {
        let safeArea: UIEdgeInsets
        let size: CGSize
        let height = 2500
        let width = 480
        
        switch orientation {
            // 横向き
        case .landscape:
            safeArea = .zero
            size = .init(width: width, height: height)
        case .portrait:
            safeArea = .zero
            size = .init(width: width, height: height)
        }
        
        return .init(safeArea: safeArea, size: size, traits: .fullScreen(orientation))
    }
    
}

extension UITraitCollection {
    public static func fullScreen(_ orientation: ViewImageConfig.Orientation)
    -> UITraitCollection {
        let base: [UITraitCollection] = [
            
            .init(forceTouchCapability: .available),
            .init(layoutDirection: .leftToRight),
            .init(preferredContentSizeCategory: .medium),
            .init(userInterfaceIdiom: .phone)
        ]
        switch orientation {
        case .landscape:
            return .init(
                traitsFrom: base + [
                    .init(horizontalSizeClass: .compact),
                    .init(verticalSizeClass: .compact)
                ]
            )
        case .portrait:
            return .init(
                traitsFrom: base + [
                    .init(horizontalSizeClass: .compact),
                    .init(verticalSizeClass: .regular)
                ]
            )
        }
    }
    
}
