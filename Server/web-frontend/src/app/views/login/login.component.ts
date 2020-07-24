import { AuthService } from './../../services/auth.service';
import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';

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
  welcome;

  hide = true;
  constructor(
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.loginForm = this.formBuilder.group({
      username: ['', Validators.required],
      password: ['', Validators.required]
    });
	  this.welcome = localStorage.getItem("localStorageUsername");
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/overview';
  }

  get f() { return this.loginForm.controls; }

  onSubmit(temp: boolean) {
    this.submitted = true;
    
    if(temp){
      this.welcome = "Hello";
      return;
    }

    if (this.loginForm.invalid) {
      return;
    }

    this.loading = true;
    
    let username: string = this.f.username.value;
    let password: string = this.f.password.value;

    username = encodeURIComponent(username);
    password = encodeURIComponent(password);

    this.authService.login(username, password)
      .pipe(first())
      .subscribe(
        data => {

		//Save username
		if (localStorage.getItem("localStorageUsername") === null) 
		{
			localStorage.setItem("localStorageUsername", username);
		}
		else if (localStorage.getItem("localStorageUsername") != null)
		{
			localStorage.setItem("localStorageUsername", username);
		}
          this.router.navigate([this.returnUrl]);
        },
        error => {
          this.loading = false;
        });
  }
}
