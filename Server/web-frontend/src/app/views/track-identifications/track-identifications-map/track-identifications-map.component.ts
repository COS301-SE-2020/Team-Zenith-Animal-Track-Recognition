import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-track-identifications-map',
  templateUrl: './track-identifications-map.component.html',
  styleUrls: ['./track-identifications-map.component.css']
})

export class TrackIdentificationsMapComponent implements OnInit {

	@Input() searchText: string;
	@Input() rangersList;
	@Input() tracksList;
	@Input() tracksExist: boolean;
	@Output() tracksOnChange: EventEmitter<Object> = new EventEmitter();
	numRangers: any;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	sorted: string;
	map: google.maps.Map = null; 
	
	
	//PLACEHOLDER VALUES
	coordIndex = 0;

	constructor(private http: HttpClient, private changeDetection: ChangeDetectorRef) { }

	ngOnInit(): void {
				//console.log("Track Map: " + this.tracksList);

		//setTimeout(this.placeMarkers, 5000);
		this.initMap();
	}

	initMap() {
				console.log("Map init");
		if (this.map == null)
		{
			this.map = new google.maps.Map(document.getElementById("identifications-google-map-container") as HTMLElement, {
				center: { lat: -23.988, lng: 31.554 },
				mapTypeId: 'roadmap',
				maxZoom: 15,
				minZoom: 7,
				zoom: 9
			});
			if (this.map)
			{
				console.log("setting timeout");
				//setTimeout(this.placeMarkers, 3000);
				this.placeMarkers();
			}
		}	
	}
	
	check(exist: any)
	{
		if (exist == true)
			return true;
	}

	placeMarkers()
	{
		console.log("PLACING MARK");
		var	coordinates = [
		{
			position: {
				lat: -25.389,
				lng: 31.974
			}
		},
		{
			position: {
				lat: -24.994727,
				lng: 31.596844
			}
		},
		{	
			position: {
				lat: -22.440,
				lng: 31.083
			}
		},
		{	
			position: {
				lat: -25.389095,
				lng: 31.974704
			}
		},
		{
			position: {
				lat: -24.600824,
				lng: 31.629764
			}
		},
		{	position: {
				lat: -25.389095,
				lng: 31.974704
			}
		},
		{
			position: {
				lat: -24.923853,
				lng: 31.659375
			}
		},
		{
			position: {
				lat: 25.364658,
				lng: 31.683832
			}
		},
		{
			position: {
				lat: -24.992296,
				lng: 31.598448
			}
		},
		{
			position: {
				lat: -24.992296,
				lng: 31.598448
			}
		},
		{
			position: {
				lat: -24.45083,
				lng: 31.9775
			}
		},
		{
			position: {
				lat: -24.450961,
				lng: 31.977753
			}
		},
		{
			position: {
				lat: -25.353957,
				lng: 31.990556
			}
		},
		{
			position: {
				lat: -25.307752,
				lng: 31.971838
			}
		},
		{
			position: {
				lat: -24.873248,
				lng: 31.656253
			}
		},
		{
			position: {
				lat: 25.13490,
				lng: 31.34007
			}
		}
	];
		for (let i = 0; i < coordinates.length; i++) {
			var track = this.tracksList[i];
			var markerIcon = {
				path: "M172.3,501.7C27,291,0,269.4,0,192C0,86,86,0,192,0s192,86,192,192c0,77.4-27,99-172.3,309.7 C202.2,515.4,181.8,515.4,172.3,501.7L172.3,501.7z M192,272c44.2,0,80-35.8,80-80s-35.8-80-80-80s-80,35.8-80,80S147.8,272,192,272",
				//fillColor: '#06BAFB',
				fillColor: track.animal.animalMarkerColor,
				fillOpacity: 1,
				strokeWeight: 0,
				scale: 0.07
			}
					console.log("Placing marker for " + track.animal.commonName);

			//markerIcon.fillColor = 	this.tracksList[i].animal.animalMarkerColor;
			let trackLocation = new google.maps.Marker({
				map: this.map,
				position: new google.maps.LatLng(coordinates[i].position.lat, coordinates[i].position.lng),
				animation: google.maps.Animation.DROP,
				icon: markerIcon,
			});
		}
	}
	
	getAnimalMarkerColor(index: number)
	{
		console.log("Sending Marker color");
		return this.tracksList[index].animal.animalMarkerColor;
	}

	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}
}
