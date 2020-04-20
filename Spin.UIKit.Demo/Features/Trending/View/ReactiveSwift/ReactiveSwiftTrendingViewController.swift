//
//  ReactiveSwiftTrendingViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift
import Reusable
import RxFlow
import RxRelay
import SpinReactiveSwift
import UIKit

class ReactiveSwiftTrendingViewController: UIViewController, StoryboardBased, Stepper {

    fileprivate var uiSpin: UISpin<Trending.State, Trending.Event>!

    let steps = PublishRelay<Step>()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var failureLabel: UILabel!
    @IBOutlet private weak var pagesLabel: UILabel!

    private var datasource = [(GifOverview, Bool)]()

    @IBAction func previousTapped(_ sender: UIButton) {
        self.uiSpin.emit(.loadPrevious)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.uiSpin.emit(.loadNext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Trending"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.uiSpin.render(on: self) { $0.interpret(state:) }
        self.uiSpin.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiSpin.emit(.load)
    }
}

extension ReactiveSwiftTrendingViewController {
    func interpret(state: Trending.State) -> Void {

        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = true
            self.tableView.isHidden = false
            self.pagesLabel.isHidden = true
        case .loading:
            self.activityIndicator.startAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 0.5
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = true
            self.pagesLabel.isHidden = true
        case .loaded(let gifs, let currentPage, _, _, let totalPages):
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 1
            self.datasource = gifs
            self.tableView.reloadData()
            self.previouxButton.isEnabled = state.hasPreviousPage
            self.nextButton.isEnabled = state.hasNextPage
            self.failureLabel.isHidden = true
            self.pagesLabel.isHidden = false
            self.pagesLabel.text = "\(currentPage + 1) / \(totalPages)"
        case .failed:
            self.datasource = []
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = false
            self.tableView.isHidden = true
            self.pagesLabel.isHidden = true
        }
    }
}

extension ReactiveSwiftTrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].0.title
        cell.imageView?.image = self.datasource[indexPath.row].1 ? UIImage(systemName: "star.fill") : nil
        return cell
    }
}

extension ReactiveSwiftTrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gif = self.datasource[indexPath.row].0
        self.steps.accept(GifStep.gif(gif: gif))
    }
}

extension ReactiveSwiftTrendingViewController {
    static func make(uiSpin: UISpin<Trending.State, Trending.Event>) -> ReactiveSwiftTrendingViewController {
        let viewController = ReactiveSwiftTrendingViewController.instantiate()
        viewController.uiSpin = uiSpin
        return viewController
    }
}


