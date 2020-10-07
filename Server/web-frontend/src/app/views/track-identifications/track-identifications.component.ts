import { Component, OnInit, ViewChild, Input, Output, EventEmitter, Inject } from '@angular/core';
import { EMPTY } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { MapInfoWindow, MapMarker, GoogleMap } from '@angular/google-maps';
import MarkerClusterer from "@googlemaps/markerclustererplus";
import { Router, ActivatedRoute } from '@angular/router';
import { Track } from 'src/app/models/track';
import { TrackIdentificationsSidenavComponent } from './track-identifications-sidenav/track-identifications-sidenav.component';
import { TrackIdentificationsToolbarComponent } from './track-identifications-toolbar/track-identifications-toolbar.component';
import { TracksService } from './../../services/tracks.service';
import { TrackViewNavigationService } from './../../services/track-view-navigation.service';

@Component({
	selector: 'app-track-identifications',
	templateUrl: './track-identifications.component.html',
	styleUrls: ['./track-identifications.component.css'],
	providers: [TracksService, TrackViewNavigationService]
})

export class TrackIdentificationsComponent implements OnInit {
	
	//Map & Map Marker Variables
	kruger = { lat: -23.988, lng: 31.554 };
	rietvlei = { lat: -25.8739714, lng: 28.2661832};
	defaultMapCenter = this.kruger; 	//Default locations where the map is centered
	geoCoder: google.maps.Geocoder;
	infoWindow: google.maps.InfoWindow;
	map: google.maps.Map;
	mapMarkers = {
		markers: [] = [],
		tracks: [] = []
	};
	markerClusterer: any;
	markerClustererOptions = { imagePath: 'https://cdn.rawgit.com/googlemaps/js-marker-clusterer/gh-pages/images/m' };	
	trackHltCircle: any;
	trackIdentifications: Track[] = null;
	
	//Heatmap Variables
	heatmap: any = null;
	heatmapColourRedGreen = ["rgba(31, 255, 0, 0)",
    "rgba(143, 250, 0, 1)",
    "rgba(255, 244, 0, 1)",
    "rgba(255, 112, 0, 1)",
    "rgba(255, 0, 0, 1)"];
	heatmapColourRedBlue = ["rgba(0, 232, 255, 0)",
    "rgba(0, 110, 255, 1)",
    "rgba(46, 0, 255, 1)",
    "rgba(255, 0, 0, 1)"];
	heatmapColourGreenBlue = ["rgba(4, 0, 250, 0)",
    "rgba(0, 146, 255, 1)",
    "rgba(22, 255, 0, 1)",
    "rgba(255, 252, 0, 1)"];
	heatmapColour = this.heatmapColourRedGreen;
	heatmapRadius = 200;
	heatmapTimeRange = "1 Week";
	showHeatmap: boolean = false;
	showHeatmapSettingsBtn: boolean = false;

	//Query Parameters
	initWithOpenTrack: boolean = false;
	initWithOpenTrackId: any;
	initWithTrackFilter: boolean = false;
	initWithFilterValue: any;

	//Track Variables	
	activeTrack: any = null;
	activeTrackInfo: any = null;
	defaultTrackLocation: string = 'Address not found';
	
