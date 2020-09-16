import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy} from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-animal-search-sidenav',
	templateUrl: './animal-search-sidenav.component.html',
	styleUrls: ['./animal-search-sidenav.component.css']
})
export class AnimalSearchSidenavComponent implements OnInit {
	@Input() animals: any;
	@Input() searchText: string;
	@Input() sortBy: any = [];
	@Input() selection: string;

	@Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();

	currentAlphabet: any;

	constructor(private changeDetection: ChangeDetectorRef, private http: HttpClient, private router: Router) { }
	
	public ngOnChanges(changes: SimpleChanges) {
		if (changes.animals) {
			this.stopSidenavLoader();
		}
	}
	
	ngOnInit(): void {
		this.stopSidenavLoader();
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}
	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}

	checkIfNew(title: string) {
		if (this.currentAlphabet === ("" + title).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).toLowerCase();
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
