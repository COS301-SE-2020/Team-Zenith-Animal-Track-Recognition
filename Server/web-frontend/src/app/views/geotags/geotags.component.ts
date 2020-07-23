import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-geotags',
  templateUrl: './geotags.component.html',
  styleUrls: ['./geotags.component.css']
})
export class GeotagsComponent implements OnInit {

  constructor(private router: Router) { }

  ngOnInit(): void {
    document.getElementById("geotags-route").classList.add("activeRoute");
    const temp = new URLSearchParams();
    if(temp.has('reload')){
      this.router.navigate(['rangers']);
    }
  }

}
