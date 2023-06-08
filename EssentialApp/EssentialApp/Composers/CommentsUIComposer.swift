//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 7.06.2023.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import EssentialImageCommentPresentation
import SharedPresentation
import SharedAPI

public final class CommentsUIComposer {
    
    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<ResourceLoaderAdapter, [ImageComment], CommentsViewAdapter>
    
    private init() {}
    
    public static func commentsComposedWith(commentsLoader: ImageCommentLoader) -> ListViewController {
        let presentationAdapter = CommentsPresentationAdapter(loader: ResourceLoaderAdapter(loader: MainQueueDispatchDecorator(decoratee: commentsLoader)))
        
        let commentsController = makeCommentsViewController(title: ImageCommentPresenter.title)
        commentsController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(resourceView: CommentsViewAdapter(controller: commentsController),
                                                              loadingView: WeakRefVirtualProxy(commentsController),
                                                              errorView: WeakRefVirtualProxy(commentsController),
                                                              mapper: { ImageCommentPresenter.map($0) })
        return commentsController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.title = title
        return controller
    }
}

private class ResourceLoaderAdapter: ResourceLoader {
    
    let loader: ImageCommentLoader
    
    init(loader: ImageCommentLoader) {
        self.loader = loader
    }
    
    func load(completion: @escaping (ImageCommentLoader.Result) -> Void) -> ResourceLoaderTask? {
        loader.load(completion: completion)
        return nil
    }
}

final class CommentsViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { comment in
            CellController(id: comment, ImageCommentCellController(model: comment))
        })
    }
}
