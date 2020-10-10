import { MatSnackBar } from '@angular/material/snack-bar';
import { AnimalPhotoDetailsComponent } from './../../../animals/animals-gallery/animal-photos/animal-photo-details/animal-photo-details.component';
import { AfterViewInit, Component, OnInit, Input, Output, ViewChildren, EventEmitter} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { GoogleMap } from '@angular/google-maps';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { Track } from 'src/app/models/track';
import { TracksService } from './../../../../services/tracks.service';
import { TrackViewNavigationService } from './../../../../services/track-view-navigation.service';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Router } from '@angular/router';
import { catchError, retry } from 'rxjs/operators';
import { EMPTY } from 'rxjs';

@Component({
	selector: 'app-track-identifications-info',
	templateUrl: './track-identifications-info.component.html',
	styleUrls: ['./track-identifications-info.component.css']
})
export class TrackIdentificationsInfoComponent implements OnInit {

	activeTrack: Track = null;
	@ViewChildren('otherMatchesMatTab') otherMatchesMatTab;
	@ViewChildren('simTracksMatTab') simTracksMatTab;
	@Input() otherMatchesMatTabIndex = 0;
	@Input() similarTracksMatTabIndex = 0;
	geoCoder: google.maps.Geocoder;
	similarTrackList: any [] = null;
	otherMatchesList: any [] = null;

	constructor(private http: HttpClient,
		private snackBar: MatSnackBar,
		public dialog: MatDialog,
		private router: Router,
		private tracksService: TracksService,
		private trackViewNavService: TrackViewNavigationService) {
		tracksService.activeTrack$.subscribe(
			track => {
				this.activeTrack = track;
				if (this.activeTrack != null) {
					this.setTrackAddress();
					this.filterNullOtherMatches();
					this.updateSimilarTracks();
				}
			});
	}

	ngOnInit(): void {
	}
	
	ngAfterViewInit(): void {
		this.otherMatchesMatTab.changes.subscribe(item => {
			this.otherMatchesMatTabIndex  = 0;
		});
		this.simTracksMatTab.changes.subscribe(item => {
			this.similarTracksMatTabIndex = 0;
		});
	}
	
	filterNullOtherMatches() {
		if (this.activeTrack != null) {
			var otherPossibleValidMatches = this.activeTrack.potentialMatches.filter(match => ((match.confidence > 0) && 
				(match.animal.classification !== this.activeTrack.animal.classification)));
			
			var maxNumOtherMatches = otherPossibleValidMatches.length;
			this.otherMatchesList = [];
			for (let j = 0; j < maxNumOtherMatches; j += 2) {
				this.otherMatchesList.push(otherPossibleValidMatches.slice(j, j + 2));
			}
			if (otherPossibleValidMatches.length % 2 == 0) {
				this.otherMatchesList.push([{animal: {commonName: "showReclassifyOption"}}]);
			}
		}
	}
	
	changeActiveTrack(track: Track) {
		this.tracksService.changeActiveTrack(track);
		this.trackViewNavService.zoomOnTrack(track.spoorIdentificationID + ',' + track.location.latitude + ',' + track.location.longitude);
	}

	backToTrackList() {
		this.trackViewNavService.changeTab("Tracklist");
		this.trackViewNavService.zoomOnTrack(this.activeTrack.spoorIdentificationID + ',resetZoom');
		this.tracksService.changeActiveTrack(null);
	}
	nextPotentialMatch() {
		if (this.otherMatchesMatTabIndex != (this.otherMatchesList.length - 1))
			this.otherMatchesMatTabIndex++;
	}
	prevPotentialMatch() {
		if (this.otherMatchesMatTabIndex != 0)
			this.otherMatchesMatTabIndex--;
	}
	nextSimilarTrack() {
		if (this.similarTracksMatTabIndex != (this.similarTrackList.length - 1))
			this.similarTracksMatTabIndex += 1;
	}
	prevSimilarTrack() {
		if (this.similarTrackList.length > 0 && this.similarTracksMatTabIndex != 0)
			this.similarTracksMatTabIndex -= 1;
	}

	reclassifyTrack(track: any, newAnimal: any) {
		console.log("clicked on " + newAnimal.commonName);
		//this.tracksService.reclassifyTrack(JSON.parse(localStorage.getItem('currentToken'))['value'], track, newAnimal);
		//Visually show change
		//this.activeTrack.potentialMatches[this.activeTrack.potentialMatches.length - otherMatchIndex].animal = this.activeTrack.animal;
		//this.activeTrack.potentialMatches[this.activeTrack.potentialMatches.length - otherMatchIndex].confidence = this.activeTrack.potentialMatches[this.activeTrack.potentialMatches.length - 1].confidence;
		//this.activeTrack.animal = newAnimal;
		//this.activeTrack.potentialMatches[this.activeTrack.potentialMatches.length - 1].confidence = 1.00;
	}
	//Track Identification manipulation
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
	}

	updateSimilarTracks() {
		//Load similar tracks for the same animal being viewed
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.activeTrack.animal.classification + '"){spoorIdentificationID,animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}}dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
			.pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					return EMPTY;
				})
			)
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				var trackList = temp[0];
				var tracks = trackList.filter(track => track.spoorIdentificationID != this.activeTrack.spoorIdentificationID);
				//Split similar tracks into groups of up to 3 and limit it to 9 similar tracks
				var maxNumSimilarTracks = 9;
				if (trackList.length < maxNumSimilarTracks) {
					maxNumSimilarTracks = trackList.length;
				}
				this.similarTrackList = [];
				var similarTracks = [];
				for (let j = 0, i = 0; j < maxNumSimilarTracks; j += 3, i++) {
					similarTracks.push(tracks.slice(j, j + 3));
					if (similarTracks[i].length > 0)
						this.similarTrackList.push(tracks.slice(j, j + 3));
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
