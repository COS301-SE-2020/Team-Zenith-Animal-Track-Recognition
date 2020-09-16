import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-ranger-search-sidenav-comp',
	templateUrl: './ranger-search-sidenav-comp.component.html',
	styleUrls: ['./ranger-search-sidenav-comp.component.css'],
})

export class RangerSearchSidenavCompComponent implements OnInit {

	@Input() rangers;
	@Input() searchText: string;
	@Input() sortBySurname: boolean;
	@Input() selection: string;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();

	currentAlphabet: any;
	sorted: string;

	constructor(private changeDetection: ChangeDetectorRef, private http: HttpClient, private router: Router) { }
	
	public ngOnChanges(changes: SimpleChanges) {
		if (changes.rangers) {
			this.stopSidenavLoader();
		}
	}

	ngOnInit(): void {
	}

	viewRangerProfile(rangerID: string) {
		this.router.navigate(['rangers/profiles'], { queryParams: { ranger: rangerID } });
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}

	checkIfNew(title: string) {
		if (this.currentAlphabet === ('' + title).charAt(0).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ('' + title).charAt(0).toLowerCase();
			return true;
		}
	}
	
	checkResult(str: string) {
		return str == this.selection;
	}
	
	updateSearchText(event) {
		this.searchTextOnChange.emit(event);
		if ((<HTMLInputElement>document.getElementById("search-sidenav-input")).value == "")
			this.currentAlphabet = null;
	}
	
	//Loader
	startSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}
