//
//  MappingViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import MapKit
import CoreLocation
import Kingfisher

class MappingViewController: UIViewController {
    
    private var commentData: [Comment] = []
    private var currentUser: Account?
    private var reportButton = UIButton()
    private let locationManager = CLLocationManager()
    private let mapView = MapView()
    lazy var searchBar: UISearchBar = UISearchBar()
    
    // 計算對應的function用
    private var gestureHolder: [UITapGestureRecognizer] = []
    
    var isSearchResults = false
    
    private var storeData: [Store] = [] {
        didSet {
            storeTag = storeData.flatMap {$0.tags}.uniqued()
        }
    }
    private var filteredStoreData: [Store] = [] {
        didSet {
            filteredStoreTags = filteredStoreData.flatMap {$0.tags}.uniqued()
        }
    }
    
    private var storeTag: [String] = []
    private var filteredStoreTags: [String] = []
    
    private var commentOfStore: [[Comment]] = []
    private var commentOfFilteredStore: [[Comment]] = []
    
    
    private var distance: [Double] = []
    private var filteredStoreDistance: [Double] = []
    
    
    // collectionView
    var storeCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tagSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var selectedIndex = 0 {
        didSet {
            if isSearchResults {
                print(selectedIndex)
                storeCardCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                let locationPoint = CLLocationCoordinate2D(latitude: filteredStoreData[selectedIndex].coordinate.lat - 0.002, longitude: filteredStoreData[selectedIndex].coordinate.long)
                mapView.setRegion(MKCoordinateRegion(center: locationPoint, latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
            } else {
                print(selectedIndex)
                storeCardCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                let locationPoint = CLLocationCoordinate2D(latitude: storeData[selectedIndex].coordinate.lat - 0.002, longitude: storeData[selectedIndex].coordinate.long)
                mapView.setRegion(MKCoordinateRegion(center: locationPoint, latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        storeCardCollectionView.isHidden = true
        StoreRequestProvider.shared.listenStore {
            self.updataStore()
        }
        //        setupLocationManager()
        self.view.stickSubView(mapView)
        fetchData {
            LKProgressHUD.showSuccess(text: "下載資料成功")
            self.setupSearchBar()
            self.setupMapView()
            self.setupTagCollectionView()
            self.setupHiddenCollectionView()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMapView()
    }
    
    func setupMapView() {
        mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.09108, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
        mapView.layoutView(from: storeData)
    }
    func setupHiddenCollectionView() {
        setupDataForCollectionCell()
        if let flowLayout = storeCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        storeCardCollectionView.register(UINib(nibName: String(describing: StoreCardsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StoreCardsCell.self))
        storeCardCollectionView.dataSource = self
        storeCardCollectionView.delegate = self
        self.view.addSubview(storeCardCollectionView)
        storeCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storeCardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        storeCardCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        storeCardCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        storeCardCollectionView.heightAnchor.constraint(equalTo: storeCardCollectionView.widthAnchor, multiplier: 230/390).isActive = true
        storeCardCollectionView.backgroundColor = .clear
    }
    func setupTagCollectionView() {
        
        if let flowLayout = tagSelectionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        tagSelectionCollectionView.register(UINib(nibName: String(describing: TagCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TagCell.self))
        tagSelectionCollectionView.dataSource = self
        tagSelectionCollectionView.delegate = self
        tagSelectionCollectionView.isHidden = true
        self.view.addSubview(tagSelectionCollectionView)
        tagSelectionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tagSelectionCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tagSelectionCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tagSelectionCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tagSelectionCollectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tagSelectionCollectionView.backgroundColor = .clear
    }
    func setupDescriptionCardView() {
        if storeCardCollectionView.isHidden {
            storeCardCollectionView.isHidden = false
            addDragFloatBtn()
        }
    }
    func updataStore() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data) :
                self.storeData = data
                self.reloadMapView()
                self.storeCardCollectionView.reloadData()
            case .failure(let error) :
                print("下載商店資料失敗", error)
            }
        }
    }
    func fetchData(competion: @escaping () -> Void) {
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        LKProgressHUD.show(text: "下載店家資訊中")
        group.enter()
        concurrentQueue1.async(group: group) {
            StoreRequestProvider.shared.fetchStores { result in
                switch result {
                case .success(let data) :
                    self.storeData = data
                case .failure(let error) :
                    print("下載商店資料失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載商店資料失敗")
                }
                group.leave()
            }
        }
        group.enter()
        concurrentQueue2.async(group: group) {
            CommentRequestProvider.shared.fetchComments { result in
                switch result {
                case .success(let data) :
                    self.commentData = data
                case .failure(let error) :
                    print("下載評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        group.enter()
        concurrentQueue3.async(group: group) {
            guard let currentUserID = UserRequestProvider.shared.currentUserID else {
                group.leave()
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "載入使用者失敗")
                return
                
            }
            AccountRequestProvider.shared.fetchAccount(currentUserID: currentUserID) { result in
                switch result {
                case .success(let data) :
                    self.currentUser = data
                case .failure(let error) :
                    print("載入使用者失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "載入使用者失敗")
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            LKProgressHUD.dismiss()
            competion()
        }
    }
    func setupDataForCollectionCell() {
        let fakeLocationAkaTaipei101 = CLLocation(latitude: 25.038685278051556, longitude: 121.5323763590289)
        for (index, data) in storeData.enumerated() {
            var commentHolder: [Comment] = []
            distance.append(fakeLocationAkaTaipei101.distance(from: CLLocation(latitude: data.coordinate.lat, longitude: data.coordinate.long)))
            for comment in commentData where comment.storeID == data.storeID {
                commentHolder.append(comment)
            }
            commentOfStore.insert(commentHolder, at: index)
        }
    }
    func setupDataForFilteredCell() {
        let fakeLocationAkaTaipei101 = CLLocation(latitude: 25.038685278051556, longitude: 121.5323763590289)
        for (index, data) in filteredStoreData.enumerated() {
            var commentHolder: [Comment] = []
            filteredStoreDistance.append(fakeLocationAkaTaipei101.distance(from: CLLocation(latitude: data.coordinate.lat, longitude: data.coordinate.long)))
            for comment in commentData where comment.storeID == data.storeID {
                commentHolder.append(comment)
            }
            commentOfFilteredStore.insert(commentHolder, at: index)
        }
    }
    func setupSearchBar() {
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            //textField.font = myFont
            //textField.textColor = myTextColor
            //textField.tintColor = myTintColor
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
        }
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            // 他沒打開
            print("Map not open")
            
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        }
    }
    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MappingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let viewSize = 50.0
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewSize, height: viewSize))
            imageView.layer.cornerRadius = viewSize/2
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // create View
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            // assign annotation
            annotationView?.annotation = annotation
        }
        // set Image
        annotationView?.frame = CGRect(x: 0, y: 0, width: viewSize, height: viewSize)
        
        switch annotation.title {
        default:
            for store in storeData.reversed() where annotation.title == store.name {
                switch cogfigReport(store: store) {
                case 1:
                    annotationView?.doGlowAnimation(withColor: .blue, withEffect: .small)
                case 2:
                    annotationView?.doGlowAnimation(withColor: .green, withEffect: .normal)
                case 3:
                    annotationView?.doGlowAnimation(withColor: .orange, withEffect: .mid)
                case 4:
                    annotationView?.doGlowAnimation(withColor: .red, withEffect: .big)
                default:
                    break
                }
                
                imageView.kf.setImage(with: URL(string: store.mainImage), placeholder: UIImage(named: "AppIcon") )
                annotationView?.subviews.forEach { $0.removeFromSuperview() }
                annotationView?.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
                tap.name = store.storeID
                gestureHolder.append(tap)
                annotationView?.addGestureRecognizer(tap)
            }
        }
        return annotationView
    }
    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
        guard let name = sender.name else { return }
        if isSearchResults {
            for (index, store) in filteredStoreData.enumerated() where store.storeID == name {
                selectedIndex = index
                setupDescriptionCardView()
            }
        } else {
            for (index, store) in storeData.enumerated() where store.storeID == name {
                selectedIndex = index
                setupDescriptionCardView()
            }
        }
    }
    func cogfigReport(store: Store) -> Int {
        guard let reports = store.queueReport else { return 0 }
        let date = Double(Date().timeIntervalSince1970)
        if !reports.isEmpty {
            guard let report = reports.sorted(by: {$0.createdTime > $1.createdTime}).first else { return 0 }
            if (report.createdTime + 60*60*3) > date {
                return report.queueCount
            } else {
                return 0
            }
        }
        return 0
    }
    func reloadMapView() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
            mapView.addAnnotation(annotation)
        }
    }
    
    
}
extension MappingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagSelectionCollectionView {
            if isSearchResults {
                return filteredStoreTags.count
            } else {
                return storeTag.count
            }
        } else {
            if isSearchResults {
                return filteredStoreData.count
            } else {
                return storeData.count
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tagSelectionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TagCell.self)", for: indexPath) as? TagCell else { return UICollectionViewCell() }
            if isSearchResults {
                
                cell.tagButton.setTitle(filteredStoreTags[indexPath.row], for: .normal)
                return cell
            } else {
                
                cell.tagButton.setTitle(storeTag[indexPath.row], for: .normal)
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoreCardsCell.self)", for: indexPath) as? StoreCardsCell else { return UICollectionViewCell() }
            guard let user = currentUser else { return StoreCardsCell() }
            cell.delegate = self
            if isSearchResults {
                let isCollect = filteredStoreData[indexPath.row].collectedUser?.contains(user.userID)
                cell.layoutCardView(dataSource: filteredStoreData[indexPath.row], commentData: commentOfFilteredStore[indexPath.row], isCollect: isCollect ?? false)
                return cell
            } else {
                let isCollect = storeData[indexPath.row].collectedUser?.contains(user.userID)
                cell.layoutCardView(dataSource: storeData[indexPath.row], commentData: commentOfStore[indexPath.row], isCollect: isCollect ?? false)
                return cell
            }
        }
        
    }
}