	//View Navigation
	pageSize: number = 25;
	@ViewChild('sidenav') sidenav;	
	@ViewChild('trackIdentificationsSidenav') trackSidenav: TrackIdentificationsSidenavComponent;
	@ViewChild('trackIdentificationsToolbar') trackToolbar: TrackIdentificationsToolbarComponent;
	
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
				this.filterTrackMarkers(filter[0], filter[1]);
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
		//Determines whether the heatmap is currently viewable
		trackViewNavService.trackHeatmapTimeRange$.subscribe(
			timeRange => {
				this.changeHeatmapTimeRange(timeRange);
			}
		);
		//Determine whether the heatmap settings tab is open, closed or simply inactive
		trackViewNavService.trackHeatmapSettings$.subscribe(
			state => {
				switch(state) {
					case "on":
						this.showHeatmapSettingsBtn = true;
					break;
					case "off":
						this.showHeatmapSettingsBtn = false;
					break;
					case "inactive":
						this.toggleHeatmapTab();
					break;
				};
			}
		);
		//Determines which colour the heatmap is set to
		trackViewNavService.trackHeatmapColour$.subscribe(
			colour => {
				this.changeHeatmapColour(colour);
			}
		);
		//Determines the radius of the heatmap around each track
		trackViewNavService.trackHeatmapRadius$.subscribe(
			radius => {
				this.changeHeatmapRadius(radius);
			}
		);
	}

	ngOnInit(): void {
		document.getElementById("geotags-route").classList.add("activeRoute");
		this.startLoader();
		this.startSidenavLoader();
		
		//Check if a track was selected from the query parameters
		const spoorIdQuery = new URLSearchParams(window.location.search);
		const requestedSpoorId = spoorIdQuery.get("openTrackId");
		if (requestedSpoorId != null) {
			this.initWithOpenTrack = true;
			this.initWithOpenTrackId = requestedSpoorId;
			//this.snackBar.open('Displaying track on the map...');
		}
		
		this.initMap();
		
		//Check if a filter parameter was set from another view
		const requestedTrackFilterType = spoorIdQuery.get("filterType");
		if (requestedTrackFilterType != null) {
			const requestedTrackFilter = spoorIdQuery.get("filter");
			this.getTrackIdentifications({initWithFilter: true, filterType: requestedTrackFilterType, filter: requestedTrackFilter});
		}
		else
			this.getTrackIdentifications({initWithFilter: false});
	}
	
	getTrackIdentifications(initWithFilter: any) {
		this.tracksService.getTrackIdentifications(JSON.parse(localStorage.getItem('currentToken'))['value'], initWithFilter);
	}

	initMap() {
		this.map = new google.maps.Map(document.getElementById("identifications-google-map-container") as HTMLElement, {
			center: this.defaultMapCenter,
			fullscreenControl: false,
			mapTypeId: 'roadmap',
			maxZoom: 15,
			minZoom: 5,
			scaleControl: true,
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
		
		if (this.initWithOpenTrack) {
			//If query param exists, open track that corresponds to that id first
			let trackMarker = this.trackIdentifications.filter(x => x.spoorIdentificationID == this.initWithOpenTrackId);
			this.addTrackMarker(trackMarker[0]);
			let requestedTrack = this.getTrackMarker(this.initWithOpenTrackId);
			google.maps.event.trigger(requestedTrack, 'click');
			//this.snackBar.open('Track displayed!', "Dismiss", { duration: 3000, });
		}
		
		for (let i = 0; i < this.trackIdentifications.length; i++) {
			if (!this.initWithOpenTrack) {
				this.addTrackMarker(this.trackIdentifications[i]);
			}
			else if (this.initWithOpenTrack) {
				if (this.trackIdentifications[i].spoorIdentificationID != this.initWithOpenTrackId)
					this.addTrackMarker(this.trackIdentifications[i]);
			}
		}
		

		// Add a marker clusterer to manage the markers.
		this.markerClusterer = new MarkerClusterer(this.map, this.mapMarkers.markers, this.markerClustererOptions);
		
		this.stopLoader();
		this.initWithOpenTrack =  false;
		this.initWithTrackFilter =  false;
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
					'<div class="track-info-image-container">' +
						'<div class="track-identification-info-container">' +
							'<div class="track-identification-animal-name">' +
								'<span>' + 
									'<p class="track-identification-animal-commonName fontSB">' + track.animal.commonName + ' Track</p>' + 
								'</span>' +
							'</div>' + 
							'<p class="track-identification-capture-ranger fontM">' + track.dateObj.toDateString() + '</p>' +
							'<p class="track-identification-capture-ranger fontM">Captured by: ' + track.ranger.firstName + ' ' + track.ranger.lastName + '</p>' +
							'<span>' +
								'<p class="fontSB">ACCURACY SCORE:&nbsp;' + Math.round((track.potentialMatches[track.potentialMatches.length - 1].confidence * 100)) + '%</p>' + 
							'</span>' +
						'</div>' +
					'</div>' +
				'</div>');
			this.infoWindow.open(this.map, animalTrack);
		});
		
		//Store track marker with it's associated track and heatmap location data
		this.mapMarkers.markers.push(animalTrack);
		this.mapMarkers.tracks.push(track);
	}
	filterTrackMarkers(filterCategory: string, filterChoice: string) {
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
		if (filterCategory == "Animal") {
			this.trackToolbar.showHeatmap = false;
			this.toggleHeatmap("off");
		}
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
	changeHeatmapColour(colour: string) {
		if (this.heatmap) {
			switch(colour) {
				case "redGreen":
					this.heatmapColour = this.heatmapColourRedGreen;
					this.heatmap.set("gradient", this.heatmapColourRedGreen);
				break;
				case "redBlue":
					this.heatmapColour = this.heatmapColourRedBlue;
					this.heatmap.set("gradient", this.heatmapColourRedBlue);
				break;
				case "greenBlue":
					this.heatmapColour = this.heatmapColourGreenBlue;
					this.heatmap.set("gradient", this.heatmapColourGreenBlue);
				break;
			}
		}
	}
	changeHeatmapRadius(radius: number) {
		if (this.heatmap) {
			this.heatmapRadius = radius;
			this.heatmap.set("radius", radius);
		}
	}
	changeHeatmapTimeRange(timeRange: string) {
		this.heatmapTimeRange = timeRange;
		this.toggleHeatmap("on");
	}
	calculateTrackWeighting(timeDifference: number, timeRange: string) {
		var timeRangeFactor;
		switch(timeRange) {
			case "1 Week":
				timeRangeFactor = -0.0003542999;
			break;
			case "1 Month":
				timeRangeFactor = -0.0000187599;
			break;
			case "6 Months":
				timeRangeFactor = -0.0000005199;
			break;
			case "1 Year":
				timeRangeFactor = -0.0000001303;
			break;
		}
		var trackWeight = (timeRangeFactor * Math.pow(timeDifference, 2)) + 10.0;
		return Math.abs(Math.round(trackWeight * 100) / 100).toFixed(2);
	}
	generateHeatmap() {
		var heatmapData = [];
		const todaysDate = new Date();
		var cutOffDate = new Date();
		let timeRangeNum;
		//Filter out tracks that do not fall within the time range
		switch(this.heatmapTimeRange) {
			case "1 Week":
				cutOffDate.setDate(cutOffDate.getDate() - 7);
			break;
			case "1 Month":
				cutOffDate.setMonth(cutOffDate.getMonth() - 1);
			break;
			case "6 Months":
				cutOffDate.setMonth(cutOffDate.getMonth() - 6);
			break;
			case "1 Year":
				cutOffDate.setFullYear(cutOffDate.getFullYear() - 1);
			break;
		}
		var todaysDateMilli = todaysDate.getTime();
		
		this.trackIdentifications.forEach(track => {
			if (track.dateObj.getTime() > cutOffDate.getTime()) {
				var timeDiff = Math.abs(todaysDateMilli - track.dateObj.getTime()) / 3600000;
				var trackWeight = this.calculateTrackWeighting(timeDiff, this.heatmapTimeRange);
				heatmapData.push({location: new google.maps.LatLng(track.location.latitude, track.location.longitude), weight: trackWeight});		
			}
		});
		return heatmapData;
	}
	toggleHeatmap(state: string) {
		switch(state) {
			case "on":
				if (this.heatmap)
					this.heatmap.setMap(null);
				var heatmapData = this.generateHeatmap();
				this.heatmap = new google.maps.visualization.HeatmapLayer({
					data: heatmapData,
					dissipating: true,
					gradient: this.heatmapColour,
					radius: this.heatmapRadius
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