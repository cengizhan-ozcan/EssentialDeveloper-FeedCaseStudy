//
//  ImageCommentsPresenter.swift
//  EssentialImageCommentPresentation
//
//  Created by Cengizhan Özcan on 31.05.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsPresenter {
    
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE", tableName: "ImageComments", bundle: Bundle(for: ImageCommentsPresenter.self),
                                 comment: "Title for the comments view")
    }
}
