import { Component, OnInit, Input, Output, ViewChild, EventEmitter} from '@angular/core';
import { Router } from '@angular/router';
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


	constructor( private router: Router) { }

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
	viewAnimalPhotos(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/gallery/photos'], { queryParams: { classification: classificationQuery } });
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}
	

}
