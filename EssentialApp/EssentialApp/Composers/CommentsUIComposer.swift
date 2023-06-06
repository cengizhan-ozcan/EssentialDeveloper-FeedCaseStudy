//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 7.06.2023.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import EssentialFeedPresentation
import EssentialImageCommentPresentation
import SharedPresentation
import SharedAPI

public final class CommentsUIComposer {
    
    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<ResourceLoaderAdapter, [FeedImage], FeedViewAdapter>
    
    private init() {}
    
    public static func commentsComposedWith(commentsLoader: FeedLoader) -> ListViewController {
        let presentationAdapter = CommentsPresentationAdapter(loader: ResourceLoaderAdapter(loader: MainQueueDispatchDecorator(decoratee: commentsLoader)))
        
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedController,
                                                                                            imageLoader: DummyImageLoader()),
                                                              loadingView: WeakRefVirtualProxy(feedController),
                                                              errorView: WeakRefVirtualProxy(feedController),
                                                              mapper: FeedPresenter.map)
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}

private class DummyImageLoader: FeedImageDataLoader {
    
    private class Task: FeedImageDataLoaderTask {
    
        func cancel() {
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> FeedImageDataLoaderTask {
        return Task()
    }
}

private class ResourceLoaderAdapter: ResourceLoader {
    
    let loader: FeedLoader
    
    init(loader: FeedLoader) {
        self.loader = loader
    }
    
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) -> ResourceLoaderTask? {
        loader.load(completion: completion)
        return nil
    }
}
