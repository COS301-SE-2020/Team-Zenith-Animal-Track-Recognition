import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { EMPTY} from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { MapInfoWindow, MapMarker, GoogleMap } from '@angular/google-maps';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Router, ActivatedRoute } from '@angular/router';
import { TrackIdentificationsSidenavComponent } from './track-identifications-sidenav/track-identifications-sidenav.component';

@Component({
	selector: 'app-track-identifications',
	templateUrl: './track-identifications.component.html',
	styleUrls: ['./track-identifications.component.css']
})

export class TrackIdentificationsComponent implements OnInit {

	@ViewChild('trackIdentificationsSidenav') trackSidenav: TrackIdentificationsSidenavComponent;
	@ViewChild('sidenav') sidenav;
	activeTrack: any = null;
	currentAlphabet;
	displayedTracks: any;
	defaultLocation: string = 'Address not found';
	geoCoder: google.maps.Geocoder;
	initWithOpenTrack: boolean = false;
	initWithOpenTrackId: any; 
	infoWindow: google.maps.InfoWindow;
	map: google.maps.Map;
	mapMarkers: any = [];
	pageSize: number = 25;
	searchText: string;
	sortBySurname: boolean = true;
	sorted: string;
	trackHltCircle: any;
	trackIdentifications: any;
	
