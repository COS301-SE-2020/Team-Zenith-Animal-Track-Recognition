import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-track-identifications-sidenav',
  templateUrl: './track-identifications-sidenav.component.html',
  styleUrls: ['./track-identifications-sidenav.component.css']
})

export class TrackIdentificationsSidenavComponent implements OnInit {

	@Input() rangers;
	@Input() searchText: string;
	@Input() sortBySurname: boolean;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();

	currentAlphabet: any;
	sorted: string;
  
	constructor(private http: HttpClient) { }

	ngOnInit(): void {
	}
	
	checkIfNew(title: string, pos: number) {
		if (this.currentAlphabet === ('' + title).charAt(pos).toLowerCase()) {
			return false;
		} 
		else {
			this.currentAlphabet = ('' + title).charAt(pos).toLowerCase();
			return true;
		}
	}

	updateSearchText(event) {
		this.searchTextOnChange.emit(event);
		if ((<HTMLInputElement>document.getElementById("search-sidenav-input")).value == "")
			this.currentAlphabet = null;
	}

	toggle(bool: boolean) {
		this.sortBySurname = bool;
		this.sort(bool);
	}

	sort(bool: boolean) {
		let temp: string;
		if (bool) {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
			temp = "Sorted alphabetically";
		} 
		else {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].accessLevel > this.rangers[j].accessLevel) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
			temp = "Sorted by ranger level";
		}
		this.sorted = temp;
		return temp;
	}
}
