import { Component, OnInit, ViewChild, Input, Output, EventEmitter, Inject } from '@angular/core';
import { EMPTY } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { MapInfoWindow, MapMarker, GoogleMap } from '@angular/google-maps';
import MarkerClusterer from "@googlemaps/markerclustererplus";
import { Router, ActivatedRoute } from '@angular/router';
import { Track } from 'src/app/models/track';
import { TrackIdentificationsSidenavComponent } from './track-identifications-sidenav/track-identifications-sidenav.component';
import { TracksService } from './../../services/tracks.service';
import { TrackViewNavigationService } from './../../services/track-view-navigation.service';

@Component({
	selector: 'app-track-identifications',
	templateUrl: './track-identifications.component.html',
	styleUrls: ['./track-identifications.component.css'],
	providers: [TracksService, TrackViewNavigationService]
})

export class TrackIdentificationsComponent implements OnInit {

	//y=-0.001929x^{2}+10.00
	@ViewChild('trackIdentificationsSidenav') trackSidenav: TrackIdentificationsSidenavComponent;
	@ViewChild('sidenav') sidenav;
	activeTrack: any = null;
	activeTrackInfo: any = null;
	currentAlphabet;
	displayedTracks: any;
	defaultLocation: string = 'Address not found';
	geoCoder: google.maps.Geocoder;
	heatmap: any = null;
	initWithOpenTrack: boolean = false;
	initWithOpenTrackId: any;
	infoWindow: google.maps.InfoWindow;
	map: google.maps.Map;
	mapMarkers = {
		markers: [] = [],
		heatmap: [] = [],
		tracks: [] = []
	};
	markerClusterer: any;
	markerClustererOptions = { imagePath: 'https://cdn.rawgit.com/googlemaps/js-marker-clusterer/gh-pages/images/m' };		
	pageSize: number = 25;
	trackHltCircle: any;
	trackIdentifications: Track[] = null;
	showHeatmap: boolean = false;
	showHeatmapSettings: boolean = false;
	
	//Default Map Settings
	//Default locations where the map is centered
	kruger = { lat: -23.988, lng: 31.554 };
	rietvlei = { lat: -25.8739714, lng: 28.2661832};
	defaultMapCenter = this.kruger;
	
	constructor(private activatedRoute: ActivatedRoute, private router: Router, 
		private tracksService: TracksService, private trackViewNavService: TrackViewNavigationService) { 
		
		//Determines which track is being viewed in the Track Identifications Info tab
		tracksService.activeTrack$.subscribe(
			track => {
				this.activeTrack = track;
			}
		);
		//Get the latest collection of track identifications
		tracksService.identifications.subscribe(
			trackList => {
				//Add track markers to the map if tracks are present
				if (trackList != null && trackList.length > 0) {
					//Add track markers to the map if initial list of tracks
					if (this.trackIdentifications == null) {
						this.trackIdentifications = trackList;	
						this.addTrackMarkers();
					}
					else {
						//Updating identifications with filtered tracks
						this.trackIdentifications = trackList;
					}
				}
				else if (trackList != null && trackList.length == 0) {
					if (this.trackIdentifications != null) {
						//If the track list returned is not the initial value but is empty nonetheless (if filtered for example)
						this.trackIdentifications = trackList;
					}
				}
			}
		);
		//Determines which filter option is applied to the tracks and markers
		tracksService.trackFilter$.subscribe(
			filter => {
				this.filterTrackMarkers(filter);
			}
		);		
		//Determines which track is being zoomed on
		trackViewNavService.trackMapZoom$.subscribe(
			coords => {
				this.zoomOnTrack(coords);
			}
		);
		//Determines whether the heatmap is currently viewable
		trackViewNavService.trackHeatmap$.subscribe(
			state => {
				this.toggleHeatmap(state);
			}
		);
		//Determine whether the heatmap settings tab is open, closed or simply inactive
		trackViewNavService.trackHeatmapSettings$.subscribe(
			state => {
				switch(state) {
					case "on":
						this.showHeatmapSettings = true;
					break;
					case "off":
						this.showHeatmapSettings = false;
					break;
					case "inactive":
						this.toggleHeatmapTab();
					break;
				};
			}
		);
	}

	ngOnInit(): void {
		document.getElementById("geotags-route").classList.add("activeRoute");
		this.startLoader();
		this.startSidenavLoader();
		const spoorIdQuery = new URLSearchParams(window.location.search);
		const requestedSpoorId = spoorIdQuery.get("openTrackId");
		if (requestedSpoorId != null) {
			this.initWithOpenTrack = true;
			this.initWithOpenTrackId = requestedSpoorId;
			//this.snackBar.open('Displaying track on the map...');
		}
		this.initMap();
		this.getTrackIdentifications();
		//Check if a track was selected from the query parameters
		/*
				this.filteredListArray = temp[0];

				//Only display a certain number of tracks per sidenav page
				this.displayedTracks = temp[0].slice(0, this.pageSize);

			});
		*/
	}
	
