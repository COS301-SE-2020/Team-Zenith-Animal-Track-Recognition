import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { MapInfoWindow, MapMarker, GoogleMap } from '@angular/google-maps';

@Component({
	selector: 'app-track-identifications',
	templateUrl: './track-identifications.component.html',
	styleUrls: ['./track-identifications.component.css']
})

export class TrackIdentificationsComponent implements OnInit {

	@ViewChild('sidenav') sidenav;
	trackIdentifications: any;
	searchText: string;
	sortBySurname: boolean = true;
	currentAlphabet;
	sorted: string;
	timeAsString: any = [];
	map: google.maps.Map;

	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById("geotags-route").classList.add("activeRoute");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){spoorIdentificationID,animal{classification,animalID,commonName,heightM,heightF,weightM,weightF,dietType,lifeSpan,Offspring,gestationPeriod,animalOverview,animalDescription,animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName,pictureURL},potentialMatches{confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.trackIdentifications = temp[0];
				this.timeToString();
				this.initMap();
			});
	}

	initMap() {
		this.map = new google.maps.Map(document.getElementById("identifications-google-map-container") as HTMLElement, {
			center: { lat: -23.988, lng: 31.554 },
			mapTypeId: 'roadmap',
			maxZoom: 15,
			minZoom: 5,
			zoom: 9
		});
		//Place track markers
		for (let i = 0; i < this.trackIdentifications.length; i++) {
			var markerIcon = {
				path: "M172.3,501.7C27,291,0,269.4,0,192C0,86,86,0,192,0s192,86,192,192c0,77.4-27,99-172.3,309.7 C202.2,515.4,181.8,515.4,172.3,501.7L172.3,501.7z M192,272c44.2,0,80-35.8,80-80s-35.8-80-80-80s-80,35.8-80,80S147.8,272,192,272",
				fillColor: this.trackIdentifications[i].animal.animalMarkerColor,
				fillOpacity: 1,
				strokeWeight: 0,
				scale: 0.07
			}
			let trackLocation = new google.maps.Marker({
				map: this.map,
				position: new google.maps.LatLng(this.trackIdentifications[i].location.latitude, this.trackIdentifications[i].location.longitude),
				animation: google.maps.Animation.DROP,
				icon: markerIcon,
			});
		}
		this.stopLoader();
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
		console.log("starting loader");
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		console.log("stopping loader");
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}