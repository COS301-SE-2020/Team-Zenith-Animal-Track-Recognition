import { AppComponent } from './../../app.component';
import { AuthService } from './../../services/auth.service';
import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  loginForm: FormGroup;
  loading = false;
  submitted = false;
  returnUrl: string;
  welcome: string = "Hello";

  hide = true;
  constructor(
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private snackBar: MatSnackBar,
    private authService: AuthService) { }

  ngOnInit(): void {
    this.loginForm = this.formBuilder.group({
      username: ['', Validators.required],
      password: ['', Validators.required]
    });
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/ranger-statistics';
  }

  get f() { return this.loginForm.controls; }

  onSubmit(temp: boolean) {
    this.snackBar.open('Signing in...');
    this.submitted = true;

    if (temp) {
      return;
    }

    if (this.loginForm.invalid) {
      return;
    }

    this.loading = true;
    this.startLoader();
    let username: string = this.f.username.value;
    let password: string = this.f.password.value;

    username = encodeURIComponent(username);
    password = encodeURIComponent(password);

    this.authService.login(username, password)
      .pipe(first())
      .subscribe(
        data => {
			if (data != null)
			{
        this.snackBar.open("Signed in.", "Dismiss", { duration: 2500, });
				this.router.navigate([this.returnUrl]);
			}
			else
			{
				this.loading = false;
				this.stopLoader();
				this.snackBar.open('User not found. Please ensure that your sign in details are correct and try again.', "Dismiss", { duration: 7000, });				
			}
        },
        error => {
          this.loading = false;
          this.stopLoader();
          this.snackBar.open('There was an error signing you in. Please try again.', "Dismiss", { duration: 7000, });
        });
  }

  //Loader
  startLoader() {
    document.getElementById("loader-container").style.visibility = "visible";
  }
  stopLoader() {
    document.getElementById("loader-container").style.visibility = "hidden";
  }

}
