import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-add-ranger',
  templateUrl: './add-ranger.component.html',
  styleUrls: ['./add-ranger.component.css']
})
export class AddRangerComponent implements OnInit {
  addUserForm: FormGroup;
  loading = false;
  submitted = false;

  hide = true;
	constructor(private formBuilder: FormBuilder, private router: Router, private http: HttpClient, public dialogRef: MatDialogRef<AddRangerComponent>) {}

  ngOnInit(): void {
		this.addUserForm = this.formBuilder.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', Validators.required],
      phoneNumber: ['', Validators.required],
      password: ['', Validators.required],
      dob: ['', Validators.required]
    });
  }

  get f() { return this.addUserForm.controls; }

	onSubmit(test: boolean) 
	{
		if(test){return true;}
		this.submitted = true;
		if (this.addUserForm.invalid) 
		{
			return;
		}
		this.loading = true;
		this.startLoader();
		let phoneNumber: string = "" + this.f.phoneNumber.value;
		phoneNumber = phoneNumber.trim();

		this.http.post<any>('http://putch.dyndns.org:55555/graphql?query=mutation{AddUser(firstName:"' + encodeURIComponent(this.f.firstName.value) + '",lastName:"' + encodeURIComponent(this.f.lastName.value) + '",Password:"' + encodeURIComponent(this.f.password.value) + '",Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",Access_Level:"1",e_mail:"' + encodeURIComponent(this.f.email.value) + '",phoneNumber:"' + encodeURIComponent(phoneNumber) + '"){lastName}}',
		'mutation{AddUser(firstName:"' + encodeURIComponent(this.f.firstName.value) + '",lastName:"' + encodeURIComponent(this.f.lastName.value) + '",Password:"' + encodeURIComponent(this.f.password.value) + '",Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",Access_Level:"1",e_mail:"' + encodeURIComponent(this.f.email.value) + '",phoneNumber:"' + encodeURIComponent(phoneNumber) + '"){lastName}}')
		.subscribe({next: data => this.dialogRef.close("success"), error: error => this.dialogRef.close("Error " + error.message)});
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
