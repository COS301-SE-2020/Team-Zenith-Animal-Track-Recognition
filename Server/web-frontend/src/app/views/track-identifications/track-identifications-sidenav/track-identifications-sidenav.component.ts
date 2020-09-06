import { Component, OnInit, Input, Output, ViewChild, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe';

@Component({
	selector: 'app-track-identifications-sidenav',
	templateUrl: './track-identifications-sidenav.component.html',
	styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {

	//https://codersloth.com/blogs/a-simple-time-ago-pipe-to-display-relative-time-in-angular/  <--- Time-ago Pipe
	@ViewChild('trackMatTab') trackMatTab;
	@Input() searchText: string;
	@Input() trackIds: any;
	@Input() trackDateTimes: string;
	@Output() tracksOnChange: EventEmitter<Object> = new EventEmitter();
	activeTrack: any = null;

	public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if (changes.trackIdentifications) {
			//If tracks has updated
			this.changeDetection.detectChanges();
		}
		this.stopLoader();
	}

	constructor(private http: HttpClient, private changeDetection: ChangeDetectorRef) { }

	ngOnInit(): void {
		this.startLoader();
	}

	viewTrack(track: any) {
		this.activeTrack = track;
		this.trackMatTab.selectedIndex = 1;
		console.log("Swapped");
	}
	backToTrackList() {
		this.trackMatTab.selectedIndex = 0;
		this.activeTrack = null;
		console.log("backtotrcklist");
	}

	//Loader
	startLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}