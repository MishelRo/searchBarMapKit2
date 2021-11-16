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
        case Constants.getStatus(status: .alarm):
            self.markerTintColor = .red
        case Constants.getStatus(status: .stop):
            self.markerTintColor = .gray
        case Constants.getStatus(status: .movement):
            self.markerTintColor = .yellow
        case Constants.getStatus(status: .parking):
            self.markerTintColor = .green
        default:
            self.markerTintColor = .orange
    }
}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
