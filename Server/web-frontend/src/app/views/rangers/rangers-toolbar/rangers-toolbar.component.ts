import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-rangers-toolbar',
  templateUrl: './rangers-toolbar.component.html',
  styleUrls: ['./rangers-toolbar.component.css']
})
export class RangersToolbarComponent implements OnInit {


  constructor() { }

  @Input() searchText: string;

  ngOnInit(): void {
  }

}
