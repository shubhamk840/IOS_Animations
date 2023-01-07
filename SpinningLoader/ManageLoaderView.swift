//
//  ManageLoaderView.swift
//  ios_assignment
//
//  Created by Shubham Kushwaha on 07/01/23.
//

import Foundation
import RSLoadingView


// Note:- Have used here third party code for the loader.
// Using RSLoadingView

struct Loaders {
    static func showLoader(On View: UIView) {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.shouldDimBackground = false
        loadingView.show(on: View)
    }
    
    static func hideLoader(On View: UIView) {
        RSLoadingView.hide(from: View)
    }
}

