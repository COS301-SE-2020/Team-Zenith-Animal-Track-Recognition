import { Component, OnInit, Input, Output, ViewChild, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { MatPaginatorIntl } from '@angular/material/paginator';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
	selector: 'app-track-identifications-sidenav',
	templateUrl: './track-identifications-sidenav.component.html',
	styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {

	@ViewChild('trackMatTab') trackMatTab;
	@ViewChild('trackPaginator') trackPaginator;
	@Input() searchText: string;
	@Input() fullTrackList: any;
	@Input() selectedFilter: any;
	@Input() filteredListArray: any;
	@Input() displayedTracks: any = null;
	@Output() trackPageOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() focusOnTrackChange: EventEmitter<Object> = new EventEmitter();
	activeTrack: any = null;
	originType: string = "track-identifications";


	constructor(private http: HttpClient, private changeDetection: ChangeDetectorRef, private router: Router, private snackBar: MatSnackBar) { }

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

	viewTrack(track: any) {
		this.activeTrack = null;
		this.activeTrack = track;
		this.focusOnTrackChange.emit(track.spoorIdentificationID + ',' + track.location.latitude + ',' + track.location.longitude);
		this.trackMatTab.selectedIndex = 1;
	}

	backToTrackList(status: any) {
		this.trackMatTab.selectedIndex = 0;
		this.focusOnTrackChange.emit(this.activeTrack.spoorIdentificationID + ',resetZoom');
		this.activeTrack = null;
	}

	onPageChange($event) {
		let pageEvent = { 'event': $event, 'hasNextPage': this.trackPaginator.hasNextPage() };
		this.trackPageOnChange.emit(pageEvent);
	}

	//Loader
	startLoader() {
		console.log("SIDENAV STart LOADER");
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		console.log("SIDENAV STOP LOADER");
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}