import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-rangers',
  templateUrl: './rangers.component.html',
  styleUrls: ['./rangers.component.css']
})
export class RangersComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
    document.getElementById("rangers-route").classList.add("activeRoute");
  
  }

}