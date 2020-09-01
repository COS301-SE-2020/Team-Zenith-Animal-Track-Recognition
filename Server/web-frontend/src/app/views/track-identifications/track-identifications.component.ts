import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { MapInfoWindow, MapMarker, GoogleMap } from '@angular/google-maps';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
	selector: 'app-track-identifications',
	templateUrl: './track-identifications.component.html',
	styleUrls: ['./track-identifications.component.css']
})

export class TrackIdentificationsComponent implements OnInit {

	@ViewChild('sidenav') sidenav;
	trackIdentifications: any;
	displayedTracks: any;
	searchText: string;
	sortBySurname: boolean = true;
	currentAlphabet;
	sorted: string;
	pageSize: number = 25;
	map: google.maps.Map;
	geoCoder: google.maps.Geocoder;
	infoWindow: google.maps.InfoWindow;
	trackHltCircle: any;
	
	constructor(private http: HttpClient, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById("geotags-route").classList.add("activeRoute");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){spoorIdentificationID,animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.trackIdentifications = temp[0];
				this.timeToString();
				this.displayedTracks = temp[0].splice(0, this.pageSize);
				this.initMap();
			});
	}

	initMap() {
		this.map = new google.maps.Map(document.getElementById("identifications-google-map-container") as HTMLElement, {
			center: { lat: -23.988, lng: 31.554 },
			mapTypeId: 'roadmap',
			maxZoom: 15,
			minZoom: 5,
			zoom: 7
		});

		//Place track markers
		for (let i = 0; i < this.trackIdentifications.length; i++) {
			var markerIcon = {
				anchor: new google.maps.Point(54,190),
				path: "M108.4,55c0.3,8.4-2.6,17.1-6.8,25.3c-3.8,7.4-8.1,14.5-12.4,21.6c-15.6,25.7-26.3,53.3-31.1,83.1c-0.3,1.9-2.7,3.4-4.1,5.1c-1.3-1.6-3.5-3.1-3.8-4.9c-5.1-31.8-16.5-61.2-33.8-88.4c-4.3-6.7-8.2-13.7-11.5-21C-4.4,55-0.3,32.6,15.5,16.4	C30.8,0.7,54.1-4.3,74.4,3.8C94.8,11.9,108.2,31.7,108.4,55z M54.4,74.3c9.7,0,17.6-7.7,17.6-17.3c0-10-7.8-17.9-17.6-17.9c-10,0-17.8,7.7-17.9,17.7C36.3,66.4,44.3,74.2,54.4,74.3z",
				fillColor: this.trackIdentifications[i].animal.animalMarkerColor,
				fillOpacity: 1,
				strokeWeight: 0,
				scale: 0.3
			}
			let trackLocation = new google.maps.Marker({
				map: this.map,
				position: new google.maps.LatLng(this.trackIdentifications[i].location.latitude, this.trackIdentifications[i].location.longitude),
				animation: google.maps.Animation.DROP,
				icon: markerIcon,
			});
		}
		this.geoCoder = new google.maps.Geocoder;
		this.infoWindow = new google.maps.InfoWindow;
		this.stopLoader();
	}
	zoomOnTrack(coords: string)
	{
		if (coords == "resetZoom")
		{
			this.map.setZoom(7);
			this.trackHltCircle.setMap(null);
		}
		else
		{
			var latlngStr = coords.split(',', 2);
			var latlng = {lat: parseFloat(latlngStr[0]), lng: parseFloat(latlngStr[1])};
			this.map.setCenter(latlng);
			this.map.setZoom(14);
			
			//Highlight marker with circle
			this.trackHltCircle = new google.maps.Circle({
			  strokeColor: "#FF0000",
			  strokeOpacity: 0.8,
			  strokeWeight: 2,
			  fillColor: "#FF0000",
			  fillOpacity: 0.35,
			  map: this.map,
			  center: latlng,
			  radius: 250
			});
		}
	}

	timeToString() {
		this.trackIdentifications.forEach(element => {
			let temp = element.dateAndTime;
			temp.month = temp.month < 10 ? '0' + temp.month : temp.month;
			temp.day = temp.day < 10 ? '0' + temp.day : temp.day;
			temp.hour = temp.hour < 10 ? '0' + temp.hour : temp.hour;
			temp.min = temp.min < 10 ? '0' + temp.min : temp.min;
			temp.second = temp.second < 10 ? '0' + temp.second : temp.second;
			const str: string = temp.year + "-" + temp.month + "-" + temp.day + "T" + temp.hour + ":" + temp.min + ":" + temp.second + ".000Z";
			element.timeAsString = str;
			element.dateObj = new Date(temp.year, temp.month, temp.day, temp.hour, temp.min, temp.second);
		});
	}

	updateSearchText(event) {
		this.searchText = event;
	}

	refresh(updateOp: string) {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){rangerID,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				var newRangerList = temp[0];
				switch (updateOp) {
					case "update":
						this.trackIdentifications = null;
						this.trackIdentifications = newRangerList;
						break;
					case "add":
						//newRangerList.forEach(x => this.addIfNewRanger(x));
						break;
				}
				//this.sort(this.sortBySurname);
			});
	}
	//Ranger CRUD Operations
	updateTrackList(updatedList: string) {
		this.refresh(updatedList);
	}
	
	iterateDisplayedTracks($event) {
        this.displayedTracks =  this.trackIdentifications.slice($event.pageIndex*$event.pageSize,
        $event.pageIndex*$event.pageSize + $event.pageSize);
    }

	showOpenBtn() {
		//Show Open Button
		document.getElementById('sidenav-open-btn-container').style.visibility = 'visible';
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-open-btn-container').style.left = '0%';

		//Hide Closed Button
		document.getElementById('sidenav-close-btn-container').style.transitionDuration = '0.2s';
		document.getElementById('sidenav-close-btn-container').style.left = '-10%';
		document.getElementById('sidenav-close-btn-container').style.visibility = 'hidden';
	}

	showCloseBtn() {
		//Show Close Button
		document.getElementById('sidenav-close-btn-container').style.visibility = 'visible';
		document.getElementById('sidenav-close-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-close-btn-container').style.left = '0%';

		//Hide Open Button
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.2s';
		document.getElementById('sidenav-open-btn-container').style.left = '-10%';
		document.getElementById('sidenav-open-btn-container').style.visibility = 'hidden';
	}

	openSidenav() {
		this.sidenav.open();
		this.showCloseBtn();
	}

	closeSidenav() {
		this.sidenav.close();
		this.showOpenBtn();
	}

	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}