extension MappingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagSelectionCollectionView {
            if isSearchResults {
                filterAnnotation(text: filteredStoreTags[indexPath.row])
            } else {
                filterAnnotation(text: storeTag[indexPath.row])
            }
        } else {
            guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "StorePageViewController") as? StorePageViewController else { return }
            if isSearchResults {
                controller.currentUser = currentUser
                controller.storeData = filteredStoreData[indexPath.row]
                controller.commentData = commentOfFilteredStore[indexPath.row]
                self.addChild(controller)
                navigationController?.pushViewController(controller, animated: true)
                
            } else {
                controller.currentUser = currentUser
                controller.storeData = storeData[indexPath.row]
                controller.commentData = commentOfStore[indexPath.row]
                self.addChild(controller)
                navigationController?.pushViewController(controller, animated: true)
            }
            
        }
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tagSelectionCollectionView {
            
        } else {
            let itemSize = CGSize(width: self.storeCardCollectionView.frame.size.width - 2 * 16, height: self.storeCardCollectionView.frame.size.height - 2 * 6)
            let xCenterOffset = targetContentOffset.pointee.x + (itemSize.width / 2.0)
            let indexPath = IndexPath(item: Int(xCenterOffset / (itemSize.width + 16 / 2.0)), section: 0)
            self.selectedIndex = indexPath.row
            let offset = CGPoint(x: (itemSize.width + 16.0 / 2.0) * CGFloat(indexPath.item), y: 0)
            scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
            targetContentOffset.pointee = offset
        }
    }
}
extension MappingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        if collectionView == tagSelectionCollectionView {
            if isSearchResults {
                let string = filteredStoreTags[indexPath.item]
                let font = UIFont.systemFont(ofSize: 16)
                let size = string.widthWithConstrainedHeight(30, font: font)
                return CGSize(width: size + 10, height: 30)
            } else {
                let string = storeTag[indexPath.item]
                let font = UIFont.systemFont(ofSize: 16)
                let size = string.widthWithConstrainedHeight(30, font: font)
                return CGSize(width: size + 10, height: 30)
            }
        } else {
            let cellSize = CGSize(width: collectionViewSize.width - 2 * 16.0, height: collectionViewSize.height - 2 * 6.0)
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0)
    }
    
}

