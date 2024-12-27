import Foundation
import MyIdSDK

public class AppearancePublic: NSObject {

    public let primaryColor: UIColor?
    public let errorColor: UIColor?
    public let primaryButtonColor: UIColor?
    public let primaryButtonColorDisabled: UIColor?
    public let primaryButtonTextColor: UIColor?
    public let primaryButtonTextColorDisabled: UIColor?
    public let buttonCornerRadius: Int?
    
    public init(
        primaryColor: UIColor?,
        errorColor: UIColor?,
        primaryButtonColor: UIColor?,
        primaryButtonColorDisabled: UIColor?,
        primaryButtonTextColor: UIColor?,
        primaryButtonTextColorDisabled: UIColor?,
        buttonCornerRadius: Int?
    ) {
        self.primaryColor = primaryColor
        self.errorColor = errorColor
        self.primaryButtonColor = primaryButtonColor
        self.primaryButtonColorDisabled = primaryButtonColorDisabled
        self.primaryButtonTextColor = primaryButtonTextColor
        self.primaryButtonTextColorDisabled = primaryButtonTextColorDisabled
        self.buttonCornerRadius = buttonCornerRadius
    }
}

public func loadAppearance(config: NSDictionary) throws -> AppearancePublic? {
    if let jsonResult = config as? Dictionary<String, AnyObject> {
        let primaryColor = (jsonResult["primaryColor"] == nil)
                ? nil : UIColor.from(hex: jsonResult["primaryColor"] as! String)
        
        let errorColor = (jsonResult["errorColor"] == nil)
                ? nil : UIColor.from(hex: jsonResult["errorColor"] as! String)
        
        let primaryButtonColor = (jsonResult["primaryButtonColor"] == nil)
                ? nil : UIColor.from(hex: jsonResult["primaryButtonColor"] as! String)
        
        let primaryButtonColorDisabled = (jsonResult["primaryButtonColorDisabled"] == nil)
                ? nil : UIColor.from(hex: jsonResult["primaryButtonColorDisabled"] as! String)
        
        let primaryButtonTextColor = (jsonResult["primaryButtonTextColor"] == nil)
                ? nil : UIColor.from(hex: jsonResult["primaryButtonTextColor"] as! String)
        
        let primaryButtonTextColorDisabled = (jsonResult["primaryButtonTextColorDisabled"] == nil)
                ? nil : UIColor.from(hex: jsonResult["primaryButtonTextColorDisabled"] as! String)
        
        let buttonCornerRadius: Int? = (jsonResult["buttonCornerRadius"] == nil) ? nil : 8
                        
        let appearancePublic = AppearancePublic(
            primaryColor: primaryColor,
            errorColor: errorColor,
            primaryButtonColor: primaryButtonColor,
            primaryButtonColorDisabled: primaryButtonColorDisabled,
            primaryButtonTextColor: primaryButtonTextColor,
            primaryButtonTextColorDisabled: primaryButtonTextColorDisabled,
            buttonCornerRadius: buttonCornerRadius
        )
        return appearancePublic
    } else {
        return nil
    }
}

public func loadAppearanceFromConfig(appearancePublic: AppearancePublic?) throws -> MyIdAppearance {
    if let appearancePublic = appearancePublic {
        let appearance = MyIdAppearance()
        appearance.primaryColor = appearancePublic.primaryColor
        appearance.errorColor = appearancePublic.errorColor
        appearance.primaryButtonColor = appearancePublic.primaryButtonColor
        appearance.primaryButtonColorDisabled = appearancePublic.primaryButtonColorDisabled
        appearance.primaryButtonTextColor = appearancePublic.primaryButtonTextColor
        appearance.primaryButtonTextColorDisabled = appearancePublic.primaryButtonTextColorDisabled
        
        if let buttonCornerRadius = appearancePublic.buttonCornerRadius {
            appearance.buttonCornerRadius = Float(buttonCornerRadius)
        }
        
        return appearance
    } else {
        return MyIdAppearance()
    }
}

