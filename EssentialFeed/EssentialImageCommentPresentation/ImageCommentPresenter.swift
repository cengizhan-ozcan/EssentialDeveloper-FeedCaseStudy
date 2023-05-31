//
//  ImageCommentPresenter.swift
//  EssentialImageCommentPresentation
//
//  Created by Cengizhan Özcan on 31.05.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentPresenter {
    
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE", tableName: "ImageComment", bundle: Bundle(for: ImageCommentPresenter.self),
                                 comment: "Title for the comments view")
    }
}
