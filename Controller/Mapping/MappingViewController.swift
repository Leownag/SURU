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
    var storeData: [Store] = []
    var commentData: [Comment] = []
    var originStoreData: [Store] = []
    var btn = UIButton()
    
    // annotion對應的store index
    var annotionIndexOfStore: [Int] = []
    // 計算對應的function用
    var gestureHolder: [UITapGestureRecognizer] = []
    var storeHolder: [Store] = []
    //    let view = UIImageView()
    //    let pan = UIPanGestureRecognizer()
    //    pan.addTarget(self, action: #s)
    // 計算對應的datasource用
    var distance: [Double] = []
    var commentOfStore: [[Comment]] = []
    var selectedIndex = 0 {
        didSet {
            print(selectedIndex)
            
            storeCardCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: storeData[selectedIndex].coordinate.lat-0.002, longitude: storeData[selectedIndex].coordinate.long), latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
            
        }
    }
    
    let mapView = MapView()
    //    var locationManager = CLLocationManager()
    var storeCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCommentData()
        fetchStoreData {
            self.setupMapView()
            self.setupHiddenCollectionView()
        }
        storeCardCollectionView.dataSource = self
        storeCardCollectionView.delegate = self
        if let flowLayout = storeCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        storeCardCollectionView.register(UINib(nibName: String(describing: StoreCardCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StoreCardCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        setupLocationManager()
    }
    func fetchCommentData() {
        CommentRequestProvider.shared.fetchComments { [weak self] result in
            switch result {
            case .success(let data):
                self?.commentData = data
                print("Get all comment data from firebase in Mapping page")
            case .failure(let error):
                print("Mapping page error with code: \(error)")
            }
        }
    }
    func fetchStoreData(competion: @escaping () -> Void) {
        StoreRequestProvider.shared.fetchStores { [weak self] result in
            switch result {
            case .success(let data):
                self?.originStoreData = data
                self?.storeData = data.sorted(by: { $0.coordinate.long < $1.coordinate.long
                })
                print("Get all store data from firebase in Mapping page")
            case .failure(let error):
                print("Mapping page error with code: \(error)")
            }
            competion()
        }
    }
    
    func setupMapView() {
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.delegate = self
        mapView.layoutView(from: storeData)
    }
    func setupHiddenCollectionView() {
        setupDataForCollectionCell()
        storeCardCollectionView.isHidden = true
        self.view.addSubview(storeCardCollectionView)
        storeCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storeCardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        storeCardCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        storeCardCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        storeCardCollectionView.heightAnchor.constraint(equalTo: storeCardCollectionView.widthAnchor, multiplier: 230/390).isActive = true
        storeCardCollectionView.backgroundColor = .clear
    }
    func setupDescriptionCardView() {
        if storeCardCollectionView.isHidden {
            storeCardCollectionView.isHidden = false
            addDragFloatBtn()
            
        }
    }
    
    func zoomMapViewin(_ point: Coordinate) {
        // call mapView function
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
    
    //    func setupLocationManager() {
    //        locationManager.delegate = self
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.requestAlwaysAuthorization()
    //
    //        if CLLocationManager.locationServicesEnabled() {
    //            locationManager.startUpdatingLocation()
    //        }
    //    }
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
            for (index, store) in storeData.enumerated() where annotation.title == store.name {
                imageView.kf.setImage(with: URL(string: store.mainImage))
                annotionIndexOfStore.append(index)
                annotationView?.subviews.forEach { $0.removeFromSuperview() }
                annotationView?.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
                tap.name = store.storeID
                //                gestureHolder.append(tap)
                
                annotationView?.addGestureRecognizer(tap)
            }
        }
        return annotationView
    }
    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
        guard let name = sender.name else { return }
        for (index, store) in storeData.enumerated() where store.storeID == name {
            selectedIndex = index
            setupDescriptionCardView()
        }
    }
}
extension MappingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoreCardCell.self)", for: indexPath) as? StoreCardCell else { return UICollectionViewCell() }
        
        cell.layoutCardView(dataSource: storeData[indexPath.row], commentData: commentOfStore[indexPath.row], areaName: "還沒做出來區", distance: distance[indexPath.row])
        return cell
    }
}

extension MappingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemSize = CGSize(width: self.storeCardCollectionView.frame.size.width - 2 * 16, height: self.storeCardCollectionView.frame.size.height - 2 * 6)
        let xCenterOffset = targetContentOffset.pointee.x + (itemSize.width / 2.0)
        let indexPath = IndexPath(item: Int(xCenterOffset / (itemSize.width + 16 / 2.0)), section: 0)
        self.selectedIndex = indexPath.row
        let offset = CGPoint(x: (itemSize.width + 16.0 / 2.0) * CGFloat(indexPath.item), y: 0)
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        targetContentOffset.pointee = offset
        
        
    }
}
extension MappingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        let cellSize = CGSize(width: collectionViewSize.width - 2 * 16.0, height: collectionViewSize.height - 2 * 6.0)
        return cellSize
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
        btn.frame = CGRect(x: UIScreen.width-70, y: 30, width: 60, height: 60)
        
        btn.layer.cornerRadius = 30.0
        self.view .addSubview(btn)
        btn.setImage( UIImage(named: "broadcast"), for: .normal)
        
        btn.backgroundColor = .black.withAlphaComponent(0.4)
        btn.tintColor = .white
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn.addTarget(self, action: #selector(floatBtnAction(sender:)), for: .touchUpInside)
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

   @objc func dragAction(gesture: UIPanGestureRecognizer) {
       // 移动状态
       let moveState = gesture.state
       switch moveState {
           case .began:
               break
           case .changed:
               // floatBtn 获取移动轨迹
               let point = gesture.translation(in: self.view)
               self.btn.center = CGPoint(x: self.btn.center.x                 + point.x, y: self.btn.center.y + point.y)
               break
           case .ended:
               // floatBtn 移动结束吸边
               let point = gesture.translation(in: self.view)
               var newPoint = CGPoint(x: self.btn.center.x +                     point.x, y: self.btn.center.y + point.y)
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
               // 0.5秒 吸边动画
               UIView.animate(withDuration: 0.5) {
                   self.btn.center = newPoint
               }
               break
           default:
               break
       }
       gesture.setTranslation(.zero, in: self.view)
   }
   @objc func floatBtnAction(sender: UIButton) {
       print("floatBtnAction")
   }

}

//extension MappingViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation: CLLocation = locations[0] as CLLocation
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.setRegion(mRegion, animated: true)
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error - locationManager: \(error.localizedDescription)")
//    }
//}
