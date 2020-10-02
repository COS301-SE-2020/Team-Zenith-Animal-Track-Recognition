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
	@Input() searchText: string;
	trackIdentifications: Track[] = null;
	@Input() selectedFilter: any;
	@Input() filteredListArray: any;
	@Output() trackPageOnChange: EventEmitter<Object> = new EventEmitter();
	originType: string = "track-identifications";
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
				this.trackIdentifications = trackList;
				if (trackList != null && trackList.length > 0)
					this.stopLoader();
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

	public ngOnChanges(changes: SimpleChanges) {
		if (changes.filteredListArray && changes.filteredListArray.currentValue) {
			if (this.trackPaginator) {
				this.trackPaginator.length = this.filteredListArray.length;
				this.trackPaginator.firstPage();
			}
		}
		if (changes.displayedTracks && changes.displayedTracks.currentValue) {
			this.stopLoader();
		}
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