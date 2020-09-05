import { Component, OnInit, Input, Output, ViewChild, EventEmitter} from '@angular/core';
import { Router } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { AnimalPhotoDetailsComponent } from './../../../animals/animals-gallery/animal-photos/animal-photo-details/animal-photo-details.component'; 
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';

@Component({
  selector: 'app-track-identifications-info',
  templateUrl: './track-identifications-info.component.html',
  styleUrls: ['./track-identifications-info.component.css']
})
export class TrackIdentificationsInfoComponent implements OnInit {

	@Input() activeTrack: any;
	@Output() viewingTrackOnChange: EventEmitter<Object> = new EventEmitter();
	@ViewChild('otherMatchesMatTab') otherMatchesMatTab;
	@ViewChild('simTracksMatTab') simTracksMatTab;


	constructor( private router: Router, public dialog: MatDialog) { }

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
	
	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	viewTrackPhotoDetails() {
		//Open AnimalPhotoDetailsComponent and display the selected photo 
		let mediaList = [this.activeTrack.picture];
		const animalPhotoDetailsDialogRef = this.dialog.open(AnimalPhotoDetailsComponent, {
			height: '100%',
			width: '100%',
			autoFocus: true,
			disableClose: true,
			id: 'animal-photo-details-dialog',
			data: {
				initialIndex: 0,
				entity: this.activeTrack,
				imageList: mediaList,
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
