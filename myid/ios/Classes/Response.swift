import Foundation
import MyIdSDK

func createResponse(_ result: MyIdResult) -> [String: String] {
    var jsonResponse = [String: String]()
    
    if let code = result.code {
        jsonResponse["code"] = code
    }
    if let comparison = result.comparisonValue {
        jsonResponse["comparison"] = comparison
    }
    if let image = result.image {
        if let base64 = image.jpegData(compressionQuality: 1.0)?.base64EncodedString() {
            jsonResponse["base64"] = base64
        }
    }

    return jsonResponse
}
