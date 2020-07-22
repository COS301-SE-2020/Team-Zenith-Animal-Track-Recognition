import { Component, OnInit, Input } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';

@Component({
  selector: 'app-ranger-profile-card',
  templateUrl: './ranger-profile-card.component.html',
  styleUrls: ['./ranger-profile-card.component.css']
})
export class RangerProfileCardComponent implements OnInit {

  @Input() searchText: string;
  rangers = RANGERS;

  constructor() { }

  ngOnInit(): void {
  }

}
