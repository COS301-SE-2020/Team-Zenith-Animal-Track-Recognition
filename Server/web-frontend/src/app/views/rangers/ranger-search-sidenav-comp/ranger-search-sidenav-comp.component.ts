import { DataService } from './../../../services/data.service';
import { Component, OnInit } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';

@Component({
	selector: 'app-ranger-search-sidenav-comp',
	templateUrl: './ranger-search-sidenav-comp.component.html',
	styleUrls: ['./ranger-search-sidenav-comp.component.css']
})
export class RangerSearchSidenavCompComponent implements OnInit {

	rangers = RANGERS;
	searchText;
	currentAlphabet;
	surnames: boolean = true;
	levels: boolean = false;

	constructor(private data: DataService) { }

	ngOnInit(): void {
		this.sort(true);
		this.data.currentMessage.subscribe(searchText => this.searchText = searchText);
	}

	checkIfNew(title: string, pos: number) {
		if (this.currentAlphabet === ("" + title).charAt(pos).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).charAt(pos).toLowerCase();
			return true;
		}
	}

	updateMessage(){
		this.data.changeMessage(this.searchText);
	}

	toggle(bool: boolean) {
		this.surnames = bool;
		this.levels = !bool;
		this.sort(bool);
	}

	sort(bool: boolean) {
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
		} else {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].rangerLevel > this.rangers[j].rangerLevel) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
		}
	}
}