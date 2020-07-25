import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.css']
})
export class SettingsComponent implements OnInit {

  test: boolean;

  constructor() { }

  ngOnInit(): void {
    document.getElementById("settings-route").classList.add("activeRoute");
  }

  setTest(t: boolean){
    this.test = t;
  }
}
