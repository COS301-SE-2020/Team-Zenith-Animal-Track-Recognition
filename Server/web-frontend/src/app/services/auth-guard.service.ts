import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';
import { AuthService } from './auth.service';

@Injectable()
export class AuthGuardService implements CanActivate {

  constructor(public auth: AuthService, public router: Router) { }

  canActivate(): boolean {
    if (!this.auth.isAuthenticated()) {
      this.router.navigate(['login']);
      return false;
    }
    document.getElementById("animals-route-link").classList.remove("activeRoute");
    document.getElementById("animals-gallery-route").classList.remove("activeRoute");
    document.getElementById("overview-route").classList.remove("activeRoute");
    document.getElementById("rangers-route").classList.remove("activeRoute");
    document.getElementById("geotags-route").classList.remove("activeRoute");
    return true;
  }
}