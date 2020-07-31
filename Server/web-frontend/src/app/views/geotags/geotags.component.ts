import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { threadId } from 'worker_threads';

@Component({
  selector: 'app-geotags',
  templateUrl: './geotags.component.html',
  styleUrls: ['./geotags.component.css']
})
export class GeotagsComponent implements OnInit {

  test: boolean = false;

  constructor(private router: Router) {
    this.executeOrder66(false);
  }

  ngOnInit(): void {
    document.getElementById("geotags-route").classList.add("activeRoute");
  }

  executeOrder66(test: boolean) {
    if(test){
      return;
    }
    const temp = new URLSearchParams(window.location.search);
    if (temp.has('reload')) {
      var start = new Date().getTime();
      var end = start;
      while (end < start + 750) {
        end = new Date().getTime();
      }
      this.router.navigate(['/rangers']);
    }
    if (temp.has('reloadPerms')) {
      var start = new Date().getTime();
      var end = start;
      while (end < start + 750) {
        end = new Date().getTime();
      }
      this.router.navigate(['/rangers/permissions']);
    }
    if (temp.has('reloadAnimals')) {
      var start = new Date().getTime();
      var end = start;
      while (end < start + 750) {
        end = new Date().getTime();
      }
      this.router.navigate(['/animals']);
    }
  }
}
