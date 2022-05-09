//
//  UIImage+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import Foundation
import UIKit

enum ImageAsset: String {
    
    case Icons_36px_Home_Normal
    case Icons_36px_Home_Selected
    case Icons_36px_Profile_Normal
    case Icons_36px_Profile_Selected
    case Icons_36px_Cart_Normal
    case Icons_36px_Cart_Selected
    case Icons_36px_Catalog_Normal
    case Icons_36px_Catalog_Selected
    case Image_Logo02
    
    // Profile tab - Order
    case Icons_24px_AwaitingPayment
    case Icons_24px_AwaitingShipment
    case Icons_24px_Shipped
    case Icons_24px_AwaitingReview
    case Icons_24px_Exchange
    
    // Profile tab - Service
    case Icons_24px_Starred
    case Icons_24px_Notification
    case Icons_24px_Refunded
    case Icons_24px_Address
    case Icons_24px_CustomerService
    case Icons_24px_SystemFeedback
    case Icons_24px_RegisterCellphone
    case Icons_24px_Settings
    
    // Product page
    case Icons_24px_CollectionView
    case Icons_24px_ListView
    
    // Product size and color picker
    case Image_StrikeThrough
    
    // PlaceHolder
    case Image_Placeholder
    
    // Back button
    case Icons_24px_Back02
    
    // Drop down
    case Icons_24px_DropDown
}


// swiftlint:enable identifier_name

extension UIImage {
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
    
    func withSaturationAdjustment(byVal: CGFloat) -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        guard let filter = CIFilter(name: "CIColorControls") else { return self }
        filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        filter.setValue(byVal, forKey: kCIInputSaturationKey)
        guard let result = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let newCgImage = CIContext(options: nil).createCGImage(result, from: result.extent) else { return self }
        return UIImage(cgImage: newCgImage, scale: UIScreen.main.scale, orientation: imageOrientation)
    }
    
    
}
