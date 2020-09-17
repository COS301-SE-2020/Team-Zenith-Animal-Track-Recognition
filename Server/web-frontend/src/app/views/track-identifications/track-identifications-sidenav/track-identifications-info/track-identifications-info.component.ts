import { AnimalPhotoDetailsComponent } from './../../../animals/animals-gallery/animal-photos/animal-photo-details/animal-photo-details.component';
import { Component, OnInit, Input, Output, ViewChild, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { GoogleMap } from '@angular/google-maps';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Router } from '@angular/router';

@Component({
	selector: 'app-track-identifications-info',
	templateUrl: './track-identifications-info.component.html',
	styleUrls: ['./track-identifications-info.component.css']
})
export class TrackIdentificationsInfoComponent implements OnInit {

	@Input() activeTrack: any;
	@Input() originType: string;
	@Output() viewingTrackOnChange: EventEmitter<Object> = new EventEmitter();
	@ViewChild('otherMatchesMatTab') otherMatchesMatTab;
	@ViewChild('simTracksMatTab') simTracksMatTab;
	geoCoder: google.maps.Geocoder;
	similarTrackList: any = null;

	constructor(private changeDetection: ChangeDetectorRef, private http: HttpClient, public dialog: MatDialog, private router: Router) { }

	public ngOnChanges(changes: SimpleChanges) {
		if (changes) {
			this.changeDetection.detectChanges();
			this.updateSimilarTracks();
			this.setTrackAddress();
		}
	}

	ngOnInit(): void {
	}

	backToTrackList() {
		this.viewingTrackOnChange.emit("back");
	}
	nextPotentialMatch() {
		if (this.otherMatchesMatTab.selectedIndex != 2)
			this.otherMatchesMatTab.selectedIndex += 1;
	}
	prevPotentialMatch() {
		if (this.otherMatchesMatTab.selectedIndex != 0)
			this.otherMatchesMatTab.selectedIndex -= 1;
	}
	nextSimilarTrack() {
		this.simTracksMatTab.selectedIndex += 1;
	}
	prevSimilarTrack() {
		this.simTracksMatTab.selectedIndex -= 1;
	}


	//Track Identification manipulation
	timeToString() {
		let temp = this.activeTrack.dateAndTime;
		this.activeTrack.dateObj = new Date(temp.year, (temp.month - 1), temp.day, temp.hour, temp.min, temp.second);
	}
	setTrackAddress() {
		//Determine physical location name of each track through Reverse Geocoding
		this.geoCoder = new google.maps.Geocoder;
		var latlng = { lat: this.activeTrack.location.latitude, lng: this.activeTrack.location.longitude };
		var temp = this.activeTrack;
		this.geoCoder.geocode({ 'location': latlng }, function (results, status) {
			if (status === 'OK') {
				if (results[0]) {
					temp.location.addresses = results;
				}
				else {
					//Address could not be obtained
					temp.location.addresses = null;
				}
			}
			else {
				//console.log('Geocoder failed due to: ' + status);
				temp.location.addresses = null;
			}
		});
		this.timeToString();
	}

	updateSimilarTracks() {
		//Load similar tracks for the same animal being viewed
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.activeTrack.animal.classification + '"){spoorIdentificationID,animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}}dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				var trackList = temp[0];
				for (let i = 0; i < trackList.length; i++) {
					if (trackList[i].spoorIdentificationID === this.activeTrack.spoorIdentificationID)
						trackList.splice(i, 1);
				}

				//Split similar tracks into groups of up to 3 and limit it to 9 similar tracks
				var maxNumSimilarTracks = 9;
				if (trackList.length < maxNumSimilarTracks) {
					maxNumSimilarTracks = trackList.length;
				}
				this.similarTrackList = [];
				for (let j = 0; j < maxNumSimilarTracks; j += 3) {
					this.similarTrackList.push(trackList.slice(j, j + 3));
				}
			});
	}

	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	viewTrackPhotoDetails() {
		//Open AnimalPhotoDetailsComponent and display the selected photo 
		let mediaList = [this.activeTrack];
		const animalPhotoDetailsDialogRef = this.dialog.open(AnimalPhotoDetailsComponent, {
			height: '100%',
			width: '100%',
			autoFocus: true,
			disableClose: true,
			id: 'animal-photo-details-dialog',
			data: {
				initialIndex: 0,
				entity: mediaList,
				photoType: "Single Track"
			}
		});
	}
	viewAnimalPhotos(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/gallery/photos'], { queryParams: { classification: classificationQuery } });
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}


}
