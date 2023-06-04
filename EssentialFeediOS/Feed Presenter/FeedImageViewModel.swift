//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Mushthak Ebrahim on 04/06/23.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
