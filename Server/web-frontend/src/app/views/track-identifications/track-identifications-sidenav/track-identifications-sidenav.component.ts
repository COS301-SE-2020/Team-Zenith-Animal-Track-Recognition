import { Component, OnInit, Input, Output, ViewChild, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
	selector: 'app-track-identifications-sidenav',
	templateUrl: './track-identifications-sidenav.component.html',
	styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {

	//https://codersloth.com/blogs/a-simple-time-ago-pipe-to-display-relative-time-in-angular/  <--- Time-ago Pipe
	@ViewChild('trackMatTab') trackMatTab;
	@Input() searchText: string;
	@Input() fullTrackList: any;
	@Input() displayedTracks: any = null;
	@Output() trackPageOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() focusOnTrackChange: EventEmitter<Object> = new EventEmitter();
	activeTrack: any = null;

	public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if (changes.displayedTracks) {
			//If tracks has updated
			this.changeDetection.detectChanges();
		}
		this.stopLoader();
	}

	constructor(private http: HttpClient, private changeDetection: ChangeDetectorRef, private router: Router, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
	}

	viewTrack(track: any) {
		var similarTracksUrls = [];
		var similarTrackBatch = [];
		track.animal.pictures.forEach(element => {
			if (element.kindOfPicture == 'trak')
			{
				if (similarTrackBatch.length != 3)
				{
					similarTrackBatch.push(element.URL);
				}
				else
				{
					similarTracksUrls.push(similarTrackBatch);
					similarTrackBatch = null;
					similarTrackBatch = [];
					similarTrackBatch.push(element.URL);
				}
			}
		});
		if (similarTrackBatch.length > 0)
			similarTracksUrls.push(similarTrackBatch);
		track.similarTracks = similarTracksUrls;
		this.activeTrack = track;
		this.focusOnTrackChange.emit(track.location.latitude + "," + track.location.longitude);
		this.trackMatTab.selectedIndex = 1;
	}
	backToTrackList(status: any) {
		this.trackMatTab.selectedIndex = 0;
		this.focusOnTrackChange.emit("resetZoom");
		this.activeTrack = null;
	}
	
	onPageChange($event)
	{
		this.trackPageOnChange.emit($event);
	}


	//Loader
	startLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}