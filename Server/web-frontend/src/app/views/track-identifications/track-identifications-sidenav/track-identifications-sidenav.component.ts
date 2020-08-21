import { Component, OnInit, Input, Output, ViewChild, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy  } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-track-identifications-sidenav',
  templateUrl: './track-identifications-sidenav.component.html',
  styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {
	
  /*Placeholder values*/
	trackIdentifications = [
		{
			commonName: 'Elephant',
			classification: 'Loxodonta Africanus',
			dateTime: '09:13, 12th Dec 2020',
			recentPlaceholder: '4 min. ago',
			coordinates: '-24.019097, 31.559270',
			capturedBy: 'Kagiso Ndlovu',
			accuracyScore: '67%'
		},
		{
			commonName: 'Black Rhinoceros',
			classification: 'Diceros Bicornis',
			dateTime: '09:13, 12th Dec 2020',
			recentPlaceholder: '9 min. ago',
			coordinates: '-24.019097, 31.559270',
			capturedBy: 'Kagiso Ndlovu',
			accuracyScore: '97%'
		},
		{
			commonName: 'Cape Buffalo',
			classification: 'Syncerus Caffer',
			dateTime: '09:13, 12th Dec 2020',
			recentPlaceholder: '17 min. ago',
			coordinates: '-24.019097, 31.559270',
			capturedBy: 'Kagiso Ndlovu',
			accuracyScore: '73%'
		},
		{
			commonName: 'Cheetah',
			classification: 'Acinonyx Jubatus',
			dateTime: '09:13, 12th Dec 2020',
			recentPlaceholder: '30 min. ago',
			coordinates: '-24.019097, 31.559270',
			capturedBy: 'Kagiso Ndlovu',
			accuracyScore: '67%'
		},
		{
			commonName: 'Lion',
			classification: 'Panthera Leo',
			dateTime: '09:13, 12th Dec 2020',
			recentPlaceholder: '44 min. ago',
			coordinates: '-24.019097, 31.559270',
			capturedBy: 'Kagiso Ndlovu',
			accuracyScore: '67%'
		},
		{
			commonName: 'Impala',
			classification: 'Aepyceros Melampus',
			dateTime: '09:13, 12th Dec 2020',
			recentPlaceholder: '1 hr. ago',
			coordinates: '-24.019097, 31.559270',
			capturedBy: 'Kagiso Ndlovu',
			accuracyScore: '59%'
		}
	];
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
	
	viewTrack(track: any)
	{
		this.activeTrack = track;
		this.trackMatTab.selectedIndex = 1;
		console.log("Swapped");
	}
	backToTrackList()
	{
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
