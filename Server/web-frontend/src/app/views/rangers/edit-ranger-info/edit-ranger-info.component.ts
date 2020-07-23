import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-edit-ranger-info',
  templateUrl: './edit-ranger-info.component.html',
  styleUrls: ['./edit-ranger-info.component.css']
})
export class EditRangerInfoComponent implements OnInit {
  editUserForm: FormGroup;

  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private router: Router, private http: HttpClient, private formBuilder: FormBuilder) { }

  ngOnInit(): void {
    this.editUserForm = this.formBuilder.group({
      firstName: [this.data.firstName , Validators.required],
      lastName: [this.data.lastName, Validators.required],
      email: [this.data.email, Validators.required],
      phoneNumber: [this.data.phoneNumber, Validators.required]
    });
  }

  get f() { return this.editUserForm.controls; }

  onSubmit() {
    let temp = this.http.post<any>('http://putch.dyndns.org:55555/graphql?query=mutation{UpdateUser('
      + 'TokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
      + 'TokenChange:"' + this.data.Token + '",'
      + 'e_mail:"' + this.f.email.value + '",'
      + 'lastName:"' + this.f.lastName.value + '",'
      + 'phoneNumber:"' + this.f.phoneNumber.value + '",'
      + 'firstName:"' + this.f.firstName.value + '"){lastName,Token}}', '').subscribe((data: any[]) => {
        let t = [];
        t = Object.values(Object.values(data)[0]);        
      });

    this.router.navigate(["/geotags"], { queryParams: { reload: "true" } });
  }
}
