//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 1.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit
import EssentialImageCommentPresentation

public final class ImageCommentCellController: CellController {
    
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dateLabel.text = model.date
        return cell
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
}