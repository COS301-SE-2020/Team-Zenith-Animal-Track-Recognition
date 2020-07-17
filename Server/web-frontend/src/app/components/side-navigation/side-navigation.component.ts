import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { mixinColor } from '@angular/material/core';

@Component({
  selector: 'app-side-navigation',
  templateUrl: './side-navigation.component.html',
  styleUrls: ['./side-navigation.component.css']
})
export class SideNavigationComponent implements OnInit {

  constructor(
    private router: Router) { }

  ngOnInit(): void {
  }

  route(location: string) {
    document.getElementById("animals-route").style.backgroundColor = "white";
    document.getElementById("overview-route").style.backgroundColor = "white";
    document.getElementById("rangers-route").style.backgroundColor = "white";
    document.getElementById("geotags-route").style.backgroundColor = "white";
    document.getElementById("settings-route").style.backgroundColor = "white";
  
    this.router.navigate([location]);
  }
}
