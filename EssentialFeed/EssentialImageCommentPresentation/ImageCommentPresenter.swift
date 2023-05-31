//
//  ImageCommentPresenter.swift
//  EssentialImageCommentPresentation
//
//  Created by Cengizhan Özcan on 31.05.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public struct ImageCommentsViewModel {
    
    public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Equatable {
    
    public let message: String
    public let date: String
    public let username: String
    
    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public final class ImageCommentPresenter {
    
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE", tableName: "ImageComment", bundle: Bundle(for: ImageCommentPresenter.self),
                                 comment: "Title for the comments view")
    }
    
    public static func map(_ comments: [ImageComment], currentDate: Date = Date(),
                           calendar: Calendar = .current, locale: Locale = .current) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        return ImageCommentsViewModel(comments: comments.map({ comment in
            ImageCommentViewModel(message: comment.message,
                                  date: formatter.localizedString(for: comment.createdAt, relativeTo: currentDate),
                                  username: comment.username)
        }))
    }
}
