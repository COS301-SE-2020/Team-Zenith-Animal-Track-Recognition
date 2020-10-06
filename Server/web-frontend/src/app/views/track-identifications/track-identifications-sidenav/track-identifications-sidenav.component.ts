import { Component, OnInit, Input, Output, ViewChild, EventEmitter } from '@angular/core';
import { MatPaginatorIntl } from '@angular/material/paginator';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';
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

	constructor(private tracksService: TracksService, private trackViewNavService: TrackViewNavigationService) { 
		tracksService.activeTrack$.subscribe(
			track => {
				this.activeTrack = track;
		}
		);
		tracksService.identifications.subscribe(
			trackList => {
				if (trackList != null) {
					this.trackIdentifications = trackList;
					if (this.trackPaginator) {
						this.trackPaginator.length = this.trackIdentifications.length;
						this.trackPaginator.firstPage();
						this.stopLoader();
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
	
	changeTrackFilter(filterType: string, filter: string) {
		this.tracksService.changeTrackFilter(filterType, filter);
	}

	//Loader
	startLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}