public func buildMyIdConfig(
    config: NSDictionary,
    appearanceConfig: NSDictionary
) throws -> MyIdConfig {
    let appearancePublic = try loadAppearance(config: appearanceConfig)
    let appearance = try loadAppearanceFromConfig(appearancePublic: appearancePublic)

    let clientId = config["clientId"] as? String ?? ""
    let clientHash = config["clientHash"] as? String ?? ""
    let clientHashId = config["clientHashId"] as? String ?? ""
    let passportData = config["passportData"] as? String ?? ""
    let dateOfBirth = config["dateOfBirth"] as? String ?? ""
    let minAge = config["minAge"] as? Int ?? 16
    let sdkHash = config["sdkHash"] as? String ?? ""
    let externalId = config["externalId"] as? String ?? ""
        
    let threshold = config["threshold"] as? Double ?? 0.55
    let distance = config["distance"] as? Double ?? 0.60
    
    let buildModeKey = config["buildMode"] as? String ?? ""
    var buildMode = MyIdBuildMode.PRODUCTION
    if (buildModeKey == "DEBUG") {
        buildMode = MyIdBuildMode.DEBUG
    }
    
    let entryTypeKey = config["entryType"] as? String ?? ""
    var entryType = MyIdEntryType.AUTH
    if (entryTypeKey == "FACE") {
        entryType = MyIdEntryType.FACE
    }
    
    let residencyKey = config["residency"] as? String ?? ""
    var residency = MyIdResidency.RESIDENT
    if (residencyKey == "USER_DEFINED") {
        residency = MyIdResidency.USER_DEFINED
    } else if (residencyKey == "NON_RESIDENT") {
        residency = MyIdResidency.NON_RESIDENT
    }
    
    let localeKey = config["locale"] as? String ?? ""
    var locale = MyIdLocale.UZ
    if (localeKey == "RUSSIAN") {
        locale = MyIdLocale.RU
    } else if (localeKey == "ENGLISH") {
        locale = MyIdLocale.EN
    }
    
    let cameraShapeKey = config["cameraShape"] as? String ?? ""
    var cameraShape = MyIdCameraShape.CIRCLE
    if (cameraShapeKey == "ELLIPSE") {
        cameraShape = MyIdCameraShape.ELLIPSE
    }

    let cameraSelectorKey = config["cameraSelector"] as? String ?? ""
    var cameraSelector = MyIdCameraSelector.FRONT
    if (cameraSelectorKey == "BACK") {
        cameraSelector = MyIdCameraSelector.BACK
    }
    
    let resolutionKey = config["resolution"] as? String ?? ""
    var resolution = MyIdResolution.RESOLUTION_480
    if (resolutionKey == "RESOLUTION_720") {
        resolution = MyIdResolution.RESOLUTION_720
    }
    
    let withPhoto = config["withPhoto"] as? Bool ?? false

    let organizationDetailsDict = config["organizationDetails"] as? NSDictionary

    let logo = (organizationDetailsDict?["logo"] == nil) ? nil : UIImage(named: organizationDetailsDict?["logo"] as! String)
    let organizationDetails = MyIdOrganizationDetails()
    organizationDetails.phoneNumber = organizationDetailsDict?["phone"] as? String ?? ""
    organizationDetails.logo = logo
    
    let config = MyIdConfig()
    config.clientId = clientId
    config.clientHash = clientHash
    config.clientHashId = clientHashId
    config.passportData = passportData
    config.dateOfBirth = dateOfBirth
    config.minAge = minAge
    config.sdkHash = sdkHash
    config.externalId = externalId
    config.threshold = Float(threshold)
    config.buildMode = buildMode
    config.entryType = entryType
    config.residency = residency
    config.locale = locale
    config.cameraShape = cameraShape
    config.cameraSelector = cameraSelector
    config.resolution = resolution
    config.withPhoto = withPhoto
    config.appearance = appearance
    config.organizationDetails = organizationDetails
    config.distance = Float(distance)

    return config
}

@objc(MyIdSdk)
class MyIdSdk: NSObject, MyIdClientDelegate {
    
    private var flutterResult: FlutterResult? = nil
    
    func onSuccess(result: MyIdResult) {
        if let fResult = flutterResult {
            fResult(createResponse(result))
        }
    }
    
    func onError(exception: MyIdException) {
        if let fResult = flutterResult {
            fResult(FlutterError(code: "error", message: "\(exception.code ?? "101") - \(exception.message ?? "Unexpected error starting MyID")", details: nil))
        }
    }
    
    func onUserExited() {
        if let fResult = flutterResult {
            fResult(FlutterError(code: "cancel", message: "User canceled flow", details: nil))
        }
    }
    
    @objc static func requiresMainQueueSetup() -> Bool {
      return false
    }

    @objc func start(
        _ config: NSDictionary,
        result: @escaping FlutterResult
    ) -> Void {
        flutterResult = result
        
        DispatchQueue.main.async {
          let withConfig = config["config"] as! NSDictionary
          let withAppearance = config["appearance"] as! NSDictionary
          self.run(withConfig: withConfig, withAppearance: withAppearance, result: result)
        }
    }
    
    private func run(
        withConfig config: NSDictionary,
        withAppearance appearanceConfig: NSDictionary,
        result: @escaping FlutterResult
    ) {
        do {
            let myidConfig = try buildMyIdConfig(config: config, appearanceConfig: appearanceConfig)
            
            MyIdClient.start(withConfig: myidConfig, withDelegate: self)
        } catch let error as NSError {
            result(FlutterError(code: "error", message: error.domain, details: nil))
            return;
        } catch {
            result(FlutterError(code: "error", message: "Unexpected error starting MyID", details: nil))
            return;
        }
    }
}

extension UIColor {

    static func from(hex: String) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let redInt = Int(color >> 16) & mask
        let greenInt = Int(color >> 8) & mask
        let blueInt = Int(color) & mask

        let red = CGFloat(redInt) / 255.0
        let green = CGFloat(greenInt) / 255.0
        let blue = CGFloat(blueInt) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension MyIdAppearance {

    static let `default` = MyIdAppearance()
}

