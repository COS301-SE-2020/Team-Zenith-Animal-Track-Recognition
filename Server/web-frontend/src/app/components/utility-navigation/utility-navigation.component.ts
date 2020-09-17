import { User } from './../../models/user';
import { AuthService } from './../../services/auth.service';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-utility-navigation',
  templateUrl: './utility-navigation.component.html',
  styleUrls: ['./utility-navigation.component.css']
})
export class UtilityNavigationComponent implements OnInit {

  currentUser: User;
  rangerName: string;

  constructor(private router: Router, private authService: AuthService) {
  }

  ngOnInit(): void { 
    this.rangerName = 'Hi, ' + JSON.parse(localStorage.getItem('currentToken'))['firstName'] +'!';
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }

  viewRangerProfile() {
    let token = JSON.parse(localStorage.getItem('currentToken'))['currentID'];
    this.router.navigate(['rangers/profiles'], { queryParams: { ranger: token } });
  }
}
