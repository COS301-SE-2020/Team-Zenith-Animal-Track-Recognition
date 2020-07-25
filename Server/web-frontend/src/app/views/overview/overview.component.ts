import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.css']
})
export class OverviewComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
    document.getElementById("overview-route").classList.add("activeRoute");
  	  this.stopLoader();
  }
  
    //Loader
  startLoader()
  {
	  console.log("Starting Loader");
	  document.getElementById("loader-container").style.visibility = "visible";
  }  
  stopLoader()
  {
	  	  console.log("Stopping Loader");
	  document.getElementById("loader-container").style.visibility = "hidden";
  }

}