	constructor(private activatedRoute: ActivatedRoute, private http: HttpClient, private router: Router, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		this.startSidenavLoader();
		document.getElementById("geotags-route").classList.add("activeRoute");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){spoorIdentificationID,animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
			.pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					this.stopLoader();
					this.stopSidenavLoader();
					return EMPTY;
				})
			)
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.trackIdentifications = temp[0];
				
				//Only display a certain number of tracks per sidenav page
				this.displayedTracks = temp[0].slice(0, this.pageSize);
				//Add 'time ago' field to each track
				this.timeToString();
				
				//Check if a track was selected from the query parameters
				const spoorIdQuery = new URLSearchParams(window.location.search);
				const requestedSpoorId = spoorIdQuery.get("openTrackId");
				if (requestedSpoorId != null) {
					this.initWithOpenTrack = true;
					this.initWithOpenTrackId = requestedSpoorId;
					this.snackBar.open('Displaying track on the map...');
				}
				
				this.initMap();
			});
	}

	initMap() {
		this.map = new google.maps.Map(document.getElementById("identifications-google-map-container") as HTMLElement, {
			center: { lat: -23.988, lng: 31.554 },
			fullscreenControl: false,
			mapTypeId: 'roadmap',
			maxZoom: 15,
			minZoom: 5,
			streetViewControl: false,
			zoom: 7
		});
		
		//Place track markers on map
		
		if (this.initWithOpenTrack) {
			//If query param exists, open track that corresponds to that id first
			let trackMarker = this.trackIdentifications.filter(x => x.spoorIdentificationID == this.initWithOpenTrackId);
			this.addTrackMarker(trackMarker[0]);
			let requestedTrack = this.getTrack(this.initWithOpenTrackId);
			google.maps.event.trigger(requestedTrack.marker, 'click');	
			this.snackBar.open('Track displayed!', "Dismiss", { duration: 3000, });
		}
		for (let i = 0; i < this.trackIdentifications.length; i++) {
			if ((!this.initWithOpenTrack) || (this.initWithOpenTrack && this.trackIdentifications[i].spoorIdentificationID !== this.initWithOpenTrackId))
				setTimeout(() => this.addTrackMarker(this.trackIdentifications[i]), i * 200);
		}
		this.stopLoader();
	}
	addTrackMarker(track: any) {
		//Create the track marker icon
		var markerIcon = {
			anchor: new google.maps.Point(54,190),
			fillColor: track.animal.animalMarkerColor,
			fillOpacity: 1,
			path: "M108.4,55c0.3,8.4-2.6,17.1-6.8,25.3c-3.8,7.4-8.1,14.5-12.4,21.6c-15.6,25.7-26.3,53.3-31.1,83.1c-0.3,1.9-2.7,3.4-4.1,5.1c-1.3-1.6-3.5-3.1-3.8-4.9c-5.1-31.8-16.5-61.2-33.8-88.4c-4.3-6.7-8.2-13.7-11.5-21C-4.4,55-0.3,32.6,15.5,16.4	C30.8,0.7,54.1-4.3,74.4,3.8C94.8,11.9,108.2,31.7,108.4,55z M54.4,74.3c9.7,0,17.6-7.7,17.6-17.3c0-10-7.8-17.9-17.6-17.9c-10,0-17.8,7.7-17.9,17.7C36.3,66.4,44.3,74.2,54.4,74.3z",				scale: 0.3,				
			strokeWeight: 0
		}
		let animalTrack = new google.maps.Marker({				
			animation: null,
			icon: markerIcon,
			map: this.map,
			position: new google.maps.LatLng(track.location.latitude, track.location.longitude),	
		});		
		this.mapMarkers.push({'marker': animalTrack, 'track': track});
		//Set event listener to make the track markers interactable
		google.maps.event.addListener(animalTrack, 'click', () => {
			this.trackSidenav.viewTrack(track);
		});
		google.maps.event.addListener(animalTrack, 'mouseout', () => {
			this.infoWindow.close();
		});
		google.maps.event.addListener(animalTrack, 'mouseover', () => {
			this.infoWindow = new google.maps.InfoWindow();
			this.infoWindow.setContent(
				'<div id="track-info-window">' +
					'<div class="track-info-image-container"><div class="track-identification-info-container">' +
							'<div class="track-identification-animal-name">' +
									'<span><p class="track-identification-animal-commonName fontSB">' + track.animal.commonName + ' Track</span>' +
							'</div>' +
							'<p class="track-identification-capture-ranger fontM">Captured by: ' + track.ranger.firstName + ' ' + track.ranger.lastName + '</p>' +
							'<span><p class="fontSB">ACCURACY SCORE:&nbsp;' + (track.potentialMatches[track.potentialMatches.length - 1].confidence *100) + '%</p></span>'	+
				'</div></div></div>');
			this.infoWindow.open(this.map, animalTrack);
		});
	}
	zoomOnTrack(coords: string)
	{
		//Reset activeTrack if set
		if (this.activeTrack != null) {
			//Remove highlight if a track marker is already being viewed
			this.activeTrack.marker.setAnimation(null);
			if (this.trackHltCircle != null) {
				this.trackHltCircle.setMap(null);
				this.trackHltCircle = null;
			}	
		}
		var latlngStr = coords.split(',', 3);
		this.activeTrack = this.getTrack(latlngStr[0]);

		if (latlngStr[1] == "resetZoom")
		{
			this.map.setZoom(7);
			this.activeTrack = null;
		}
		else
		{
			//Zoom in on marker location
			var latlng = {lat: parseFloat(latlngStr[1]), lng: parseFloat(latlngStr[2])};
			this.map.setCenter(latlng);
			this.map.setZoom(18);
			
			//Highlight marker with BOUNCE animation
			this.activeTrack.marker.setAnimation(google.maps.Animation.BOUNCE);

			//Highlight marker location with circle
			this.trackHltCircle = new google.maps.Circle({
				strokeColor: "#FF0000",
				strokeOpacity: 0.8,
				strokeWeight: 2,
				fillColor: "#FF0000",
				fillOpacity: 0.35,
				map: this.map,
				center: latlng,
				radius: 200
			});
			//Set track location address
			this.setTrackAddress(this.activeTrack.track);
		}
	}
	getTrack(id: any) {
		let trackMarker = this.mapMarkers.filter(x => x.track.spoorIdentificationID == id);
		return trackMarker[0];
	}
	
	//Track Identification manipulation
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
	setTrackAddress(track: any)
	{
		//Determine physical location name of each track through Reverse Geocoding
		this.geoCoder = new google.maps.Geocoder;
		var latlng = {lat: track.location.latitude, lng: track.location.longitude};
		this.geoCoder.geocode({'location': latlng}, function(results, status) {
			if (status === 'OK') {
				if (results[0]) {
					track.location.addresses = results;
				} 
				else {
					//Address could not be obtained
					track.location.addresses = null;
				}
			} 
			else {
				//console.log('Geocoder failed due to: ' + status);
				track.location.addresses = null;
			}
		});
	}

	updateSearchText(event) {
		this.searchText = event;
	}
	
	iterateDisplayedTracks($event) {
		this.displayedTracks = this.trackIdentifications.slice($event.event.pageIndex*$event.event.pageSize, $event.event.pageIndex*$event.event.pageSize + $event.event.pageSize);
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
	
	toggleFullScreen()
	{
		var tracksView = document.getElementById('identifications-view-workspace-container');
		tracksView.classList.toggle('fullScreen');
		
		if (tracksView.classList.contains('fullScreen')) {
			document.addEventListener('keydown', function(event){
				if(event.key === "Escape") {
					tracksView.classList.remove('fullScreen');
				}
			});
		}
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
	//Loader
	startSidenavLoader() {
		console.log("PARENT SIDENAV START LOADER");
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopSidenavLoader() {
		console.log("PARENT SIDENAV STOP LOADER");
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}