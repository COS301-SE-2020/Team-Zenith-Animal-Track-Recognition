import { DataService } from './../../../services/data.service';
import { RangerSearchSidenavCompComponent } from './../ranger-search-sidenav-comp/ranger-search-sidenav-comp.component';
import { Component, OnInit } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';

@Component({
  selector: 'app-ranger-profile-card',
  templateUrl: './ranger-profile-card.component.html',
  styleUrls: ['./ranger-profile-card.component.css']
})
export class RangerProfileCardComponent implements OnInit {

  searchText;

  rangers = RANGERS;

  constructor(private data: DataService) { }

  ngOnInit(): void {
    this.data.currentMessage.subscribe(searchText => this.searchText = searchText);
  }

}
