import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-ranger-search-sidenav-comp',
  templateUrl: './ranger-search-sidenav-comp.component.html',
  styleUrls: ['./ranger-search-sidenav-comp.component.css']
})
export class RangerSearchSidenavCompComponent implements OnInit {

  @Input() rangers;
  @Input() searchText: string;
  @Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
  @Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();

  currentAlphabet: any;
  sortByLevel: boolean = false;
  sorted: string;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {}

  checkIfNew(title: string, pos: number) {
    if (this.currentAlphabet === ("" + title).charAt(pos).toLowerCase()) {
      return false;
    } else {
      this.currentAlphabet = ("" + title).charAt(pos).toLowerCase();
      return true;
    }
  }

  updateSearchText(event) {
    this.searchTextOnChange.emit(event);
  }

  toggle(bool: boolean) {
	this.sortByLevel = !this.sortByLevel;
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
    } else {
      for (let i = 0; i < this.rangers.length - 1; i++) {
        for (let j = i + 1; j < this.rangers.length; j++) {
          if (this.rangers[i].Access_Level > this.rangers[j].Access_Level) {
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
