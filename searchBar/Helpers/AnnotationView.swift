//
//  File.swift
//  searchBar
//
//  Created by User on 28.10.2021.
//

import MapKit
class AnnotationView: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        switch reuseIdentifier {
        case Constants.getStatus(status: .reuseIdentifier):
            self.markerTintColor = .blue
            self.clusteringIdentifier = "pins"
        case Constants.getStatus(status: .alarm):
            self.clusteringIdentifier = "Тревога"
            self.markerTintColor = .red
        case Constants.getStatus(status: .stop):
            self.markerTintColor = .gray
            self.clusteringIdentifier = "Остановка"
        case Constants.getStatus(status: .movement):
            self.markerTintColor = .yellow
            self.clusteringIdentifier = "Движение"
        case Constants.getStatus(status: .parking):
            self.markerTintColor = .green
            self.clusteringIdentifier = "Парковка"
        default:
            self.markerTintColor = .orange
    }
}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