extension MappingViewController {
    func addDragFloatBtn() {
        reportButton.frame = CGRect(x: UIScreen.width-70, y: 200, width: 60, height: 60)
        
        reportButton.layer.cornerRadius = 30.0
        self.view .addSubview(reportButton)
        reportButton.setImage( UIImage(named: "broadcast"), for: .normal)
        
        reportButton.backgroundColor = .black.withAlphaComponent(0.4)
        reportButton.tintColor = .white
        reportButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        reportButton.addTarget(self, action: #selector(floatBtnAction(sender:)), for: .touchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragAction(gesture:)))
        reportButton .addGestureRecognizer(panGesture)
    }
    
    @objc func dragAction(gesture: UIPanGestureRecognizer) {
        let moveState = gesture.state
        switch moveState {
        case .began:
            break
        case .changed:
            let point = gesture.translation(in: self.view)
            self.reportButton.center = CGPoint(x: self.reportButton.center.x + point.x, y: self.reportButton.center.y + point.y)
            break
        case .ended:
            let point = gesture.translation(in: self.view)
            var newPoint = CGPoint(x: self.reportButton.center.x + point.x, y: self.reportButton.center.y + point.y)
            if newPoint.x < self.view.bounds.width / 2.0 {
                newPoint.x = 40.0
            } else {
                newPoint.x = self.view.bounds.width - 40.0
            }
            if newPoint.y <= 40.0 {
                newPoint.y = 40.0
            } else if newPoint.y >= self.view.bounds.height - 40.0 {
                newPoint.y = self.view.bounds.height - 40.0
            }
            UIView.animate(withDuration: 0.5) {
                self.reportButton.center = newPoint
            }
            break
        default:
            break
        }
        gesture.setTranslation(.zero, in: self.view)
    }
    @objc func floatBtnAction(sender: UIButton) {
        initReportQueueView()
    }
    private func initReportQueueView() {
        let storeName = storeData[selectedIndex].name
        let reportView: ReportView = UIView.fromNib()
        reportView.delegate = self
        self.view.addSubview(reportView)
        reportView.layoutView(name: storeName)
        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reportView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        reportView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        reportView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    private func pulishQueue(queue: Int) {
        let storeID = storeData[selectedIndex].storeID
        guard let currentUserID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "回報失敗")
            return
        }
        var queue = QueueReport(queueCount: queue)
        QueueReportRequestProvider.shared.publishQueueReport(currentUserID: currentUserID, targetStoreID: storeID, report: &queue) { result in
            switch result {
            case .failure:
                LKProgressHUD.showFailure(text: "回報失敗")
            case .success(let count):
                LKProgressHUD.showSuccess(text: "回報成功")
            }
        }
    }
}
extension MappingViewController: ReportViewDelegate {
    func didTapSendButton(_ view: ReportView, queue: Int) {
        pulishQueue(queue: queue)
    }
}
extension MappingViewController: CLLocationManagerDelegate {
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let userLocation: CLLocation = locations[0] as CLLocation
    //        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    //        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    //
    //        mapView.setRegion(mRegion, animated: true)
    //    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
extension MappingViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        setRegion()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // mapView.layoutView(from: storeData)
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setRegion()
        if searchText.isEmpty && isSearchResults {
            isSearchResults = false
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
            storeCardCollectionView.reloadData()
            mapView.layoutView(from: storeData)
        } else {
            filterAnnotation(text: searchText)
        }
    }
    private func filterAnnotation(text: String) {
        filteredStoreData = storeData.filter({ store in
            let tag = store.tags.joined()
            let title = store.name
            let address = store.address
            
            let isMatchTags = tag.localizedStandardContains(text)
            let isMatchName = title.localizedStandardContains(text)
            let isMatchAddress = address.localizedStandardContains(text)
            if isMatchTags || isMatchName || isMatchAddress == true {
                return true
            } else {
                return false
            }
        })
        setupDataForFilteredCell()
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        isSearchResults = true
        storeCardCollectionView.reloadData()
        mapView.layoutView(from: filteredStoreData)
        
    }
    private func setRegion() {
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.00708, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000), animated: true)
    }
}
extension MappingViewController: StoreCardsCellDelegate {
    func didtapCollectionButton(view: StoreCardsCell, storeID: String) {
        guard let user = currentUser else { return }
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "收藏失敗")
                
            }
        }
    }
    
    func didtapUnCollectionButton(view: StoreCardsCell, storeID: String) {
        guard let user = currentUser else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "取消失敗")
                
            }
        }
    }
    
    
    
    
}
