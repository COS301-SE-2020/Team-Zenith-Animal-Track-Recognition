import { Component, OnInit, Input, Output, ViewChild, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { MatPaginatorIntl } from '@angular/material/paginator';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Track } from 'src/app/models/track';
import { TracksService } from './../../../services/tracks.service';
import { TrackViewNavigationService } from './../../../services/track-view-navigation.service';


@Component({
	selector: 'app-track-identifications-sidenav',
	templateUrl: './track-identifications-sidenav.component.html',
	styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {

	@ViewChild('trackMatTab') trackMatTab;
	@ViewChild('trackPaginator') trackPaginator;
	trackIdentifications: Track[] = null;
	@Output() trackPageOnChange: EventEmitter<Object> = new EventEmitter();
	activeTrack: Track = null;

	constructor(private http: HttpClient, private changeDetection: ChangeDetectorRef, 
		private router: Router, private snackBar: MatSnackBar, private tracksService: TracksService, private trackViewNavService: TrackViewNavigationService) { 
		tracksService.activeTrack$.subscribe(
			track => {
				this.activeTrack = track;
		}
		);
		tracksService.identifications.subscribe(
			trackList => {
				if (trackList != null && trackList.length > 0) {
					this.trackIdentifications = trackList;
					this.trackPaginator.length = this.trackIdentifications.length;
					this.trackPaginator.firstPage();
					this.stopLoader();
				}
				else if (trackList != null && trackList.length == 0) {
					if (this.trackIdentifications != null) {
						//If the track list returned is not the initial value but is empty nonetheless (if filtered for example)
						this.trackIdentifications = trackList;
						this.trackPaginator.length = this.trackIdentifications.length;
						this.trackPaginator.firstPage();
					}
				}
			}
		);
		trackViewNavService.trackSidenavTab$.subscribe(
			tab => {
				switch(tab) {
					case "Track":
						this.trackMatTab.selectedIndex = 2;
					break;
					case "Tracklist":
						this.trackMatTab.selectedIndex = 1;
					break;
					case "Heatmap":
						this.trackMatTab.selectedIndex = 0;
					break;
				}
			}
		);
	}
	
	ngOnInit(): void {
	}

	viewTrack(track: Track) {
		this.tracksService.changeActiveTrack(track);
		this.trackViewNavService.changeTab("Track");
		this.trackViewNavService.zoomOnTrack(track.spoorIdentificationID + ',' + track.location.latitude + ',' + track.location.longitude);
	}

	onPageChange($event) {
		let pageEvent = { 'event': $event, 'hasNextPage': this.trackPaginator.hasNextPage() };
		this.trackPageOnChange.emit(pageEvent);
	}

	//Loader
	startLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}