	getTrackIdentifications() {
		this.tracksService.getTrackIdentifications(JSON.parse(localStorage.getItem('currentToken'))['value']);
	}

	initMap() {
		this.map = new google.maps.Map(document.getElementById("identifications-google-map-container") as HTMLElement, {
			center: this.defaultMapCenter,
			fullscreenControl: false,
			mapTypeId: 'roadmap',
			maxZoom: 15,
			minZoom: 5,
			streetViewControl: false,
			zoom: 7
		});
	}
	
	//Track Identification Marker functions
	addTrackMarkers() {
		//Place track markers on map
		
		if (this.mapMarkers.markers.length > 0) {
			//Clear all track markers first
			this.clearAllMarkers();
		}

		this.mapMarkers.markers.length = 0;
		this.mapMarkers.tracks.length = 0;
		this.mapMarkers.heatmap.length = 0;
		
		
		if (this.initWithOpenTrack) {
			//If query param exists, open track that corresponds to that id first
			let trackMarker = this.trackIdentifications.filter(x => x.spoorIdentificationID == this.initWithOpenTrackId);
			this.addTrackMarker(trackMarker[0]);
			let requestedTrack = this.getTrackMarker(this.initWithOpenTrackId);
			google.maps.event.trigger(requestedTrack, 'click');
			this.initWithOpenTrack =  false;
			//this.snackBar.open('Track displayed!', "Dismiss", { duration: 3000, });
		}
		
		for (let i = 0; i < this.trackIdentifications.length; i++) {
			this.addTrackMarker(this.trackIdentifications[i]);
		}
		
		/*
				if (((!this.initWithOpenTrack) ||
					(this.initWithOpenTrack && this.trackIdentifications[i].spoorIdentificationID !== this.initWithOpenTrackId))) {
					//setTimeout(() => this.addTrackMarker(this.trackIdentifications[i]), i * 15);
					this.addTrackMarker(this.trackIdentifications[i]);
					this.filteredListArray.push(this.trackIdentifications[i]);
				}
				
		*/

		//this.displayedTracks = [];
		//this.displayedTracks = this.filteredListArray.slice(0, this.filteredListArray.length > 25 ? 25 : this.filteredListArray.length);

		// Add a marker clusterer to manage the markers.
		this.markerClusterer = new MarkerClusterer(this.map, this.mapMarkers.markers, this.markerClustererOptions);
		this.stopLoader();
	}
	addTrackMarker(track: Track) {
		//Create the track marker icon
		var markerIcon = {
			anchor: new google.maps.Point(54, 190),
			fillColor: track.animal.animalMarkerColor,
			fillOpacity: 1,
			path: "M108.4,55c0.3,8.4-2.6,17.1-6.8,25.3c-3.8,7.4-8.1,14.5-12.4,21.6c-15.6,25.7-26.3,53.3-31.1,83.1c-0.3,1.9-2.7,3.4-4.1,5.1c-1.3-1.6-3.5-3.1-3.8-4.9c-5.1-31.8-16.5-61.2-33.8-88.4c-4.3-6.7-8.2-13.7-11.5-21C-4.4,55-0.3,32.6,15.5,16.4	C30.8,0.7,54.1-4.3,74.4,3.8C94.8,11.9,108.2,31.7,108.4,55z M54.4,74.3c9.7,0,17.6-7.7,17.6-17.3c0-10-7.8-17.9-17.6-17.9c-10,0-17.8,7.7-17.9,17.7C36.3,66.4,44.3,74.2,54.4,74.3z", scale: 0.3,
			strokeWeight: 0
		}
		let animalTrack = new google.maps.Marker({
			animation: null,
			icon: markerIcon,
			map: this.map,
			position: new google.maps.LatLng(track.location.latitude, track.location.longitude),
		});
		//Set event listener to make the track markers interactable
		google.maps.event.addListener(animalTrack, 'click', () => {
			this.tracksService.changeActiveTrack(track);
			this.trackViewNavService.changeTab("Track");
			this.trackViewNavService.zoomOnTrack(track.spoorIdentificationID + ',' + track.location.latitude + ',' + track.location.longitude);
			}
		);
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
				'<span><p class="fontSB">ACCURACY SCORE:&nbsp;' + Math.round((track.potentialMatches[track.potentialMatches.length - 1].confidence * 100)) + '%</p></span>' +
				'</div></div></div>');
			this.infoWindow.open(this.map, animalTrack);
		});
		
		//Store track marker with it's associated track and heatmap location data
		this.mapMarkers.markers.push(animalTrack);
		this.mapMarkers.tracks.push(track);
		this.mapMarkers.heatmap.push(new google.maps.LatLng(track.location.latitude, track.location.longitude));
	}
	filterTrackMarkers(filterChoice: string) {
		if (filterChoice == "All") {
			//Show all map markers
			this.setMapOnAll(this.map);
			this.markerClusterer.setMap(null);
			this.markerClusterer = new MarkerClusterer(this.map, this.mapMarkers.markers, this.markerClustererOptions);
			return;
		}
		//Hide all tracks
		var filteredMarkers = [];
		this.markerClusterer.setMap(null);
		this.setMapOnAll(null);
		for (let i = 0; i < this.mapMarkers.markers.length; i++) {
			for (let j = 0; j < this.trackIdentifications.length; j++) {
				if (this.mapMarkers.tracks[i].spoorIdentificationID == this.trackIdentifications[j].spoorIdentificationID) {
					this.mapMarkers.markers[i].setMap(this.map);
					filteredMarkers.push(this.mapMarkers.markers[i]);
				}
			}
		}
		this.markerClusterer = new MarkerClusterer(this.map, filteredMarkers, this.markerClustererOptions);
	}
	setMapOnAll(map: google.maps.Map | null) {
		for (let i = 0; i < this.mapMarkers.markers.length; i++) {
			this.mapMarkers.markers[i].setMap(map);
		}
	}
	clearAllMarkers() {
		//Remove track markers from map
		if (this.markerClusterer)
			this.markerClusterer.setMap(null);
		this.setMapOnAll(null);
		this.mapMarkers.markers.length = 0;
	}

	//Heatmap related functions
	toggleHeatmap(state: string) {
		switch(state) {
			case "on":
				this.heatmap = new google.maps.visualization.HeatmapLayer({
					data: this.mapMarkers.heatmap
				});
				this.heatmap.setMap(this.map);
			break;
			case "off":
				if (this.heatmap)
					this.heatmap.setMap(null);
			break;
		}
	}
	toggleHeatmapTab() {
		//Toggle the heatmap settings tab
		var heatmapSettingsBtn = document.getElementById("heatmap-btn-container");
		if (!heatmapSettingsBtn.classList.contains("activeHeatmapTab")) {
			heatmapSettingsBtn.classList.add("activeHeatmapTab");
			this.trackViewNavService.changeTab("Heatmap");
		}
		else if (heatmapSettingsBtn.classList.contains("activeHeatmapTab")) {
			heatmapSettingsBtn.classList.remove("activeHeatmapTab");
			if (this.activeTrack != null)
				this.trackViewNavService.changeTab("Track");
			else
				this.trackViewNavService.changeTab("Tracklist");
		}
	}
	
	
	//View Navigation functions
	zoomOnTrack(coords: string) {
		var latlngStr = coords.split(',', 3);
				
		if (this.activeTrackInfo)
			this.activeTrackInfo.setAnimation(null);

		this.activeTrackInfo = this.getTrackMarker(latlngStr[0]);

		if (latlngStr[1] == "resetZoom") {
			this.map.setZoom(7);
			this.activeTrackInfo.setAnimation(null);
			this.activeTrackInfo = null;
			this.trackHltCircle.setMap(null);
			this.trackHltCircle = null;
		}
		else {
			//Zoom in on marker location
			var latlng = { lat: parseFloat(latlngStr[1]), lng: parseFloat(latlngStr[2]) };
			this.map.setCenter(latlng);
			this.map.setZoom(18);

			//Highlight marker with BOUNCE animation
			this.activeTrackInfo.setAnimation(null);
			this.activeTrackInfo.setAnimation(google.maps.Animation.BOUNCE);

			//Highlight marker location with circle
			if (this.trackHltCircle != null) {
				this.trackHltCircle.setMap(null);
				this.trackHltCircle = null;
			}
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
			this.setTrackAddress(this.mapMarkers.tracks[this.mapMarkers.markers.indexOf(this.activeTrackInfo)]);
		}
	}
	
	//Other

	getTrackMarker(id: any) {
		//Find the associated track and determine it's index
		let associatedTrack = this.mapMarkers.tracks.filter(x => x.spoorIdentificationID == id);
		let associatedTrackIndex = this.mapMarkers.tracks.indexOf(associatedTrack[0]);
		
		//Find associated track marker from index
		let trackMarker = this.mapMarkers.markers[associatedTrackIndex];
		return trackMarker;
	}

	setTrackAddress(track: any) {
		//Determine physical location name of each track through Reverse Geocoding
		this.geoCoder = new google.maps.Geocoder;
		var latlng = { lat: track.location.latitude, lng: track.location.longitude };
		this.geoCoder.geocode({ 'location': latlng }, function (results, status) {
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

	iterateDisplayedTracks($event) {
		//this.displayedTracks = this.filteredListArray.slice($event.event.pageIndex * $event.event.pageSize, $event.event.pageIndex * $event.event.pageSize + $event.event.pageSize);
		//console.log(this.displayedTracks);
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

	toggleFullScreen() {
		var tracksView = document.getElementById('identifications-view-workspace-container');
		tracksView.classList.toggle('fullScreen');

		if (tracksView.classList.contains('fullScreen')) {
			document.addEventListener('keydown', function (event) {
				if (event.key === "Escape") {
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
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}