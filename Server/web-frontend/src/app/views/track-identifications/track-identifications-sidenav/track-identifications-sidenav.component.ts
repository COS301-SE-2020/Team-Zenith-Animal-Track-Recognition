import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RelativeTimeMPipe } from 'src/app/pipes/relative-time-m.pipe'; 

@Component({
  selector: 'app-track-identifications-sidenav',
  templateUrl: './track-identifications-sidenav.component.html',
  styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {
	
	//https://codersloth.com/blogs/a-simple-time-ago-pipe-to-display-relative-time-in-angular/  <--- Time-ago Pipe
 	@Input() searchText: string;
	@Input() trackIds: any;
	@Input() trackDateTimes: string;
	@Output() tracksOnChange: EventEmitter<Object> = new EventEmitter();
	
	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		this.startLoader();
	}
	
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}

}
