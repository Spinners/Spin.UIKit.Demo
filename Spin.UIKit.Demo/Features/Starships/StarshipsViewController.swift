//
//  StarshipsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine
import Reusable
import RxFlow
import RxRelay
import UIKit

class StarshipsViewController: UIViewController, StoryboardBased, Stepper {
    let steps = PublishRelay<Step>()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var failureLabel: UILabel!

    var disposeBag = [AnyCancellable]()
    
    private var datasource = [(Starship, Bool)]()
    
    let actionSubject = PassthroughSubject<StarshipsFeature.Action, Never>()
        
    @IBAction func previousTapped(_ sender: UIButton) {
        self.actionSubject.send(StarshipsFeature.Action.loadPrevious)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.actionSubject.send(StarshipsFeature.Action.loadNext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.actionSubject.send(StarshipsFeature.Action.load)
    }
}

/////////////////////////
// FEEDBACKS
/////////////////////////
extension StarshipsViewController {
    func stateFeedback(state: StarshipsFeature.State) {
        print("<UI FEEDBACK> interpret state: \(state)")
        self.interpret(state: state)
    }

    func actionFeedback() -> AnyPublisher<StarshipsFeature.Action, Never> {
        print("<UI FEEDBACK> mutate with user actions")
        return self.actionSubject.handleEvents(receiveSubscription: { _ in
            print("<UI FEEDBACK> action subject has been subscribed")
        }, receiveOutput: { mutation in print("<UI FEEDBACK> action emitted: \(mutation)") }).eraseToAnyPublisher()
    }
}

extension StarshipsViewController {
    func interpret(state: StarshipsFeature.State) -> Void {

        guard
            self.activityIndicator != nil,
            self.previouxButton != nil,
            self.nextButton != nil,
            self.failureLabel != nil,
            self.tableView != nil else { return }

        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = true
            self.tableView.isHidden = false
        case .loading:
            self.activityIndicator.startAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 0.5
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = true
        case .loaded(let planets, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 1
            self.datasource = planets
            self.tableView.reloadData()
            self.previouxButton.isEnabled = (previous != nil)
            self.nextButton.isEnabled = (next != nil)
            self.failureLabel.isHidden = true
        case .failed:
            self.datasource = []
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }
}

extension StarshipsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starshipCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].0.name
        cell.imageView?.image = self.datasource[indexPath.row].1 ? UIImage(systemName: "star.fill") : nil
        return cell
    }
}

extension StarshipsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let starship = self.datasource[indexPath.row].0
        self.steps.accept(AppSteps.starship(starship: starship))
    }
}
